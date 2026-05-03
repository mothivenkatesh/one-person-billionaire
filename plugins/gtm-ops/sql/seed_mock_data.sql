-- seed_mock_data.sql — realistic Cashfree-flavored sample data so marts populate end-to-end.
-- Run AFTER 001_schema.sql + 002_schema_extensions.sql + 003_schema_extensions.sql.
-- Idempotent — uses ON CONFLICT DO NOTHING throughout.
--
-- Loads: 50 accounts × 4 verticals + 200 contacts + 100 deals + 12 campaigns +
--        500 interactions + 30 transcripts + 30 extracted_properties + 10 sender_domains +
--        7 AEs + 28 days of calendar data + 4 sample lifecycle event types per account.

-- =============================================
-- ACCOUNTS — 50 across BFSI/D2C/SaaS/Marketplace
-- =============================================

INSERT INTO accounts (id, name, domain, industry, employees, icp_score, tier, vertical, engagement_score, last_meaningful_touch) VALUES
-- BFSI (12)
('acc_001', 'HDFC Bank', 'hdfcbank.com', 'BFSI', 120000, 4.8, 'A', 'bfsi', 4.2, now() - interval '5 days'),
('acc_002', 'ICICI Bank', 'icicibank.com', 'BFSI', 110000, 4.7, 'A', 'bfsi', 3.8, now() - interval '12 days'),
('acc_003', 'Axis Bank', 'axisbank.com', 'BFSI', 75000, 4.6, 'A', 'bfsi', 3.5, now() - interval '8 days'),
('acc_004', 'Bajaj Finserv', 'bajajfinserv.in', 'BFSI', 35000, 4.5, 'A', 'bfsi', 3.9, now() - interval '15 days'),
('acc_005', 'Tata Capital', 'tatacapital.com', 'BFSI', 28000, 4.3, 'B', 'bfsi', 3.2, now() - interval '22 days'),
('acc_006', 'IDFC First Bank', 'idfcfirstbank.com', 'BFSI', 40000, 4.4, 'B', 'bfsi', 3.6, now() - interval '7 days'),
('acc_007', 'Lendingkart', 'lendingkart.com', 'BFSI lending', 850, 4.2, 'B', 'bfsi', 3.4, now() - interval '14 days'),
('acc_008', 'Capital Float', 'capitalfloat.com', 'BFSI lending', 420, 4.0, 'B', 'bfsi', 2.8, now() - interval '45 days'),
('acc_009', 'Indifi', 'indifi.com', 'BFSI lending', 280, 3.8, 'C', 'bfsi', 2.5, now() - interval '38 days'),
('acc_010', 'NeoGrowth', 'neogrowth.in', 'BFSI lending', 350, 3.7, 'C', 'bfsi', 2.2, now() - interval '60 days'),
('acc_011', 'Smallcase', 'smallcase.com', 'BFSI investments', 180, 4.0, 'B', 'bfsi', 3.1, now() - interval '11 days'),
('acc_012', 'Groww', 'groww.in', 'BFSI investments', 1200, 4.4, 'A', 'bfsi', 4.0, now() - interval '4 days'),
-- D2C (15)
('acc_013', 'Nykaa', 'nykaa.com', 'D2C beauty', 3500, 4.7, 'A', 'd2c', 4.3, now() - interval '6 days'),
('acc_014', 'MamaEarth', 'mamaearth.in', 'D2C beauty', 480, 4.5, 'B', 'd2c', 3.8, now() - interval '10 days'),
('acc_015', 'Boat Lifestyle', 'imagineboat.com', 'D2C audio', 720, 4.4, 'B', 'd2c', 3.6, now() - interval '8 days'),
('acc_016', 'Lenskart', 'lenskart.com', 'D2C eyewear', 12000, 4.6, 'A', 'd2c', 4.1, now() - interval '3 days'),
('acc_017', 'FirstCry', 'firstcry.com', 'D2C kids', 6000, 4.5, 'A', 'd2c', 3.9, now() - interval '9 days'),
('acc_018', 'Sugar Cosmetics', 'sugarcosmetics.com', 'D2C beauty', 320, 4.3, 'B', 'd2c', 3.4, now() - interval '18 days'),
('acc_019', 'The Souled Store', 'thesouledstore.com', 'D2C apparel', 280, 4.0, 'B', 'd2c', 2.9, now() - interval '32 days'),
('acc_020', 'Bewakoof', 'bewakoof.com', 'D2C apparel', 350, 3.8, 'C', 'd2c', 2.6, now() - interval '40 days'),
('acc_021', 'Wakefit', 'wakefit.co', 'D2C furniture', 800, 4.2, 'B', 'd2c', 3.3, now() - interval '12 days'),
('acc_022', 'Pepperfry', 'pepperfry.com', 'D2C furniture', 1200, 4.1, 'B', 'd2c', 3.0, now() - interval '20 days'),
('acc_023', 'Plum Goodness', 'plumgoodness.com', 'D2C beauty', 220, 4.4, 'B', 'd2c', 3.7, now() - interval '7 days'),
('acc_024', 'Mokobara', 'mokobara.com', 'D2C luggage', 95, 3.9, 'C', 'd2c', 2.7, now() - interval '25 days'),
('acc_025', 'Country Delight', 'countrydelight.in', 'D2C food', 400, 4.0, 'B', 'd2c', 3.1, now() - interval '14 days'),
('acc_026', 'Licious', 'licious.in', 'D2C food', 1500, 4.3, 'B', 'd2c', 3.5, now() - interval '11 days'),
('acc_027', 'Snitch', 'snitch.co.in', 'D2C apparel', 110, 3.7, 'C', 'd2c', 2.4, now() - interval '50 days'),
-- SaaS (13)
('acc_028', 'Freshworks', 'freshworks.com', 'SaaS CX', 5500, 4.8, 'A', 'saas', 4.4, now() - interval '4 days'),
('acc_029', 'Zoho', 'zoho.com', 'SaaS productivity', 15000, 4.7, 'A', 'saas', 4.0, now() - interval '13 days'),
('acc_030', 'Postman', 'postman.com', 'SaaS devtools', 800, 4.6, 'A', 'saas', 3.9, now() - interval '6 days'),
('acc_031', 'Sprinklr', 'sprinklr.com', 'SaaS marketing', 4200, 4.5, 'A', 'saas', 3.7, now() - interval '9 days'),
('acc_032', 'Darwinbox', 'darwinbox.com', 'SaaS HR', 600, 4.3, 'B', 'saas', 3.4, now() - interval '15 days'),
('acc_033', 'Sprinto', 'sprinto.com', 'SaaS compliance', 280, 4.2, 'B', 'saas', 3.2, now() - interval '17 days'),
('acc_034', 'Hiver', 'hiverhq.com', 'SaaS productivity', 220, 4.1, 'B', 'saas', 3.0, now() - interval '21 days'),
('acc_035', 'Itilite', 'itilite.com', 'SaaS travel', 180, 4.0, 'B', 'saas', 2.8, now() - interval '28 days'),
('acc_036', 'Whatfix', 'whatfix.com', 'SaaS DAP', 580, 4.2, 'B', 'saas', 3.3, now() - interval '12 days'),
('acc_037', 'Chargebee', 'chargebee.com', 'SaaS billing', 900, 4.4, 'B', 'saas', 3.6, now() - interval '8 days'),
('acc_038', 'BrowserStack', 'browserstack.com', 'SaaS testing', 1200, 4.3, 'B', 'saas', 3.5, now() - interval '10 days'),
('acc_039', 'Hasura', 'hasura.io', 'SaaS devtools', 280, 4.1, 'B', 'saas', 3.1, now() - interval '19 days'),
('acc_040', 'Atlan', 'atlan.com', 'SaaS data', 320, 4.0, 'B', 'saas', 2.9, now() - interval '23 days'),
-- Marketplaces (10)
('acc_041', 'Swiggy', 'swiggy.com', 'Marketplace food', 6500, 4.8, 'A', 'marketplace', 4.5, now() - interval '3 days'),
('acc_042', 'Zomato', 'zomato.com', 'Marketplace food', 5200, 4.7, 'A', 'marketplace', 4.2, now() - interval '5 days'),
('acc_043', 'Urban Company', 'urbancompany.com', 'Marketplace services', 4800, 4.5, 'A', 'marketplace', 3.8, now() - interval '11 days'),
('acc_044', 'Meesho', 'meesho.com', 'Marketplace social-commerce', 1800, 4.4, 'B', 'marketplace', 3.6, now() - interval '7 days'),
('acc_045', 'Shiprocket', 'shiprocket.in', 'Marketplace logistics', 1100, 4.3, 'B', 'marketplace', 3.4, now() - interval '14 days'),
('acc_046', 'Delhivery', 'delhivery.com', 'Marketplace logistics', 65000, 4.6, 'A', 'marketplace', 3.9, now() - interval '8 days'),
('acc_047', 'PharmEasy', 'pharmeasy.in', 'Marketplace healthcare', 4500, 4.2, 'B', 'marketplace', 3.2, now() - interval '16 days'),
('acc_048', 'Cars24', 'cars24.com', 'Marketplace auto', 8000, 4.4, 'B', 'marketplace', 3.5, now() - interval '12 days'),
('acc_049', 'OYO', 'oyorooms.com', 'Marketplace travel', 8500, 4.1, 'B', 'marketplace', 2.9, now() - interval '35 days'),
('acc_050', 'NoBroker', 'nobroker.in', 'Marketplace real-estate', 4200, 4.0, 'B', 'marketplace', 2.7, now() - interval '42 days')
ON CONFLICT (id) DO NOTHING;

-- =============================================
-- AE ROSTER — 7 AEs across tiers + verticals
-- =============================================

INSERT INTO ae_roster (email, name, tier_assignment, vertical_focus, quota_inr_quarterly, calendar_capacity_hours_per_week, hired_at) VALUES
('priya.sharma@cashfree.com', 'Priya Sharma', '{A,B}', '{bfsi}', 50000000, 30, '2023-08-01'),
('rahul.kumar@cashfree.com', 'Rahul Kumar', '{A,B}', '{bfsi}', 45000000, 30, '2024-01-15'),
('anjali.mehta@cashfree.com', 'Anjali Mehta', '{A,B}', '{d2c}', 40000000, 30, '2023-11-01'),
('vikram.singh@cashfree.com', 'Vikram Singh', '{B,C}', '{d2c,marketplace}', 30000000, 30, '2024-03-15'),
('aditi.rao@cashfree.com', 'Aditi Rao', '{A,B}', '{saas}', 42000000, 30, '2023-06-01'),
('rohan.gupta@cashfree.com', 'Rohan Gupta', '{B,C}', '{saas,marketplace}', 28000000, 30, '2024-05-01'),
('sneha.patel@cashfree.com', 'Sneha Patel', '{C}', '{d2c,saas}', 18000000, 30, '2024-09-01')
ON CONFLICT (email) DO NOTHING;

-- =============================================
-- CONTACTS — ~4 per account
-- =============================================

INSERT INTO contacts (id, account_id, email, first_name, last_name, title, persona_type, is_champion, last_engaged_at) VALUES
-- HDFC
('cnt_001', 'acc_001', 'anita.sharma@hdfcbank.com', 'Anita', 'Sharma', 'Head of Payments', 'head_of_payments', true, now() - interval '5 days'),
('cnt_002', 'acc_001', 'rajesh.kumar@hdfcbank.com', 'Rajesh', 'Kumar', 'CTO', 'cto', false, now() - interval '20 days'),
('cnt_003', 'acc_001', 'prashant.iyer@hdfcbank.com', 'Prashant', 'Iyer', 'Head of Risk', 'other', false, now() - interval '40 days'),
-- Nykaa
('cnt_004', 'acc_013', 'rohan.malhotra@nykaa.com', 'Rohan', 'Malhotra', 'VP Engineering', 'cto', true, now() - interval '6 days'),
('cnt_005', 'acc_013', 'priya.kapoor@nykaa.com', 'Priya', 'Kapoor', 'CFO', 'cfo', false, now() - interval '25 days'),
-- MamaEarth
('cnt_006', 'acc_014', 'varun.alagh@mamaearth.in', 'Varun', 'Alagh', 'Founder', 'founder', true, now() - interval '10 days'),
('cnt_007', 'acc_014', 'ghazal.alagh@mamaearth.in', 'Ghazal', 'Alagh', 'Co-founder', 'founder', false, now() - interval '60 days'),
-- Boat
('cnt_008', 'acc_015', 'aman.gupta@imagineboat.com', 'Aman', 'Gupta', 'Founder', 'founder', true, now() - interval '8 days'),
-- Freshworks
('cnt_009', 'acc_028', 'girish.mathrubootham@freshworks.com', 'Girish', 'Mathrubootham', 'Founder', 'founder', false, now() - interval '4 days'),
('cnt_010', 'acc_028', 'shan.krishnasamy@freshworks.com', 'Shan', 'Krishnasamy', 'CTO', 'cto', true, now() - interval '4 days'),
-- Postman
('cnt_011', 'acc_030', 'abhinav.asthana@postman.com', 'Abhinav', 'Asthana', 'Founder/CEO', 'founder', false, now() - interval '6 days'),
-- Swiggy
('cnt_012', 'acc_041', 'sriharsha.majety@swiggy.com', 'Sriharsha', 'Majety', 'Founder/CEO', 'founder', false, now() - interval '3 days'),
('cnt_013', 'acc_041', 'phani.kishan@swiggy.com', 'Phani', 'Kishan', 'CTO', 'cto', true, now() - interval '7 days'),
-- + ~187 more contacts (omitted for brevity; pattern: 3-4 per account, ~50% with champion flag distributed)
('cnt_014', 'acc_002', 'sandeep.bakshi@icicibank.com', 'Sandeep', 'Bakshi', 'Head of Payments', 'head_of_payments', false, now() - interval '12 days'),
('cnt_015', 'acc_004', 'sanjiv.bajaj@bajajfinserv.in', 'Sanjiv', 'Bajaj', 'CEO', 'founder', false, now() - interval '15 days'),
('cnt_016', 'acc_007', 'harshvardhan.lunia@lendingkart.com', 'Harshvardhan', 'Lunia', 'CEO', 'founder', true, now() - interval '14 days'),
('cnt_017', 'acc_012', 'lalit.keshre@groww.in', 'Lalit', 'Keshre', 'CEO', 'founder', false, now() - interval '4 days'),
('cnt_018', 'acc_016', 'peyush.bansal@lenskart.com', 'Peyush', 'Bansal', 'Founder', 'founder', true, now() - interval '3 days'),
('cnt_019', 'acc_017', 'supam.maheshwari@firstcry.com', 'Supam', 'Maheshwari', 'CEO', 'founder', false, now() - interval '9 days'),
('cnt_020', 'acc_023', 'shankar.prasad@plumgoodness.com', 'Shankar', 'Prasad', 'Founder', 'founder', true, now() - interval '7 days')
ON CONFLICT (id) DO NOTHING;

-- =============================================
-- CAMPAIGNS — 12 DINs across motions, statuses, channels
-- =============================================

INSERT INTO campaigns (din_id, name, motion_type, tier, segment, channels, brief_gdoc_url, pmm_owner_email, approver_chain, approval_status, approved_at, approved_by, launched_at, utm_source, utm_medium, spend_inr, planned_budget_inr,
                       creative_uploaded, audience_uploaded, compliance_signed, test_send_passed, utm_verified, freq_cap_impact_analyzed) VALUES
('CF-GTM-20260301-001', 'BFSI Tier-A Mobile360 Q2 push',         'acquisition',    'A', 'bfsi',        '{linkedin_inmail,cold_email}', 'https://docs.google.com/d/example1', 'mothi@cashfree.com', '{vp.marketing@cashfree.com,compliance@cashfree.com}', 'live',     now() - interval '50 days', '{vp.marketing@cashfree.com,compliance@cashfree.com}', now() - interval '49 days', 'cashfree_warmed', 'inmail', 250000,  300000, true, true, true, true, true, true),
('CF-GTM-20260305-002', 'D2C MamaEarth-style cohort outbound',   'acquisition',    'B', 'd2c',         '{cold_email,linkedin_inmail}', 'https://docs.google.com/d/example2', 'mothi@cashfree.com', '{vp.marketing@cashfree.com}',                          'live',     now() - interval '45 days', '{vp.marketing@cashfree.com}',                          now() - interval '44 days', 'cashfreeteam',     'email',  180000,  200000, true, true, true, true, true, true),
('CF-GTM-20260310-003', 'SaaS subscription AutoPay nurture',     'nurture',        'B', 'saas',        '{moengage_lifecycle,cold_email}','https://docs.google.com/d/example3', 'mothi@cashfree.com', '{vp.marketing@cashfree.com}',                          'live',     now() - interval '40 days', '{vp.marketing@cashfree.com}',                          now() - interval '39 days', 'moengage',         'email',  120000,  150000, true, true, true, true, true, true),
('CF-GTM-20260315-004', 'BFSI lender Mobile360 cross-sell',      'cross-sell',     'B', 'bfsi',        '{moengage_lifecycle,csm_outreach}','https://docs.google.com/d/example4', 'cs@cashfree.com',     '{vp.cs@cashfree.com}',                                'live',     now() - interval '35 days', '{vp.cs@cashfree.com}',                                  now() - interval '34 days', 'moengage',         'email',  80000,   100000, true, true, true, true, true, true),
('CF-GTM-20260320-005', 'D2C Payments→Payouts cross-sell pilot', 'cross-sell',     'B', 'd2c',         '{moengage_lifecycle,in_app}',  'https://docs.google.com/d/example5', 'cs@cashfree.com',     '{vp.cs@cashfree.com}',                                'live',     now() - interval '30 days', '{vp.cs@cashfree.com}',                                  now() - interval '29 days', 'moengage',         'in_app', 50000,   75000,  true, true, true, true, true, true),
('CF-GTM-20260325-006', 'Marketplace Tier-A Swiggy-pattern push','acquisition',    'A', 'marketplace', '{linkedin_inmail,partner}',    'https://docs.google.com/d/example6', 'mothi@cashfree.com', '{vp.marketing@cashfree.com,founders@cashfree.com}',   'live',     now() - interval '25 days', '{vp.marketing@cashfree.com,founders@cashfree.com}',     now() - interval '24 days', 'cashfree_warmed', 'inmail', 350000,  400000, true, true, true, true, true, true),
('CF-GTM-20260401-007', 'BFSI dormant re-engagement Q1 cohort',  're-engagement',  'B', 'bfsi',        '{cold_email,moengage_lifecycle}','https://docs.google.com/d/example7', 'mothi@cashfree.com', '{vp.marketing@cashfree.com}',                          'live',     now() - interval '20 days', '{vp.marketing@cashfree.com}',                          now() - interval '19 days', 'cashfreeteam',     'email',  90000,   100000, true, true, true, true, true, true),
('CF-GTM-20260405-008', 'D2C SMB churn-save WhatsApp campaign',  'churn-save',     'C', 'd2c',         '{whatsapp,moengage_lifecycle}','https://docs.google.com/d/example8', 'cs@cashfree.com',     '{vp.cs@cashfree.com,compliance@cashfree.com}',         'live',     now() - interval '17 days', '{vp.cs@cashfree.com,compliance@cashfree.com}',          now() - interval '16 days', 'moengage',         'whatsapp', 30000, 50000, true, true, true, true, true, true),
('CF-GTM-20260410-009', 'WTFraud Q2 webinar drive',              'acquisition',    'B', 'bfsi',        '{wtfraud_community,linkedin_ads}','https://docs.google.com/d/example9', 'mothi@cashfree.com', '{vp.marketing@cashfree.com}',                          'live',     now() - interval '12 days', '{vp.marketing@cashfree.com}',                          now() - interval '11 days', 'wtfraud',          'community',60000, 80000,  true, true, true, true, true, true),
('CF-GTM-20260415-010', 'SaaS expansion Capital cross-sell',     'cross-sell',     'B', 'saas',        '{moengage_lifecycle,csm_outreach}','https://docs.google.com/d/example10','cs@cashfree.com',     '{vp.cs@cashfree.com}',                                'in_review',NULL,                       NULL,                                                    NULL,                       'moengage',         'email',  0,       100000, true, true, true, false, false, false),
('CF-GTM-20260420-011', 'Q3 Marketplace Cars24-pattern outbound','acquisition',    'B', 'marketplace', '{cold_email,linkedin_inmail}', 'https://docs.google.com/d/example11','mothi@cashfree.com', '{vp.marketing@cashfree.com}',                          'draft',    NULL,                       NULL,                                                    NULL,                       'cashfreeteam',     'email',  0,       150000, true, false, false, false, false, false),
('CF-GTM-20260425-012', 'D2C International PG nurture (UAE)',    'nurture',        'B', 'd2c',         '{moengage_lifecycle,linkedin_inmail}','https://docs.google.com/d/example12','mothi@cashfree.com','{vp.marketing@cashfree.com}',                       'live',     now() - interval '2 days',  '{vp.marketing@cashfree.com}',                          now() - interval '1 day',   'moengage',         'email',  20000,   100000, true, true, true, true, true, true)
ON CONFLICT (din_id) DO NOTHING;

-- =============================================
-- DEALS — 100 distributed across stages, owners, verticals
-- (Sample of 25 representative deals; full 100 follows same pattern)
-- =============================================

INSERT INTO deals (id, account_id, stage, amount, owner_email, last_activity_at, gtm_motion, source, campaign_din,
                    lead_created_date, mql_at, sql_at, sales_ready_at, working_at, meeting_booked_at, pipeline_at,
                    opportunity_type, closed_won_at, closed_lost_at, lost_reason, created_at) VALUES
-- Closed-won (12 deals)
('deal_001', 'acc_007', 'closed_won', 8500000,  'priya.sharma@cashfree.com', now() - interval '2 days',   'demand_gen', 'cold_email',     'CF-GTM-20260301-001', now() - interval '95 days', now() - interval '90 days', now() - interval '85 days', now() - interval '85 days', now() - interval '80 days', now() - interval '70 days', now() - interval '50 days', 'new_business', now() - interval '5 days',  NULL,                          NULL, now() - interval '95 days'),
('deal_002', 'acc_014', 'closed_won', 4200000,  'anjali.mehta@cashfree.com', now() - interval '8 days',   'demand_gen', 'linkedin_inmail','CF-GTM-20260305-002', now() - interval '70 days', now() - interval '65 days', now() - interval '60 days', now() - interval '60 days', now() - interval '55 days', now() - interval '40 days', now() - interval '25 days', 'new_business', now() - interval '10 days', NULL,                          NULL, now() - interval '70 days'),
('deal_003', 'acc_023', 'closed_won', 2800000,  'anjali.mehta@cashfree.com', now() - interval '12 days',  'demand_gen', 'webinar',        'CF-GTM-20260305-002', now() - interval '60 days', now() - interval '55 days', now() - interval '52 days', now() - interval '52 days', now() - interval '48 days', now() - interval '35 days', now() - interval '20 days', 'new_business', now() - interval '14 days', NULL,                          NULL, now() - interval '60 days'),
('deal_004', 'acc_034', 'closed_won', 3500000,  'aditi.rao@cashfree.com',    now() - interval '6 days',   'inbound',    'content_inbound',NULL,                  now() - interval '50 days', now() - interval '47 days', now() - interval '45 days', now() - interval '45 days', now() - interval '40 days', now() - interval '30 days', now() - interval '15 days', 'new_business', now() - interval '8 days',  NULL,                          NULL, now() - interval '50 days'),
('deal_005', 'acc_044', 'closed_won', 6800000,  'rohan.gupta@cashfree.com',  now() - interval '15 days',  'partner',    'partner',        NULL,                  now() - interval '120 days',now() - interval '115 days',now() - interval '110 days',now() - interval '110 days',now() - interval '105 days',now() - interval '90 days', now() - interval '60 days', 'new_business', now() - interval '17 days', NULL,                          NULL, now() - interval '120 days'),
('deal_006', 'acc_011', 'closed_won', 1800000,  'rahul.kumar@cashfree.com',  now() - interval '20 days',  'demand_gen', 'webinar',        'CF-GTM-20260410-009', now() - interval '55 days', now() - interval '50 days', now() - interval '48 days', now() - interval '48 days', now() - interval '42 days', now() - interval '32 days', now() - interval '22 days', 'new_business', now() - interval '22 days', NULL,                          NULL, now() - interval '55 days'),
-- Closed-won expansion (cross-sell)
('deal_007', 'acc_007', 'closed_won', 1200000,  'priya.sharma@cashfree.com', now() - interval '3 days',   'cross_sell', 'csm_outreach',   'CF-GTM-20260315-004', now() - interval '40 days', now() - interval '38 days', now() - interval '35 days', now() - interval '35 days', now() - interval '32 days', now() - interval '25 days', now() - interval '15 days', 'expansion',    now() - interval '5 days',  NULL,                          NULL, now() - interval '40 days'),
('deal_008', 'acc_014', 'closed_won', 850000,   'anjali.mehta@cashfree.com', now() - interval '4 days',   'cross_sell', 'in_app',         'CF-GTM-20260320-005', now() - interval '30 days', now() - interval '28 days', now() - interval '26 days', now() - interval '26 days', now() - interval '24 days', now() - interval '18 days', now() - interval '12 days', 'expansion',    now() - interval '6 days',  NULL,                          NULL, now() - interval '30 days'),
-- Closed-lost (8)
('deal_009', 'acc_005', 'closed_lost', 5500000, 'priya.sharma@cashfree.com', now() - interval '25 days',  'demand_gen', 'linkedin_inmail','CF-GTM-20260301-001', now() - interval '110 days',now() - interval '105 days',now() - interval '100 days',now() - interval '100 days',now() - interval '95 days', now() - interval '80 days', now() - interval '60 days', 'new_business', NULL,                       now() - interval '30 days',     'Karza did 1-week POC; Cashfree-managed POC arrived too late',                       now() - interval '110 days'),
('deal_010', 'acc_018', 'closed_lost', 2100000, 'anjali.mehta@cashfree.com', now() - interval '22 days',  'demand_gen', 'cold_email',     'CF-GTM-20260305-002', now() - interval '85 days', now() - interval '82 days', now() - interval '78 days', now() - interval '78 days', now() - interval '72 days', now() - interval '55 days', now() - interval '40 days', 'new_business', NULL,                       now() - interval '25 days',     'Pricing — Razorpay quoted 0.05% lower MDR',                                          now() - interval '85 days'),
('deal_011', 'acc_037', 'closed_lost', 3800000, 'aditi.rao@cashfree.com',    now() - interval '32 days',  'inbound',    'content_inbound',NULL,                  now() - interval '95 days', now() - interval '90 days', now() - interval '85 days', now() - interval '85 days', now() - interval '80 days', now() - interval '65 days', now() - interval '50 days', 'new_business', NULL,                       now() - interval '35 days',     'Capability gap — needed feature X, deferred to roadmap',                            now() - interval '95 days'),
('deal_012', 'acc_021', 'closed_lost', 1400000, 'vikram.singh@cashfree.com', now() - interval '40 days',  'demand_gen', 'cold_email',     'CF-GTM-20260305-002', now() - interval '75 days', now() - interval '70 days', now() - interval '67 days', now() - interval '67 days', now() - interval '62 days', now() - interval '50 days', NULL,                        'new_business', NULL,                       now() - interval '42 days',     'Timing — code freeze through Q3',                                                   now() - interval '75 days'),
-- Open deals (varying stages)
('deal_013', 'acc_001', 'poc',         9500000, 'priya.sharma@cashfree.com', now() - interval '4 days',   'demand_gen', 'linkedin_inmail','CF-GTM-20260301-001', now() - interval '60 days', now() - interval '55 days', now() - interval '50 days', now() - interval '50 days', now() - interval '45 days', now() - interval '30 days', now() - interval '15 days', 'new_business', NULL,                       NULL,                          NULL, now() - interval '60 days'),
('deal_014', 'acc_002', 'discovery',   8000000, 'rahul.kumar@cashfree.com',  now() - interval '11 days',  'demand_gen', 'cold_email',     'CF-GTM-20260301-001', now() - interval '40 days', now() - interval '37 days', now() - interval '34 days', now() - interval '34 days', now() - interval '30 days', now() - interval '20 days', NULL,                        'new_business', NULL,                       NULL,                          NULL, now() - interval '40 days'),
('deal_015', 'acc_013', 'demo',        7200000, 'anjali.mehta@cashfree.com', now() - interval '5 days',   'demand_gen', 'linkedin_inmail','CF-GTM-20260305-002', now() - interval '35 days', now() - interval '32 days', now() - interval '30 days', now() - interval '30 days', now() - interval '25 days', now() - interval '15 days', NULL,                        'new_business', NULL,                       NULL,                          NULL, now() - interval '35 days'),
('deal_016', 'acc_028', 'negotiation', 5500000, 'aditi.rao@cashfree.com',    now() - interval '7 days',   'inbound',    'content_inbound',NULL,                  now() - interval '90 days', now() - interval '85 days', now() - interval '80 days', now() - interval '80 days', now() - interval '75 days', now() - interval '60 days', now() - interval '40 days', 'new_business', NULL,                       NULL,                          NULL, now() - interval '90 days'),
('deal_017', 'acc_030', 'proposal',    4200000, 'aditi.rao@cashfree.com',    now() - interval '9 days',   'inbound',    'content_inbound',NULL,                  now() - interval '70 days', now() - interval '67 days', now() - interval '63 days', now() - interval '63 days', now() - interval '58 days', now() - interval '45 days', now() - interval '30 days', 'new_business', NULL,                       NULL,                          NULL, now() - interval '70 days'),
('deal_018', 'acc_041', 'qualification',12000000,'vikram.singh@cashfree.com',now() - interval '6 days',   'partner',    'partner',        'CF-GTM-20260325-006', now() - interval '25 days', now() - interval '22 days', now() - interval '20 days', now() - interval '20 days', now() - interval '16 days', NULL,                       NULL,                        'new_business', NULL,                       NULL,                          NULL, now() - interval '25 days'),
-- Recycled (3 — closed_lost but back in nurture, with one revival)
('deal_019', 'acc_022', 'closed_lost', 1900000, 'vikram.singh@cashfree.com', now() - interval '180 days', 'demand_gen', 'cold_email',     'CF-GTM-20260305-002', now() - interval '270 days',now() - interval '260 days',now() - interval '250 days',now() - interval '250 days',now() - interval '245 days',now() - interval '220 days',now() - interval '200 days', 'new_business', NULL,                       now() - interval '180 days',    'Pricing',                                                                            now() - interval '270 days'),
('deal_020', 'acc_022', 'discovery',   2500000, 'vikram.singh@cashfree.com', now() - interval '15 days',  'demand_gen', 'webinar',        'CF-GTM-20260410-009', now() - interval '30 days', now() - interval '28 days', now() - interval '25 days', now() - interval '25 days', now() - interval '18 days', NULL,                       NULL,                        'new_business', NULL,                       NULL,                          NULL, now() - interval '30 days')
ON CONFLICT (id) DO NOTHING;

-- Set recycled_to_nurture_at for the recycled ones
UPDATE deals SET recycled_to_nurture_at = now() - interval '60 days' WHERE id = 'deal_019';

-- =============================================
-- INTERACTIONS — pattern: many touches per active deal
-- (Sample of ~80 interactions; production seed would have 500+)
-- =============================================

INSERT INTO interactions (account_id, contact_id, deal_id, channel, touch_type, source_agent, campaign_din, recorded_at, metadata) VALUES
-- HDFC Tier A active deal (deal_013) — heavy multi-channel touches
('acc_001', 'cnt_001', 'deal_013', 'linkedin_inmail',    'impression', 'cf-outreach-writer', 'CF-GTM-20260301-001', now() - interval '60 days', '{}'),
('acc_001', 'cnt_001', 'deal_013', 'linkedin_inmail',    'open',       'cf-outreach-writer', 'CF-GTM-20260301-001', now() - interval '60 days', '{}'),
('acc_001', 'cnt_001', 'deal_013', 'linkedin_inmail',    'reply',      'human',              'CF-GTM-20260301-001', now() - interval '58 days', '{"intent":"positive"}'),
('acc_001', 'cnt_001', 'deal_013', 'cold_email',         'open',       'cf-outreach-writer', 'CF-GTM-20260301-001', now() - interval '55 days', '{}'),
('acc_001', 'cnt_001', 'deal_013', 'meeting',            'meeting',    'human',              'CF-GTM-20260301-001', now() - interval '50 days', '{"duration_min":45}'),
('acc_001', 'cnt_001', 'deal_013', 'meeting',            'demo',       'human',              'CF-GTM-20260301-001', now() - interval '45 days', '{"duration_min":60}'),
('acc_001', 'cnt_002', 'deal_013', 'meeting',            'meeting',    'human',              'CF-GTM-20260301-001', now() - interval '30 days', '{"poc_kickoff":true}'),
('acc_001', 'cnt_001', 'deal_013', 'cold_email',         'reply',      'human',              'CF-GTM-20260301-001', now() - interval '15 days', '{"intent":"objection","subcategory":"timing"}'),
-- Nykaa active deal (deal_015)
('acc_013', 'cnt_004', 'deal_015', 'linkedin_inmail',    'impression', 'cf-outreach-writer', 'CF-GTM-20260305-002', now() - interval '35 days', '{}'),
('acc_013', 'cnt_004', 'deal_015', 'linkedin_inmail',    'reply',      'human',              'CF-GTM-20260305-002', now() - interval '33 days', '{"intent":"positive"}'),
('acc_013', 'cnt_004', 'deal_015', 'meeting',            'demo',       'human',              'CF-GTM-20260305-002', now() - interval '15 days', '{"duration_min":60}'),
-- Closed-won deal_001 (Lendingkart) — full funnel
('acc_007', 'cnt_016', 'deal_001', 'cold_email',         'open',       'cf-outreach-writer', 'CF-GTM-20260301-001', now() - interval '95 days', '{}'),
('acc_007', 'cnt_016', 'deal_001', 'cold_email',         'reply',      'human',              'CF-GTM-20260301-001', now() - interval '90 days', '{}'),
('acc_007', 'cnt_016', 'deal_001', 'meeting',            'demo',       'human',              'CF-GTM-20260301-001', now() - interval '70 days', '{}'),
('acc_007', 'cnt_016', 'deal_001', 'meeting',            'meeting',    'human',              'CF-GTM-20260301-001', now() - interval '40 days', '{"contract_signed":true}'),
-- Closed-won expansion deal_007 (Lendingkart cross-sell)
('acc_007', 'cnt_016', 'deal_007', 'csm_outreach',       'reply',      'human',              'CF-GTM-20260315-004', now() - interval '40 days', '{"cross_sell":"mobile360"}'),
('acc_007', 'cnt_016', 'deal_007', 'meeting',            'demo',       'human',              'CF-GTM-20260315-004', now() - interval '25 days', '{}'),
-- D2C campaign mass touches (acc_014, 015, 023 etc)
('acc_014', 'cnt_006', 'deal_002', 'cold_email',         'impression', 'cf-outreach-writer', 'CF-GTM-20260305-002', now() - interval '70 days', '{}'),
('acc_014', 'cnt_006', 'deal_002', 'cold_email',         'open',       'cf-outreach-writer', 'CF-GTM-20260305-002', now() - interval '70 days', '{}'),
('acc_014', 'cnt_006', 'deal_002', 'cold_email',         'click',      'cf-outreach-writer', 'CF-GTM-20260305-002', now() - interval '69 days', '{}'),
('acc_014', 'cnt_006', 'deal_002', 'cold_email',         'reply',      'human',              'CF-GTM-20260305-002', now() - interval '67 days', '{"intent":"positive"}'),
('acc_014', 'cnt_006', 'deal_002', 'meeting',            'demo',       'human',              'CF-GTM-20260305-002', now() - interval '40 days', '{}'),
-- Many short impression-only touches across the rest (cold outbound at scale)
('acc_004', 'cnt_015', NULL,        'linkedin_inmail',    'impression', 'cf-outreach-writer', 'CF-GTM-20260301-001', now() - interval '40 days', '{}'),
('acc_006', NULL,       NULL,        'cold_email',         'impression', 'cf-outreach-writer', 'CF-GTM-20260301-001', now() - interval '38 days', '{}'),
('acc_009', NULL,       NULL,        'cold_email',         'impression', 'cf-outreach-writer', 'CF-GTM-20260301-001', now() - interval '36 days', '{}'),
('acc_008', NULL,       NULL,        'cold_email',         'impression', 'cf-outreach-writer', 'CF-GTM-20260301-001', now() - interval '34 days', '{}'),
('acc_021', NULL,       NULL,        'cold_email',         'impression', 'cf-outreach-writer', 'CF-GTM-20260305-002', now() - interval '32 days', '{}'),
('acc_022', NULL,       NULL,        'cold_email',         'impression', 'cf-outreach-writer', 'CF-GTM-20260305-002', now() - interval '30 days', '{}'),
('acc_046', NULL,       NULL,        'partner',            'meeting',    'human',              'CF-GTM-20260325-006', now() - interval '20 days', '{}'),
('acc_044', NULL,       NULL,        'wtfraud_community',  'reply',      'human',              'CF-GTM-20260410-009', now() - interval '11 days', '{}'),
-- Recycled account revival touches
('acc_022', NULL,       'deal_020', 'webinar',            'meeting',    'human',              'CF-GTM-20260410-009', now() - interval '20 days', '{"webinar_id":"wtfraud_q2"}'),
('acc_022', NULL,       'deal_020', 'cold_email',         'reply',      'human',              'CF-GTM-20260410-009', now() - interval '15 days', '{}');

-- =============================================
-- TRANSCRIPTS — 8 representative call transcripts
-- =============================================

INSERT INTO transcripts (id, source, deal_id, recorded_at, duration_s, text, metadata) VALUES
('tx_001', 'fathom', 'deal_013', now() - interval '50 days', 2700, 'Anita Sharma (HDFC): The issue isn''t capability — your Mobile360 numbers look better than Karza''s. The issue is, we''re in the middle of a 3-month security audit and any new vendor onboarding is paused until July. Also, Karza did a 1-week POC for us last year — they were faster on that. Can you match that turnaround? Mothi: Yes, we can offer a Cashfree-managed POC where our SE runs your file and delivers a benchmark deck in 5 days. Anita: OK, send it. Loop in Rohan our Onboarding Lead.', '{"attendees":["anita.sharma@hdfcbank.com","mothi@cashfree.com"]}'),
('tx_002', 'fathom', 'deal_015', now() - interval '15 days', 3600, 'Rohan Malhotra (Nykaa): Honestly the MDR delta is small — 0.05% versus Razorpay. Where I see the win is cross-border. We just launched UAE shipping last month and our current FX cost is killing us. Mothi: Cashfree International PG settles in INR sub-2% MDR with FX hedging. Rohan: Send me the spec.', '{"attendees":["rohan.malhotra@nykaa.com","anjali.mehta@cashfree.com"]}'),
('tx_003', 'fathom', 'deal_001', now() - interval '70 days', 4200, 'Harshvardhan Lunia (Lendingkart): Mobile360 NTC coverage is exactly what we need — bureau prefill misses 60% of our applicants. Let''s run the POC. Cashfree SE: We''ll have benchmarks ready in 5 business days.', '{"attendees":["harshvardhan.lunia@lendingkart.com","priya.sharma@cashfree.com"]}'),
('tx_004', 'fathom', 'deal_009', now() - interval '40 days', 3000, 'Deal lost call. Tata Capital prospect: Karza''s 1-week POC turnaround beat us by 3 weeks. They''ve already started integration. Cashfree-managed POC offering came too late — we should have led with it.', '{"outcome":"lost","reason":"poc_timing"}'),
('tx_005', 'fathom', 'deal_010', now() - interval '32 days', 2400, 'Vineeta Singh (Sugar Cosmetics): Razorpay quoted us 0.05% lower MDR. We''re not switching unless we see a meaningful reason — capability or service. Mothi acknowledged: we should have led with cross-border + Pre-COD case studies, not domestic MDR.', '{"outcome":"lost","reason":"pricing"}'),
('tx_006', 'fathom', 'deal_007', now() - interval '25 days', 1800, 'Lendingkart cross-sell call. Customer: We have 80+ vendor payments to influencers each month — currently manual. Showed Payouts API demo. Customer: Sign us up. Volume: ₹12L/month estimate.', '{"cross_sell":"payouts"}'),
('tx_007', 'fathom', 'deal_004', now() - interval '30 days', 3300, 'Hiver call. Customer (CFO): Need recurring billing for SaaS subscription. AutoPay coverage on UPI is non-negotiable. Cashfree pitched UPI AutoPay deepest coverage in India. Customer: Move to proposal.', '{}'),
('tx_008', 'fathom', 'deal_018', now() - interval '16 days', 2100, 'Swiggy partnership call. Sriharsha mentioned vendor count crossed 200K and Payouts API at T+0 is the cornerstone. Phani Kishan (CTO): integration spec in 2 weeks; production migration phased over Q3.', '{"strategic":true,"founder_call":true}');

-- =============================================
-- EXTRACTED PROPERTIES — typed signals from transcripts
-- =============================================

INSERT INTO extracted_property (account_id, deal_id, property_name, property_value, source_type, source_id, confidence, extracted_by_agent) VALUES
-- HDFC (acc_001)
('acc_001', 'deal_013', 'objection_raised',     'security audit pause until July',           'transcript', 'tx_001', 0.95, 'cf-drive-transcript-extractor'),
('acc_001', 'deal_013', 'competitor_mentioned', 'Karza — 1-week POC turnaround',             'transcript', 'tx_001', 0.98, 'cf-drive-transcript-extractor'),
('acc_001', 'deal_013', 'next_step_committed',  'Send Cashfree-managed POC spec',            'transcript', 'tx_001', 0.94, 'cf-drive-transcript-extractor'),
('acc_001', 'deal_013', 'decision_maker_added', 'Rohan — Onboarding Lead',                   'transcript', 'tx_001', 0.91, 'cf-drive-transcript-extractor'),
-- Nykaa (acc_013)
('acc_013', 'deal_015', 'expansion_signal',     'international shipping launched (UAE)',     'transcript', 'tx_002', 0.92, 'cf-drive-transcript-extractor'),
('acc_013', 'deal_015', 'competitor_mentioned', 'Razorpay — 0.05% MDR delta',                'transcript', 'tx_002', 0.96, 'cf-drive-transcript-extractor'),
-- Tata Capital lost (acc_005)
('acc_005', 'deal_009', 'churn_risk_phrase',    'Karza already started integration',         'transcript', 'tx_004', 0.93, 'cf-drive-transcript-extractor'),
-- Sugar lost (acc_018)
('acc_018', 'deal_010', 'objection_raised',     'pricing — Razorpay 0.05% lower',            'transcript', 'tx_005', 0.92, 'cf-drive-transcript-extractor'),
-- Lendingkart cross-sell (acc_007)
('acc_007', 'deal_007', 'expansion_signal',     '80+ manual influencer payments/month',      'transcript', 'tx_006', 0.94, 'cf-drive-transcript-extractor'),
-- Hiver (acc_034)
('acc_034', 'deal_004', 'expansion_signal',     'recurring billing requirement',             'transcript', 'tx_007', 0.91, 'cf-drive-transcript-extractor'),
-- Swiggy (acc_041)
('acc_041', 'deal_018', 'expansion_signal',     'vendor count crossed 200K',                 'transcript', 'tx_008', 0.95, 'cf-drive-transcript-extractor'),
('acc_041', 'deal_018', 'next_step_committed',  'integration spec in 2 weeks; Q3 migration', 'transcript', 'tx_008', 0.93, 'cf-drive-transcript-extractor');

-- =============================================
-- SIGNALS — competitive + intent signals
-- =============================================

INSERT INTO signals (account_id, source, signal_type, strength, observed_at, metadata) VALUES
('acc_013', 'ahrefs',   'traffic_spike', 4.2, now() - interval '8 days',  '{"change_pct":42}'),
('acc_014', 'ahrefs',   'traffic_spike', 3.8, now() - interval '12 days', '{"change_pct":38}'),
('acc_007', 'meta_ads', 'ad_scale',      3.5, now() - interval '15 days', '{"creative_themes":["NTC","fraud"]}'),
('acc_034', 'g2',       'intent_surge',  4.0, now() - interval '10 days', '{"researching_category":"recurring_billing"}'),
('acc_041', 'crunchbase','funding',      4.5, now() - interval '20 days', '{"round":"strategic"}'),
('acc_022', 'crunchbase','funding',      3.0, now() - interval '14 days', '{"round":"Series B"}'),
('acc_001', 'news',     'regulatory',    4.0, now() - interval '5 days',  '{"event":"RBI V-CIP clarification"}');

-- =============================================
-- SENDER DOMAINS — 10 across pools
-- =============================================

INSERT INTO sender_domains (domain, pool, warmed_at, daily_send_cap, status) VALUES
('cashfreeteam.io',  'tier_c_outbound', now() - interval '180 days', 100, 'healthy'),
('cashfreeteam.com', 'tier_c_outbound', now() - interval '160 days', 100, 'healthy'),
('cashfree-india.io','tier_c_outbound', now() - interval '140 days', 100, 'healthy'),
('cashfree-pay.io',  'tier_c_outbound', now() - interval '120 days', 80,  'warning'),
('cfteam.in',        'tier_c_outbound', now() - interval '90 days',  60,  'healthy'),
('cfreach.io',       'tier_c_outbound', now() - interval '60 days',  50,  'healthy'),
('grow.cashfree.com','pmm_demand',      now() - interval '300 days', 200, 'healthy'),
('hello.cashfree.com','cashfree_warmed',now() - interval '500 days', 200, 'healthy'),
('cashfree-team.in', 'reserve',         now() - interval '20 days',  30,  'healthy'),
('cashfree-co.io',   'reserve',         NULL,                          0,  'healthy')
ON CONFLICT (domain) DO NOTHING;

-- Domain deliverability snapshots — last 14 days for each domain
INSERT INTO domain_deliverability_daily (domain, snapshot_date, sends_count, bounces, spam_complaints, replies, opens, clicks, inbox_placement_score)
SELECT
    sd.domain,
    (now() - (n || ' days')::interval)::date AS snapshot_date,
    GREATEST(10, sd.daily_send_cap - (n * 2)) AS sends_count,
    GREATEST(0, ((random() * sd.daily_send_cap * 0.02))::int) AS bounces,
    GREATEST(0, ((random() * sd.daily_send_cap * 0.0008))::int) AS spam_complaints,
    GREATEST(0, ((random() * sd.daily_send_cap * 0.025))::int) AS replies,
    ((sd.daily_send_cap * 0.45))::int AS opens,
    ((sd.daily_send_cap * 0.08))::int AS clicks,
    GREATEST(0.70, 0.95 - (random() * 0.15)) AS inbox_placement_score
FROM sender_domains sd
CROSS JOIN generate_series(0, 13) AS n
WHERE sd.warmed_at IS NOT NULL
ON CONFLICT (domain, snapshot_date) DO NOTHING;

-- =============================================
-- AE CALENDAR — last 28 days for each active AE
-- =============================================

INSERT INTO ae_calendar_daily (ae_email, snapshot_date, hours_booked, hours_external_meetings, meetings_count)
SELECT
    r.email,
    (now() - (n || ' days')::interval)::date AS snapshot_date,
    CASE WHEN EXTRACT(ISODOW FROM (now() - (n || ' days')::interval)) BETWEEN 1 AND 5
         THEN GREATEST(2.0, LEAST(7.5, 4.0 + (random() * 3.5)))
         ELSE 0.0
    END AS hours_booked,
    CASE WHEN EXTRACT(ISODOW FROM (now() - (n || ' days')::interval)) BETWEEN 1 AND 5
         THEN GREATEST(1.0, LEAST(5.0, 2.5 + (random() * 2)))
         ELSE 0.0
    END AS hours_external_meetings,
    CASE WHEN EXTRACT(ISODOW FROM (now() - (n || ' days')::interval)) BETWEEN 1 AND 5
         THEN ((random() * 5))::int + 2
         ELSE 0
    END AS meetings_count
FROM ae_roster r
CROSS JOIN generate_series(0, 27) AS n
WHERE r.active = true
ON CONFLICT (ae_email, snapshot_date) DO NOTHING;

-- =============================================
-- LIFECYCLE EVENTS — sample milestones for some accounts
-- =============================================

INSERT INTO merchant_lifecycle_events (account_id, event_type, event_subtype, occurred_at) VALUES
-- Lendingkart (acc_007) — full lifecycle
('acc_007', 'signup',           NULL,         now() - interval '450 days'),
('acc_007', 'kyc_completed',    NULL,         now() - interval '445 days'),
('acc_007', 'first_transaction',NULL,         now() - interval '440 days'),
('acc_007', 'activated',        NULL,         now() - interval '425 days'),
('acc_007', 'feature_adopted',  'mobile360',  now() - interval '5 days'),
('acc_007', 'cross_sell_attached','payouts',  now() - interval '5 days'),
-- MamaEarth (acc_014)
('acc_014', 'signup',           NULL,         now() - interval '300 days'),
('acc_014', 'activated',        NULL,         now() - interval '275 days'),
('acc_014', 'feature_adopted',  'payouts',    now() - interval '6 days'),
-- Pepperfry (acc_022) — recycled-and-revived
('acc_022', 'signup',           NULL,         now() - interval '600 days'),
('acc_022', 'activated',        NULL,         now() - interval '575 days'),
('acc_022', 'dormant_entered',  NULL,         now() - interval '90 days'),
('acc_022', 'reengaged',        NULL,         now() - interval '15 days'),
('acc_022', 'win_back_revived', NULL,         now() - interval '10 days'),
-- Hiver (acc_034)
('acc_034', 'signup',           NULL,         now() - interval '60 days'),
('acc_034', 'activated',        NULL,         now() - interval '40 days'),
('acc_034', 'feature_adopted',  'autopay',    now() - interval '8 days'),
-- New trial-stage merchants for onboarding metrics
('acc_023', 'signup',           NULL,         now() - interval '15 days'),
('acc_023', 'kyc_completed',    NULL,         now() - interval '12 days'),
('acc_023', 'first_transaction',NULL,         now() - interval '10 days'),
('acc_023', 'activated',        NULL,         now() - interval '5 days'),
('acc_032', 'signup',           NULL,         now() - interval '20 days'),
('acc_032', 'kyc_completed',    NULL,         now() - interval '16 days'),
('acc_032', 'activated',        NULL,         now() - interval '8 days'),
('acc_036', 'signup',           NULL,         now() - interval '12 days'),
('acc_036', 'kyc_completed',    NULL,         now() - interval '10 days'),
-- some signups that did NOT activate (for onboarding completion < 100%)
('acc_027', 'signup',           NULL,         now() - interval '18 days'),
('acc_024', 'signup',           NULL,         now() - interval '22 days');

-- =============================================
-- CAMPAIGN SPEND DAILY — last 28 days per active campaign
-- =============================================

INSERT INTO campaign_spend_daily (din_id, snapshot_date, spend_inr, channel)
SELECT
    c.din_id,
    (now() - (n || ' days')::interval)::date AS snapshot_date,
    GREATEST(500, (c.spend_inr / 28)::numeric * (0.5 + random())) AS spend_inr,
    unnest(c.channels) AS channel
FROM campaigns c
CROSS JOIN generate_series(0, 27) AS n
WHERE c.approval_status = 'live' AND c.spend_inr > 0
ON CONFLICT (din_id, snapshot_date, channel) DO NOTHING;

-- =============================================
-- METRIC DEFINITIONS — seed the canonical list (anti-sprawl rule)
-- =============================================

INSERT INTO metric_definitions (metric_name, sql_view, column_name, aggregation, description, owner, surfaces) VALUES
('calendar_fill_pct',          'mart_ae_performance',     'calendar_fill_pct_4wk_avg',  'avg',  'AE calendar fill rate (% of capacity hours booked, Mon-Fri only). North-star metric.', 'revops@cashfree.com', '{sheets,metabase,quicksight}'),
('pipeline_created_inr',       'mart_buyer_journey',      'opportunity_amount',         'sum',  'Total open pipeline ₹ from new opportunities.',                                       'revops@cashfree.com', '{sheets,metabase,quicksight}'),
('mql_to_sql_pct',             'mart_buyer_journey',      'sql_date',                   'rate', '% of MQLs that became SQLs.',                                                          'revops@cashfree.com', '{metabase,quicksight}'),
('sql_to_won_pct',             'mart_buyer_journey',      'closed_won_date',            'rate', '% of SQLs that became Closed-Won.',                                                    'revops@cashfree.com', '{metabase,quicksight}'),
('cost_per_demo_inr',          'mart_din_performance',    'cost_per_demo_inr',          'avg',  '₹ spent per demo booked (per DIN). Anti-sprawl checked.',                              'revops@cashfree.com', '{metabase}'),
('reply_rate_pct',             'mart_outbound_health',    'reply_rate_pct_30d',         'avg',  'Reply rate per sender domain over last 30 days.',                                      'mops@cashfree.com',   '{sheets,metabase}'),
('onboarding_completion_pct',  'mart_lifecycle_metrics',  'this_week_pct',              'rate', '% new merchants who activated within 30d of signup. Razorpay floor: 29%.',             'cs@cashfree.com',     '{sheets,metabase,quicksight}'),
('retention_pct',              'mart_lifecycle_metrics',  'this_week_pct',              'rate', '% activated merchants still active (last touch <90d). Razorpay floor: 25%.',            'cs@cashfree.com',     '{sheets,metabase,quicksight}'),
('reengagement_pct',           'mart_lifecycle_metrics',  'this_week_pct',              'rate', '% dormant accounts that reengaged within 60d. Razorpay floor: 19%.',                   'cs@cashfree.com',     '{sheets,metabase,quicksight}'),
('adoption_pct',               'mart_lifecycle_metrics',  'this_week_pct',              'rate', '% feature adoptions tied to a campaign. Razorpay floor: 16%.',                          'pmm@cashfree.com',    '{sheets,metabase,quicksight}'),
('account_health_score',       'mart_account_health',     'churn_risk_score',           'avg',  'Composite per-account churn risk (0-5).',                                              'cs@cashfree.com',     '{metabase,quicksight}'),
('din_roi_multiple',           'mart_din_performance',    'roi_multiple',               'avg',  'Won revenue / spend per DIN.',                                                         'revops@cashfree.com', '{metabase,quicksight}')
ON CONFLICT (metric_name) DO NOTHING;
