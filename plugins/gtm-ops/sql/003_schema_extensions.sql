-- gtm-ops schema extensions v3 — supporting tables for the next 6 marts.
-- Additive; doesn't touch existing 001_schema or 002_schema_extensions.

-- =============================================
-- SENDER DOMAINS — for mart_outbound_health
-- =============================================

CREATE TABLE IF NOT EXISTS sender_domains (
    domain              TEXT PRIMARY KEY,
    pool                TEXT NOT NULL CHECK (pool IN ('tier_c_outbound', 'pmm_demand', 'reserve', 'cashfree_warmed')),
    warmed_at           TIMESTAMPTZ,
    daily_send_cap      INT NOT NULL DEFAULT 50,
    status              TEXT NOT NULL DEFAULT 'healthy' CHECK (status IN ('healthy', 'warning', 'quarantine')),
    quarantined_at      TIMESTAMPTZ,
    quarantine_reason   TEXT,
    created_at          TIMESTAMPTZ DEFAULT now(),
    updated_at          TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS domain_deliverability_daily (
    domain                  TEXT REFERENCES sender_domains(domain),
    snapshot_date           DATE NOT NULL,
    sends_count             INT NOT NULL DEFAULT 0,
    bounces                 INT NOT NULL DEFAULT 0,
    spam_complaints         INT NOT NULL DEFAULT 0,
    replies                 INT NOT NULL DEFAULT 0,
    opens                   INT NOT NULL DEFAULT 0,
    clicks                  INT NOT NULL DEFAULT 0,
    inbox_placement_score   NUMERIC(3, 2),       -- 0.00–1.00 from GlockApps test
    PRIMARY KEY (domain, snapshot_date)
);

CREATE INDEX IF NOT EXISTS idx_domain_deliverability_date ON domain_deliverability_daily(snapshot_date DESC);

-- =============================================
-- AE ROSTER — for mart_ae_performance
-- =============================================

CREATE TABLE IF NOT EXISTS ae_roster (
    email                            TEXT PRIMARY KEY,
    name                             TEXT NOT NULL,
    tier_assignment                  TEXT[],            -- {'A', 'B'} or {'C'} or {'plg'}
    vertical_focus                   TEXT[],            -- {'bfsi', 'd2c'} etc
    quota_inr_quarterly              NUMERIC(12, 2),
    calendar_capacity_hours_per_week INT NOT NULL DEFAULT 30,
    active                           BOOLEAN DEFAULT true,
    hired_at                         DATE,
    created_at                       TIMESTAMPTZ DEFAULT now(),
    updated_at                       TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS ae_calendar_daily (
    ae_email                  TEXT REFERENCES ae_roster(email),
    snapshot_date             DATE NOT NULL,
    hours_booked              NUMERIC(4, 2) NOT NULL DEFAULT 0,
    hours_external_meetings   NUMERIC(4, 2) NOT NULL DEFAULT 0,
    meetings_count            INT NOT NULL DEFAULT 0,
    PRIMARY KEY (ae_email, snapshot_date)
);

CREATE INDEX IF NOT EXISTS idx_ae_calendar_date ON ae_calendar_daily(snapshot_date DESC);

-- =============================================
-- CAMPAIGN SPEND tracking — extension to existing campaigns table
-- =============================================

ALTER TABLE campaigns ADD COLUMN IF NOT EXISTS spend_inr               NUMERIC(12, 2) DEFAULT 0;
ALTER TABLE campaigns ADD COLUMN IF NOT EXISTS planned_budget_inr      NUMERIC(12, 2) DEFAULT 0;

-- Per-day spend snapshots so we can chart burn-rate
CREATE TABLE IF NOT EXISTS campaign_spend_daily (
    din_id          TEXT REFERENCES campaigns(din_id),
    snapshot_date   DATE NOT NULL,
    spend_inr       NUMERIC(12, 2) NOT NULL DEFAULT 0,
    channel         TEXT,   -- which channel produced the spend that day
    PRIMARY KEY (din_id, snapshot_date, channel)
);

CREATE INDEX IF NOT EXISTS idx_campaign_spend_date ON campaign_spend_daily(snapshot_date DESC);

-- =============================================
-- LIFECYCLE EVENTS — for mart_lifecycle_metrics
-- =============================================

-- Tracks merchant lifecycle milestones for onboarding/retention/re-engagement/adoption metrics.
CREATE TABLE IF NOT EXISTS merchant_lifecycle_events (
    id                  BIGSERIAL PRIMARY KEY,
    account_id          TEXT REFERENCES accounts(id),
    event_type          TEXT NOT NULL CHECK (event_type IN (
        'signup',
        'kyc_completed',
        'first_transaction',
        'activated',                -- 5+ transactions OR ₹X volume in first 30d
        'dormant_entered',          -- temperature flipped to dormant
        'reengaged',                -- temperature flipped back from dormant to warm/hot
        'churned',                  -- explicit churn
        'feature_adopted',          -- new feature first use (per merchant per feature)
        'cross_sell_attached',      -- new product activated
        'win_back_revived'          -- previously churned, restarted activity
    )),
    event_subtype       TEXT,                       -- e.g., for feature_adopted: 'autopay', 'international_pg'
    occurred_at         TIMESTAMPTZ NOT NULL,
    related_din         TEXT REFERENCES campaigns(din_id),
    metadata            JSONB,
    created_at          TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_lifecycle_events_account_type ON merchant_lifecycle_events(account_id, event_type);
CREATE INDEX IF NOT EXISTS idx_lifecycle_events_type_date ON merchant_lifecycle_events(event_type, occurred_at DESC);
