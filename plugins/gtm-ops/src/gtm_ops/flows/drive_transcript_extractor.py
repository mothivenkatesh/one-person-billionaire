"""Utility Agent — Drive-Transcript-Extractor.

Drive watcher (5-min poll) on mothi GTM AI / Transcripts/. When a new transcript
file lands (Drive AI auto-transcription of a Google Meet call), extract typed
properties via Claude Haiku and write them to Postgres `extracted_property` for
downstream agents (Stage-Mover, Churn-Saver, Cross-Sell-Detector) to consume.

This is the "first-party unstructured signal" wedge — most competitor stacks miss
this entirely. See gtm-context §3.4 for why this is the layer-3.5 unlock.

Properties extracted per transcript:
- objection_raised (with category: pricing, timing, capability, integration, compliance)
- competitor_mentioned (named vendor)
- expansion_signal (interest in adjacent product)
- churn_risk_phrase (specific quotes implying departure)
- decision_maker_added (new stakeholder named in call)
- next_step_committed (what was agreed)
- feature_request

Graph:
    START
      → poll_drive_for_new_transcripts (Drive API)
      → download_and_normalize         (strip filler, normalize speaker labels)
      → resolve_account_from_attendees (match attendee emails to SF Account)
      → extract_typed_properties       (Claude Haiku — structured output)
      → write_to_postgres              (extracted_property table — one row per property)
      → write_back_summary_to_sf       (custom field on Account: latest_call_summary)
      → audit_log
    END
"""

from typing import Any, TypedDict

from langgraph.graph import END, START, StateGraph

from ..integrations.hubspot import HubSpotClient
from ..integrations.openrouter import OpenRouterClient
from ._base import default_checkpointer


class DriveTranscriptExtractorState(TypedDict, total=False):
    new_transcripts: list[dict]    # [{drive_file_id, attendees, recorded_at}]
    transcripts: list[dict]        # with text loaded
    resolved_accounts: dict[str, str]  # transcript_id → account_id
    extracted: dict[str, list[dict]]   # transcript_id → [{property_name, value, confidence, source_quote}]
    rows_written: int
    error: str | None


async def poll_drive_for_new_transcripts(state: DriveTranscriptExtractorState) -> dict:
    """Drive API: query for files modified since last cursor."""
    # TODO: Drive API list with q="parents in 'mothi-GTM-AI/Transcripts' and modifiedTime > $last_cursor"
    # Track cursor in Postgres: agent_state table {agent='drive-transcript-extractor', last_cursor=...}
    return {"new_transcripts": []}


async def download_and_normalize(state: DriveTranscriptExtractorState) -> dict:
    """Download transcript text, normalize speaker labels, strip filler."""
    transcripts = []
    for t in state.get("new_transcripts", []):
        # TODO: Drive API download .docx/.gdoc → plain text
        # TODO: Run light normalization: collapse "umm/uhh", merge consecutive same-speaker turns
        transcripts.append({**t, "text": "<normalized text>"})
    return {"transcripts": transcripts}


async def resolve_account_from_attendees(state: DriveTranscriptExtractorState) -> dict:
    """Match attendee email domains to SF Account.domain — heuristic but mostly works."""
    hub = HubSpotClient()
    resolved = {}
    try:
        for t in state.get("transcripts", []):
            external_emails = [
                a for a in t.get("attendees", [])
                if not a.endswith("@mothi.com")
            ]
            if external_emails:
                domain = external_emails[0].split("@")[-1]
                # TODO: SF SOQL: SELECT Id FROM Account WHERE Domain = $domain LIMIT 1
                resolved[t["drive_file_id"]] = "<resolved-sf-account-id>"
        return {"resolved_accounts": resolved}
    finally:
        await hub.aclose()


async def extract_typed_properties(state: DriveTranscriptExtractorState) -> dict:
    """Per transcript: Claude Haiku extracts 7 typed property categories."""
    llm = OpenRouterClient()
    extracted = {}
    for t in state.get("transcripts", []):
        if t["drive_file_id"] not in state.get("resolved_accounts", {}):
            continue
        system = (
            "Extract structured properties from this sales call transcript. "
            "Return JSON array, one entry per property found:\n"
            "[{\n"
            "  \"property_name\": \"objection_raised | competitor_mentioned | expansion_signal | "
            "churn_risk_phrase | decision_maker_added | next_step_committed | feature_request\",\n"
            "  \"value\": \"<extracted value, e.g., 'pricing' or 'Razorpay' or 'Payouts'>\",\n"
            "  \"confidence\": 0.0-1.0,\n"
            "  \"source_quote\": \"<verbatim quote from transcript, max 200 chars>\"\n"
            "}]\n"
            "Only include properties you can cite with a verbatim quote. Confidence < 0.6 → skip."
        )
        user = f"TRANSCRIPT:\n{t['text']}"
        raw = await llm.complete(tier="fast", system=system, user=user, max_tokens=1500)
        # TODO: parse JSON, validate via Pydantic (PropertyExtraction schema)
        extracted[t["drive_file_id"]] = []
    return {"extracted": extracted}


async def write_to_postgres(state: DriveTranscriptExtractorState) -> dict:
    """One INSERT per extracted property — preserves traceability."""
    rows = 0
    for transcript_id, properties in state.get("extracted", {}).items():
        account_id = state["resolved_accounts"][transcript_id]
        for prop in properties:
            # TODO: INSERT INTO extracted_property (account_id, property_name, property_value,
            # source_type='transcript', source_id=transcript_id, confidence,
            # extracted_by_agent='drive-transcript-extractor', extracted_at=now())
            rows += 1
    return {"rows_written": rows}


async def write_back_summary_to_sf(state: DriveTranscriptExtractorState) -> dict:
    """For each account with new transcript activity, update Account.latest_call_summary custom field."""
    hub = HubSpotClient()
    try:
        for transcript_id, account_id in state.get("resolved_accounts", {}).items():
            # TODO: build 3-line summary from extracted properties
            # TODO: SF Account update with custom_field 'latest_call_summary' + 'latest_call_at'
            pass
        return {}
    finally:
        await hub.aclose()


async def audit_log(state: DriveTranscriptExtractorState) -> dict:
    return {}


def build_drive_transcript_extractor_graph():
    g = StateGraph(DriveTranscriptExtractorState)
    for name, fn in [
        ("poll_drive_for_new_transcripts", poll_drive_for_new_transcripts),
        ("download_and_normalize", download_and_normalize),
        ("resolve_account_from_attendees", resolve_account_from_attendees),
        ("extract_typed_properties", extract_typed_properties),
        ("write_to_postgres", write_to_postgres),
        ("write_back_summary_to_sf", write_back_summary_to_sf),
        ("audit_log", audit_log),
    ]:
        g.add_node(name, fn)

    g.add_edge(START, "poll_drive_for_new_transcripts")
    g.add_edge("poll_drive_for_new_transcripts", "download_and_normalize")
    g.add_edge("download_and_normalize", "resolve_account_from_attendees")
    g.add_edge("resolve_account_from_attendees", "extract_typed_properties")
    g.add_edge("extract_typed_properties", "write_to_postgres")
    g.add_edge("write_to_postgres", "write_back_summary_to_sf")
    g.add_edge("write_back_summary_to_sf", "audit_log")
    g.add_edge("audit_log", END)

    return g.compile(checkpointer=default_checkpointer())
