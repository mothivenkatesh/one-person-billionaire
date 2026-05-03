"""Smartlead cold-email client — campaigns, leads, webhook-driven reply catch.

Smartlead is preferred over Instantly at enterprise scale for deliverability (unified
inbox warmup, better spam-test coverage) and webhook ergonomics.
"""

import httpx

from ..config import settings


class SmartleadClient:
    BASE_URL = "https://server.smartlead.ai/api/v1"

    def __init__(self, api_key: str | None = None) -> None:
        self._api_key = api_key or settings.smartlead_api_key
        self._client = httpx.AsyncClient(base_url=self.BASE_URL, timeout=30.0)

    async def create_campaign(self, name: str, mailboxes: list[str]) -> str:
        r = await self._client.post(
            "/campaigns/create",
            params={"api_key": self._api_key},
            json={"name": name, "mailbox_emails": mailboxes},
        )
        r.raise_for_status()
        return r.json()["campaign_id"]

    async def add_leads(self, campaign_id: str, leads: list[dict]) -> None:
        r = await self._client.post(
            f"/campaigns/{campaign_id}/leads",
            params={"api_key": self._api_key},
            json={"lead_list": leads},
        )
        r.raise_for_status()

    async def pause_lead(self, campaign_id: str, lead_id: str) -> None:
        """Called when a reply fires via webhook — pauses further sequence steps.

        TODO: POST /campaigns/{campaign_id}/leads/{lead_id}/pause
        """
        raise NotImplementedError

    async def aclose(self) -> None:
        await self._client.aclose()
