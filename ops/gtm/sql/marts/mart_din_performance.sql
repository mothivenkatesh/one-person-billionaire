-- mart_din_performance — per-DIN pipeline + spend + win-rate + cost efficiency.
-- The core artifact for the weekly digest's DIN leaderboard (spec §8.3 Section F).
--
-- Refresh: nightly via cron (REFRESH MATERIALIZED VIEW CONCURRENTLY mart_din_performance).

DROP MATERIALIZED VIEW IF EXISTS mart_din_performance;

CREATE MATERIALIZED VIEW mart_din_performance AS
WITH din_touches AS (
    -- Aggregate interactions per DIN
    SELECT
        campaign_din,
        COUNT(*)                                                            AS touches_count,
        COUNT(DISTINCT account_id)                                          AS accounts_touched,
        COUNT(*) FILTER (WHERE touch_type = 'open')                         AS opens,
        COUNT(*) FILTER (WHERE touch_type = 'click')                        AS clicks,
        COUNT(*) FILTER (WHERE touch_type = 'reply')                        AS replies,
        COUNT(*) FILTER (WHERE touch_type = 'meeting')                      AS meetings_held,
        COUNT(*) FILTER (WHERE touch_type = 'demo')                         AS demos_booked
    FROM interactions
    WHERE campaign_din IS NOT NULL
    GROUP BY campaign_din
),
din_pipeline AS (
    -- Aggregate downstream pipeline per DIN via mart_buyer_journey first_touch attribution
    -- (Most attribution-conservative: count a deal once even if DIN appears in influencing_touches AND as first_touch)
    SELECT
        campaign                                                            AS campaign_din,
        COUNT(*)                                                            AS deals_sourced,
        COUNT(*) FILTER (WHERE outcome = 'won')                             AS deals_won,
        COUNT(*) FILTER (WHERE outcome = 'lost')                            AS deals_lost,
        COUNT(*) FILTER (WHERE outcome = 'open')                            AS deals_open,
        SUM(opportunity_amount) FILTER (WHERE outcome = 'open')             AS open_pipeline_inr,
        SUM(opportunity_amount) FILTER (WHERE outcome = 'won')              AS won_revenue_inr,
        SUM(opportunity_amount)                                             AS total_pipeline_inr,
        AVG(cycle_days) FILTER (WHERE outcome IN ('won', 'lost'))           AS avg_cycle_days
    FROM mart_buyer_journey
    WHERE campaign IS NOT NULL
    GROUP BY campaign
),
din_spend AS (
    -- Total spend per DIN
    SELECT
        din_id                                                              AS campaign_din,
        SUM(spend_inr)                                                      AS total_spend_inr,
        SUM(spend_inr) FILTER (WHERE snapshot_date > now() - interval '7 days') AS spend_last_7d_inr,
        SUM(spend_inr) FILTER (WHERE snapshot_date > now() - interval '30 days') AS spend_last_30d_inr
    FROM campaign_spend_daily
    GROUP BY din_id
)
SELECT
    c.din_id                                                                AS din,
    c.name                                                                  AS campaign_name,
    c.motion_type,
    c.tier,
    c.segment,
    c.channels,
    c.pmm_owner_email,
    c.approval_status,
    c.launched_at,
    c.ended_at,

    -- Spend
    COALESCE(c.spend_inr, 0)                                                AS total_spend_inr,
    COALESCE(c.planned_budget_inr, 0)                                       AS planned_budget_inr,
    COALESCE(ds.spend_last_7d_inr, 0)                                       AS spend_last_7d_inr,
    COALESCE(ds.spend_last_30d_inr, 0)                                      AS spend_last_30d_inr,

    -- Touches
    COALESCE(dt.touches_count, 0)                                           AS touches,
    COALESCE(dt.accounts_touched, 0)                                        AS accounts_touched,
    COALESCE(dt.opens, 0)                                                   AS opens,
    COALESCE(dt.clicks, 0)                                                  AS clicks,
    COALESCE(dt.replies, 0)                                                 AS replies,
    COALESCE(dt.meetings_held, 0)                                           AS meetings_held,
    COALESCE(dt.demos_booked, 0)                                            AS demos_booked,

    -- Pipeline
    COALESCE(dp.deals_sourced, 0)                                           AS deals_sourced,
    COALESCE(dp.deals_won, 0)                                               AS deals_won,
    COALESCE(dp.deals_lost, 0)                                              AS deals_lost,
    COALESCE(dp.deals_open, 0)                                              AS deals_open,
    COALESCE(dp.open_pipeline_inr, 0)                                       AS open_pipeline_inr,
    COALESCE(dp.won_revenue_inr, 0)                                         AS won_revenue_inr,
    COALESCE(dp.total_pipeline_inr, 0)                                      AS total_pipeline_inr,
    dp.avg_cycle_days,

    -- Derived metrics
    CASE
        WHEN COALESCE(dp.deals_won + dp.deals_lost, 0) > 0
        THEN ROUND(100.0 * dp.deals_won / (dp.deals_won + dp.deals_lost), 1)
        ELSE NULL
    END                                                                     AS win_rate_pct,

    CASE
        WHEN COALESCE(dt.demos_booked, 0) > 0
        THEN ROUND(c.spend_inr / dt.demos_booked, 0)
        ELSE NULL
    END                                                                     AS cost_per_demo_inr,

    CASE
        WHEN COALESCE(dp.total_pipeline_inr, 0) > 0
        THEN ROUND(c.spend_inr / dp.total_pipeline_inr, 4)
        ELSE NULL
    END                                                                     AS cost_per_pipeline_rupee,

    CASE
        WHEN COALESCE(dt.touches_count, 0) > 0
        THEN ROUND(100.0 * dt.replies / dt.touches_count, 2)
        ELSE NULL
    END                                                                     AS reply_rate_pct,

    -- ROI signal — won_revenue / spend (multi-quarter; not strict ROI math)
    CASE
        WHEN COALESCE(c.spend_inr, 0) > 0 AND COALESCE(dp.won_revenue_inr, 0) > 0
        THEN ROUND(dp.won_revenue_inr / c.spend_inr, 2)
        ELSE NULL
    END                                                                     AS roi_multiple,

    -- Health flags for the weekly digest
    CASE
        WHEN c.spend_inr > 0 AND COALESCE(dt.replies, 0) = 0 AND c.launched_at < now() - interval '14 days' THEN 'underperforming_kill'
        WHEN COALESCE(dp.deals_won, 0) >= 1 AND COALESCE(c.spend_inr, 0) > 0 AND dp.won_revenue_inr / c.spend_inr >= 5 THEN 'top_performer_repeat'
        WHEN COALESCE(dt.replies, 0) > 0 AND COALESCE(dp.deals_sourced, 0) = 0 THEN 'replies_not_converting'
        ELSE 'normal'
    END                                                                     AS health_flag,

    now()                                                                   AS mart_refreshed_at

FROM campaigns c
LEFT JOIN din_touches  dt ON dt.campaign_din = c.din_id
LEFT JOIN din_pipeline dp ON dp.campaign_din = c.din_id
LEFT JOIN din_spend    ds ON ds.campaign_din = c.din_id;

CREATE UNIQUE INDEX idx_mart_din_performance_din ON mart_din_performance(din);
CREATE INDEX idx_mart_din_performance_health ON mart_din_performance(health_flag);
CREATE INDEX idx_mart_din_performance_pipeline ON mart_din_performance(total_pipeline_inr DESC);
CREATE INDEX idx_mart_din_performance_motion ON mart_din_performance(motion_type, tier);

-- =============================================
-- Common queries
-- =============================================

-- Top 5 performing DINs by pipeline this quarter
-- SELECT din, campaign_name, motion_type, tier, total_pipeline_inr, win_rate_pct, cost_per_demo_inr
-- FROM mart_din_performance
-- WHERE launched_at >= date_trunc('quarter', now()) ORDER BY total_pipeline_inr DESC LIMIT 5;

-- DINs to kill this week (high spend, no replies after 14d)
-- SELECT din, campaign_name, total_spend_inr, touches, replies
-- FROM mart_din_performance WHERE health_flag = 'underperforming_kill';

-- Cost-efficiency leaderboard (most pipeline per ₹ spent)
-- SELECT din, campaign_name, total_spend_inr, total_pipeline_inr, cost_per_pipeline_rupee
-- FROM mart_din_performance
-- WHERE total_pipeline_inr > 0 ORDER BY cost_per_pipeline_rupee ASC LIMIT 10;
