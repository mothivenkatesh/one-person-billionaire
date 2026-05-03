"""Agent 7 — Churn-Saver (Re-engagement loop).

Daily 6am cron. For ACTIVE merchants, computes a composite churn-risk signal:
- Usage drop >50% over 14d (Postgres product_usage)
- Support ticket sentiment trending negative (Freshdesk/Zendesk via cf-drive-transcript-extractor variant)
- Competitor mention in latest call transcript (extracted_property)
- Low NPS response (Google Forms webhook trigger via cf-forms-router)
- Recent churn-exit-survey responses

Generates save-brief with talking points + cited transcript evidence.
Routes: SMB tier → auto MoEngage WhatsApp + email; ₹10L+/mo → CSM Slack alert.

Graph:
    START
      → compute_composite_churn_signal  (mart_account_health.churn_risk_score + recent extractions)
      → enrich_with_transcript_evidence (specific objection/competitor quotes)
      → fetch_save_history              (have we lost similar accounts? what worked?)
      → generate_save_brief             (Claude Opus — CSM playbook output)
      → route_by_tier_and_value
      → execute_save_motion             (CSM Slack OR MoEngage save journey)
      → audit_log
    END
"""

from typing import Any, TypedDict

from langgraph.graph import END, START, StateGraph

from ..integrations.openrouter import OpenRouterClient
from ._base import default_checkpointer


class ChurnSaverState(TypedDict, total=False):
    at_risk_accounts: list[dict]   # composite score above threshold
    enriched_evidence: dict[str, list[dict]]  # account_id → [{quote, source, date}]
    save_history: dict[str, Any]   # historical save patterns
    save_briefs: dict[str, dict]   # account_id → CSM-ready brief
    routed: dict[str, str]         # account_id → channel
    saves_initiated: int
    error: str | None


async def compute_composite_churn_signal(state: ChurnSaverState) -> dict:
    """Pull from mart_account_health where churn_risk_score >= 3.0 AND temperature != 'never_touched'."""
    # TODO: Postgres query
    # SELECT * FROM mart_account_health
    # WHERE churn_risk_score >= 3.0
    #   AND temperature IN ('hot', 'warm', 'cooling')   -- exclude already-dormant
    #   AND won_revenue > 0                              -- only paying customers
    # ORDER BY churn_risk_score DESC
    return {"at_risk_accounts": []}


async def enrich_with_transcript_evidence(state: ChurnSaverState) -> dict:
    """For each at-risk account, pull the EXACT verbatim quotes that triggered the risk score.

    CSMs trust the brief when they see the quote. Aggregate evidence breaks if it's just numbers.
    """
    enriched = {}
    for acct in state.get("at_risk_accounts", []):
        # TODO: SELECT property_value, source_id, extracted_at FROM extracted_property
        # WHERE account_id = $aid
        #   AND property_name IN ('churn_risk_phrase', 'competitor_mentioned', 'objection_raised')
        #   AND extracted_at > now() - interval '60 days'
        # ORDER BY extracted_at DESC LIMIT 5
        enriched[acct["account_id"]] = []
    return {"enriched_evidence": enriched}


async def fetch_save_history(state: ChurnSaverState) -> dict:
    """Have we lost similar accounts? What worked when we saved them?

    Cluster of historical save attempts by tier × vertical × churn_signal_type.
    """
    # TODO: Postgres query on closed_lost deals + their save_attempt records
    # Aggregate: which save tactics had highest success rate per cluster?
    return {"save_history": {}}


async def generate_save_brief(state: ChurnSaverState) -> dict:
    """CSM-ready save brief with talking points + draft outreach + escalation criteria."""
    llm = OpenRouterClient()
    briefs = {}
    for acct in state.get("at_risk_accounts", []):
        evidence = state["enriched_evidence"].get(acct["account_id"], [])
        system = (
            "You are a CSM coach. Write a save-brief for this at-risk merchant. Sections: "
            "(1) Risk diagnosis (1 line citing 2 specific evidence items by date), "
            "(2) Top 3 talking points to lead the save call, "
            "(3) Draft 3-line check-in message (WhatsApp+email format), "
            "(4) Pre-empt the most likely objection, "
            "(5) Escalation criteria (when to loop in VP CS). "
            "Voice: peer to CSM, no marketing speak."
        )
        user = (
            f"AT-RISK ACCOUNT: {acct}\n\n"
            f"TRANSCRIPT EVIDENCE: {evidence}\n\n"
            f"SAVE HISTORY (similar accounts): {state.get('save_history')}"
        )
        brief = await llm.complete(tier="smart", system=system, user=user, max_tokens=1500)
        briefs[acct["account_id"]] = {"brief": brief, "tier": acct.get("tier"),
                                      "monthly_value": acct.get("won_revenue", 0)}
    return {"save_briefs": briefs}


async def route_by_tier_and_value(state: ChurnSaverState) -> dict:
    """₹10L+/mo monthly value → CSM Slack. SMB → auto MoEngage WhatsApp + email."""
    routed = {}
    for account_id, brief_data in state.get("save_briefs", {}).items():
        monthly_value = brief_data.get("monthly_value", 0)
        if monthly_value >= 1_000_000:  # ₹10L+/mo
            routed[account_id] = "csm_slack_alert"
        else:
            routed[account_id] = "moengage_save_journey"
    return {"routed": routed}


async def execute_save_motion(state: ChurnSaverState) -> dict:
    """Execute per-tier save: human-led for high-value, automated for SMB."""
    saves_initiated = 0
    for account_id, channel in state.get("routed", {}).items():
        if channel == "csm_slack_alert":
            # TODO: Slack DM to account CSM with full save brief + linked evidence
            saves_initiated += 1
        elif channel == "moengage_save_journey":
            # TODO: MoEngage API — set user attribute churn_risk=true,
            # enroll in 5-touch save flow (WhatsApp + email + in-app banner)
            # NO HITL for this tier — speed > polish for SMB churn
            saves_initiated += 1
    return {"saves_initiated": saves_initiated}


async def audit_log(state: ChurnSaverState) -> dict:
    return {}


def build_churn_saver_graph():
    g = StateGraph(ChurnSaverState)
    for name, fn in [
        ("compute_composite_churn_signal", compute_composite_churn_signal),
        ("enrich_with_transcript_evidence", enrich_with_transcript_evidence),
        ("fetch_save_history", fetch_save_history),
        ("generate_save_brief", generate_save_brief),
        ("route_by_tier_and_value", route_by_tier_and_value),
        ("execute_save_motion", execute_save_motion),
        ("audit_log", audit_log),
    ]:
        g.add_node(name, fn)

    g.add_edge(START, "compute_composite_churn_signal")
    g.add_edge("compute_composite_churn_signal", "enrich_with_transcript_evidence")
    g.add_edge("enrich_with_transcript_evidence", "fetch_save_history")
    g.add_edge("fetch_save_history", "generate_save_brief")
    g.add_edge("generate_save_brief", "route_by_tier_and_value")
    g.add_edge("route_by_tier_and_value", "execute_save_motion")
    g.add_edge("execute_save_motion", "audit_log")
    g.add_edge("audit_log", END)

    return g.compile(checkpointer=default_checkpointer())
