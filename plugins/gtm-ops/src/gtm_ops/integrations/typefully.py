"""Typefully client — publishing + engagement analytics.

REST v2 API shipped Dec 2025. Composio MCP wraps this for Claude agent use.
$19/mo tier covers agent-driven publishing to X / LinkedIn / Bluesky / Threads.

Dual role in the stack:
    - OUTPUT: publishes content drafted by the content-to-pipeline flow
    - INPUT: analytics (replies, saves, DMs) feed back as intent signals
"""

import httpx

from ..config import settings


class TypefullyClient:
    BASE_URL = "https://api.typefully.com/v1"

    def __init__(self, api_key: str | None = None) -> None:
        self._api_key = api_key or settings.typefully_api_key
        self._client = httpx.AsyncClient(
            base_url=self.BASE_URL,
            headers={"X-API-KEY": self._api_key},
            timeout=30.0,
        )

    async def create_draft(
        self,
        content: str,
        platforms: list[str],
        schedule_date: str | None = None,
    ) -> str:
        """Create a draft for X / LinkedIn / Bluesky / Threads."""
        payload: dict = {"content": content, "platforms": platforms}
        if schedule_date:
            payload["schedule-date"] = schedule_date
        r = await self._client.post("/drafts/", json=payload)
        r.raise_for_status()
        return r.json()["id"]

    async def get_post_analytics(self, post_id: str) -> dict:
        """Fetch engagement — replies, saves, impressions. Feeds the signal layer."""
        r = await self._client.get(f"/posts/{post_id}/analytics")
        r.raise_for_status()
        return r.json()

    async def aclose(self) -> None:
        await self._client.aclose()
