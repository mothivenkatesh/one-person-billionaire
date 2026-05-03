-- mart_account_health — composite ICP-fit + intent + engagement + churn-risk per account.
-- Used by Churn-Saver, Dormant-Detector, Stage-Mover agents + Metabase dashboard.
--
-- Refresh: every 6 hours (more frequent than mart_buyer_journey because intent shifts daily).

DROP MATERIALIZED VIEW IF EXISTS mart_account_health;

CREATE MATERIALIZED VIEW mart_account_health AS
WITH recent_signals AS (
    -- Aggregate signals over rolling windows
    SELECT
        account_id,
        COUNT(*) FILTER (WHERE observed_at > now() - interval '7 days')   AS signals_7d,
        COUNT(*) FILTER (WHERE observed_at > now() - interval '30 days')  AS signals_30d,
        COUNT(*) FILTER (WHERE signal_type = 'traffic_spike' AND observed_at > now() - interval '14 days') AS traffic_spikes_14d,
        COUNT(*) FILTER (WHERE signal_type = 'intent_surge' AND observed_at > now() - interval '14 days') AS intent_surges_14d,
        AVG(strength) FILTER (WHERE observed_at > now() - interval '30 days') AS avg_signal_strength_30d
    FROM signals
    GROUP BY account_id
),
recent_interactions AS (
    -- Aggregate interactions
    SELECT
        account_id,
        COUNT(*) FILTER (WHERE recorded_at > now() - interval '7 days')   AS touches_7d,
        COUNT(*) FILTER (WHERE recorded_at > now() - interval '30 days')  AS touches_30d,
        MAX(recorded_at)                                                  AS last_touch_at,
        COUNT(*) FILTER (WHERE touch_type = 'reply' AND recorded_at > now() - interval '30 days') AS replies_30d,
        COUNT(*) FILTER (WHERE touch_type = 'meeting' AND recorded_at > now() - interval '90 days') AS meetings_90d
    FROM interactions
    GROUP BY account_id
),
recent_extracted AS (
    -- Roll up Claude-extracted typed properties
    SELECT
        account_id,
        COUNT(*) FILTER (WHERE property_name = 'churn_risk_phrase' AND extracted_at > now() - interval '30 days') AS churn_risk_signals_30d,
        COUNT(*) FILTER (WHERE property_name = 'expansion_signal' AND extracted_at > now() - interval '30 days') AS expansion_signals_30d,
        COUNT(*) FILTER (WHERE property_name = 'objection_raised' AND extracted_at > now() - interval '30 days') AS objections_30d,
        COUNT(*) FILTER (WHERE property_name = 'competitor_mentioned' AND extracted_at > now() - interval '30 days') AS competitor_mentions_30d
    FROM extracted_property
    GROUP BY account_id
),
deal_state AS (
    -- Account-level deal state
    SELECT
        account_id,
        COUNT(*) FILTER (WHERE stage NOT IN ('closed_won', 'closed_lost')) AS open_deals,
        COUNT(*) FILTER (WHERE stage = 'closed_won')                       AS won_deals,
        COUNT(*) FILTER (WHERE stage = 'closed_lost')                      AS lost_deals,
        SUM(amount) FILTER (WHERE stage NOT IN ('closed_won', 'closed_lost')) AS open_pipeline,
        SUM(amount) FILTER (WHERE stage = 'closed_won')                    AS won_revenue
    FROM deals
    GROUP BY account_id
)
SELECT
    a.id                                    AS account_id,
    a.name                                  AS account_name,
    a.tier,
    a.vertical,
    a.industry,
    a.employees,
    a.icp_score,
    a.engagement_score,
    a.last_meaningful_touch,

    -- Signal counts
    COALESCE(rs.signals_7d, 0)              AS signals_7d,
    COALESCE(rs.signals_30d, 0)             AS signals_30d,
    COALESCE(rs.traffic_spikes_14d, 0)      AS traffic_spikes_14d,
    COALESCE(rs.intent_surges_14d, 0)       AS intent_surges_14d,
    COALESCE(rs.avg_signal_strength_30d, 0) AS avg_signal_strength_30d,

    -- Interaction counts
    COALESCE(ri.touches_7d, 0)              AS touches_7d,
    COALESCE(ri.touches_30d, 0)             AS touches_30d,
    ri.last_touch_at,
    COALESCE(ri.replies_30d, 0)             AS replies_30d,
    COALESCE(ri.meetings_90d, 0)            AS meetings_90d,

    -- Extracted-property counts (the layer 3.5 magic)
    COALESCE(re.churn_risk_signals_30d, 0)  AS churn_risk_signals_30d,
    COALESCE(re.expansion_signals_30d, 0)   AS expansion_signals_30d,
    COALESCE(re.objections_30d, 0)          AS objections_30d,
    COALESCE(re.competitor_mentions_30d, 0) AS competitor_mentions_30d,

    -- Deal state
    COALESCE(ds.open_deals, 0)              AS open_deals,
    COALESCE(ds.won_deals, 0)               AS won_deals,
    COALESCE(ds.lost_deals, 0)              AS lost_deals,
    COALESCE(ds.open_pipeline, 0)           AS open_pipeline,
    COALESCE(ds.won_revenue, 0)             AS won_revenue,

    -- Composite scores (capped 0-5 each)
    LEAST(5.0, GREATEST(0.0,
        COALESCE(a.icp_score, 0)
    ))                                      AS fit_score,

    LEAST(5.0, GREATEST(0.0,
        (COALESCE(rs.signals_30d, 0) * 0.3) +
        (COALESCE(rs.intent_surges_14d, 0) * 1.0) +
        (COALESCE(re.expansion_signals_30d, 0) * 1.5)
    ))                                      AS intent_score,

    LEAST(5.0, GREATEST(0.0,
        (COALESCE(ri.touches_30d, 0) * 0.1) +
        (COALESCE(ri.replies_30d, 0) * 0.5) +
        (COALESCE(ri.meetings_90d, 0) * 1.0)
    ))                                      AS engagement_composite_score,

    LEAST(5.0, GREATEST(0.0,
        (COALESCE(re.churn_risk_signals_30d, 0) * 1.5) +
        (COALESCE(re.competitor_mentions_30d, 0) * 1.0) +
        (CASE WHEN ri.last_touch_at < now() - interval '30 days' THEN 1.0 ELSE 0.0 END) +
        (CASE WHEN ri.last_touch_at < now() - interval '60 days' THEN 1.5 ELSE 0.0 END)
    ))                                      AS churn_risk_score,

    -- Temperature
    CASE
        WHEN ri.last_touch_at IS NULL THEN 'never_touched'
        WHEN ri.last_touch_at < now() - interval '90 days' THEN 'dormant'
        WHEN ri.last_touch_at < now() - interval '30 days' THEN 'cooling'
        WHEN ri.last_touch_at < now() - interval '14 days' THEN 'warm'
        ELSE 'hot'
    END                                     AS temperature,

    now()                                   AS mart_refreshed_at

FROM accounts a
LEFT JOIN recent_signals rs    ON rs.account_id = a.id
LEFT JOIN recent_interactions ri ON ri.account_id = a.id
LEFT JOIN recent_extracted re  ON re.account_id = a.id
LEFT JOIN deal_state ds        ON ds.account_id = a.id;

CREATE UNIQUE INDEX idx_mart_account_health_account ON mart_account_health(account_id);
CREATE INDEX idx_mart_account_health_temperature ON mart_account_health(temperature);
CREATE INDEX idx_mart_account_health_churn_risk ON mart_account_health(churn_risk_score DESC);
CREATE INDEX idx_mart_account_health_intent ON mart_account_health(intent_score DESC);
