"""Flow 3 — CRM enrichment pipeline (canonical scaffold).

Triggered by a HubSpot webhook on new-deal or new-contact. Runs a Clay-style waterfall
(Apollo → ZoomInfo → Proxycurl → Claygent fallback), scores against ICP, writes back.

Graph:
    START
      → receive_webhook
      → apollo_enrich        (cheap, fast)
      → zoominfo_enrich      (premium firmographics — only if gaps)
      → proxycurl_linkedin   (contact + company LI data)
      → claygent_fallback    (Haiku web research for bespoke fields)
      → score_against_icp    (OpenRouter Haiku)
      → writeback_hubspot
    END
"""

from typing import Any, TypedDict

from langgraph.graph import END, START, StateGraph

from ..integrations.hubspot import HubSpotClient
from ..integrations.openrouter import OpenRouterClient
from ._base import default_checkpointer


class EnrichmentState(TypedDict, total=False):
    deal_id: str
    account_domain: str
    enrichment: dict[str, Any]
    score: float
    gaps: list[str]
    writeback_status: str


async def receive_webhook(state: EnrichmentState) -> dict:
    # TODO: parse HubSpot webhook envelope, resolve account_domain from deal → account
    return {"enrichment": {}}


async def apollo_enrich(state: EnrichmentState) -> dict:
    # TODO: Apollo API: people_search + organizations_enrich by domain
    return {"enrichment": state.get("enrichment", {})}


async def zoominfo_enrich(state: EnrichmentState) -> dict:
    # TODO: Only fire if apollo left gaps — check state["gaps"]
    return {"enrichment": state.get("enrichment", {})}


async def proxycurl_linkedin(state: EnrichmentState) -> dict:
    # TODO: Proxycurl /linkedin/company/profile + /linkedin/person/profile for key contacts
    return {"enrichment": state.get("enrichment", {})}


async def claygent_fallback(state: EnrichmentState) -> dict:
    """Use OpenRouter-Haiku as a Claygent substitute for bespoke web research."""
    if not state.get("gaps"):
        return {"enrichment": state.get("enrichment", {})}
    # TODO: for each gap, craft a research prompt + web tool call via OpenRouter
    return {"enrichment": state.get("enrichment", {})}


async def score_against_icp(state: EnrichmentState) -> dict:
    llm = OpenRouterClient()
    score_str = await llm.complete(
        tier="fast",
        system="Return a float 0.0–5.0 scoring ICP fit. No prose, just the number.",
        user=str(state.get("enrichment", {})),
        max_tokens=10,
    )
    try:
        return {"score": float(score_str.strip())}
    except ValueError:
        return {"score": 0.0}


async def writeback_hubspot(state: EnrichmentState) -> dict:
    hub = HubSpotClient()
    try:
        properties = {
            "icp_score": str(state.get("score", 0.0)),
            # TODO: flatten enrichment dict into HubSpot custom properties
        }
        await hub.update_deal(state["deal_id"], properties)
        return {"writeback_status": "ok"}
    finally:
        await hub.aclose()


def build_crm_enrichment_graph():
    g = StateGraph(EnrichmentState)
    for name, fn in [
        ("receive_webhook", receive_webhook),
        ("apollo_enrich", apollo_enrich),
        ("zoominfo_enrich", zoominfo_enrich),
        ("proxycurl_linkedin", proxycurl_linkedin),
        ("claygent_fallback", claygent_fallback),
        ("score_against_icp", score_against_icp),
        ("writeback_hubspot", writeback_hubspot),
    ]:
        g.add_node(name, fn)

    g.add_edge(START, "receive_webhook")
    g.add_edge("receive_webhook", "apollo_enrich")
    g.add_edge("apollo_enrich", "zoominfo_enrich")
    g.add_edge("zoominfo_enrich", "proxycurl_linkedin")
    g.add_edge("proxycurl_linkedin", "claygent_fallback")
    g.add_edge("claygent_fallback", "score_against_icp")
    g.add_edge("score_against_icp", "writeback_hubspot")
    g.add_edge("writeback_hubspot", END)

    return g.compile(checkpointer=default_checkpointer())
