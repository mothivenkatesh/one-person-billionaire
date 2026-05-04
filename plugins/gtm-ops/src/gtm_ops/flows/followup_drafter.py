"""Flow 4 — Follow-up email drafter.

Triggered when a transcript (Drive AI / Fathom / Gong) lands for a deal that's
in stage Working / Meeting Booked / Pipeline. Generates a personalized
follow-up email draft, runs HITL approval, then logs the send back to SF.

Graph:
    START
      → fetch_transcript           (Drive AI / Fathom MCP)
      → fetch_deal_context         (HubSpot/SF — deal + account + past activities)
      → fetch_extracted_properties (Postgres — recent objections, competitors, expansion signals)
      → draft_email                (OpenRouter Haiku — first pass)
      → polish_email               (OpenRouter Opus — voice + brand pass)
      → [HITL interrupt: rep approves]
      → create_gmail_draft         (Gmail MCP)
      → log_send                   (SF activity + Postgres audit)
    END
"""

from typing import Any, TypedDict

from langgraph.graph import END, START, StateGraph

from ..integrations.hubspot import HubSpotClient
from ..integrations.openrouter import OpenRouterClient
from ._base import default_checkpointer


class FollowupDrafterState(TypedDict, total=False):
    deal_id: str
    transcript_id: str
    transcript_text: str
    deal: dict[str, Any]
    past_activities: list[dict]
    extracted_properties: list[dict]
    draft: dict[str, str]      # {subject, body, cta}
    polished: dict[str, str]
    approved: bool
    gmail_draft_id: str | None
    error: str | None


async def fetch_transcript(state: FollowupDrafterState) -> dict:
    # TODO: pull transcript via Drive API (Drive AI) or FathomClient.get_transcript()
    # Strip filler words, normalize speaker labels.
    return {"transcript_text": "<transcript body>"}


async def fetch_deal_context(state: FollowupDrafterState) -> dict:
    hub = HubSpotClient()
    try:
        deal = await hub.get_deal(state["deal_id"])
        # TODO: also fetch past 10 activities, account context, contacts
        return {"deal": deal.model_dump(), "past_activities": []}
    finally:
        await hub.aclose()


async def fetch_extracted_properties(state: FollowupDrafterState) -> dict:
    # TODO: query Postgres `extracted_property` WHERE deal_id = $deal_id
    # Recent (last 30 days) objections, competitors_mentioned, expansion_signals, decision_makers_added
    return {"extracted_properties": []}


async def draft_email(state: FollowupDrafterState) -> dict:
    """First pass — Haiku for speed + cost."""
    llm = OpenRouterClient()
    system = (
        "You are a senior B2B sales follow-up writer. Draft a follow-up email after a sales call. "
        "Length: 80-120 words. Voice: peer-to-peer, no marketing speak. "
        "Reference 1 specific moment from the transcript and 1 specific next step. "
        "Include a calendar-direct CTA with a specific proposed time."
    )
    user = (
        f"DEAL: {state.get('deal')}\n\n"
        f"TRANSCRIPT EXCERPT (last 2000 chars): {state.get('transcript_text', '')[-2000:]}\n\n"
        f"PAST ACTIVITIES (last 10): {state.get('past_activities')}\n\n"
        f"RECENT EXTRACTED PROPERTIES (objections / competitors / signals): {state.get('extracted_properties')}\n\n"
        "Output as JSON: {\"subject\": \"...\", \"body\": \"...\", \"cta\": \"...\"}"
    )
    raw = await llm.complete(tier="fast", system=system, user=user, max_tokens=600)
    # TODO: parse JSON, validate via Pydantic schema
    return {"draft": {"subject": "<draft subject>", "body": raw, "cta": "<draft cta>"}}


async def polish_email(state: FollowupDrafterState) -> dict:
    """Second pass — Opus for voice + brand consistency."""
    llm = OpenRouterClient()
    system = (
        "You are the editor. Polish this follow-up email for: "
        "(a) mothi brand voice (infrastructure-first, product-led, no hype), "
        "(b) DPDP compliance (no claims about data we don't have, no alternate-data references), "
        "(c) tone match to the prospect's seniority level (CFO ≠ founder ≠ developer-IC), "
        "(d) one improvement to the CTA — make it more specific or lower-friction. "
        "Keep total length within 100 words."
    )
    user = (
        f"DRAFT TO POLISH:\nSubject: {state['draft']['subject']}\n\n"
        f"Body: {state['draft']['body']}\n\n"
        f"CTA: {state['draft']['cta']}\n\n"
        f"DEAL CONTEXT: {state.get('deal')}\n\n"
        "Output as JSON: {\"subject\": \"...\", \"body\": \"...\", \"cta\": \"...\"}"
    )
    raw = await llm.complete(tier="smart", system=system, user=user, max_tokens=500)
    # TODO: parse JSON, validate via Pydantic schema
    return {"polished": {"subject": "<polished>", "body": raw, "cta": "<polished cta>"}}


async def create_gmail_draft(state: FollowupDrafterState) -> dict:
    """Only fires if HITL approval = True."""
    if not state.get("approved"):
        return {"gmail_draft_id": None, "error": "awaiting approval"}
    # TODO: Gmail MCP create-draft call with rep's email as sender
    # TODO: include UTM tags on any links per spec §11.3
    return {"gmail_draft_id": "<gmail-draft-id>"}


async def log_send(state: FollowupDrafterState) -> dict:
    if not state.get("gmail_draft_id"):
        return {"error": "no draft to log"}
    # TODO: Write SF Activity (type=email_draft, related to deal)
    # TODO: Write Postgres `agent_decisions` audit entry
    # TODO: Write Postgres `interactions` row (channel=ae_email, touch_type=draft_created)
    return {}


def build_followup_drafter_graph():
    g = StateGraph(FollowupDrafterState)
    g.add_node("fetch_transcript", fetch_transcript)
    g.add_node("fetch_deal_context", fetch_deal_context)
    g.add_node("fetch_extracted_properties", fetch_extracted_properties)
    g.add_node("draft_email", draft_email)
    g.add_node("polish_email", polish_email)
    g.add_node("create_gmail_draft", create_gmail_draft)
    g.add_node("log_send", log_send)

    g.add_edge(START, "fetch_transcript")
    g.add_edge("fetch_transcript", "fetch_deal_context")
    g.add_edge("fetch_deal_context", "fetch_extracted_properties")
    g.add_edge("fetch_extracted_properties", "draft_email")
    g.add_edge("draft_email", "polish_email")
    g.add_edge("polish_email", "create_gmail_draft")
    g.add_edge("create_gmail_draft", "log_send")
    g.add_edge("log_send", END)

    return g.compile(
        checkpointer=default_checkpointer(),
        interrupt_before=["create_gmail_draft"],  # HITL — rep approves before Gmail draft
    )
