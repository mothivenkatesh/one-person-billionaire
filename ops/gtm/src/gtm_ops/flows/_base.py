"""Shared state + HITL checkpoint helper for LangGraph flows."""

from typing import Any, TypedDict

from langgraph.checkpoint.memory import MemorySaver


class FlowState(TypedDict, total=False):
    """Base state every flow can extend."""

    deal_id: str
    context: dict[str, Any]
    draft: str
    approved: bool
    error: str | None


def default_checkpointer() -> MemorySaver:
    """In-memory checkpointer for demo. Swap to Postgres or Redis in production."""
    return MemorySaver()
