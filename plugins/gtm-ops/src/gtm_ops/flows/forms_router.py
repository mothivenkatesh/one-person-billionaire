"""Utility Agent — Forms-Router.

Google Forms webhook handler. Every Form submission gets parsed, classified by
intent type, and routed to the appropriate downstream agent or workflow.

Form taxonomy (each has its own webhook URL pointing here):
- gtm.demo-request → ICP-Scout (real-time path, skip-tier-A for explicit demos)
- gtm.content-download → MoEngage nurture enrollment (low-priority lead)
- gtm.webinar-registration → MoEngage webinar journey + add to engagement_score
- gtm.nps-survey → Churn-Saver (low NPS = churn signal)
- gtm.churn-exit-survey → Product team Drive doc + Win/Loss-Analyzer next run
- gtm.partner-signup → Partner-ops repo (cross-domain handoff)

Graph:
    START
      → parse_form_payload          (Apps Script POSTs JSON; normalize per form schema)
      → identify_form_type          (form_name → intent class)
      → enrich_minimal              (Clay only-if-explicit-demo; others skip enrichment)
      → route_to_downstream_agent   (dispatch to ICP-Scout / Churn-Saver / etc.)
      → write_form_response_to_sheet (gtm.form-responses.{form_name} sheet)
      → audit_log
    END
"""

from typing import Any, TypedDict

from langgraph.graph import END, START, StateGraph

from ._base import default_checkpointer


class FormsRouterState(TypedDict, total=False):
    raw_payload: dict[str, Any]
    form_name: str
    parsed: dict[str, Any]
    intent_class: str  # demo | content | webinar | nps | churn_exit | partner
    enriched: dict[str, Any] | None
    downstream_agent_invoked: str | None
    sheet_row_written: bool
    error: str | None


async def parse_form_payload(state: FormsRouterState) -> dict:
    """Apps Script onFormSubmit → POST JSON here. Normalize fields per form schema."""
    p = state.get("raw_payload", {})
    return {
        "form_name": p.get("form_name"),
        "parsed": {
            "respondent_email": p.get("respondent_email"),
            "company": p.get("company"),
            "fields": p.get("fields", {}),
            "submitted_at": p.get("submitted_at"),
        },
    }


async def identify_form_type(state: FormsRouterState) -> dict:
    """Map form_name to intent class."""
    intent_map = {
        "gtm.demo-request": "demo",
        "gtm.content-download": "content",
        "gtm.webinar-registration": "webinar",
        "gtm.nps-survey": "nps",
        "gtm.churn-exit-survey": "churn_exit",
        "gtm.partner-signup": "partner",
    }
    return {"intent_class": intent_map.get(state.get("form_name", ""), "unclassified")}


async def enrich_minimal(state: FormsRouterState) -> dict:
    """Only enrich if it's a high-intent form (demo, partner). Others go through quickly."""
    if state.get("intent_class") not in ("demo", "partner"):
        return {"enriched": None}
    # TODO: Clay quick-enrich on email domain — firmographics + LinkedIn URL only
    # Avoid full waterfall here — that's ICP-Scout's job
    return {"enriched": {}}


async def route_to_downstream_agent(state: FormsRouterState) -> dict:
    """Dispatch based on intent_class."""
    intent = state.get("intent_class")
    invoked = None

    if intent == "demo":
        # TODO: Trigger ICP-Scout with trigger_type='forms_webhook' → bypasses cron, real-time path
        # Mark as 'high_intent_explicit' so ICP-Scout fast-tracks to Tier A/B regardless of score
        invoked = "cf-icp-scout"
    elif intent == "content":
        # TODO: MoEngage API — enroll in nurture journey with content topic as merge field
        invoked = "moengage_nurture"
    elif intent == "webinar":
        # TODO: MoEngage — webinar reminder journey + +1 to account.engagement_score
        invoked = "moengage_webinar"
    elif intent == "nps":
        score = int(state["parsed"]["fields"].get("nps_score", 5))
        if score <= 6:  # detractor
            # TODO: Trigger Churn-Saver for this account
            invoked = "cf-churn-saver"
        else:
            # passive/promoter — log only
            invoked = "log_only"
    elif intent == "churn_exit":
        # TODO: Drive Doc append for product team review
        # TODO: Flag for next Win/Loss-Analyzer monthly run
        invoked = "product_team_drive"
    elif intent == "partner":
        # Cross-domain handoff to partner-ops repo's intake agent
        invoked = "partner_ops_handoff"

    return {"downstream_agent_invoked": invoked}


async def write_form_response_to_sheet(state: FormsRouterState) -> dict:
    """Append row to gtm.form-responses.{form_name} for archival + audit."""
    # TODO: Sheets API append to the form-specific landing sheet
    return {"sheet_row_written": True}


async def audit_log(state: FormsRouterState) -> dict:
    return {}


def build_forms_router_graph():
    g = StateGraph(FormsRouterState)
    for name, fn in [
        ("parse_form_payload", parse_form_payload),
        ("identify_form_type", identify_form_type),
        ("enrich_minimal", enrich_minimal),
        ("route_to_downstream_agent", route_to_downstream_agent),
        ("write_form_response_to_sheet", write_form_response_to_sheet),
        ("audit_log", audit_log),
    ]:
        g.add_node(name, fn)

    g.add_edge(START, "parse_form_payload")
    g.add_edge("parse_form_payload", "identify_form_type")
    g.add_edge("identify_form_type", "enrich_minimal")
    g.add_edge("enrich_minimal", "route_to_downstream_agent")
    g.add_edge("route_to_downstream_agent", "write_form_response_to_sheet")
    g.add_edge("write_form_response_to_sheet", "audit_log")
    g.add_edge("audit_log", END)

    return g.compile(checkpointer=default_checkpointer())
