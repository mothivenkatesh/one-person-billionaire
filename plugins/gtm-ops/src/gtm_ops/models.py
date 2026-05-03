"""Pydantic models typed over the INPUT / OUTPUT domain."""

from datetime import datetime
from enum import Enum

from pydantic import BaseModel, Field


class DealStage(str, Enum):
    DISCOVERY = "discovery"
    QUALIFICATION = "qualification"
    POC = "poc"
    PROPOSAL = "proposal"
    NEGOTIATION = "negotiation"
    CLOSED_WON = "closed_won"
    CLOSED_LOST = "closed_lost"


class Deal(BaseModel):
    id: str
    account_name: str
    stage: DealStage
    amount: float
    owner_email: str
    last_activity_at: datetime | None = None
    next_step: str | None = None
    created_at: datetime
    updated_at: datetime


class Contact(BaseModel):
    id: str
    email: str
    first_name: str
    last_name: str
    title: str | None = None
    account_id: str


class Transcript(BaseModel):
    id: str
    source: str  # gong | fathom | granola | fireflies
    deal_id: str | None = None
    participants: list[str]
    duration_seconds: int
    text: str
    recorded_at: datetime


class EnrichmentResult(BaseModel):
    account_id: str
    firmographics: dict = Field(default_factory=dict)
    tech_stack: list[str] = Field(default_factory=list)
    intent_signals: list[str] = Field(default_factory=list)
    competitive_signals: dict = Field(default_factory=dict)
    confidence: float = 0.0


class MeetingBrief(BaseModel):
    deal_id: str
    account_summary: str
    recent_moves: list[str]
    stakeholders: list[Contact]
    competitive_context: str
    past_touchpoints: list[str]
    recommended_questions: list[str]
    recommended_next_step: str
