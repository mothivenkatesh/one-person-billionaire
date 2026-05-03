-- gtm-ops schema — HubSpot-shaped deals + enrichment cache + transcripts.
-- Run once against the pgvector/pgvector:pg16 container.

CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE IF NOT EXISTS accounts (
    id            TEXT PRIMARY KEY,
    name          TEXT NOT NULL,
    domain        TEXT,
    industry      TEXT,
    employees     INT,
    icp_score     NUMERIC(3, 2),
    created_at    TIMESTAMPTZ DEFAULT now(),
    updated_at    TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS contacts (
    id            TEXT PRIMARY KEY,
    account_id    TEXT REFERENCES accounts(id),
    email         TEXT UNIQUE,
    first_name    TEXT,
    last_name     TEXT,
    title         TEXT,
    linkedin_url  TEXT,
    updated_at    TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS deals (
    id                  TEXT PRIMARY KEY,
    account_id          TEXT REFERENCES accounts(id),
    stage               TEXT NOT NULL,
    amount              NUMERIC(12, 2),
    owner_email         TEXT,
    last_activity_at    TIMESTAMPTZ,
    next_step           TEXT,
    close_date          DATE,
    created_at          TIMESTAMPTZ DEFAULT now(),
    updated_at          TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS activities (
    id            BIGSERIAL PRIMARY KEY,
    deal_id       TEXT REFERENCES deals(id),
    type          TEXT,   -- email_open, email_reply, call, meeting, linkedin_reply
    channel       TEXT,   -- email, linkedin, in-person, phone, slack
    occurred_at   TIMESTAMPTZ,
    metadata      JSONB
);

CREATE TABLE IF NOT EXISTS signals (
    id              BIGSERIAL PRIMARY KEY,
    account_id      TEXT REFERENCES accounts(id),
    source          TEXT,   -- ahrefs, meta_ads, common_room, g2, typefully
    signal_type     TEXT,   -- traffic_spike, ad_scale, intent_surge, reply_engaged
    strength        NUMERIC(3, 2),
    observed_at     TIMESTAMPTZ,
    metadata        JSONB
);

CREATE TABLE IF NOT EXISTS transcripts (
    id              TEXT PRIMARY KEY,
    source          TEXT NOT NULL,   -- gong, fathom, granola, fireflies
    deal_id         TEXT REFERENCES deals(id),
    recorded_at     TIMESTAMPTZ,
    duration_s      INT,
    text            TEXT,
    embedding       vector(1536),    -- pgvector for similarity search
    metadata        JSONB
);

CREATE INDEX IF NOT EXISTS idx_deals_stage_activity ON deals(stage, last_activity_at);
CREATE INDEX IF NOT EXISTS idx_signals_account_time ON signals(account_id, observed_at DESC);
CREATE INDEX IF NOT EXISTS idx_transcripts_deal ON transcripts(deal_id);
CREATE INDEX IF NOT EXISTS idx_transcripts_embedding ON transcripts USING ivfflat (embedding vector_cosine_ops);

-- Materialized view — powers the Metabase cold-deal dashboard.
DROP MATERIALIZED VIEW IF EXISTS cold_deal_flags;
CREATE MATERIALIZED VIEW cold_deal_flags AS
SELECT
    d.id AS deal_id,
    d.account_id,
    a.name AS account_name,
    d.stage,
    d.amount,
    d.owner_email,
    d.last_activity_at,
    EXTRACT(DAY FROM now() - d.last_activity_at) AS days_cold,
    COUNT(s.id) FILTER (WHERE s.observed_at > now() - interval '14 days') AS recent_signals,
    CASE
        WHEN d.last_activity_at IS NULL THEN 'never_touched'
        WHEN now() - d.last_activity_at > interval '21 days' THEN 'cold'
        WHEN now() - d.last_activity_at > interval '14 days' THEN 'cooling'
        ELSE 'active'
    END AS temperature
FROM deals d
JOIN accounts a ON a.id = d.account_id
LEFT JOIN signals s ON s.account_id = d.account_id
WHERE d.stage NOT IN ('closed_won', 'closed_lost')
GROUP BY d.id, a.name, a.id;

CREATE UNIQUE INDEX ON cold_deal_flags(deal_id);
