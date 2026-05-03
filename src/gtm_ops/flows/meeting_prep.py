"""Flow 1 — AI copilot for meeting prep (canonical scaffold).

Pulls deal history (HubSpot) + stakeholder context + competitive moves + past transcripts,
synthesizes a meeting brief, pauses for rep approval, posts to Slack.

Graph:
    START
      → fetch_deal             (HubSpot)
      → fetch_stakeholders     (HubSpot contacts + ZoomInfo/Apollo enrichment)
      → fetch_competitive      (Ahrefs + Meta Ads Library)
      → fetch_past_touchpoints (llm-wiki + past Gong/Fathom/Granola transcripts)
      → synthesize_brief       (OpenRouter: Opus tier)
      → [HITL interrupt]
      → post_to_slack
    END
"""

from typing import Any, TypedDict

from langgraph.graph import END, START, StateGraph

from ..integrations.hubspot import HubSpotClient
from ..integrations.openrouter import OpenRouterClient
from ._base import default_checkpointer


class MeetingPrepState(TypedDict, total=False):
    deal_id: str
    deal: dict[str, Any]
    stakeholders: list[dict]
    competitive: dict[str, Any]
    past_touchpoints: list[str]
    brief: str
    approved: bool
    posted: bool
    error: str | None


async def fetch_deal(state: MeetingPrepState) -> dict:
    hub = HubSpotClient()
    try:
        deal = await hub.get_deal(state["deal_id"])
        return {"deal": deal.model_dump()}
    finally:
        await hub.aclose()


async def fetch_stakeholders(state: MeetingPrepState) -> dict:
    # TODO: hub.list_associated_contacts → hub.get_contact per id
    # TODO: enrich titles/seniority via ZoomInfo or Apollo
    return {"stakeholders": []}


async def fetch_competitive(state: MeetingPrepState) -> dict:
    # TODO: call AhrefsClient.traffic_snapshot(domain) + MetaAdsClient.recent_creative(page_id)
    return {"competitive": {}}


async def fetch_past_touchpoints(state: MeetingPrepState) -> dict:
    # TODO: read llm-wiki account page + semantic search over transcripts table (pgvector)
    return {"past_touchpoints": []}


async def synthesize_brief(state: MeetingPrepState) -> dict:
    llm = OpenRouterClient()
    system = (
        "You are a senior sales copilot. Write a 1-page meeting brief: "
        "account summary (3 lines), recent moves (3 bullets), stakeholders (names + roles), "
        "competitive context (2 lines), recommended questions (5), recommended next step (1 line)."
    )
    user = (
        f"Deal: {state.get('deal')}\n\n"
        f"Stakeholders: {state.get('stakeholders')}\n\n"
        f"Competitive: {state.get('competitive')}\n\n"
        f"Past touchpoints: {state.get('past_touchpoints')}"
    )
    brief = await llm.complete(tier="smart", system=system, user=user, max_tokens=1500)
    return {"brief": brief}


async def post_to_slack(state: MeetingPrepState) -> dict:
    if not state.get("approved"):
        return {"posted": False, "error": "awaiting approval"}
    # TODO: slack_sdk WebClient().chat_postMessage to deal's channel, @mention owner
    return {"posted": True}


def build_meeting_prep_graph():
    g = StateGraph(MeetingPrepState)
    g.add_node("fetch_deal", fetch_deal)
    g.add_node("fetch_stakeholders", fetch_stakeholders)
    g.add_node("fetch_competitive", fetch_competitive)
    g.add_node("fetch_past_touchpoints", fetch_past_touchpoints)
    g.add_node("synthesize_brief", synthesize_brief)
    g.add_node("post_to_slack", post_to_slack)

    g.add_edge(START, "fetch_deal")
    g.add_edge("fetch_deal", "fetch_stakeholders")
    g.add_edge("fetch_stakeholders", "fetch_competitive")
    g.add_edge("fetch_competitive", "fetch_past_touchpoints")
    g.add_edge("fetch_past_touchpoints", "synthesize_brief")
    g.add_edge("synthesize_brief", "post_to_slack")
    g.add_edge("post_to_slack", END)

    return g.compile(
        checkpointer=default_checkpointer(),
        interrupt_before=["post_to_slack"],  # HITL — rep approves before Slack post
    )
