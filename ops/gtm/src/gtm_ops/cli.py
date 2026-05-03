"""Typer-based CLI. Entry point for all flows.

Run: `uv run gtm-ops <command> [--options]`.
"""

import asyncio

import typer
from rich.console import Console

from .flows.crm_enrichment import build_crm_enrichment_graph
from .flows.meeting_prep import build_meeting_prep_graph

app = typer.Typer(help="gtm-ops — the CLI for all demo flows.")
console = Console()


@app.command("meeting-prep")
def meeting_prep(deal_id: str = typer.Option(..., "--deal-id")) -> None:
    """Flow 1 — AI copilot for meeting prep."""
    graph = build_meeting_prep_graph()
    config = {"configurable": {"thread_id": f"meeting-prep-{deal_id}"}}
    result = asyncio.run(graph.ainvoke({"deal_id": deal_id}, config))
    console.print(result)


@app.command("crm-enrichment")
def crm_enrichment(deal_id: str = typer.Option(..., "--deal-id")) -> None:
    """Flow 3 — CRM enrichment pipeline."""
    graph = build_crm_enrichment_graph()
    config = {"configurable": {"thread_id": f"enrichment-{deal_id}"}}
    result = asyncio.run(graph.ainvoke({"deal_id": deal_id}, config))
    console.print(result)


if __name__ == "__main__":
    app()
