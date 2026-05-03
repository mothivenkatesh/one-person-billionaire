"""Flow 7 — Win/loss pattern analysis.

Monthly cron. Pulls all closed deals (won + lost) from last 90 days, fetches
their transcripts, extracts loss/win reasons via Claude, clusters via embeddings,
writes a postmortem to llm-wiki, refreshes the Metabase dashboard, and drafts
a monthly Typefully thread summarizing learnings.

Graph:
    START
      → fetch_closed_deals          (Postgres mart_buyer_journey filter)
      → fetch_transcripts           (Drive AI / Fathom — last call per deal)
      → extract_reasons             (OpenRouter Opus — structured-output extraction)
      → embed_reasons               (OpenAI/Vertex embeddings → pgvector)
      → cluster_reasons             (sklearn / pgvector cosine clustering)
      → synthesize_postmortem       (OpenRouter Opus — narrative)
      → write_to_llm_wiki           (file write to wiki/research/win-loss-{YYYY-MM}.md)
      → draft_typefully_thread      (OpenRouter Opus — public version, brand-safe)
      → [HITL interrupt: PMM approves Typefully draft]
      → publish_via_typefully       (Composio MCP)
    END
"""

from typing import Any, TypedDict

from langgraph.graph import END, START, StateGraph

from ..integrations.openrouter import OpenRouterClient
from ..integrations.typefully import TypefullyClient
from ._base import default_checkpointer


class WinLossAnalyzerState(TypedDict, total=False):
    period_start: str  # ISO8601
    period_end: str
    closed_deals: list[dict]
    transcripts: dict[str, str]   # deal_id → transcript text
    extracted_reasons: list[dict]  # [{deal_id, outcome, reasons: [...], evidence: [...]}]
    embeddings: dict[str, list[float]]  # reason → vector
    clusters: list[dict]           # [{cluster_id, theme, deal_ids, count, examples}]
    postmortem_markdown: str
    wiki_path: str
    typefully_draft: dict[str, Any]  # {content, platforms, schedule_date}
    typefully_post_id: str | None
    approved: bool
    error: str | None


async def fetch_closed_deals(state: WinLossAnalyzerState) -> dict:
    # TODO: Postgres query on mart_buyer_journey
    # SELECT * FROM mart_buyer_journey
    # WHERE outcome IN ('won', 'lost')
    #   AND COALESCE(closed_won_date, closed_lost_date) BETWEEN $start AND $end
    return {"closed_deals": []}


async def fetch_transcripts(state: WinLossAnalyzerState) -> dict:
    # TODO: For each closed deal, fetch the most recent transcript
    # Source priority: Drive AI > Fathom > Gong (when available)
    transcripts = {}
    for deal in state.get("closed_deals", []):
        transcripts[deal["deal_id"]] = "<transcript text>"
    return {"transcripts": transcripts}


async def extract_reasons(state: WinLossAnalyzerState) -> dict:
    """Per-deal structured extraction of why-won / why-lost."""
    llm = OpenRouterClient()
    extracted = []
    for deal in state.get("closed_deals", []):
        transcript = state["transcripts"].get(deal["deal_id"], "")
        if not transcript:
            continue
        system = (
            "Extract structured win/loss reasons from this sales call transcript. "
            "Output JSON: {\"primary_reason\": \"...\", \"contributing_factors\": [...], "
            "\"competitor_mentioned\": \"... | null\", \"objection_categories\": [...], "
            "\"verbatim_evidence\": [\"quoted lines from the transcript\"]}"
        )
        user = (
            f"OUTCOME: {deal.get('outcome')}\nDEAL AMOUNT: {deal.get('opportunity_amount')}\n"
            f"VERTICAL: {deal.get('vertical')} | TIER: {deal.get('tier')}\n\n"
            f"TRANSCRIPT:\n{transcript[:8000]}"
        )
        raw = await llm.complete(tier="smart", system=system, user=user, max_tokens=800)
        # TODO: parse JSON, validate via Pydantic
        extracted.append({"deal_id": deal["deal_id"], "outcome": deal.get("outcome"), "raw": raw})
    return {"extracted_reasons": extracted}


async def embed_reasons(state: WinLossAnalyzerState) -> dict:
    # TODO: For each extracted primary_reason string, call OpenAI/Vertex embedding API
    # Store in Postgres pgvector for cluster analysis + future similarity queries
    return {"embeddings": {}}


async def cluster_reasons(state: WinLossAnalyzerState) -> dict:
    # TODO: pgvector cosine-similarity clustering OR sklearn KMeans on embeddings
    # Group reasons into 5-10 themes
    # For each cluster: {cluster_id, theme_name, deal_count, example_quotes (3), pct_of_total}
    return {"clusters": []}


async def synthesize_postmortem(state: WinLossAnalyzerState) -> dict:
    """Generate the narrative postmortem for llm-wiki."""
    llm = OpenRouterClient()
    system = (
        "Write a sales-leadership-grade win/loss postmortem in markdown. "
        "Sections: (1) Executive summary (3 bullets), (2) Top 5 win patterns, "
        "(3) Top 5 loss patterns with verbatim evidence, (4) Competitor displacement notes, "
        "(5) Recommended PMM/sales actions for next quarter. "
        "Use Cashfree brand voice — infrastructure-first, no hype, evidence-backed."
    )
    user = (
        f"PERIOD: {state.get('period_start')} → {state.get('period_end')}\n\n"
        f"CLOSED DEALS COUNT: {len(state.get('closed_deals', []))}\n"
        f"WON: {sum(1 for d in state.get('closed_deals', []) if d.get('outcome') == 'won')}\n"
        f"LOST: {sum(1 for d in state.get('closed_deals', []) if d.get('outcome') == 'lost')}\n\n"
        f"CLUSTERED REASONS:\n{state.get('clusters')}\n\n"
        f"FULL EXTRACTION DATA:\n{state.get('extracted_reasons')}"
    )
    postmortem = await llm.complete(tier="smart", system=system, user=user, max_tokens=4000)
    return {"postmortem_markdown": postmortem}


async def write_to_llm_wiki(state: WinLossAnalyzerState) -> dict:
    # TODO: Write to llm-wiki/wiki/research/win-loss-{YYYY-MM}.md
    # Auto-commit via the wiki's PostToolUse hook (or manual commit)
    period_label = state.get("period_end", "unknown")[:7]  # YYYY-MM
    wiki_path = f"llm-wiki/wiki/research/win-loss-{period_label}.md"
    # File write happens here
    return {"wiki_path": wiki_path}


async def draft_typefully_thread(state: WinLossAnalyzerState) -> dict:
    """Brand-safe public version — different from internal postmortem."""
    llm = OpenRouterClient()
    system = (
        "Convert this internal postmortem into a public Twitter/X thread (5-7 posts). "
        "Cashfree brand voice. NO competitor names. NO Cashfree-internal numbers (lost deal sizes, "
        "specific account names). Use generic patterns: 'we saw X% of D2C losses cite pricing'. "
        "Hook the first post with the most surprising finding. Last post is a single CTA."
    )
    user = f"INTERNAL POSTMORTEM:\n{state.get('postmortem_markdown')}"
    thread = await llm.complete(tier="smart", system=system, user=user, max_tokens=2000)
    return {
        "typefully_draft": {
            "content": thread,
            "platforms": ["twitter", "linkedin"],
            "schedule_date": None,  # PMM picks
        }
    }


async def publish_via_typefully(state: WinLossAnalyzerState) -> dict:
    if not state.get("approved"):
        return {"typefully_post_id": None, "error": "awaiting PMM approval"}
    client = TypefullyClient()
    try:
        draft = state["typefully_draft"]
        post_id = await client.create_draft(
            content=draft["content"],
            platforms=draft["platforms"],
            schedule_date=draft.get("schedule_date"),
        )
        return {"typefully_post_id": post_id}
    finally:
        await client.aclose()


def build_win_loss_analyzer_graph():
    g = StateGraph(WinLossAnalyzerState)
    g.add_node("fetch_closed_deals", fetch_closed_deals)
    g.add_node("fetch_transcripts", fetch_transcripts)
    g.add_node("extract_reasons", extract_reasons)
    g.add_node("embed_reasons", embed_reasons)
    g.add_node("cluster_reasons", cluster_reasons)
    g.add_node("synthesize_postmortem", synthesize_postmortem)
    g.add_node("write_to_llm_wiki", write_to_llm_wiki)
    g.add_node("draft_typefully_thread", draft_typefully_thread)
    g.add_node("publish_via_typefully", publish_via_typefully)

    g.add_edge(START, "fetch_closed_deals")
    g.add_edge("fetch_closed_deals", "fetch_transcripts")
    g.add_edge("fetch_transcripts", "extract_reasons")
    g.add_edge("extract_reasons", "embed_reasons")
    g.add_edge("embed_reasons", "cluster_reasons")
    g.add_edge("cluster_reasons", "synthesize_postmortem")
    g.add_edge("synthesize_postmortem", "write_to_llm_wiki")
    g.add_edge("write_to_llm_wiki", "draft_typefully_thread")
    g.add_edge("draft_typefully_thread", "publish_via_typefully")
    g.add_edge("publish_via_typefully", END)

    return g.compile(
        checkpointer=default_checkpointer(),
        interrupt_before=["publish_via_typefully"],  # HITL — PMM approves Typefully thread
    )
