"""Utility Agent — DIN-Watchdog.

The enforcement bot for the DIN approval gate. Two trigger modes:

(A) 15-minute cron: real-time anomaly scan. Cross-references active campaigns
    across Smartlead, MoEngage, LinkedIn Ads, Gmail, and SF — anything active
    without an approved DIN gets flagged in #gtm-ops within 15 minutes.

(B) Daily 9am cron: reconciliation report. Aggregates all anomalies, DINs in
    review >48h, briefs missing uploads, yesterday's blocked launches — posted
    as a single digest to #gtm-ops.

Graph (mode-branched):
    START
      → identify_mode                 (15min vs daily_recon)
      → fetch_active_assets           (Smartlead + MoEngage + LI Ads + Gmail + SF Campaigns)
      → fetch_approved_dins           (Postgres campaigns table)
      → cross_reference               (load cf-din-watchdog skill, run anomaly classifier)
      → format_slack_payload          (Block Kit per spec §11.6.2)
      → post_to_slack
      → audit_log
    END
"""

from typing import Any, TypedDict

from langgraph.graph import END, START, StateGraph

from ..integrations.openrouter import OpenRouterClient
from ._base import default_checkpointer


class DinWatchdogState(TypedDict, total=False):
    mode: str  # "15min_scan" | "daily_recon"
    active_assets_per_channel: dict[str, list[dict]]
    approved_dins_in_postgres: list[dict]
    anomalies: list[dict]
    daily_recon_payload: dict[str, Any]
    slack_payload: dict[str, Any]
    posted: bool
    error: str | None


async def identify_mode(state: DinWatchdogState) -> dict:
    """No-op routing setup — mode set by trigger."""
    return {}


async def fetch_active_assets(state: DinWatchdogState) -> dict:
    """Query each channel for currently-active campaigns/flows/ad-sets/sends."""
    assets: dict[str, list[dict]] = {
        "smartlead": [],
        "moengage": [],
        "linkedin_ads": [],
        "gmail": [],
        "sf_campaign": [],
    }
    # TODO: Smartlead /campaigns?status=active → extract cf_din custom field per campaign
    # TODO: MoEngage Flows API → list active flows + their din_id user attribute
    # TODO: LinkedIn Marketing API /campaigns → extract utm_campaign from destination URLs
    # TODO: Gmail audit log via Workspace Reports API — flag any mass-sends not from n8n workflows
    # TODO: SF SOQL: SELECT Id, Name, DIN_ID__c FROM Campaign WHERE IsActive = true
    return {"active_assets_per_channel": assets}


async def fetch_approved_dins(state: DinWatchdogState) -> dict:
    """Postgres campaigns table — all DINs with current approval status."""
    # TODO: SELECT din_id, name, approval_status, approved_at FROM campaigns
    return {"approved_dins_in_postgres": []}


async def cross_reference(state: DinWatchdogState) -> dict:
    """Load cf-din-watchdog skill, run Claude classifier on the cross-product."""
    llm = OpenRouterClient()
    skill_body = "<cf-din-watchdog skill body from Shared Drive>"

    if state.get("mode") == "daily_recon":
        # Daily reconciliation — aggregated metrics + anomalies summary
        system = skill_body + "\n\nGenerate the daily 9am reconciliation report per spec §11.6.2 layer 3."
        user = (
            f"ACTIVE ASSETS: {state.get('active_assets_per_channel')}\n"
            f"APPROVED DINS: {state.get('approved_dins_in_postgres')}\n"
            f"REPORT DATE: <today>"
        )
        raw = await llm.complete(tier="fast", system=system, user=user, max_tokens=2000)
        # TODO: parse JSON
        return {"daily_recon_payload": {"report_markdown": raw}}
    else:
        # 15-min anomaly scan
        system = skill_body + "\n\nDetect any active asset without an approved live DIN. Output anomalies array per skill schema."
        user = (
            f"ACTIVE ASSETS: {state.get('active_assets_per_channel')}\n"
            f"APPROVED DINS: {state.get('approved_dins_in_postgres')}"
        )
        raw = await llm.complete(tier="fast", system=system, user=user, max_tokens=1500)
        # TODO: parse JSON, extract anomalies array
        return {"anomalies": []}


async def format_slack_payload(state: DinWatchdogState) -> dict:
    """Format per Slack Block Kit, severity-tiered."""
    if state.get("mode") == "daily_recon":
        # Always post (even if clean — daily presence builds trust)
        # TODO: format daily_recon_payload as Block Kit with sections per spec
        return {"slack_payload": {"channel": "#gtm-ops", "blocks": []}}
    else:
        anomalies = state.get("anomalies", [])
        if not anomalies:
            # Clean scan — don't post (avoid 15-min noise per spec anti-pattern)
            return {"slack_payload": None}
        # P0 anomalies get full Block Kit alert with @mentions
        # P1 get subtler ⚠️ alert without leadership tag
        # TODO: format per spec §11.6.2 layer 2
        return {"slack_payload": {"channel": "#gtm-ops", "blocks": []}}


async def post_to_slack(state: DinWatchdogState) -> dict:
    payload = state.get("slack_payload")
    if not payload:
        return {"posted": False}
    # TODO: Slack webhook POST
    return {"posted": True}


async def audit_log(state: DinWatchdogState) -> dict:
    return {}


def build_din_watchdog_graph():
    g = StateGraph(DinWatchdogState)
    for name, fn in [
        ("identify_mode", identify_mode),
        ("fetch_active_assets", fetch_active_assets),
        ("fetch_approved_dins", fetch_approved_dins),
        ("cross_reference", cross_reference),
        ("format_slack_payload", format_slack_payload),
        ("post_to_slack", post_to_slack),
        ("audit_log", audit_log),
    ]:
        g.add_node(name, fn)

    g.add_edge(START, "identify_mode")
    g.add_edge("identify_mode", "fetch_active_assets")
    g.add_edge("fetch_active_assets", "fetch_approved_dins")
    g.add_edge("fetch_approved_dins", "cross_reference")
    g.add_edge("cross_reference", "format_slack_payload")
    g.add_edge("format_slack_payload", "post_to_slack")
    g.add_edge("post_to_slack", "audit_log")
    g.add_edge("audit_log", END)

    return g.compile(checkpointer=default_checkpointer())
