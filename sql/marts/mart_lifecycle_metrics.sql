-- mart_lifecycle_metrics — onboarding / re-engagement / retention / adoption rates.
-- Cashfree's 4 motions vs Razorpay's public MoEngage benchmarks (29% / 19% / 25% / 16%).
-- Powers the weekly digest's Lifecycle vs Razorpay Floor section (spec §8.3 Section C).
--
-- Refresh: daily (lifecycle metrics shift slowly; daily is enough).

DROP MATERIALIZED VIEW IF EXISTS mart_lifecycle_metrics;

CREATE MATERIALIZED VIEW mart_lifecycle_metrics AS
WITH date_buckets AS (
    -- We compute "this week" (last 7 days) vs "4-week avg" (last 28 days)
    SELECT
        date_trunc('day', now())                                AS today,
        date_trunc('day', now() - interval '7 days')            AS week_start,
        date_trunc('day', now() - interval '28 days')           AS month_start
),

-- ============= ONBOARDING COMPLETION =============
-- Definition: % of new merchants (signup event) who reach 'activated' within 30 days
onboarding_this_week AS (
    SELECT
        COUNT(*) FILTER (WHERE EXISTS (
            SELECT 1 FROM merchant_lifecycle_events e2
            WHERE e2.account_id = e1.account_id
              AND e2.event_type = 'activated'
              AND e2.occurred_at <= e1.occurred_at + interval '30 days'
        ))::FLOAT / NULLIF(COUNT(*), 0)                         AS onboarding_completion_pct_this_week
    FROM merchant_lifecycle_events e1, date_buckets db
    WHERE e1.event_type = 'signup'
      AND e1.occurred_at >= db.week_start
      AND e1.occurred_at < db.today
),
onboarding_4wk_avg AS (
    SELECT
        COUNT(*) FILTER (WHERE EXISTS (
            SELECT 1 FROM merchant_lifecycle_events e2
            WHERE e2.account_id = e1.account_id
              AND e2.event_type = 'activated'
              AND e2.occurred_at <= e1.occurred_at + interval '30 days'
        ))::FLOAT / NULLIF(COUNT(*), 0)                         AS onboarding_completion_pct_4wk
    FROM merchant_lifecycle_events e1, date_buckets db
    WHERE e1.event_type = 'signup'
      AND e1.occurred_at >= db.month_start
      AND e1.occurred_at < db.today
),

-- ============= RE-ENGAGEMENT =============
-- Definition: % of accounts that flipped 'dormant_entered' → 'reengaged' within the period
reengagement_this_week AS (
    SELECT
        COUNT(*) FILTER (WHERE EXISTS (
            SELECT 1 FROM merchant_lifecycle_events e2
            WHERE e2.account_id = e1.account_id
              AND e2.event_type = 'reengaged'
              AND e2.occurred_at >= e1.occurred_at
              AND e2.occurred_at <= e1.occurred_at + interval '60 days'
        ))::FLOAT / NULLIF(COUNT(*), 0)                         AS reengagement_pct_this_week
    FROM merchant_lifecycle_events e1, date_buckets db
    WHERE e1.event_type = 'dormant_entered'
      AND e1.occurred_at >= db.week_start - interval '60 days'  -- give time to re-engage
      AND e1.occurred_at < db.today - interval '30 days'         -- but not too recent
),
reengagement_4wk_avg AS (
    SELECT
        COUNT(*) FILTER (WHERE EXISTS (
            SELECT 1 FROM merchant_lifecycle_events e2
            WHERE e2.account_id = e1.account_id
              AND e2.event_type = 'reengaged'
              AND e2.occurred_at >= e1.occurred_at
              AND e2.occurred_at <= e1.occurred_at + interval '60 days'
        ))::FLOAT / NULLIF(COUNT(*), 0)                         AS reengagement_pct_4wk
    FROM merchant_lifecycle_events e1, date_buckets db
    WHERE e1.event_type = 'dormant_entered'
      AND e1.occurred_at >= db.month_start - interval '60 days'
      AND e1.occurred_at < db.today - interval '30 days'
),

-- ============= RETENTION =============
-- Definition: % of activated merchants still active (last_meaningful_touch within 90d) over period
retention_this_week AS (
    SELECT
        COUNT(*) FILTER (WHERE a.last_meaningful_touch >= now() - interval '90 days')::FLOAT
            / NULLIF(COUNT(*), 0)                               AS retention_pct_this_week
    FROM accounts a
    WHERE EXISTS (
        SELECT 1 FROM merchant_lifecycle_events e
        WHERE e.account_id = a.id AND e.event_type = 'activated'
    )
),
-- 4-wk avg for retention is the same window in this simple model; a more sophisticated approach
-- would snapshot the rate weekly; for v1 we approximate using a 28d backward-looking window
retention_4wk_avg AS (
    SELECT
        AVG(weekly_retention) AS retention_pct_4wk
    FROM (
        SELECT
            COUNT(*) FILTER (WHERE a.last_meaningful_touch >= week_anchor - interval '90 days')::FLOAT
                / NULLIF(COUNT(*), 0)                           AS weekly_retention
        FROM accounts a
        CROSS JOIN (SELECT generate_series(now() - interval '28 days', now(), interval '7 days') AS week_anchor) w
        WHERE EXISTS (
            SELECT 1 FROM merchant_lifecycle_events e
            WHERE e.account_id = a.id AND e.event_type = 'activated'
              AND e.occurred_at <= week_anchor
        )
        GROUP BY week_anchor
    ) sub
),

-- ============= ADOPTION =============
-- Definition: % of merchants who first-used a product after a campaign for that product launched
adoption_this_week AS (
    SELECT
        COUNT(*) FILTER (WHERE EXISTS (
            SELECT 1 FROM campaigns c
            WHERE c.din_id = e.related_din
              AND c.motion_type IN ('cross-sell', 'nurture')
              AND e.event_type = 'feature_adopted'
        ))::FLOAT / NULLIF(COUNT(*), 0)                         AS adoption_pct_this_week
    FROM merchant_lifecycle_events e, date_buckets db
    WHERE e.event_type = 'feature_adopted'
      AND e.occurred_at >= db.week_start
),
adoption_4wk_avg AS (
    SELECT
        COUNT(*) FILTER (WHERE EXISTS (
            SELECT 1 FROM campaigns c
            WHERE c.din_id = e.related_din
              AND c.motion_type IN ('cross-sell', 'nurture')
              AND e.event_type = 'feature_adopted'
        ))::FLOAT / NULLIF(COUNT(*), 0)                         AS adoption_pct_4wk
    FROM merchant_lifecycle_events e, date_buckets db
    WHERE e.event_type = 'feature_adopted'
      AND e.occurred_at >= db.month_start
)

SELECT
    motion,
    this_week_pct,
    four_week_avg_pct,
    razorpay_floor_pct,
    ROUND((this_week_pct - razorpay_floor_pct)::NUMERIC, 1)     AS gap_to_razorpay_floor_pct,
    CASE
        WHEN this_week_pct >= razorpay_floor_pct * 1.10 THEN 'beating_floor'
        WHEN this_week_pct >= razorpay_floor_pct THEN 'meeting_floor'
        WHEN this_week_pct >= razorpay_floor_pct * 0.85 THEN 'near_floor'
        ELSE 'below_floor'
    END                                                         AS razorpay_status,
    now()                                                       AS mart_refreshed_at

FROM (
    SELECT 'onboarding_completion' AS motion,
           ROUND((COALESCE((SELECT onboarding_completion_pct_this_week FROM onboarding_this_week), 0) * 100)::NUMERIC, 1) AS this_week_pct,
           ROUND((COALESCE((SELECT onboarding_completion_pct_4wk      FROM onboarding_4wk_avg), 0) * 100)::NUMERIC, 1)    AS four_week_avg_pct,
           29.0                                                                                                            AS razorpay_floor_pct
    UNION ALL
    SELECT 're_engagement',
           ROUND((COALESCE((SELECT reengagement_pct_this_week FROM reengagement_this_week), 0) * 100)::NUMERIC, 1),
           ROUND((COALESCE((SELECT reengagement_pct_4wk      FROM reengagement_4wk_avg), 0) * 100)::NUMERIC, 1),
           19.0
    UNION ALL
    SELECT 'retention',
           ROUND((COALESCE((SELECT retention_pct_this_week FROM retention_this_week), 0) * 100)::NUMERIC, 1),
           ROUND((COALESCE((SELECT retention_pct_4wk      FROM retention_4wk_avg), 0) * 100)::NUMERIC, 1),
           25.0
    UNION ALL
    SELECT 'adoption',
           ROUND((COALESCE((SELECT adoption_pct_this_week FROM adoption_this_week), 0) * 100)::NUMERIC, 1),
           ROUND((COALESCE((SELECT adoption_pct_4wk      FROM adoption_4wk_avg), 0) * 100)::NUMERIC, 1),
           16.0
) summary;

CREATE UNIQUE INDEX idx_mart_lifecycle_metrics_motion ON mart_lifecycle_metrics(motion);

-- =============================================
-- Common queries
-- =============================================

-- Lifecycle scorecard for the weekly digest
-- SELECT * FROM mart_lifecycle_metrics ORDER BY motion;

-- Are we beating Razorpay on any motion this week?
-- SELECT motion, this_week_pct, razorpay_floor_pct, razorpay_status FROM mart_lifecycle_metrics
-- WHERE razorpay_status IN ('beating_floor', 'meeting_floor');
