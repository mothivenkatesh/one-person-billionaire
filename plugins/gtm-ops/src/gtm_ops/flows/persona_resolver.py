"""Utility — Persona Resolver.

Maps SF Contact title strings to canonical persona names declared in
persona_registry. Used by every persona-aware agent at runtime.

Two modes:
1. Synchronous lookup: given a title + vertical, return persona_canonical (or None)
2. Bulk backfill: scan contacts table, set persona_canonical on rows where it's null

Resolution strategy (deterministic, then LLM fallback):
1. Exact match against persona_registry.common_titles
2. Keyword match (case-insensitive substring) — pick highest-priority registry entry
3. LLM fallback (Claude Haiku) — only if no deterministic match AND we have title + company context

Confidence:
- Exact common_titles match → 0.95
- Keyword match → 0.75
- LLM fallback → returned by Claude (typically 0.6–0.85)
- <0.8 → set persona_canonical but flag persona_confidence < 0.8 for manual review
"""

from typing import Any, TypedDict

from langgraph.graph import END, START, StateGraph

from ..integrations.openrouter import OpenRouterClient
from ._base import default_checkpointer


class PersonaResolverState(TypedDict, total=False):
    contact_id: str
    title: str
    vertical: str         # developer | d2c-operator | bfsi | saas
    company_size: int
    company_context: dict[str, Any]
    candidates: list[dict]      # registry rows that passed initial filter
    deterministic_match: dict | None
    llm_match: dict | None
    final_resolution: dict | None
    error: str | None


# =============================================
# Synchronous helper (called by other agents)
# =============================================

async def resolve_persona(
    title: str,
    vertical: str,
    company_size: int | None = None,
    use_llm_fallback: bool = True,
) -> dict[str, Any]:
    """Synchronous-ish resolver.

    Returns: {"persona_canonical": str|None, "confidence": float, "method": str, "needs_review": bool}
    """
    # 1. Try exact common_titles match against persona_registry
    deterministic = _exact_match_lookup(title, vertical)
    if deterministic:
        return {
            "persona_canonical": deterministic["persona_canonical"],
            "confidence": 0.95,
            "method": "exact_common_titles_match",
            "needs_review": False,
        }

    # 2. Keyword/substring match
    keyword = _keyword_match_lookup(title, vertical)
    if keyword:
        return {
            "persona_canonical": keyword["persona_canonical"],
            "confidence": 0.75,
            "method": "keyword_substring_match",
            "needs_review": True,  # <0.8 → flag for manual review
        }

    # 3. LLM fallback
    if use_llm_fallback:
        llm = await _llm_resolve(title, vertical, company_size)
        if llm:
            return {**llm, "method": "llm_fallback"}

    return {
        "persona_canonical": None,
        "confidence": 0.0,
        "method": "no_match",
        "needs_review": True,
    }


def _exact_match_lookup(title: str, vertical: str) -> dict | None:
    """SQL: SELECT * FROM persona_registry WHERE vertical = $vertical AND $title = ANY(common_titles)."""
    # TODO: real Postgres query
    # Simulated for unit-testing purposes:
    title_normalized = title.strip().lower()
    # In production, query persona_registry table
    return None


def _keyword_match_lookup(title: str, vertical: str) -> dict | None:
    """Case-insensitive substring match on common_titles + keyword priority."""
    # TODO: real Postgres query with ILIKE
    title_normalized = title.strip().lower()
    return None


async def _llm_resolve(title: str, vertical: str, company_size: int | None) -> dict | None:
    """Claude Haiku: given title + vertical + company_size, classify into persona_canonical."""
    llm = OpenRouterClient()
    system = (
        "Classify this contact's persona. Return JSON: "
        "{\"persona_canonical\": \"backend-engineer | founder-d2c | head-of-payments | "
        "cfo-d2c | head-of-growth | head-of-ops | head-of-onboarding | compliance-head | "
        "chief-risk-officer | cto-startup | cfo-saas | head-of-revops | tech-lead | "
        "devops-sre | security-engineer | marketing-lead | unknown\", \"confidence\": 0.0-1.0, "
        "\"reasoning\": \"...\"}\n\n"
        "Apply Indian-fintech context: head-of-payments only for BFSI; founder-d2c only for "
        "D2C ≤500 employees; tech-lead/backend-engineer for developer/SaaS engineering roles."
    )
    user = f"TITLE: {title}\nVERTICAL: {vertical}\nCOMPANY SIZE: {company_size or 'unknown'}"
    raw = await llm.complete(tier="fast", system=system, user=user, max_tokens=200)
    # TODO: parse JSON, validate confidence threshold
    return None


# =============================================
# LangGraph flow for bulk backfill (cron job)
# =============================================

async def fetch_unresolved_contacts(state: PersonaResolverState) -> dict:
    # TODO: SELECT id, title, account.vertical, account.employees FROM contacts
    # WHERE persona_canonical IS NULL LIMIT 1000
    return {"candidates": []}


async def resolve_each(state: PersonaResolverState) -> dict:
    resolutions = []
    for contact in state.get("candidates", []):
        resolution = await resolve_persona(
            title=contact["title"],
            vertical=contact["vertical"],
            company_size=contact.get("company_size"),
        )
        resolutions.append({**contact, "resolution": resolution})
    return {"final_resolution": {"resolutions": resolutions}}


async def writeback_to_contacts(state: PersonaResolverState) -> dict:
    # TODO: UPDATE contacts SET persona_canonical, persona_confidence,
    # persona_resolved_by='cf-persona-resolver', persona_resolved_at=now()
    # WHERE id = $contact_id
    return {}


async def log_known_instances(state: PersonaResolverState) -> dict:
    # TODO: INSERT INTO persona_known_instances for each resolved contact
    # ON CONFLICT (persona_canonical, contact_id) DO UPDATE SET last_observed_at = now()
    return {}


def build_persona_resolver_graph():
    g = StateGraph(PersonaResolverState)
    g.add_node("fetch_unresolved_contacts", fetch_unresolved_contacts)
    g.add_node("resolve_each", resolve_each)
    g.add_node("writeback_to_contacts", writeback_to_contacts)
    g.add_node("log_known_instances", log_known_instances)

    g.add_edge(START, "fetch_unresolved_contacts")
    g.add_edge("fetch_unresolved_contacts", "resolve_each")
    g.add_edge("resolve_each", "writeback_to_contacts")
    g.add_edge("writeback_to_contacts", "log_known_instances")
    g.add_edge("log_known_instances", END)

    return g.compile(checkpointer=default_checkpointer())
