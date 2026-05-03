"""Agent 1 — ICP-Scout (Acquisition loop).

Daily 6am cron + Google Forms webhook (real-time path for inbound demos).

Pulls new prospects from multiple sources, runs Clay-style waterfall enrichment,
scores against Cashfree ICP using the `cf-icp-scout` skill, and routes to SF as
a Lead with tier (A/B/C/plg/long_tail/disqualified) + recommended_action.

Sources:
- LinkedIn Sales Navigator (saved searches → new connections)
- Ahrefs (traffic-spike alerts on watched domains)
- SimilarWeb (visitor signal on watched accounts)
- Bombora intent (when added in v2)
- Google Forms (inbound demo requests, content downloads, webinar reg) — real-time webhook bypass

Graph:
    START
      → ingest_sources                (parallel fan-in: Sales Nav + Ahrefs + SimilarWeb + Forms)
      → dedupe_against_existing_sf    (skip if account already in SF as deal/customer)
      → enrich_clay_waterfall         (Apollo → ZoomInfo → Proxycurl → Hunter → Claygent fallback)
      → score_against_icp             (Claude Haiku, loads cf-icp-scout skill)
      → tier_and_route                (write SF Lead with icp_score, intent_score, tier, evidence)
      → emit_signal_if_high_intent    (write to Postgres signals table for downstream agents)
      → audit_log                     (write agent_decisions row)
    END
"""

from typing import Any, TypedDict

from langgraph.graph import END, START, StateGraph

from ..integrations.hubspot import HubSpotClient
from ..integrations.openrouter import OpenRouterClient
from ._base import default_checkpointer


class ICPScoutState(TypedDict, total=False):
    trigger_type: str  # "cron_daily" | "forms_webhook"
    trigger_payload: dict[str, Any]
    raw_prospects: list[dict]              # [{name, domain, source, raw_signals}]
    new_prospects: list[dict]              # after dedupe
    enriched: list[dict]                   # after Clay waterfall
    scored: list[dict]                     # after Claude scoring
    sf_leads_created: list[str]            # SF Lead IDs
    high_intent_signals: list[dict]        # for downstream agents
    cost_usd: float
    error: str | None


async def ingest_sources(state: ICPScoutState) -> dict:
    """Fan-in from multiple sources. For Forms webhook, payload is already a single prospect."""
    trigger = state.get("trigger_type", "cron_daily")
    if trigger == "forms_webhook":
        # Real-time path: single prospect from form submission
        payload = state["trigger_payload"]
        return {"raw_prospects": [{
            "name": payload.get("company"),
            "domain": payload.get("email", "").split("@")[-1],
            "source": "google_forms",
            "raw_signals": {"form_type": payload.get("form_name"), "intent_explicit": True},
        }]}
    # TODO: Sales Nav saved-search export, Ahrefs alerts, SimilarWeb watch, Bombora topics
    return {"raw_prospects": []}


async def dedupe_against_existing_sf(state: ICPScoutState) -> dict:
    """Skip prospects already in SF as Lead/Account/Opportunity to avoid double-touch."""
    hub = HubSpotClient()
    try:
        # TODO: batch SF SOQL: SELECT Domain FROM Account WHERE Domain IN (...)
        existing_domains: set[str] = set()
        new_prospects = [p for p in state["raw_prospects"] if p["domain"] not in existing_domains]
        return {"new_prospects": new_prospects}
    finally:
        await hub.aclose()


async def enrich_clay_waterfall(state: ICPScoutState) -> dict:
    """Cascade: Apollo → ZoomInfo → Proxycurl → Hunter → Claygent (Claude web research) fallback."""
    enriched = []
    for prospect in state.get("new_prospects", []):
        # TODO: Apollo /people/match by domain
        # TODO: If Apollo gaps, call ZoomInfo /enrich
        # TODO: Proxycurl /linkedin/company for company-level + /linkedin/person for primary contact
        # TODO: If still gaps, Claude Haiku does web research with Scrapling fallback
        enriched.append({
            **prospect,
            "firmographics": {},
            "tech_stack": [],
            "linkedin_company_url": None,
            "primary_contact": None,
            "recent_news_summary": None,
        })
    return {"enriched": enriched}


async def score_against_icp(state: ICPScoutState) -> dict:
    """Load cf-icp-scout skill, call Claude Haiku per prospect, return ICP score + tier."""
    llm = OpenRouterClient()
    scored = []
    for p in state.get("enriched", []):
        # TODO: load skill from Drive at runtime (cf-icp-scout/SKILL.md)
        skill_body = "<cf-icp-scout skill body loaded from Shared Drive>"
        system = skill_body
        user = f"Score this prospect:\n{p}"
        raw = await llm.complete(tier="fast", system=system, user=user, max_tokens=600)
        # TODO: parse JSON, validate via Pydantic schema (ICPScoutOutput)
        scored.append({**p, "scoring_result": raw})
    return {"scored": scored}


async def tier_and_route(state: ICPScoutState) -> dict:
    """Write SF Lead with tier + score. Route Tier A/B to AE; Tier C to BDR queue."""
    hub = HubSpotClient()
    sf_lead_ids = []
    try:
        for p in state.get("scored", []):
            # TODO: parse scoring_result, skip if tier='disqualified'
            # TODO: SF Lead create with custom fields: icp_score, intent_score, tier, evidence_summary, source
            # TODO: route based on tier — owner_email = AE round-robin (A/B) or BDR queue (C)
            sf_lead_ids.append("<sf-lead-id>")
        return {"sf_leads_created": sf_lead_ids}
    finally:
        await hub.aclose()


async def emit_signal_if_high_intent(state: ICPScoutState) -> dict:
    """For Tier A/B prospects, also write to Postgres signals table so Stage-Mover/Cross-Sell pick them up."""
    # TODO: INSERT INTO signals (account_id, source, signal_type, strength, observed_at, metadata)
    # for tier in ['A','B'] AND intent_score >= 3.5
    return {"high_intent_signals": []}


async def audit_log(state: ICPScoutState) -> dict:
    """Write agent_decisions row per spec §3.2 reliability rule #11."""
    # TODO: INSERT INTO agent_decisions (agent_name='cf-icp-scout', input_payload, output_payload,
    # skills_loaded, mcps_called, model_version, cost_usd, latency_ms, status)
    return {}


def build_icp_scout_graph():
    g = StateGraph(ICPScoutState)
    g.add_node("ingest_sources", ingest_sources)
    g.add_node("dedupe_against_existing_sf", dedupe_against_existing_sf)
    g.add_node("enrich_clay_waterfall", enrich_clay_waterfall)
    g.add_node("score_against_icp", score_against_icp)
    g.add_node("tier_and_route", tier_and_route)
    g.add_node("emit_signal_if_high_intent", emit_signal_if_high_intent)
    g.add_node("audit_log", audit_log)

    g.add_edge(START, "ingest_sources")
    g.add_edge("ingest_sources", "dedupe_against_existing_sf")
    g.add_edge("dedupe_against_existing_sf", "enrich_clay_waterfall")
    g.add_edge("enrich_clay_waterfall", "score_against_icp")
    g.add_edge("score_against_icp", "tier_and_route")
    g.add_edge("tier_and_route", "emit_signal_if_high_intent")
    g.add_edge("emit_signal_if_high_intent", "audit_log")
    g.add_edge("audit_log", END)

    return g.compile(checkpointer=default_checkpointer())
