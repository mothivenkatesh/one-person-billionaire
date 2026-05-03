-- mart_ae_performance — per-AE pipeline + calendar fill + conversion rates + quota attainment.
-- Powers per-rep operational sheet (gtm.ae-pipeline-{email}) and the executive QuickSight dashboard.
--
-- Refresh: hourly during business hours; nightly off-hours.

DROP MATERIALIZED VIEW IF EXISTS mart_ae_performance;

CREATE MATERIALIZED VIEW mart_ae_performance AS
WITH ae_deals AS (
    -- Deal counts and pipeline per AE
    SELECT
        owner_email                                             AS ae_email,
        COUNT(*) FILTER (WHERE outcome = 'open')                AS open_deals,
        COUNT(*) FILTER (WHERE outcome = 'won')                 AS deals_won_ytd,
        COUNT(*) FILTER (WHERE outcome = 'lost')                AS deals_lost_ytd,
        COUNT(*) FILTER (WHERE outcome = 'open' AND tier = 'A') AS open_tier_a_deals,
        COUNT(*) FILTER (WHERE outcome = 'open' AND tier = 'B') AS open_tier_b_deals,
        COUNT(*) FILTER (WHERE outcome = 'open' AND tier = 'C') AS open_tier_c_deals,
        SUM(opportunity_amount) FILTER (WHERE outcome = 'open') AS open_pipeline_inr,
        SUM(opportunity_amount) FILTER (WHERE outcome = 'won')  AS won_revenue_ytd_inr,
        SUM(opportunity_amount) FILTER (WHERE outcome = 'won' AND closed_won_date >= date_trunc('quarter', now())) AS won_revenue_qtd_inr,
        AVG(cycle_days) FILTER (WHERE outcome IN ('won', 'lost')) AS avg_cycle_days
    FROM mart_buyer_journey
    WHERE owner_email IS NOT NULL
    GROUP BY owner_email
),
ae_calendar_4wk AS (
    -- Average calendar fill rate over last 4 weeks (working days only)
    SELECT
        ae_email,
        AVG(hours_booked)                                       AS avg_daily_hours_booked,
        AVG(hours_external_meetings)                            AS avg_daily_external_hours,
        SUM(meetings_count)                                     AS total_meetings_28d
    FROM ae_calendar_daily
    WHERE snapshot_date >= now() - interval '28 days'
      AND EXTRACT(ISODOW FROM snapshot_date) BETWEEN 1 AND 5  -- Mon-Fri only
    GROUP BY ae_email
),
ae_calendar_this_week AS (
    SELECT
        ae_email,
        AVG(hours_booked)                                       AS this_week_avg_daily_hours
    FROM ae_calendar_daily
    WHERE snapshot_date >= now() - interval '7 days'
      AND EXTRACT(ISODOW FROM snapshot_date) BETWEEN 1 AND 5
    GROUP BY ae_email
),
ae_demos_30d AS (
    -- Demos booked in last 30d (from interactions)
    SELECT
        d.owner_email                                           AS ae_email,
        COUNT(*)                                                AS demos_booked_30d
    FROM interactions i
    JOIN deals d ON d.id = i.deal_id
    WHERE i.touch_type = 'demo'
      AND i.recorded_at >= now() - interval '30 days'
    GROUP BY d.owner_email
)

SELECT
    r.email                                                     AS ae_email,
    r.name                                                      AS ae_name,
    r.tier_assignment,
    r.vertical_focus,
    r.quota_inr_quarterly,
    r.calendar_capacity_hours_per_week,
    r.active,
    r.hired_at,

    -- Deal counts
    COALESCE(ad.open_deals, 0)                                  AS open_deals,
    COALESCE(ad.deals_won_ytd, 0)                               AS deals_won_ytd,
    COALESCE(ad.deals_lost_ytd, 0)                              AS deals_lost_ytd,
    COALESCE(ad.open_tier_a_deals, 0)                           AS open_tier_a_deals,
    COALESCE(ad.open_tier_b_deals, 0)                           AS open_tier_b_deals,
    COALESCE(ad.open_tier_c_deals, 0)                           AS open_tier_c_deals,

    -- Pipeline & revenue
    COALESCE(ad.open_pipeline_inr, 0)                           AS open_pipeline_inr,
    COALESCE(ad.won_revenue_ytd_inr, 0)                         AS won_revenue_ytd_inr,
    COALESCE(ad.won_revenue_qtd_inr, 0)                         AS won_revenue_qtd_inr,

    -- Quota attainment (this quarter)
    CASE WHEN r.quota_inr_quarterly > 0
         THEN ROUND(100.0 * COALESCE(ad.won_revenue_qtd_inr, 0) / r.quota_inr_quarterly, 1)
         ELSE NULL END                                          AS quota_attainment_qtd_pct,

    -- Conversion rates
    CASE WHEN COALESCE(ad.deals_won_ytd + ad.deals_lost_ytd, 0) > 0
         THEN ROUND(100.0 * ad.deals_won_ytd / (ad.deals_won_ytd + ad.deals_lost_ytd), 1)
         ELSE NULL END                                          AS win_rate_pct_ytd,

    ad.avg_cycle_days,

    -- Calendar fill rate (north-star metric — target 80%)
    COALESCE(acw.this_week_avg_daily_hours, 0)                  AS calendar_avg_daily_hours_this_week,
    COALESCE(ac4.avg_daily_hours_booked, 0)                     AS calendar_avg_daily_hours_4wk,
    CASE WHEN r.calendar_capacity_hours_per_week > 0
         THEN ROUND(100.0 * COALESCE(acw.this_week_avg_daily_hours, 0) * 5 / r.calendar_capacity_hours_per_week, 1)
         ELSE NULL END                                          AS calendar_fill_pct_this_week,
    CASE WHEN r.calendar_capacity_hours_per_week > 0
         THEN ROUND(100.0 * COALESCE(ac4.avg_daily_hours_booked, 0) * 5 / r.calendar_capacity_hours_per_week, 1)
         ELSE NULL END                                          AS calendar_fill_pct_4wk_avg,

    COALESCE(ac4.total_meetings_28d, 0)                         AS meetings_count_28d,
    COALESCE(adm.demos_booked_30d, 0)                           AS demos_booked_30d,

    -- Health flag
    CASE
        WHEN r.calendar_capacity_hours_per_week > 0
             AND COALESCE(acw.this_week_avg_daily_hours, 0) * 5 / r.calendar_capacity_hours_per_week < 0.50 THEN 'underutilized_alert'
        WHEN r.calendar_capacity_hours_per_week > 0
             AND COALESCE(acw.this_week_avg_daily_hours, 0) * 5 / r.calendar_capacity_hours_per_week > 1.10 THEN 'overloaded_alert'
        WHEN r.quota_inr_quarterly > 0
             AND COALESCE(ad.won_revenue_qtd_inr, 0) / r.quota_inr_quarterly < 0.40
             AND EXTRACT(MONTH FROM now()) % 3 = 0 THEN 'at_risk_quarter_close'
        ELSE 'normal'
    END                                                         AS health_flag,

    now()                                                       AS mart_refreshed_at

FROM ae_roster r
LEFT JOIN ae_deals               ad  ON ad.ae_email  = r.email
LEFT JOIN ae_calendar_4wk        ac4 ON ac4.ae_email = r.email
LEFT JOIN ae_calendar_this_week  acw ON acw.ae_email = r.email
LEFT JOIN ae_demos_30d           adm ON adm.ae_email = r.email
WHERE r.active = true;

CREATE UNIQUE INDEX idx_mart_ae_performance_email ON mart_ae_performance(ae_email);
CREATE INDEX idx_mart_ae_performance_health ON mart_ae_performance(health_flag);
CREATE INDEX idx_mart_ae_performance_quota ON mart_ae_performance(quota_attainment_qtd_pct);

-- =============================================
-- Common queries
-- =============================================

-- AE leaderboard (this quarter)
-- SELECT ae_name, won_revenue_qtd_inr, quota_attainment_qtd_pct, win_rate_pct_ytd, calendar_fill_pct_4wk_avg
-- FROM mart_ae_performance ORDER BY quota_attainment_qtd_pct DESC NULLS LAST;

-- AEs needing attention (underutilized OR at-risk)
-- SELECT ae_email, health_flag, calendar_fill_pct_this_week, quota_attainment_qtd_pct
-- FROM mart_ae_performance WHERE health_flag != 'normal';

-- Average calendar fill across all AEs (the org-wide north-star metric)
-- SELECT AVG(calendar_fill_pct_this_week) AS org_calendar_fill_pct FROM mart_ae_performance;
