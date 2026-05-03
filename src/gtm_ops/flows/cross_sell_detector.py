"""Agent 5 — Cross-Sell-Detector (Nurture loop).

Weekly Monday 6am cron. Scans Cashfree merchant product DB for cross-sell gaps:
heavy in product A, absent in product B, where the A→B attach pattern is proven.
Generates personalized cross-sell pitch with merchant's actual usage data,
routes to MoEngage (in-app + email + WhatsApp) for SMB tier OR CSM Slack alert
with talking points for high-value (>₹10L/mo GMV) accounts.

Day-1 cross-sell pair: Payments → Payouts (D2C vertical, highest historical attach).

Graph:
    START
      → query_product_usage_gaps     (Postgres mart_account_health JOIN product_usage)
      → score_cross_sell_readiness   (Claude Haiku — composite of usage volume, tenure, MoEngage engagement)
      → fetch_attach_pattern         (historical: which usage signal predicts B-product adoption?)
      → generate_personalized_pitch  (Claude Opus — uses merchant's actual GMV, tenure, vertical)
      → route_by_tier                (high-value→CSM Slack; SMB→MoEngage in-app+email+WhatsApp)
      → log_cross_sell_candidate     (write to Postgres + gtm.cross-sell-candidates Sheet)
      → audit_log
    END
"""

from typing import Any, TypedDict

from langgraph.graph import END, START, StateGraph

from ..integrations.openrouter import OpenRouterClient
from ._base import default_checkpointer


class CrossSellDetectorState(TypedDict, total=False):
    product_pair: tuple[str, str]  # ("payments", "payouts")
    candidates: list[dict]          # merchants with gap
    scored_candidates: list[dict]   # with cross-sell readiness score
    attach_pattern: dict[str, Any]  # historical baseline
    pitches: dict[str, dict]        # account_id → pitch
    routed: dict[str, str]          # account_id → channel
    error: str | None


async def query_product_usage_gaps(state: CrossSellDetectorState) -> dict:
    """SQL query — heavy in product A, absent in B, with min volume threshold."""
    product_a, product_b = state.get("product_pair", ("payments", "payouts"))
    # TODO: Postgres query on mart_account_health JOIN product_usage_summary
    # WHERE usage(product_a).monthly_volume > $threshold
    #   AND usage(product_b).monthly_volume = 0
    #   AND tenure_days > 90  (no brand-new merchants)
    #   AND temperature != 'dormant'  (must be active)
    return {"candidates": []}


async def score_cross_sell_readiness(state: CrossSellDetectorState) -> dict:
    """Composite score 0-5: usage volume × tenure × MoEngage engagement × ICP fit for product B."""
    llm = OpenRouterClient()
    scored = []
    for c in state.get("candidates", []):
        system = (
            "Score this merchant's cross-sell readiness 0-5 for the target product. "
            "Factors: monthly volume in current product, tenure (90d+ ideal), "
            "MoEngage engagement (open/click rates), ICP fit for target product, "
            "any expansion_signal extracted_property in last 30 days. "
            "Output JSON: {\"readiness_score\": 0.0-5.0, \"top_3_reasons\": [...], "
            "\"recommended_channel\": \"csm | moengage_lifecycle | both\"}"
        )
        user = f"Merchant: {c}\nTarget product: {state['product_pair'][1]}"
        raw = await llm.complete(tier="fast", system=system, user=user, max_tokens=400)
        # TODO: parse JSON
        scored.append({**c, "scoring": raw})
    return {"scored_candidates": scored}


async def fetch_attach_pattern(state: CrossSellDetectorState) -> dict:
    """Historical baseline — which signals best predicted B-product adoption?"""
    # TODO: Postgres query on closed-won cross-sells in last 365 days
    # Find correlated features: tenure, A-product volume, MoEngage engagement, vertical
    # Use this to inform the pitch
    return {"attach_pattern": {}}


async def generate_personalized_pitch(state: CrossSellDetectorState) -> dict:
    """Per-merchant pitch using their actual usage data + historical attach pattern."""
    llm = OpenRouterClient()
    pitches = {}
    for c in state.get("scored_candidates", []):
        if c.get("scoring", {}).get("readiness_score", 0) < 3.0:
            continue
        system = (
            "Generate a cross-sell pitch for this merchant. "
            "Use their ACTUAL usage data (volume, tenure, vertical) — no generic claims. "
            "Reference 1 similar peer-merchant who graduated from product A to A+B and saw measurable benefit. "
            "Length: 80 words. Voice: peer-to-peer, no hype. "
            "Output JSON: {\"subject\": \"...\", \"body\": \"...\", \"cta\": \"...\", \"in_app_banner_text\": \"...\"}"
        )
        user = (
            f"MERCHANT: {c}\n"
            f"ATTACH PATTERN: {state.get('attach_pattern')}\n"
            f"PRODUCT PAIR: {state['product_pair']}"
        )
        raw = await llm.complete(tier="smart", system=system, user=user, max_tokens=600)
        # TODO: parse JSON
        pitches[c["account_id"]] = {"raw": raw, "score": c.get("scoring", {})}
    return {"pitches": pitches}


async def route_by_tier(state: CrossSellDetectorState) -> dict:
    """High-value (>₹10L/mo GMV) → CSM Slack alert. SMB → MoEngage triggered campaign."""
    routed = {}
    for account_id, pitch in state.get("pitches", {}).items():
        # TODO: lookup account.gmv_monthly from Postgres
        gmv_monthly = 0  # placeholder
        if gmv_monthly >= 1_000_000:
            # TODO: Slack DM to CSM with talking-points + draft outreach
            routed[account_id] = "csm_slack"
        else:
            # TODO: MoEngage API — enroll in cross-sell journey with personalized message body
            routed[account_id] = "moengage_journey"
    return {"routed": routed}


async def log_cross_sell_candidate(state: CrossSellDetectorState) -> dict:
    """Write to Postgres + sync to gtm.cross-sell-candidates Sheet."""
    # TODO: INSERT INTO interactions (channel='in_app', touch_type='cross_sell_recommended',
    # source_agent='cf-cross-sell-detector', metadata={pitch, score})
    # TODO: Append rows to Sheets API for gtm.cross-sell-candidates
    return {}


async def audit_log(state: CrossSellDetectorState) -> dict:
    return {}


def build_cross_sell_detector_graph():
    g = StateGraph(CrossSellDetectorState)
    for name, fn in [
        ("query_product_usage_gaps", query_product_usage_gaps),
        ("score_cross_sell_readiness", score_cross_sell_readiness),
        ("fetch_attach_pattern", fetch_attach_pattern),
        ("generate_personalized_pitch", generate_personalized_pitch),
        ("route_by_tier", route_by_tier),
        ("log_cross_sell_candidate", log_cross_sell_candidate),
        ("audit_log", audit_log),
    ]:
        g.add_node(name, fn)

    g.add_edge(START, "query_product_usage_gaps")
    g.add_edge("query_product_usage_gaps", "score_cross_sell_readiness")
    g.add_edge("score_cross_sell_readiness", "fetch_attach_pattern")
    g.add_edge("fetch_attach_pattern", "generate_personalized_pitch")
    g.add_edge("generate_personalized_pitch", "route_by_tier")
    g.add_edge("route_by_tier", "log_cross_sell_candidate")
    g.add_edge("log_cross_sell_candidate", "audit_log")
    g.add_edge("audit_log", END)

    return g.compile(checkpointer=default_checkpointer())
