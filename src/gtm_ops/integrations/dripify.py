"""Dripify LinkedIn automation — cloud-hosted sequences for India B2B prospecting.

NOTE: Dripify's direct API is partner-access as of 2026-04. Practical integration is
webhook-first: we configure Dripify to POST to our `/webhooks/dripify` endpoint on
connect-accepted, message-replied, and sequence-complete events.
"""

from ..config import settings


class DripifyClient:
    """Placeholder client. Portfolio demo uses webhook ingress, not outbound API calls."""

    def __init__(self, api_key: str | None = None) -> None:
        self._api_key = api_key or settings.dripify_api_key

    async def start_sequence(self, lead_urls: list[str], sequence_id: str) -> None:
        """TODO: contact Dripify for partner API access, or simulate via webhook-only flow."""
        raise NotImplementedError(
            "Dripify API is partner-access only — use webhook ingress for demo"
        )
