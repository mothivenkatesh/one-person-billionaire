"""HubSpot API client — deals, contacts, activities. The CRM system of record."""

import httpx

from ..config import settings
from ..models import Contact, Deal


class HubSpotClient:
    """Thin async wrapper over HubSpot v3 API."""

    BASE_URL = "https://api.hubapi.com"

    def __init__(self, api_key: str | None = None) -> None:
        self._api_key = api_key or settings.hubspot_api_key
        self._client = httpx.AsyncClient(
            base_url=self.BASE_URL,
            headers={"Authorization": f"Bearer {self._api_key}"},
            timeout=30.0,
        )

    async def get_deal(self, deal_id: str) -> Deal:
        """Fetch a deal by id."""
        r = await self._client.get(f"/crm/v3/objects/deals/{deal_id}")
        r.raise_for_status()
        # TODO: map HubSpot properties → Deal model
        return Deal(**r.json())

    async def update_deal(self, deal_id: str, properties: dict) -> None:
        """Patch deal properties — used as the enrichment writeback sink."""
        r = await self._client.patch(
            f"/crm/v3/objects/deals/{deal_id}",
            json={"properties": properties},
        )
        r.raise_for_status()

    async def get_contact(self, contact_id: str) -> Contact:
        r = await self._client.get(f"/crm/v3/objects/contacts/{contact_id}")
        r.raise_for_status()
        # TODO: map properties → Contact
        return Contact(**r.json())

    async def list_associated_contacts(self, deal_id: str) -> list[str]:
        """Return contact ids associated with a deal."""
        r = await self._client.get(
            f"/crm/v4/objects/deals/{deal_id}/associations/contacts"
        )
        r.raise_for_status()
        return [item["toObjectId"] for item in r.json().get("results", [])]

    async def create_task(
        self, deal_id: str, subject: str, body: str, owner_email: str
    ) -> str:
        """Create a task on a deal — used by action-items flow to populate rep work queue."""
        # TODO: implement via /crm/v3/objects/tasks + association to deal
        raise NotImplementedError

    async def aclose(self) -> None:
        await self._client.aclose()
