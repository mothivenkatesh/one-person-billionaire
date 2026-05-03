-- gtm-ops schema extensions v4 — persona model integration.
-- Additive on top of 001 + 002 + 003.

-- =============================================
-- CONTACTS — add canonical persona resolution columns
-- =============================================

ALTER TABLE contacts ADD COLUMN IF NOT EXISTS persona_canonical TEXT;
-- Examples: 'backend-engineer', 'founder-d2c', 'head-of-payments', 'cfo-d2c'

ALTER TABLE contacts ADD COLUMN IF NOT EXISTS persona_confidence NUMERIC(3, 2);
-- 0.0–1.0; <0.8 → flag for manual review

ALTER TABLE contacts ADD COLUMN IF NOT EXISTS persona_resolved_by TEXT;
-- 'cf-persona-resolver' | 'manual' | 'cf-drive-transcript-extractor' | etc.

ALTER TABLE contacts ADD COLUMN IF NOT EXISTS persona_resolved_at TIMESTAMPTZ;

ALTER TABLE contacts ADD COLUMN IF NOT EXISTS secondary_personas TEXT[];
-- For multi-stakeholder deals: other personas in this contact's orbit

CREATE INDEX IF NOT EXISTS idx_contacts_persona_canonical ON contacts(persona_canonical);

-- =============================================
-- PERSONA REGISTRY — single source of truth for available personas
-- =============================================

CREATE TABLE IF NOT EXISTS persona_registry (
    persona_canonical   TEXT PRIMARY KEY,                 -- e.g., 'backend-engineer'
    vertical            TEXT NOT NULL,                    -- developer | d2c-operator | bfsi | saas
    seniority_levels    TEXT[],                           -- {ic, senior, tech_lead}
    authority           TEXT[],                           -- {champion, technical_evaluator}
    spear_products      TEXT[],                           -- which Cashfree products are most relevant
    common_titles       TEXT[],                           -- title patterns for resolver
    file_path           TEXT NOT NULL,                    -- personas/developer/backend-engineer.md
    source_url          TEXT,                             -- llm-wiki source
    status              TEXT NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'stable', 'stale')),
    created_at          TIMESTAMPTZ DEFAULT now(),
    updated_at          TIMESTAMPTZ DEFAULT now()
);

-- Seed all 16 canonical personas (3 from v1.1.0 + 13 from v1.2.0)
INSERT INTO persona_registry (persona_canonical, vertical, seniority_levels, authority, spear_products, common_titles, file_path, source_url, status) VALUES

-- ============== DEVELOPER (5) ==============
('backend-engineer', 'developer', '{senior,tech_lead}', '{champion,technical_evaluator}',
 '{payments-core,secure-id,payouts}',
 '{Senior Software Engineer,Senior Backend Engineer,Backend Lead,Tech Lead,Engineering Manager,Staff Engineer,Principal Engineer}',
 'personas/developer/backend-engineer.md', 'llm-wiki/wiki/sources/cashfree-synthetic-developer-icp.md', 'stable'),

('cto-startup', 'developer', '{c_suite,founder}', '{economic_buyer,decision_maker}',
 '{payments-core,secure-id,payouts,international-pg}',
 '{CTO,Chief Technology Officer,Co-Founder & CTO,VP Engineering,Head of Engineering,Engineering Lead}',
 'personas/developer/cto-startup.md', 'llm-wiki/wiki/sources/cashfree-synthetic-developer-icp.md', 'stable'),

('tech-lead', 'developer', '{senior,tech_lead}', '{champion,technical_evaluator,influencer}',
 '{payments-core,secure-id,payouts}',
 '{Tech Lead,Engineering Lead,Engineering Manager,Senior Engineering Manager,Staff Engineer,Principal Engineer,Architect}',
 'personas/developer/tech-lead.md', 'llm-wiki/wiki/sources/cashfree-synthetic-developer-icp.md', 'stable'),

('devops-sre', 'developer', '{senior,tech_lead}', '{technical_evaluator,gatekeeper}',
 '{payments-core,secure-id,payouts}',
 '{DevOps Engineer,Senior DevOps Engineer,SRE,Site Reliability Engineer,Platform Engineer,Senior Platform Engineer,Head of Platform,Infrastructure Lead}',
 'personas/developer/devops-sre.md', 'llm-wiki/wiki/sources/cashfree-synthetic-developer-icp.md', 'stable'),

('security-engineer', 'developer', '{senior,tech_lead,director}', '{gatekeeper,technical_evaluator}',
 '{secure-id,payments-core}',
 '{Security Engineer,Senior Security Engineer,Application Security Engineer,Head of Security,CISO,Chief Information Security Officer,VP Security,Director - Information Security}',
 'personas/developer/security-engineer.md', 'llm-wiki/wiki/concepts/dpdp-act.md', 'stable'),

-- ============== D2C OPERATOR (5) ==============
('founder-d2c', 'd2c-operator', '{founder}', '{economic_buyer,decision_maker}',
 '{payments-core,payouts,international-pg,capital}',
 '{Founder,Co-Founder,CEO,Founder & CEO,MD}',
 'personas/d2c-operator/founder-d2c.md', 'D:\\dtc-research\\', 'stable'),

('cfo-d2c', 'd2c-operator', '{c_suite,senior_management}', '{economic_buyer,gatekeeper}',
 '{payments-core,capital,payouts}',
 '{CFO,Chief Financial Officer,VP Finance,Head of Finance,Finance Director,Financial Controller}',
 'personas/d2c-operator/cfo-d2c.md', 'D:\\dtc-research\\', 'stable'),

('head-of-ops', 'd2c-operator', '{senior_management,director}', '{champion,technical_evaluator,economic_buyer}',
 '{payouts,payments-core}',
 '{Head of Operations,VP Operations,COO,Director - Operations,Head of Supply Chain,Head of Fulfillment,Operations Manager}',
 'personas/d2c-operator/head-of-ops.md', 'D:\\dtc-research\\', 'stable'),

('head-of-growth', 'd2c-operator', '{senior_management,director}', '{champion,technical_evaluator}',
 '{payments-core,autopay}',
 '{Head of Growth,VP Growth,Director - Growth,Growth Lead,Head of Performance Marketing,Head of D2C / Online,Head of E-commerce}',
 'personas/d2c-operator/head-of-growth.md', 'D:\\dtc-research\\', 'stable'),

('marketing-lead', 'd2c-operator', '{senior_management,director}', '{champion,influencer}',
 '{payments-core,autopay}',
 '{CMO,Chief Marketing Officer,VP Marketing,Head of Marketing,Marketing Director,Head of Brand,Director - Brand & Communications}',
 'personas/d2c-operator/marketing-lead.md', 'D:\\dtc-research\\', 'stable'),

-- ============== BFSI (4) ==============
('head-of-payments', 'bfsi', '{senior_management,director,vp}', '{champion,economic_buyer}',
 '{secure-id,mobile360,payouts}',
 '{Head of Payments,VP Payments,Senior Vice President - Payments,Director - Payments,Payments Lead,Head of Payment Operations}',
 'personas/bfsi/head-of-payments.md', 'llm-wiki/wiki/concepts/secure-id-platform-architecture.md', 'stable'),

('chief-risk-officer', 'bfsi', '{c_suite}', '{economic_buyer,gatekeeper}',
 '{secure-id,mobile360,payouts}',
 '{Chief Risk Officer,CRO,Head of Risk,Chief Credit Risk Officer,Head of Credit Risk,Chief Operating Officer & CRO}',
 'personas/bfsi/chief-risk-officer.md', 'llm-wiki/wiki/concepts/secure-id-platform-architecture.md', 'stable'),

('compliance-head', 'bfsi', '{senior_management,director,vp}', '{gatekeeper,technical_evaluator}',
 '{secure-id,mobile360}',
 '{Head of Compliance,Chief Compliance Officer,VP Compliance,Director - Compliance,Head of Regulatory Affairs,Compliance Lead,Principal Officer}',
 'personas/bfsi/compliance-head.md', 'llm-wiki/wiki/concepts/dpdp-act.md', 'stable'),

('head-of-onboarding', 'bfsi', '{senior_management,director}', '{champion,technical_evaluator}',
 '{secure-id,mobile360}',
 '{Head of Onboarding,Head of Customer Onboarding,VP Onboarding,Director - Customer Acquisition,Head of Digital Onboarding,Head of KYC Operations,Senior Onboarding PM}',
 'personas/bfsi/head-of-onboarding.md', 'llm-wiki/wiki/concepts/secure-id-platform-architecture.md', 'stable'),

-- ============== SAAS (2) ==============
('cfo-saas', 'saas', '{c_suite,senior_management}', '{economic_buyer,gatekeeper}',
 '{payments-core,autopay,payouts}',
 '{CFO,Chief Financial Officer,VP Finance,Head of Finance,Director - Finance,Financial Controller}',
 'personas/saas/cfo-saas.md', 'llm-wiki/wiki/sources/cashfree-synthetic-developer-icp.md', 'stable'),

('head-of-revops', 'saas', '{senior_management,director}', '{champion,technical_evaluator}',
 '{payments-core,autopay,payouts}',
 '{Head of Revenue Operations,VP RevOps,Director - RevOps,Head of Sales Operations,Head of Billing Operations,RevOps Lead,Senior Manager - RevOps}',
 'personas/saas/head-of-revops.md', 'llm-wiki/wiki/sources/cashfree-synthetic-developer-icp.md', 'stable')

ON CONFLICT (persona_canonical) DO NOTHING;

-- =============================================
-- PERSONA INSTANCE LOG — track real named decision-makers per persona
-- (Auto-populated by cf-drive-transcript-extractor when decision_maker_added is extracted)
-- =============================================

CREATE TABLE IF NOT EXISTS persona_known_instances (
    id                  BIGSERIAL PRIMARY KEY,
    persona_canonical   TEXT REFERENCES persona_registry(persona_canonical),
    contact_id          TEXT REFERENCES contacts(id),
    account_id          TEXT REFERENCES accounts(id),
    name                TEXT NOT NULL,
    title_at_time       TEXT,
    company_at_time     TEXT,
    first_observed_at   TIMESTAMPTZ DEFAULT now(),
    last_observed_at    TIMESTAMPTZ DEFAULT now(),
    notes               TEXT,
    UNIQUE (persona_canonical, contact_id)
);

CREATE INDEX IF NOT EXISTS idx_persona_instances_persona ON persona_known_instances(persona_canonical);
