-- gtm-ops schema extensions — additive on top of 001_schema.sql.
-- Adds: campaigns (DIN registry) · agent_decisions (audit log) · extracted_property (Claude-derived typed properties)
-- Plus ALTER TABLE additions to deals, contacts, accounts to support mart_buyer_journey.

-- =============================================
-- NEW TABLES
-- =============================================

-- Campaign registry — backs the DIN approval workflow (spec §11.5)
CREATE TABLE IF NOT EXISTS campaigns (
    din_id              TEXT PRIMARY KEY,             -- e.g., CF-GTM-20260424-001
    name                TEXT NOT NULL,
    motion_type         TEXT NOT NULL CHECK (motion_type IN ('acquisition', 'nurture', 'cross-sell', 're-engagement', 'churn-save')),
    tier                TEXT NOT NULL CHECK (tier IN ('A', 'B', 'C', 'plg', 'long_tail')),
    segment             TEXT NOT NULL,                 -- bfsi · d2c · saas · marketplace · other
    channels            TEXT[] NOT NULL,               -- {cold_email, linkedin, whatsapp, email, push, in_app, sms, ad}
    brief_gdoc_url      TEXT NOT NULL,
    pmm_owner_email     TEXT NOT NULL,
    approver_chain      TEXT[] NOT NULL,
    approval_status     TEXT NOT NULL CHECK (approval_status IN ('draft', 'in_review', 'approved', 'live', 'paused', 'archived', 'training')),
    approved_at         TIMESTAMPTZ,
    approved_by         TEXT[],
    launched_at         TIMESTAMPTZ,
    ended_at            TIMESTAMPTZ,
    utm_source          TEXT NOT NULL,
    utm_medium          TEXT NOT NULL,
    sf_campaign_id      TEXT,
    goal_kpi            JSONB,
    hypothesis          TEXT,
    retro_gdoc_url      TEXT,
    -- Mandatory upload validation flags (spec §11.6.1)
    creative_uploaded         BOOLEAN DEFAULT false,
    audience_uploaded         BOOLEAN DEFAULT false,
    compliance_signed         BOOLEAN DEFAULT false,
    test_send_passed          BOOLEAN DEFAULT false,
    utm_verified              BOOLEAN DEFAULT false,
    freq_cap_impact_analyzed  BOOLEAN DEFAULT false,
    created_at          TIMESTAMPTZ DEFAULT now(),
    updated_at          TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_campaigns_status ON campaigns(approval_status);
CREATE INDEX IF NOT EXISTS idx_campaigns_owner ON campaigns(pmm_owner_email);

-- Agent decisions audit log — every Claude call recorded (reliability rule #11)
CREATE TABLE IF NOT EXISTS agent_decisions (
    id              BIGSERIAL PRIMARY KEY,
    agent_name      TEXT NOT NULL,                     -- cf-icp-scout, cf-outreach-writer, etc.
    trigger_type    TEXT NOT NULL,                     -- cron, webhook, hitl_approval, manual
    input_payload   JSONB NOT NULL,
    output_payload  JSONB,
    skills_loaded   TEXT[],
    mcps_called     TEXT[],
    model_version   TEXT,                              -- claude-haiku-4.5, claude-opus-4.7, etc.
    cost_usd        NUMERIC(10, 6),
    latency_ms      INT,
    status          TEXT NOT NULL CHECK (status IN ('success', 'failed', 'halted', 'pending_hitl')),
    error_message   TEXT,
    related_din     TEXT REFERENCES campaigns(din_id),
    related_deal_id TEXT REFERENCES deals(id),
    related_account_id TEXT REFERENCES accounts(id),
    created_at      TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_agent_decisions_agent_time ON agent_decisions(agent_name, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_agent_decisions_din ON agent_decisions(related_din);
CREATE INDEX IF NOT EXISTS idx_agent_decisions_deal ON agent_decisions(related_deal_id);

-- Extracted properties — Claude-derived typed properties from unstructured sources (spec §3.2)
CREATE TABLE IF NOT EXISTS extracted_property (
    id              BIGSERIAL PRIMARY KEY,
    account_id      TEXT REFERENCES accounts(id),
    deal_id         TEXT REFERENCES deals(id),
    contact_id      TEXT REFERENCES contacts(id),
    property_name   TEXT NOT NULL,                     -- objection_raised, competitor_mentioned, expansion_signal, churn_risk_phrase, decision_maker_added
    property_value  TEXT NOT NULL,
    source_type     TEXT NOT NULL,                     -- transcript, support_ticket, slack, email, nps_survey, form_response
    source_id       TEXT,                              -- transcript.id, ticket.id, etc.
    confidence      NUMERIC(3, 2),                     -- 0.0–1.0
    extracted_by_agent TEXT NOT NULL,                  -- cf-drive-transcript-extractor, etc.
    extracted_at    TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_extracted_property_account ON extracted_property(account_id, property_name);
CREATE INDEX IF NOT EXISTS idx_extracted_property_deal ON extracted_property(deal_id, property_name);
CREATE INDEX IF NOT EXISTS idx_extracted_property_recent ON extracted_property(extracted_at DESC);

-- Interactions — every touch with a prospect/customer (consolidates activities across channels)
CREATE TABLE IF NOT EXISTS interactions (
    id              BIGSERIAL PRIMARY KEY,
    account_id      TEXT REFERENCES accounts(id),
    contact_id      TEXT REFERENCES contacts(id),
    deal_id         TEXT REFERENCES deals(id),
    channel         TEXT NOT NULL,                     -- cold_email · linkedin_inmail · ad · webinar · content · referral · ae_email · ae_call · csm_outreach · in_app · whatsapp · sms
    touch_type      TEXT NOT NULL,                     -- impression · open · click · reply · meeting · demo · proposal · close
    source_agent    TEXT,                              -- which agent generated it; or 'human' for manual rep work
    campaign_din    TEXT REFERENCES campaigns(din_id),
    recorded_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
    metadata        JSONB
);

CREATE INDEX IF NOT EXISTS idx_interactions_account_time ON interactions(account_id, recorded_at DESC);
CREATE INDEX IF NOT EXISTS idx_interactions_deal ON interactions(deal_id);
CREATE INDEX IF NOT EXISTS idx_interactions_din ON interactions(campaign_din);

-- =============================================
-- ALTER existing tables to support mart_buyer_journey
-- =============================================

-- accounts — add tier + vertical (today living implicit)
ALTER TABLE accounts ADD COLUMN IF NOT EXISTS tier TEXT;
ALTER TABLE accounts ADD COLUMN IF NOT EXISTS vertical TEXT;
ALTER TABLE accounts ADD COLUMN IF NOT EXISTS engagement_score NUMERIC(3, 2);
ALTER TABLE accounts ADD COLUMN IF NOT EXISTS last_meaningful_touch TIMESTAMPTZ;

-- deals — add the milestone date columns + opportunity metadata
ALTER TABLE deals ADD COLUMN IF NOT EXISTS gtm_motion TEXT;
ALTER TABLE deals ADD COLUMN IF NOT EXISTS source TEXT;
ALTER TABLE deals ADD COLUMN IF NOT EXISTS campaign_din TEXT REFERENCES campaigns(din_id);
ALTER TABLE deals ADD COLUMN IF NOT EXISTS lead_created_date TIMESTAMPTZ;
ALTER TABLE deals ADD COLUMN IF NOT EXISTS mql_at TIMESTAMPTZ;
ALTER TABLE deals ADD COLUMN IF NOT EXISTS sql_at TIMESTAMPTZ;
ALTER TABLE deals ADD COLUMN IF NOT EXISTS sales_ready_at TIMESTAMPTZ;
ALTER TABLE deals ADD COLUMN IF NOT EXISTS working_at TIMESTAMPTZ;
ALTER TABLE deals ADD COLUMN IF NOT EXISTS meeting_booked_at TIMESTAMPTZ;
ALTER TABLE deals ADD COLUMN IF NOT EXISTS pipeline_at TIMESTAMPTZ;
ALTER TABLE deals ADD COLUMN IF NOT EXISTS opportunity_type TEXT;
ALTER TABLE deals ADD COLUMN IF NOT EXISTS closed_won_at TIMESTAMPTZ;
ALTER TABLE deals ADD COLUMN IF NOT EXISTS closed_lost_at TIMESTAMPTZ;
ALTER TABLE deals ADD COLUMN IF NOT EXISTS lost_reason TEXT;
ALTER TABLE deals ADD COLUMN IF NOT EXISTS recycled_to_nurture_at TIMESTAMPTZ;

-- contacts — persona type for skill loading
ALTER TABLE contacts ADD COLUMN IF NOT EXISTS persona_type TEXT;             -- cfo, cto, founder, head_of_product, etc.
ALTER TABLE contacts ADD COLUMN IF NOT EXISTS is_champion BOOLEAN DEFAULT false;
ALTER TABLE contacts ADD COLUMN IF NOT EXISTS last_engaged_at TIMESTAMPTZ;

-- =============================================
-- METRIC DEFINITIONS table — anti-sprawl rule (spec §8.2)
-- =============================================

CREATE TABLE IF NOT EXISTS metric_definitions (
    metric_name     TEXT PRIMARY KEY,
    sql_view        TEXT NOT NULL,                     -- name of the SQL view that computes it
    column_name     TEXT NOT NULL,
    aggregation     TEXT,                              -- sum, avg, count, etc.
    description     TEXT,
    owner           TEXT,
    surfaces        TEXT[],                            -- where it's allowed to surface: sheets, metabase, quicksight
    created_at      TIMESTAMPTZ DEFAULT now(),
    updated_at      TIMESTAMPTZ DEFAULT now()
);
