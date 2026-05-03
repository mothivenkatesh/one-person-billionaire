-- mart_buyer_journey — the SPINE of all reporting (spec §8.3).
-- ONE row per opportunity (or qualified-lead-that-died) capturing every milestone, source, and amount.
-- All other marts join to this view.
--
-- Refresh: nightly via cron — REFRESH MATERIALIZED VIEW CONCURRENTLY mart_buyer_journey;

DROP MATERIALIZED VIEW IF EXISTS mart_buyer_journey;

CREATE MATERIALIZED VIEW mart_buyer_journey AS
WITH primary_contact AS (
    -- For each deal, find one primary contact (champion if exists, else first contact)
    SELECT DISTINCT ON (d.id)
        d.id AS deal_id,
        c.id AS contact_id,
        c.first_name || ' ' || c.last_name AS contact_name,
        c.persona_type
    FROM deals d
    LEFT JOIN contacts c ON c.account_id = d.account_id
    ORDER BY d.id, c.is_champion DESC NULLS LAST, c.last_engaged_at DESC NULLS LAST
),
deal_touches AS (
    -- Aggregate all interactions per deal as a JSON array
    SELECT
        deal_id,
        COUNT(*) AS touch_count,
        jsonb_agg(
            jsonb_build_object(
                'channel', channel,
                'touch_type', touch_type,
                'campaign_din', campaign_din,
                'source_agent', source_agent,
                'recorded_at', recorded_at
            ) ORDER BY recorded_at
        ) AS influencing_touches
    FROM interactions
    WHERE deal_id IS NOT NULL
    GROUP BY deal_id
),
first_last AS (
    -- First and last touch channel attribution
    SELECT
        deal_id,
        (array_agg(channel ORDER BY recorded_at ASC))[1] AS first_touch_channel,
        (array_agg(channel ORDER BY recorded_at DESC))[1] AS last_touch_channel
    FROM interactions
    WHERE deal_id IS NOT NULL
    GROUP BY deal_id
)
SELECT
    -- Identity
    gen_random_uuid()                       AS journey_id,
    d.id                                    AS deal_id,
    d.account_id,
    a.name                                  AS account_name,
    pc.contact_name,
    pc.persona_type,

    -- Motion + source + campaign
    d.gtm_motion,
    d.source,
    d.campaign_din                          AS campaign,

    -- Milestone dates (the CS2-framework canonical sequence)
    d.lead_created_date,
    d.mql_at                                AS mql_date,
    d.sql_at                                AS sql_date,
    d.sales_ready_at                        AS sales_ready_date,
    d.working_at                            AS working_date,
    d.meeting_booked_at                     AS meeting_booked_date,
    d.pipeline_at                           AS pipeline_opportunity_date,

    -- Opportunity metadata
    d.opportunity_type,
    d.amount                                AS opportunity_amount,
    d.stage                                 AS current_stage,

    -- Outcome
    d.closed_won_at                         AS closed_won_date,
    d.closed_lost_at                        AS closed_lost_date,
    d.lost_reason                           AS closed_lost_reason,
    d.recycled_to_nurture_at,

    -- Tier + vertical (from account)
    a.tier,
    a.vertical,
    a.icp_score,
    a.engagement_score,

    -- Owner
    d.owner_email,

    -- Touch attribution
    COALESCE(dt.touch_count, 0)             AS touch_count,
    COALESCE(dt.influencing_touches, '[]'::jsonb) AS influencing_touches,
    fl.first_touch_channel                  AS first_touch_attribution,
    fl.last_touch_channel                   AS last_touch_attribution,

    -- Derived metrics
    CASE
        WHEN d.closed_won_at IS NOT NULL THEN EXTRACT(DAY FROM d.closed_won_at - d.lead_created_date)
        WHEN d.closed_lost_at IS NOT NULL THEN EXTRACT(DAY FROM d.closed_lost_at - d.lead_created_date)
        ELSE EXTRACT(DAY FROM now() - d.lead_created_date)
    END                                     AS cycle_days,

    CASE
        WHEN d.closed_won_at IS NOT NULL THEN 'won'
        WHEN d.closed_lost_at IS NOT NULL THEN 'lost'
        WHEN d.recycled_to_nurture_at IS NOT NULL THEN 'recycled'
        ELSE 'open'
    END                                     AS outcome,

    -- Refresh metadata
    now()                                   AS mart_refreshed_at

FROM deals d
JOIN accounts a ON a.id = d.account_id
LEFT JOIN primary_contact pc ON pc.deal_id = d.id
LEFT JOIN deal_touches dt ON dt.deal_id = d.id
LEFT JOIN first_last fl ON fl.deal_id = d.id;

-- Unique index for CONCURRENTLY refresh
CREATE UNIQUE INDEX idx_mart_buyer_journey_deal ON mart_buyer_journey(deal_id);

-- Common query indexes
CREATE INDEX idx_mart_buyer_journey_account ON mart_buyer_journey(account_id);
CREATE INDEX idx_mart_buyer_journey_outcome ON mart_buyer_journey(outcome);
CREATE INDEX idx_mart_buyer_journey_motion ON mart_buyer_journey(gtm_motion);
CREATE INDEX idx_mart_buyer_journey_tier_vertical ON mart_buyer_journey(tier, vertical);
CREATE INDEX idx_mart_buyer_journey_owner ON mart_buyer_journey(owner_email);
CREATE INDEX idx_mart_buyer_journey_source ON mart_buyer_journey(source);

-- =============================================
-- Example queries this view answers in one statement
-- =============================================

-- Q: Cost-per-closed-won by source?
-- SELECT source, COUNT(*) AS won_deals, AVG(opportunity_amount) AS avg_acv,
--        AVG(cycle_days) AS avg_cycle FROM mart_buyer_journey
-- WHERE outcome = 'won' GROUP BY source ORDER BY won_deals DESC;

-- Q: Median cycle days by tier × vertical?
-- SELECT tier, vertical, percentile_cont(0.5) WITHIN GROUP (ORDER BY cycle_days) AS median_cycle
-- FROM mart_buyer_journey WHERE outcome IN ('won','lost') GROUP BY tier, vertical;

-- Q: Which DINs influenced the most pipeline?
-- SELECT t.value->>'campaign_din' AS din, COUNT(DISTINCT m.deal_id) AS deals,
--        SUM(m.opportunity_amount) FILTER (WHERE m.outcome = 'won') AS won_revenue
-- FROM mart_buyer_journey m, jsonb_array_elements(m.influencing_touches) t
-- WHERE t.value->>'campaign_din' IS NOT NULL GROUP BY din ORDER BY deals DESC;

-- Q: Recycled-to-revived conversion rate?
-- SELECT COUNT(*) FILTER (WHERE recycled_to_nurture_at IS NOT NULL) AS recycled,
--        COUNT(*) FILTER (WHERE recycled_to_nurture_at IS NOT NULL AND mql_date > recycled_to_nurture_at) AS revived
-- FROM mart_buyer_journey;
