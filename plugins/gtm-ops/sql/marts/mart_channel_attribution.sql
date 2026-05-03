-- mart_channel_attribution — channel-level rollup of touches → opportunities → revenue.
-- Powers the weekly digest's Channel Performance section (spec §8.3 Section B).
--
-- Three attribution lenses captured side-by-side:
--   - first_touch: count revenue against the channel that originated the lead
--   - last_touch: count against the channel of the touch right before close
--   - influenced: count if the channel appeared anywhere in the touch chain (multi-touch)
--
-- Refresh: nightly.

DROP MATERIALIZED VIEW IF EXISTS mart_channel_attribution;

CREATE MATERIALIZED VIEW mart_channel_attribution AS
WITH all_channels AS (
    SELECT DISTINCT channel FROM interactions WHERE channel IS NOT NULL
    UNION
    SELECT 'cold_email' UNION SELECT 'linkedin_inmail' UNION SELECT 'linkedin_ads'
    UNION SELECT 'meta_ads' UNION SELECT 'google_ads' UNION SELECT 'webinar'
    UNION SELECT 'content_inbound' UNION SELECT 'partner' UNION SELECT 'wtfraud_community'
    UNION SELECT 'ae_outbound_manual' UNION SELECT 'csm_outreach' UNION SELECT 'moengage_lifecycle'
),
channel_touches AS (
    -- Raw touch counts per channel
    SELECT
        channel,
        COUNT(*)                                                AS touches,
        COUNT(DISTINCT account_id)                              AS unique_accounts_touched,
        COUNT(DISTINCT deal_id)                                 AS unique_deals_touched,
        COUNT(*) FILTER (WHERE touch_type = 'open')             AS opens,
        COUNT(*) FILTER (WHERE touch_type = 'click')            AS clicks,
        COUNT(*) FILTER (WHERE touch_type = 'reply')            AS replies,
        COUNT(*) FILTER (WHERE touch_type = 'meeting')          AS meetings,
        COUNT(*) FILTER (WHERE touch_type = 'demo')             AS demos
    FROM interactions
    WHERE recorded_at >= now() - interval '90 days'
    GROUP BY channel
),
channel_first_touch AS (
    -- Revenue attribution: first-touch model
    SELECT
        first_touch_attribution                                 AS channel,
        COUNT(*) FILTER (WHERE outcome = 'won')                 AS deals_won_first_touch,
        COUNT(*) FILTER (WHERE outcome = 'lost')                AS deals_lost_first_touch,
        SUM(opportunity_amount) FILTER (WHERE outcome = 'won')  AS won_revenue_first_touch_inr,
        SUM(opportunity_amount) FILTER (WHERE outcome = 'open') AS open_pipeline_first_touch_inr,
        AVG(cycle_days) FILTER (WHERE outcome IN ('won', 'lost')) AS avg_cycle_days_first_touch
    FROM mart_buyer_journey
    WHERE first_touch_attribution IS NOT NULL
    GROUP BY first_touch_attribution
),
channel_last_touch AS (
    -- Revenue attribution: last-touch model
    SELECT
        last_touch_attribution                                  AS channel,
        COUNT(*) FILTER (WHERE outcome = 'won')                 AS deals_won_last_touch,
        SUM(opportunity_amount) FILTER (WHERE outcome = 'won')  AS won_revenue_last_touch_inr
    FROM mart_buyer_journey
    WHERE last_touch_attribution IS NOT NULL
    GROUP BY last_touch_attribution
),
channel_influenced AS (
    -- Revenue attribution: multi-touch (channel appeared anywhere in influencing_touches)
    SELECT
        t.value->>'channel'                                     AS channel,
        COUNT(DISTINCT m.deal_id) FILTER (WHERE m.outcome = 'won') AS deals_won_influenced,
        SUM(m.opportunity_amount) FILTER (WHERE m.outcome = 'won') AS won_revenue_influenced_inr
    FROM mart_buyer_journey m,
         LATERAL jsonb_array_elements(m.influencing_touches) t
    WHERE t.value->>'channel' IS NOT NULL
    GROUP BY t.value->>'channel'
)
SELECT
    ac.channel,

    -- Raw touch metrics
    COALESCE(ct.touches, 0)                                     AS touches,
    COALESCE(ct.unique_accounts_touched, 0)                     AS unique_accounts,
    COALESCE(ct.unique_deals_touched, 0)                        AS unique_deals,
    COALESCE(ct.opens, 0)                                       AS opens,
    COALESCE(ct.clicks, 0)                                      AS clicks,
    COALESCE(ct.replies, 0)                                     AS replies,
    COALESCE(ct.meetings, 0)                                    AS meetings,
    COALESCE(ct.demos, 0)                                       AS demos,

    -- First-touch attribution
    COALESCE(cft.deals_won_first_touch, 0)                      AS deals_won_first_touch,
    COALESCE(cft.deals_lost_first_touch, 0)                     AS deals_lost_first_touch,
    COALESCE(cft.won_revenue_first_touch_inr, 0)                AS won_revenue_first_touch_inr,
    COALESCE(cft.open_pipeline_first_touch_inr, 0)              AS open_pipeline_first_touch_inr,
    cft.avg_cycle_days_first_touch,

    -- Last-touch attribution
    COALESCE(clt.deals_won_last_touch, 0)                       AS deals_won_last_touch,
    COALESCE(clt.won_revenue_last_touch_inr, 0)                 AS won_revenue_last_touch_inr,

    -- Multi-touch (influenced)
    COALESCE(cinf.deals_won_influenced, 0)                      AS deals_won_influenced,
    COALESCE(cinf.won_revenue_influenced_inr, 0)                AS won_revenue_influenced_inr,

    -- Derived rates (using touches as denominator)
    CASE WHEN ct.touches > 0 THEN ROUND(100.0 * ct.replies / ct.touches, 2) ELSE NULL END  AS reply_rate_pct,
    CASE WHEN ct.touches > 0 THEN ROUND(100.0 * ct.demos / ct.touches, 2) ELSE NULL END    AS touch_to_demo_rate_pct,
    CASE WHEN cft.deals_won_first_touch + cft.deals_lost_first_touch > 0
         THEN ROUND(100.0 * cft.deals_won_first_touch / (cft.deals_won_first_touch + cft.deals_lost_first_touch), 1)
         ELSE NULL END                                          AS first_touch_win_rate_pct,

    -- Channel category for grouping in dashboards
    CASE
        WHEN ac.channel IN ('cold_email', 'ae_outbound_manual', 'linkedin_inmail') THEN 'outbound'
        WHEN ac.channel IN ('linkedin_ads', 'meta_ads', 'google_ads') THEN 'paid_ads'
        WHEN ac.channel IN ('webinar', 'content_inbound') THEN 'inbound'
        WHEN ac.channel IN ('partner', 'wtfraud_community') THEN 'community_partner'
        WHEN ac.channel IN ('csm_outreach', 'moengage_lifecycle') THEN 'lifecycle'
        ELSE 'other'
    END                                                         AS channel_category,

    now()                                                       AS mart_refreshed_at

FROM all_channels ac
LEFT JOIN channel_touches      ct  ON ct.channel  = ac.channel
LEFT JOIN channel_first_touch  cft ON cft.channel = ac.channel
LEFT JOIN channel_last_touch   clt ON clt.channel = ac.channel
LEFT JOIN channel_influenced   cinf ON cinf.channel = ac.channel;

CREATE UNIQUE INDEX idx_mart_channel_attribution_channel ON mart_channel_attribution(channel);
CREATE INDEX idx_mart_channel_attribution_category ON mart_channel_attribution(channel_category);

-- =============================================
-- Common queries
-- =============================================

-- Channel performance leaderboard (last 90d) — sort by influenced revenue
-- SELECT channel, channel_category, touches, replies, demos, deals_won_first_touch,
--        won_revenue_first_touch_inr, won_revenue_influenced_inr, reply_rate_pct, first_touch_win_rate_pct
-- FROM mart_channel_attribution ORDER BY won_revenue_influenced_inr DESC NULLS LAST;

-- Inbound vs outbound vs community contribution
-- SELECT channel_category, SUM(won_revenue_first_touch_inr) AS won_first_touch,
--        SUM(won_revenue_influenced_inr) AS won_influenced
-- FROM mart_channel_attribution GROUP BY channel_category;
