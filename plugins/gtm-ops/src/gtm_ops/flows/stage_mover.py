"""Agent 4 — Stage-Mover (Nurture loop).

Daily 7am cron + Calendar API webhook. Two distinct triggers, same skill pack:

(A) Stagnation trigger: scans SF Opportunities for any stuck >14d in current stage.
    Reads Drive transcripts + recent activity + extracted properties → Claude drafts
    a contextual move-forward action and alerts AE in Slack.

(B) Meeting-prep trigger: when Calendar API shows AE meeting with an account in 2h,
    auto-fires meeting-prep brief — pulls SF context, past Drive transcripts of meetings
    with this account, recent signals (Ahrefs/Meta Ads/Sales Nav), relevant collateral
    from Drive, → 1-pager Slack DM to the AE.

Graph (branching on trigger):
    START
      → identify_trigger              (cron stagnation OR calendar meeting-prep)
      → fetch_deal_or_meeting_context
      → fetch_drive_transcripts       (past calls with this account, via Drive API)
      → fetch_extracted_properties    (recent objections, competitors, signals)
      → fetch_competitive_context     (Ahrefs traffic, Meta Ads creative — only for meeting-prep)
      → load_relevant_collateral      (Drive API search by account/vertical)
      → synthesize_action_or_brief    (loads stage-mover skill, calls Opus)
      → post_slack_to_ae              (different format: stagnation alert vs meeting brief)
      → audit_log
    END
"""

from typing import Any, TypedDict

from langgraph.graph import END, START, StateGraph

from ..integrations.hubspot import HubSpotClient
from ..integrations.openrouter import OpenRouterClient
from ._base import default_checkpointer


class StageMoverState(TypedDict, total=False):
    trigger_type: str  # "stagnation" | "meeting_prep"
    deal_id: str | None
    calendar_event_id: str | None
    account_id: str
    deal_context: dict[str, Any]
    transcripts: list[dict]
    extracted_properties: list[dict]
    competitive_context: dict[str, Any]
    collateral: list[dict]
    output: dict[str, Any]  # {format, content}
    slack_posted: bool
    error: str | None


async def identify_trigger(state: StageMoverState) -> dict:
    """Branch on trigger_type to set flags for later nodes."""
    # No-op routing setup
    return {}


async def fetch_deal_or_meeting_context(state: StageMoverState) -> dict:
    hub = HubSpotClient()
    try:
        if state.get("trigger_type") == "meeting_prep":
            # TODO: Calendar API to get attendees, then resolve to SF Account
            pass
        else:
            # TODO: SF SOQL on Opportunity by id (stagnation case)
            pass
        return {"deal_context": {}}
    finally:
        await hub.aclose()


async def fetch_drive_transcripts(state: StageMoverState) -> dict:
    """Pull past meeting transcripts for this account via Drive API."""
    # TODO: Drive API search: parent=mothi-GTM-AI/Transcripts, filename matches account
    # OR: query Postgres transcripts table by account_id
    return {"transcripts": []}


async def fetch_extracted_properties(state: StageMoverState) -> dict:
    """Recent objections, competitors mentioned, expansion signals from this account."""
    # TODO: SELECT * FROM extracted_property WHERE account_id = $aid AND extracted_at > now() - interval '60 days'
    return {"extracted_properties": []}


async def fetch_competitive_context(state: StageMoverState) -> dict:
    """Only for meeting-prep trigger — Ahrefs + Meta Ads recent moves."""
    if state.get("trigger_type") != "meeting_prep":
        return {"competitive_context": {}}
    # TODO: Ahrefs API for domain traffic 30d delta
    # TODO: Meta Ads Library API for current ad creative
    return {"competitive_context": {}}


async def load_relevant_collateral(state: StageMoverState) -> dict:
    """Drive API search for collateral (case studies, decks) matching account vertical/stage."""
    # TODO: Drive API search in mothi-GTM-AI/Collateral/{vertical}/
    return {"collateral": []}


async def synthesize_action_or_brief(state: StageMoverState) -> dict:
    """Load stage-mover skill; output format depends on trigger."""
    llm = OpenRouterClient()
    skill_body = "<stage-mover skill body from Shared Drive>"

    if state.get("trigger_type") == "meeting_prep":
        # 1-page meeting brief
        system = skill_body + "\n\nGenerate a meeting-prep brief: account summary (3 lines), recent moves (3 bullets), stakeholders, competitive context, 5 recommended discovery questions, recommended next step."
    else:
        # Stagnation move-forward action
        system = skill_body + "\n\nGenerate a move-forward action for this stalled opportunity: 1-line diagnosis, 1 specific next step, draft email/InMail body, recommended channel."

    user = (
        f"DEAL CONTEXT: {state.get('deal_context')}\n\n"
        f"PAST TRANSCRIPTS (last 3): {state.get('transcripts', [])[:3]}\n\n"
        f"EXTRACTED PROPERTIES: {state.get('extracted_properties')}\n\n"
        f"COMPETITIVE: {state.get('competitive_context')}\n\n"
        f"RELEVANT COLLATERAL: {state.get('collateral')}"
    )
    output = await llm.complete(tier="smart", system=system, user=user, max_tokens=2000)
    return {"output": {"format": state.get("trigger_type"), "content": output}}


async def post_slack_to_ae(state: StageMoverState) -> dict:
    """Slack DM — different formatting per trigger type."""
    fmt = state.get("output", {}).get("format")
    if fmt == "meeting_prep":
        # TODO: Slack Block Kit — sectioned brief with "📋 Meeting Prep" header
        pass
    else:
        # TODO: Slack Block Kit — "🚨 Deal Stagnation Alert" with 1-click "draft email" button
        pass
    return {"slack_posted": True}


async def audit_log(state: StageMoverState) -> dict:
    return {}


def build_stage_mover_graph():
    g = StateGraph(StageMoverState)
    for name, fn in [
        ("identify_trigger", identify_trigger),
        ("fetch_deal_or_meeting_context", fetch_deal_or_meeting_context),
        ("fetch_drive_transcripts", fetch_drive_transcripts),
        ("fetch_extracted_properties", fetch_extracted_properties),
        ("fetch_competitive_context", fetch_competitive_context),
        ("load_relevant_collateral", load_relevant_collateral),
        ("synthesize_action_or_brief", synthesize_action_or_brief),
        ("post_slack_to_ae", post_slack_to_ae),
        ("audit_log", audit_log),
    ]:
        g.add_node(name, fn)

    g.add_edge(START, "identify_trigger")
    g.add_edge("identify_trigger", "fetch_deal_or_meeting_context")
    g.add_edge("fetch_deal_or_meeting_context", "fetch_drive_transcripts")
    g.add_edge("fetch_drive_transcripts", "fetch_extracted_properties")
    g.add_edge("fetch_extracted_properties", "fetch_competitive_context")
    g.add_edge("fetch_competitive_context", "load_relevant_collateral")
    g.add_edge("load_relevant_collateral", "synthesize_action_or_brief")
    g.add_edge("synthesize_action_or_brief", "post_slack_to_ae")
    g.add_edge("post_slack_to_ae", "audit_log")
    g.add_edge("audit_log", END)

    return g.compile(checkpointer=default_checkpointer())
