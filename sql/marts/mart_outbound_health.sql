-- mart_outbound_health — per-domain deliverability + reply rate + cost-per-demo + reputation status.
-- Critical for the 20-domain inbox-rotation operation. Quarantine triggers fire from this view.
--
-- Refresh: hourly during business hours.

DROP MATERIALIZED VIEW IF EXISTS mart_outbound_health;

CREATE MATERIALIZED VIEW mart_outbound_health AS
WITH domain_30d AS (
    -- 30-day aggregates per domain
    SELECT
        domain,
        SUM(sends_count)                                        AS sends_30d,
        SUM(bounces)                                            AS bounces_30d,
        SUM(spam_complaints)                                    AS spam_complaints_30d,
        SUM(replies)                                            AS replies_30d,
        SUM(opens)                                              AS opens_30d,
        SUM(clicks)                                             AS clicks_30d,
        AVG(inbox_placement_score)                              AS avg_inbox_placement_score_30d
    FROM domain_deliverability_daily
    WHERE snapshot_date >= now() - interval '30 days'
    GROUP BY domain
),
domain_7d AS (
    -- 7-day aggregates (more sensitive for early detection)
    SELECT
        domain,
        SUM(sends_count)                                        AS sends_7d,
        SUM(bounces)                                            AS bounces_7d,
        SUM(spam_complaints)                                    AS spam_complaints_7d,
        SUM(replies)                                            AS replies_7d,
        AVG(inbox_placement_score)                              AS avg_inbox_placement_score_7d
    FROM domain_deliverability_daily
    WHERE snapshot_date >= now() - interval '7 days'
    GROUP BY domain
),
domain_demos_30d AS (
    -- Demos booked credited to each domain (via Smartlead campaign attribution → DIN → channel)
    SELECT
        c.utm_source                                            AS domain_inferred,
        COUNT(*)                                                AS demos_credited_30d,
        SUM(c.spend_inr)                                        AS spend_30d_inr
    FROM mart_buyer_journey m
    JOIN campaigns c ON c.din_id = m.campaign
    WHERE m.meeting_booked_date >= now() - interval '30 days'
      AND c.utm_source IS NOT NULL
    GROUP BY c.utm_source
)

SELECT
    sd.domain,
    sd.pool,
    sd.warmed_at,
    sd.daily_send_cap,
    sd.status,
    sd.quarantined_at,
    sd.quarantine_reason,

    -- Volume metrics
    COALESCE(d30.sends_30d, 0)                                  AS sends_30d,
    COALESCE(d7.sends_7d, 0)                                    AS sends_7d,
    COALESCE(d30.opens_30d, 0)                                  AS opens_30d,
    COALESCE(d30.clicks_30d, 0)                                 AS clicks_30d,
    COALESCE(d30.replies_30d, 0)                                AS replies_30d,
    COALESCE(d7.replies_7d, 0)                                  AS replies_7d,
    COALESCE(d30.bounces_30d, 0)                                AS bounces_30d,
    COALESCE(d30.spam_complaints_30d, 0)                        AS spam_complaints_30d,

    -- Reputation + quality rates
    CASE WHEN d30.sends_30d > 0
         THEN ROUND(100.0 * d30.replies_30d / d30.sends_30d, 2)
         ELSE NULL END                                          AS reply_rate_pct_30d,
    CASE WHEN d7.sends_7d > 0
         THEN ROUND(100.0 * d7.replies_7d / d7.sends_7d, 2)
         ELSE NULL END                                          AS reply_rate_pct_7d,
    CASE WHEN d30.sends_30d > 0
         THEN ROUND(100.0 * d30.bounces_30d / d30.sends_30d, 2)
         ELSE NULL END                                          AS bounce_rate_pct_30d,
    CASE WHEN d30.sends_30d > 0
         THEN ROUND(100.0 * d30.spam_complaints_30d / d30.sends_30d, 4)
         ELSE NULL END                                          AS spam_complaint_rate_pct_30d,
    CASE WHEN d7.sends_7d > 0
         THEN ROUND(100.0 * d7.spam_complaints_7d / d7.sends_7d, 4)
         ELSE NULL END                                          AS spam_complaint_rate_pct_7d,

    d30.avg_inbox_placement_score_30d,
    d7.avg_inbox_placement_score_7d,

    -- Cost efficiency
    COALESCE(dd.demos_credited_30d, 0)                          AS demos_credited_30d,
    COALESCE(dd.spend_30d_inr, 0)                               AS spend_30d_inr,
    CASE WHEN COALESCE(dd.demos_credited_30d, 0) > 0
         THEN ROUND(dd.spend_30d_inr / dd.demos_credited_30d, 0)
         ELSE NULL END                                          AS cost_per_demo_inr_30d,

    -- Computed health recommendation (overrides table status if anomaly detected)
    CASE
        -- Quarantine triggers
        WHEN COALESCE(100.0 * d7.spam_complaints_7d / NULLIF(d7.sends_7d, 0), 0) > 0.10 THEN 'quarantine_recommended_spam'
        WHEN COALESCE(100.0 * d30.bounces_30d / NULLIF(d30.sends_30d, 0), 0) > 5.0 THEN 'quarantine_recommended_bounce'
        WHEN COALESCE(d30.avg_inbox_placement_score_30d, 1.0) < 0.70 THEN 'quarantine_recommended_inbox'
        -- Warning triggers
        WHEN COALESCE(100.0 * d7.spam_complaints_7d / NULLIF(d7.sends_7d, 0), 0) > 0.05 THEN 'warning_spam'
        WHEN COALESCE(100.0 * d7.replies_7d / NULLIF(d7.sends_7d, 0), 0) < 1.0
             AND d7.sends_7d > 100 THEN 'warning_low_reply_rate'
        WHEN COALESCE(100.0 * d30.bounces_30d / NULLIF(d30.sends_30d, 0), 0) > 2.0 THEN 'warning_bounce'
        WHEN COALESCE(d30.avg_inbox_placement_score_30d, 1.0) < 0.85 THEN 'warning_inbox'
        -- Healthy
        ELSE 'healthy'
    END                                                         AS computed_health_flag,

    -- Days since warmed (relevant for new domains)
    CASE WHEN sd.warmed_at IS NOT NULL
         THEN EXTRACT(DAY FROM now() - sd.warmed_at)::INT
         ELSE NULL END                                          AS days_since_warmed,

    now()                                                       AS mart_refreshed_at

FROM sender_domains sd
LEFT JOIN domain_30d         d30 ON d30.domain = sd.domain
LEFT JOIN domain_7d          d7  ON d7.domain  = sd.domain
LEFT JOIN domain_demos_30d   dd  ON dd.domain_inferred = sd.domain;

CREATE UNIQUE INDEX idx_mart_outbound_health_domain ON mart_outbound_health(domain);
CREATE INDEX idx_mart_outbound_health_pool ON mart_outbound_health(pool);
CREATE INDEX idx_mart_outbound_health_flag ON mart_outbound_health(computed_health_flag);

-- =============================================
-- Common queries
-- =============================================

-- Domains needing immediate attention
-- SELECT domain, pool, computed_health_flag, spam_complaint_rate_pct_7d, bounce_rate_pct_30d, reply_rate_pct_7d
-- FROM mart_outbound_health WHERE computed_health_flag LIKE 'quarantine_%' OR computed_health_flag LIKE 'warning_%';

-- Cost efficiency leaderboard (best demos-per-rupee)
-- SELECT domain, pool, demos_credited_30d, spend_30d_inr, cost_per_demo_inr_30d
-- FROM mart_outbound_health WHERE demos_credited_30d > 0 ORDER BY cost_per_demo_inr_30d ASC;

-- Pool-level summary for the weekly digest
-- SELECT pool, COUNT(*) AS domains_in_pool, AVG(reply_rate_pct_30d) AS avg_reply_rate,
--        AVG(spam_complaint_rate_pct_30d) AS avg_spam_rate
-- FROM mart_outbound_health GROUP BY pool;
