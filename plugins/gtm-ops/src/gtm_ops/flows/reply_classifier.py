"""Agent 3 — Reply-Classifier (Acquisition loop).

Triggered by Smartlead reply webhook. Claude classifies intent in <1s, logs SF
activity, alerts AE only on positive intent (otherwise: nurture, suppress, or ignore).

Without this agent live, SDRs drown when 30K sends/month produces 600-1000 replies.

Graph:
    START
      → parse_reply_payload          (Smartlead webhook → normalized {prospect, body, thread})
      → fetch_thread_context         (SF activity history for this Lead/Contact)
      → classify_intent              (Claude Haiku — 6-class classifier)
      → handle_per_intent            (router: positive→AE | objection→AE+context | not_now→nurture
                                      | unsubscribe→suppress | referral→AE | oof→reschedule)
      → write_sf_activity            (log reply with classification)
      → write_extracted_property     (objections/competitors → Postgres for downstream extraction)
      → audit_log
    END
"""

from typing import Any, TypedDict

from langgraph.graph import END, START, StateGraph

from ..integrations.hubspot import HubSpotClient
from ..integrations.openrouter import OpenRouterClient
from ..integrations.smartlead import SmartleadClient
from ._base import default_checkpointer


class ReplyClassifierState(TypedDict, total=False):
    smartlead_payload: dict[str, Any]
    prospect_email: str
    reply_body: str
    thread_history: list[dict]
    intent: str  # positive | objection | not_now | unsubscribe | referral | oof | unclear
    confidence: float
    extracted_properties: list[dict]  # objections, competitors mentioned
    routing_action: str  # alert_ae | nurture | suppress | reschedule | manual_review
    sf_activity_id: str | None
    error: str | None


async def parse_reply_payload(state: ReplyClassifierState) -> dict:
    """Normalize Smartlead webhook payload."""
    p = state.get("smartlead_payload", {})
    return {
        "prospect_email": p.get("from_email"),
        "reply_body": p.get("body_text") or p.get("body_html_stripped"),
        "thread_history": p.get("thread", []),
    }


async def fetch_thread_context(state: ReplyClassifierState) -> dict:
    """Pull SF Lead + recent activities so Claude has stage context."""
    hub = HubSpotClient()
    try:
        # TODO: SF SOQL on Lead by email + last 5 activities
        return {}
    finally:
        await hub.aclose()


async def classify_intent(state: ReplyClassifierState) -> dict:
    """6-class intent classifier with confidence."""
    llm = OpenRouterClient()
    system = (
        "Classify B2B sales reply intent. Output JSON only: "
        "{\"intent\": \"positive|objection|not_now|unsubscribe|referral|oof|unclear\", "
        "\"confidence\": 0.0-1.0, "
        "\"objection_categories\": [...], "
        "\"competitor_mentioned\": \"... | null\", "
        "\"suggested_followup\": \"...\"}\n\n"
        "Definitions:\n"
        "- positive: explicit interest, asks for demo/call/info\n"
        "- objection: pushback (price, timing, capability) but engaging\n"
        "- not_now: timing-deferred but open later (>30d)\n"
        "- unsubscribe: explicit opt-out\n"
        "- referral: forwarded to colleague\n"
        "- oof: out-of-office auto-reply\n"
        "- unclear: needs human review"
    )
    user = (
        f"REPLY:\n{state.get('reply_body')}\n\n"
        f"THREAD HISTORY (last 3):\n{state.get('thread_history', [])[:3]}"
    )
    raw = await llm.complete(tier="fast", system=system, user=user, max_tokens=400)
    # TODO: parse JSON, validate
    return {"intent": "unclear", "confidence": 0.0, "extracted_properties": []}


async def handle_per_intent(state: ReplyClassifierState) -> dict:
    """Route based on classified intent."""
    routing_map = {
        "positive": "alert_ae",
        "objection": "alert_ae_with_context",
        "not_now": "nurture",
        "unsubscribe": "suppress",
        "referral": "alert_ae",
        "oof": "reschedule",
        "unclear": "manual_review",
    }
    action = routing_map.get(state.get("intent", "unclear"), "manual_review")

    if action == "suppress":
        # TODO: append to gtm.suppression-list Sheet + Smartlead suppression list
        sl = SmartleadClient()
        try:
            # TODO: sl.pause_lead() + add email to global suppression
            pass
        finally:
            await sl.aclose()
    elif action in ("alert_ae", "alert_ae_with_context"):
        # TODO: Slack DM to deal owner with reply context + suggested followup
        pass
    elif action == "nurture":
        # TODO: pause Smartlead sequence, enroll in MoEngage 90-day nurture journey
        pass
    elif action == "reschedule":
        # TODO: parse OOF return-date, pause Smartlead until then
        pass

    return {"routing_action": action}


async def write_sf_activity(state: ReplyClassifierState) -> dict:
    hub = HubSpotClient()
    try:
        # TODO: SF Activity create — type=email_reply, subtype=$intent, body=reply summary
        return {"sf_activity_id": "<activity-id>"}
    finally:
        await hub.aclose()


async def write_extracted_property(state: ReplyClassifierState) -> dict:
    """If reply contained objection or competitor mention, persist to Postgres."""
    # TODO: INSERT INTO extracted_property for each objection/competitor extracted
    # property_name='objection_raised' OR 'competitor_mentioned'
    # source_type='email_reply', source_id=$sf_activity_id, extracted_by_agent='cf-reply-classifier'
    return {}


async def audit_log(state: ReplyClassifierState) -> dict:
    return {}


def build_reply_classifier_graph():
    g = StateGraph(ReplyClassifierState)
    for name, fn in [
        ("parse_reply_payload", parse_reply_payload),
        ("fetch_thread_context", fetch_thread_context),
        ("classify_intent", classify_intent),
        ("handle_per_intent", handle_per_intent),
        ("write_sf_activity", write_sf_activity),
        ("write_extracted_property", write_extracted_property),
        ("audit_log", audit_log),
    ]:
        g.add_node(name, fn)

    g.add_edge(START, "parse_reply_payload")
    g.add_edge("parse_reply_payload", "fetch_thread_context")
    g.add_edge("fetch_thread_context", "classify_intent")
    g.add_edge("classify_intent", "handle_per_intent")
    g.add_edge("handle_per_intent", "write_sf_activity")
    g.add_edge("write_sf_activity", "write_extracted_property")
    g.add_edge("write_extracted_property", "audit_log")
    g.add_edge("audit_log", END)

    return g.compile(checkpointer=default_checkpointer())
