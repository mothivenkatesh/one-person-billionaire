"""Agent 6 — Dormant-Detector (Re-engagement loop).

Weekly Tuesday 6am cron. Scans accounts/merchants for no meaningful activity in
30/60/90-day windows. Generates personalized re-engagement reasons + drafts win-back
sequence. Tier-aware routing: ₹50L+ accounts → AE Slack alert; SMB → MoEngage journey.

Graph:
    START
      → segment_by_dormancy_window   (Postgres mart_account_health.temperature)
      → fetch_last_meaningful_touch  (interactions table — what was the last real engagement?)
      → fetch_change_signals         (anything happened to this account since? funding, traffic, news?)
      → generate_reengagement_reason (Claude — ONE specific reason worth re-opening the door)
      → draft_winback_sequence       (Claude — tier-aware: AE-grade for >₹50L, lifecycle-grade for SMB)
      → route_by_tier
      → enroll_or_alert
      → audit_log
    END
"""

from typing import Any, TypedDict

from langgraph.graph import END, START, StateGraph

from ..integrations.openrouter import OpenRouterClient
from ._base import default_checkpointer


class DormantDetectorState(TypedDict, total=False):
    dormant_accounts: list[dict]      # split by 30/60/90d window
    accounts_with_signals: list[dict] # those with new change signals worth flagging
    reengagement_drafts: dict[str, dict]  # account_id → {reason, draft, tier}
    routed: dict[str, str]            # account_id → channel
    error: str | None


async def segment_by_dormancy_window(state: DormantDetectorState) -> dict:
    """Bucket dormant accounts into 30d / 60d / 90d windows for tier-aware messaging."""
    # TODO: Postgres query on mart_account_health
    # 30d cohort: temperature='cooling', last_touch 30-59 days ago
    # 60d cohort: temperature='cooling', last_touch 60-89 days ago
    # 90d cohort: temperature='dormant', last_touch >= 90 days ago
    return {"dormant_accounts": []}


async def fetch_last_meaningful_touch(state: DormantDetectorState) -> dict:
    """For each dormant account, identify the LAST meaningful engagement (not just opens)."""
    # TODO: SELECT MAX(recorded_at) FROM interactions WHERE account_id = $aid
    # AND touch_type IN ('reply', 'meeting', 'demo', 'proposal')  -- exclude impressions/opens
    return {}


async def fetch_change_signals(state: DormantDetectorState) -> dict:
    """Check if anything notable changed about this account since the last touch.

    The strongest re-engagement hooks: 'I noticed you closed Series C last month' or
    'Your traffic spiked 40% — looks like something changed'.
    """
    accounts_with_signals = []
    for acct in state.get("dormant_accounts", []):
        # TODO: Ahrefs traffic delta since last_touch
        # TODO: Crunchbase/Tracxn funding events since last_touch
        # TODO: LinkedIn job-changes for known champions since last_touch
        # TODO: G2 review activity (product-category researching)
        if True:  # placeholder — only include if at least one signal found
            accounts_with_signals.append({**acct, "change_signals": []})
    return {"accounts_with_signals": accounts_with_signals}


async def generate_reengagement_reason(state: DormantDetectorState) -> dict:
    """For each account, generate ONE specific reason worth re-opening the door.

    Generic 'just checking in' kills credibility. Specific 'I saw X and thought of Y' works.
    """
    llm = OpenRouterClient()
    drafts = {}
    for acct in state.get("accounts_with_signals", []):
        system = (
            "Generate ONE specific reason to re-engage this dormant account. "
            "Must reference a change_signal (funding, traffic, hiring, etc.). "
            "Output JSON: {\"reason\": \"<1 sentence citing the signal>\", "
            "\"hook\": \"<5-8 word email subject>\", "
            "\"angle\": \"<positioning paragraph 30-50 words>\"}"
        )
        user = f"ACCOUNT: {acct}"
        raw = await llm.complete(tier="fast", system=system, user=user, max_tokens=400)
        drafts[acct["account_id"]] = {"reasoning": raw, "tier": acct.get("tier", "C")}
    return {"reengagement_drafts": drafts}


async def draft_winback_sequence(state: DormantDetectorState) -> dict:
    """Tier-aware drafting. ₹50L+ → AE-grade 1:1 email. SMB → MoEngage lifecycle template."""
    llm = OpenRouterClient()
    for account_id, draft_data in state.get("reengagement_drafts", {}).items():
        tier = draft_data.get("tier", "C")
        if tier in ("A", "B"):
            # AE-grade: peer-to-peer email with calendar-direct CTA
            system = "Draft a peer-to-peer 1:1 win-back email (80 words). Reference the change signal. Include a specific calendar slot. Voice: senior peer, no marketing speak."
        else:
            # SMB: MoEngage in-app + email lifecycle copy
            system = "Draft win-back copy for MoEngage lifecycle journey: (1) email subject (35 chars), (2) email body (60 words), (3) in-app banner (15 words). Touch is automated; tone is brand-warm not bossy."
        user = f"REASONING: {draft_data['reasoning']}"
        raw = await llm.complete(tier="smart" if tier in ("A", "B") else "fast",
                                 system=system, user=user, max_tokens=500)
        draft_data["draft"] = raw
    return {}


async def route_by_tier(state: DormantDetectorState) -> dict:
    routed = {}
    for account_id, draft_data in state.get("reengagement_drafts", {}).items():
        tier = draft_data.get("tier", "C")
        if tier in ("A", "B"):
            routed[account_id] = "ae_slack_alert"  # high-value, human-led
        else:
            routed[account_id] = "moengage_winback_journey"  # automated lifecycle
    return {"routed": routed}


async def enroll_or_alert(state: DormantDetectorState) -> dict:
    """Execute the routing — Slack DM or MoEngage enrollment."""
    for account_id, channel in state.get("routed", {}).items():
        if channel == "ae_slack_alert":
            # TODO: Slack DM to deal owner with full context + draft email + change signals
            pass
        elif channel == "moengage_winback_journey":
            # TODO: MoEngage API — set user attribute is_winback_target=true,
            # enroll in 4-touch winback flow with personalized merge fields
            pass
    return {}


async def audit_log(state: DormantDetectorState) -> dict:
    return {}


def build_dormant_detector_graph():
    g = StateGraph(DormantDetectorState)
    for name, fn in [
        ("segment_by_dormancy_window", segment_by_dormancy_window),
        ("fetch_last_meaningful_touch", fetch_last_meaningful_touch),
        ("fetch_change_signals", fetch_change_signals),
        ("generate_reengagement_reason", generate_reengagement_reason),
        ("draft_winback_sequence", draft_winback_sequence),
        ("route_by_tier", route_by_tier),
        ("enroll_or_alert", enroll_or_alert),
        ("audit_log", audit_log),
    ]:
        g.add_node(name, fn)

    g.add_edge(START, "segment_by_dormancy_window")
    g.add_edge("segment_by_dormancy_window", "fetch_last_meaningful_touch")
    g.add_edge("fetch_last_meaningful_touch", "fetch_change_signals")
    g.add_edge("fetch_change_signals", "generate_reengagement_reason")
    g.add_edge("generate_reengagement_reason", "draft_winback_sequence")
    g.add_edge("draft_winback_sequence", "route_by_tier")
    g.add_edge("route_by_tier", "enroll_or_alert")
    g.add_edge("enroll_or_alert", "audit_log")
    g.add_edge("audit_log", END)

    return g.compile(checkpointer=default_checkpointer())
