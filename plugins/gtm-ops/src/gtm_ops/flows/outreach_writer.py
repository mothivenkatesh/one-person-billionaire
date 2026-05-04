"""Agent 2 — Outreach-Writer (Acquisition loop).

Triggered when ICP-Scout writes a new SF Lead with icp_score >= 3.0 (Tier A/B/C).

Reads the prospect's website, LinkedIn profile, and recent company signals.
Drafts a 3-touch personalized Smartlead sequence using the outreach-writer
skill. Tier A/B routes through HITL approval queue; Tier C auto-sends post-DIN.

Graph:
    START
      → check_din_gate                 (Postgres campaigns table — abort if no live DIN)
      → fetch_prospect_context         (SF Lead + LinkedIn via Proxycurl + Ahrefs traffic + recent news)
      → check_frequency_cap            (per spec §11.6 — 4 touches/quarter cap)
      → load_skill_pack                (outreach-writer + tier-specific persona skill)
      → generate_3_touch_sequence      (Claude Haiku for draft, Opus for polish)
      → compliance_check               (DPDP + brand guidelines pass via classifier)
      → [HITL interrupt: PMM/AE approves Tier A/B; Tier C bypasses]
      → push_to_smartlead              (assign sender domain per pool routing rules)
      → log_interactions               (write touches to Postgres interactions table)
      → audit_log
    END
"""

from typing import Any, TypedDict

from langgraph.graph import END, START, StateGraph

from ..integrations.openrouter import OpenRouterClient
from ..integrations.smartlead import SmartleadClient
from ._base import default_checkpointer


class OutreachWriterState(TypedDict, total=False):
    sf_lead_id: str
    din_id: str
    tier: str  # A | B | C | plg
    vertical: str
    spear_product: str
    prospect_context: dict[str, Any]
    frequency_cap_remaining: int
    sequence: dict[str, Any]  # {touch_1, touch_2, touch_3}
    compliance_pass: bool
    approved: bool
    smartlead_campaign_id: str | None
    error: str | None


async def check_din_gate(state: OutreachWriterState) -> dict:
    """Pre-launch gate per spec §11.6.2 — abort if DIN not approved."""
    # TODO: SELECT din_id FROM campaigns WHERE din_id = $din_id AND approval_status = 'live'
    # If no rows: HALT, log to audit, alert PMM owner in Slack
    return {}


async def fetch_prospect_context(state: OutreachWriterState) -> dict:
    """Pull SF Lead + LinkedIn + Ahrefs + recent news for personalization."""
    # TODO: SF SOQL on Lead by id
    # TODO: Proxycurl /linkedin/person/profile for primary contact
    # TODO: Ahrefs API for domain traffic + recent backlinks
    # TODO: News via Crunchbase/Tracxn or Google News API
    return {"prospect_context": {}}


async def check_frequency_cap(state: OutreachWriterState) -> dict:
    """Per spec §4.3: max 4 touches per merchant per quarter across all channels."""
    # TODO: SELECT COUNT(*) FROM interactions WHERE account_id = $aid AND recorded_at > now() - interval '90 days'
    # frequency_cap_remaining = 4 - count
    return {"frequency_cap_remaining": 4}


async def generate_3_touch_sequence(state: OutreachWriterState) -> dict:
    """Two-pass: Haiku drafts, Opus polishes."""
    if state.get("frequency_cap_remaining", 0) < 3:
        return {"sequence": {}, "error": "frequency_cap_exceeded"}

    llm = OpenRouterClient()

    # First pass: Haiku draft
    skill_body = "<outreach-writer skill body from Shared Drive>"
    persona_skill = f"<persona-{state.get('vertical')}-{state.get('tier')} skill body>"

    draft_system = skill_body + "\n\n" + persona_skill
    draft_user = (
        f"PROSPECT: {state.get('prospect_context')}\n"
        f"TIER: {state.get('tier')}\nVERTICAL: {state.get('vertical')}\n"
        f"SPEAR PRODUCT: {state.get('spear_product')}\n"
        f"DIN: {state.get('din_id')}\n"
        "Draft 3-touch sequence as JSON per skill output schema."
    )
    draft_raw = await llm.complete(tier="fast", system=draft_system, user=draft_user, max_tokens=1500)

    # Second pass: Opus polish for mothi brand voice + compliance
    polish_system = (
        "Polish this 3-touch sequence for: (a) mothi brand voice (infrastructure-first, no hype), "
        "(b) DPDP compliance (no claims about data we don't have), (c) UTM tags on every link, "
        "(d) tier-appropriate length and tone. Return same JSON shape, polished."
    )
    polished = await llm.complete(tier="smart", system=polish_system, user=draft_raw, max_tokens=1500)

    # TODO: parse JSON, Pydantic-validate
    return {"sequence": {"raw": polished}}


async def compliance_check(state: OutreachWriterState) -> dict:
    """Run compliance classifier — DPDP, brand-safety, no-alternate-data-claims."""
    llm = OpenRouterClient()
    system = (
        "You are a compliance classifier. Evaluate this outbound copy for: "
        "(1) DPDP-violation risk, (2) brand-rule violations (mothi voice), "
        "(3) RBI alternate-data claims (forbidden), (4) frequency-cap respect, "
        "(5) unsubscribe-link presence. Return JSON: {pass: bool, issues: [...]}"
    )
    user = str(state.get("sequence"))
    result = await llm.complete(tier="fast", system=system, user=user, max_tokens=400)
    # TODO: parse JSON, set compliance_pass
    return {"compliance_pass": True}


async def push_to_smartlead(state: OutreachWriterState) -> dict:
    """HITL gate honored above; this only fires if approved (or Tier C auto-bypass)."""
    if state.get("tier") in ("A", "B") and not state.get("approved"):
        return {"smartlead_campaign_id": None, "error": "awaiting_approval"}
    if not state.get("compliance_pass"):
        return {"smartlead_campaign_id": None, "error": "compliance_failed"}

    sl = SmartleadClient()
    try:
        # TODO: assign sender domain pool by tier (Tier A/B = mothi-warmed; Tier C = 20-domain rotation)
        campaign_id = await sl.create_campaign(
            name=f"DIN-{state['din_id']}-{state['sf_lead_id']}",
            mailboxes=["<resolved-pool>"],
        )
        # TODO: add lead via sl.add_leads()
        return {"smartlead_campaign_id": campaign_id}
    finally:
        await sl.aclose()


async def log_interactions(state: OutreachWriterState) -> dict:
    """Write 3 rows to Postgres interactions table — one per scheduled touch."""
    # TODO: INSERT INTO interactions (account_id, contact_id, channel='cold_email', touch_type='scheduled',
    # source_agent='outreach-writer', campaign_din=$din, recorded_at, metadata)
    return {}


async def audit_log(state: OutreachWriterState) -> dict:
    # TODO: agent_decisions row
    return {}


def build_outreach_writer_graph():
    g = StateGraph(OutreachWriterState)
    for name, fn in [
        ("check_din_gate", check_din_gate),
        ("fetch_prospect_context", fetch_prospect_context),
        ("check_frequency_cap", check_frequency_cap),
        ("generate_3_touch_sequence", generate_3_touch_sequence),
        ("compliance_check", compliance_check),
        ("push_to_smartlead", push_to_smartlead),
        ("log_interactions", log_interactions),
        ("audit_log", audit_log),
    ]:
        g.add_node(name, fn)

    g.add_edge(START, "check_din_gate")
    g.add_edge("check_din_gate", "fetch_prospect_context")
    g.add_edge("fetch_prospect_context", "check_frequency_cap")
    g.add_edge("check_frequency_cap", "generate_3_touch_sequence")
    g.add_edge("generate_3_touch_sequence", "compliance_check")
    g.add_edge("compliance_check", "push_to_smartlead")
    g.add_edge("push_to_smartlead", "log_interactions")
    g.add_edge("log_interactions", "audit_log")
    g.add_edge("audit_log", END)

    return g.compile(
        checkpointer=default_checkpointer(),
        interrupt_before=["push_to_smartlead"],  # HITL — Tier A/B require approval
    )
