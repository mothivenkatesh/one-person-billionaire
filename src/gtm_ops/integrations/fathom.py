"""Fathom transcript client.

Fathom offers paid API access (free tier covers recording but not programmatic pull).
The portfolio demo uses this client against your own recorded calls — free tier is fine
for seed data, API tier unlocks automation.
"""

import httpx

from ..config import settings
from ..models import Transcript


class FathomClient:
    BASE_URL = "https://api.fathom.video/v1"  # TODO: verify exact base URL

    def __init__(self, api_key: str | None = None) -> None:
        self._api_key = api_key or settings.fathom_api_key
        self._client = httpx.AsyncClient(
            base_url=self.BASE_URL,
            headers={"Authorization": f"Bearer {self._api_key}"},
            timeout=30.0,
        )

    async def list_transcripts(self, since: str | None = None) -> list[dict]:
        """List meetings; optionally filter by ISO-8601 since cursor."""
        params = {"since": since} if since else {}
        r = await self._client.get("/meetings", params=params)
        r.raise_for_status()
        return r.json().get("meetings", [])

    async def get_transcript(self, meeting_id: str) -> Transcript:
        """Fetch the transcript for a specific meeting.

        TODO: map Fathom response → Transcript(source="fathom").
        """
        raise NotImplementedError

    async def aclose(self) -> None:
        await self._client.aclose()
