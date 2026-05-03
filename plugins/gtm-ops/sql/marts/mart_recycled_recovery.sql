-- mart_recycled_recovery — recycled-to-revived conversion rates by tier × vertical × recycle reason.
-- Tracks how often dead leads come back to life. Critical for tuning the Dormant-Detector +
-- understanding which "no" really means "not yet."
--
-- Refresh: weekly on Sunday night (slow-moving metric).

DROP MATERIALIZED VIEW IF EXISTS mart_recycled_recovery;

CREATE MATERIALIZED VIEW mart_recycled_recovery AS
WITH recycled_journeys AS (
    -- All journeys that hit a recycle event (via mart_buyer_journey.recycled_to_nurture_at)
    SELECT
        deal_id,
        account_id,
        tier,
        vertical,
        gtm_motion,
        source                                                  AS original_source,
        opportunity_amount,
        recycled_to_nurture_at                                  AS recycled_at,
        closed_lost_reason,
        closed_won_date,
        closed_lost_date,
        outcome,
        cycle_days
    FROM mart_buyer_journey
    WHERE recycled_to_nurture_at IS NOT NULL
),
recycle_reason_normalized AS (
    -- Group recycle reasons (extracted from closed_lost_reason text via simple regex/heuristic)
    SELECT
        rj.*,
        CASE
            WHEN closed_lost_reason ILIKE '%pric%' OR closed_lost_reason ILIKE '%cost%' OR closed_lost_reason ILIKE '%budget%' THEN 'pricing'
            WHEN closed_lost_reason ILIKE '%timing%' OR closed_lost_reason ILIKE '%not ready%' OR closed_lost_reason ILIKE '%freeze%' THEN 'timing'
            WHEN closed_lost_reason ILIKE '%competitor%' OR closed_lost_reason ILIKE '%razorpay%' OR closed_lost_reason ILIKE '%payu%' OR closed_lost_reason ILIKE '%stripe%' THEN 'competitor_chosen'
            WHEN closed_lost_reason ILIKE '%capability%' OR closed_lost_reason ILIKE '%feature%' OR closed_lost_reason ILIKE '%missing%' THEN 'capability_gap'
            WHEN closed_lost_reason ILIKE '%integration%' OR closed_lost_reason ILIKE '%migration%' THEN 'integration_complexity'
            WHEN closed_lost_reason ILIKE '%compliance%' OR closed_lost_reason ILIKE '%dpdp%' OR closed_lost_reason ILIKE '%rbi%' OR closed_lost_reason ILIKE '%pci%' THEN 'compliance'
            WHEN closed_lost_reason ILIKE '%champion%' OR closed_lost_reason ILIKE '%left%' THEN 'champion_left'
            WHEN closed_lost_reason ILIKE '%budget cut%' OR closed_lost_reason ILIKE '%layoff%' OR closed_lost_reason ILIKE '%restructur%' THEN 'business_change'
            WHEN closed_lost_reason IS NULL OR closed_lost_reason = '' THEN 'unspecified'
            ELSE 'other'
        END                                                     AS recycle_reason_normalized
    FROM recycled_journeys rj
),
recycle_outcomes AS (
    -- For each recycled journey, did the same account come back as a new MQL/SQL/Won deal afterwards?
    SELECT
        rrn.*,
        EXISTS (
            SELECT 1 FROM mart_buyer_journey m2
            WHERE m2.account_id = rrn.account_id
              AND m2.deal_id != rrn.deal_id
              AND m2.lead_created_date > rrn.recycled_at
              AND m2.mql_date IS NOT NULL
        )                                                       AS account_revived_to_mql,
        EXISTS (
            SELECT 1 FROM mart_buyer_journey m2
            WHERE m2.account_id = rrn.account_id
              AND m2.deal_id != rrn.deal_id
              AND m2.lead_created_date > rrn.recycled_at
              AND m2.outcome = 'won'
        )                                                       AS account_revived_to_won,
        (SELECT MIN(m2.lead_created_date) FROM mart_buyer_journey m2
         WHERE m2.account_id = rrn.account_id
           AND m2.deal_id != rrn.deal_id
           AND m2.lead_created_date > rrn.recycled_at)          AS first_revival_lead_date,
        (SELECT MAX(m2.opportunity_amount) FROM mart_buyer_journey m2
         WHERE m2.account_id = rrn.account_id
           AND m2.deal_id != rrn.deal_id
           AND m2.lead_created_date > rrn.recycled_at
           AND m2.outcome = 'won')                              AS revival_won_amount_inr
    FROM recycle_reason_normalized rrn
)

SELECT
    tier,
    vertical,
    recycle_reason_normalized                                   AS recycle_reason,

    COUNT(*)                                                    AS recycled_count,
    COUNT(*) FILTER (WHERE account_revived_to_mql)              AS revived_to_mql_count,
    COUNT(*) FILTER (WHERE account_revived_to_won)              AS revived_to_won_count,

    -- Conversion rates
    ROUND(100.0 * COUNT(*) FILTER (WHERE account_revived_to_mql) / NULLIF(COUNT(*), 0), 1) AS revival_to_mql_rate_pct,
    ROUND(100.0 * COUNT(*) FILTER (WHERE account_revived_to_won) / NULLIF(COUNT(*), 0), 1) AS revival_to_won_rate_pct,

    -- Average revival lag (days from recycle to revival)
    AVG(EXTRACT(DAY FROM first_revival_lead_date - recycled_at))::INT AS avg_revival_lag_days,

    -- Recovered revenue vs original lost amount
    SUM(opportunity_amount)                                     AS originally_lost_pipeline_inr,
    SUM(revival_won_amount_inr)                                 AS recovered_won_revenue_inr,
    CASE WHEN SUM(opportunity_amount) > 0
         THEN ROUND(100.0 * SUM(COALESCE(revival_won_amount_inr, 0)) / SUM(opportunity_amount), 1)
         ELSE NULL END                                          AS recovery_value_pct,

    now()                                                       AS mart_refreshed_at

FROM recycle_outcomes
GROUP BY tier, vertical, recycle_reason_normalized;

-- Composite key for CONCURRENTLY refresh
CREATE UNIQUE INDEX idx_mart_recycled_recovery_key ON mart_recycled_recovery(tier, vertical, recycle_reason);
CREATE INDEX idx_mart_recycled_recovery_rate ON mart_recycled_recovery(revival_to_won_rate_pct DESC);

-- =============================================
-- Common queries
-- =============================================

-- Best-revival cohorts (where re-engagement ROI is highest)
-- SELECT tier, vertical, recycle_reason, recycled_count, revival_to_won_rate_pct, recovery_value_pct
-- FROM mart_recycled_recovery WHERE recycled_count >= 5 ORDER BY recovery_value_pct DESC NULLS LAST LIMIT 10;

-- Worst-revival cohorts (don't re-engage these — low ROI)
-- SELECT tier, vertical, recycle_reason, recycled_count, revival_to_won_rate_pct
-- FROM mart_recycled_recovery WHERE recycled_count >= 5 ORDER BY revival_to_won_rate_pct ASC LIMIT 10;

-- Total recovered revenue this year (the headline number)
-- SELECT SUM(recovered_won_revenue_inr) AS total_recovered_inr FROM mart_recycled_recovery;
