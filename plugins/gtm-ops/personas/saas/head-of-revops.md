---
name: head-of-revops
vertical: saas
seniority: senior_management | director
authority: champion | technical_evaluator
spear_products: [payments-core, autopay, payouts]
common_titles:
  - "Head of Revenue Operations"
  - "VP RevOps"
  - "Director - RevOps"
  - "Head of Sales Operations"
  - "Head of Billing Operations"
  - "RevOps Lead"
  - "Senior Manager - RevOps"
common_companies: ["Indian SaaS Series A+", "B2B SaaS (sales-led)", "Product-led SaaS (PLG)", "Marketplace SaaS", "DevTools / API-first SaaS"]
typical_arr: ["$2M → $50M ARR", "1000 → 50000 active subscriptions"]
source: llm-wiki/wiki/sources/mothi-synthetic-developer-icp.md
created: 2026-04-27
updated: 2026-04-27
status: stable
---

# Head of RevOps — SaaS

## 1. Identity

The execution-focused leader at a Series A+ SaaS company who owns revenue operations: subscription billing, dunning, retention workflows, expansion-revenue tracking, sales-ops infrastructure, and revenue analytics. 6-12 years experience, usually ex-McKinsey/BCG analyst → SaaS RevOps OR ex-Salesforce-admin career path. Reports to CFO or CRO. Owns the gap between sales-closes and cash-in-bank. Lives in Salesforce + Chargebee / Stripe Billing + Looker + Excel + Mixpanel.

**Where you find them:** RevOps Co-op community, SaaStr panel readers, Pavilion (formerly RevOps Squared), Zinnov SaaS forums, Modern Sales Pros India, Outreach.io community. Very active on LinkedIn — posts weekly on RevOps benchmarks + tactical wins.

**Where they don't hang:** RBI / fintech events, founder-only communities, brand-marketing forums.

---

## 2. Top 3 pains (ranked by SaaS-RevOps interviews)

1. **Failed-payment recovery effectiveness.** Dunning (auto-retry of failed payments) is supposed to recover 30-50% but most see 15-25% recovery. The gap is in retry-logic depth (timing windows, smart retry rules, network-specific intelligence). **mothi wedge:** Smart-retry engine recovers 32-45% on INR cards vs Stripe's 22-28%; UPI mandate retry built in.

2. **Subscription billing API gaps for India edge cases.** Stripe / Chargebee handle global cases well but stumble on India-specific (UPI AutoPay edge, RBI mandate-revoke, Cards-on-File rules, COD-equivalent for SaaS — wait-for-bank-transfer). **mothi wedge:** India-specific subscription primitives + UPI AutoPay native + COD-for-SaaS workflows.

3. **Cross-functional reporting + revenue attribution.** Pulling clean revenue data from Chargebee + Stripe + Razorpay + bank into Salesforce/Looker requires 3+ vendor-data integrations. RevOps spends 30-40% of time on data-pipeline maintenance. **mothi wedge:** Single-vendor consolidation = single API for billing + payments data → 60% reduction in data-pipeline work.

**RevOps secondary pains:**
- Pricing experiments (proration, plan changes, ramp deals)
- Sales-ops handoff (Salesforce → billing → fulfillment)
- Expansion-revenue tracking (upsell, cross-sell)
- Customer-data sync (CRM ↔ billing ↔ CS tool)
- ASC 606 implementation in tooling
- API rate-limit visibility for billing endpoints
- Webhook reliability for billing events

---

## 3. Success metrics they own

- Failed-payment recovery rate (dunning effectiveness)
- Involuntary churn rate (the metric CFO cares about)
- Time-to-cash from sale-close
- Revenue attribution accuracy
- Pricing-experiment velocity (# experiments/quarter)
- ARR data-quality score
- Sales-ops cycle time (lead-to-cash)

---

## 4. Decision criteria when evaluating mothi

RevOps is data-driven. Decision criteria:

1. **Failed-payment recovery rate (proven on their data)** (30%) — primary metric
2. **API depth for subscription edge cases (UPI AutoPay, mandate-revoke, etc.)** (25%)
3. **Salesforce + Looker integration quality** (20%)
4. **Webhook reliability + replay** (15%)
5. **Reference RevOps leaders at peer SaaS** (10%)
6. **Pricing** (5%) — last

**mothi wins them when:**
- Recovery-rate benchmark on their actual failed-payment cohort
- Live API + sandbox demo (not slides)
- Native Salesforce connector + Looker block shown working
- Sample webhook flow + replay window demo
- Peer-RevOps-lead reference: "{Peer RevOps lead} cut involuntary churn 6 → 2.4% in 4mo"

**mothi loses them when:**
- Slide-based "we recover more" without data
- Cannot demo Salesforce / Looker integration
- Webhook reliability story is generic
- Migration burden falls on RevOps team
- No peer-RevOps-lead references

---

## 5. Language that resonates / turns them off

### Resonates

- **Recovery-rate math**: "32-45% recovery on INR cards vs Stripe's 22-28% — at your $20M ARR with 12% involuntary-churn baseline, ~$1M/yr retained ARR"
- **API specifics**: "UPI AutoPay endpoint exposes mandate-state + retry-window + bank-status; sample JSON; here's the curl"
- **Pipeline reduction**: "Single vendor for billing + payments data → 60% reduction in data-pipeline maintenance hours"
- **Webhook depth**: "Webhook delivery 99.7% + 14-day replay vs Stripe's 7-day vs Razorpay's 5-day"
- **Peer RevOps stories**: "{Peer RevOps lead at scale-X} cut involuntary churn 6 → 2.4% in 4mo using AutoPay + smart-retry"
- **Sandbox quality**: "Sandbox supports failed-payment simulation, AutoPay mandate flows, edge-case test suite"

### Turns them off

- Marketing speak
- "Schedule a demo" without recovery-rate offer
- D2C / retail framing
- Generic case studies
- Slide-only pitches
- Long emails
- Pricing-led pitch

---

## 6. Common objections + mothi-specific responses

| Objection | mothi response (specific, not generic) |
|---|---|
| **"Stripe Billing handles us"** | "On INR cards + UPI AutoPay specifically: mothi recovery rate 32-45% vs Stripe 22-28%; AutoPay coverage 98% vs ~70%. Run on subset for 90 days; measure recovery + involuntary-churn delta." |
| **"Chargebee + Razorpay works"** | "Chargebee stays. mothi replaces Razorpay as the underlying PSP for INR payments. Native Chargebee connector; same Chargebee billing logic. UPI AutoPay coverage + recovery-rate jumps." |
| **"Migration burden falls on my team"** | "mothi SE owns integration. Salesforce native connector + Looker block + Webhook handlers — we ship them. Your team reviews PRs. Time-on-your-side: 6 hours total." |
| **"Recovery rate claim — show me on my data"** | "Send 1000 of your historical failed payments (anonymized). Our SE backtests mothi retry-logic; delivers what % we'd have recovered + what timing windows worked. Free; 7-day turnaround." |
| **"Webhook reliability"** | "Compare: 99.7% delivery + 14-day replay (mothi) vs 99.4% + 7-day (Stripe) vs 99.0% + 5-day (Razorpay). Source: 12B+ events YTD; happy to share the audit." |
| **"AutoPay mandate revoke handling"** | "mothi exposes mandate-revoke webhook within 60s of revocation. Stripe / Razorpay can lag 24-48hrs. Sample webhook flow demo?" |

---

## 7. When this persona is the buyer / when not

### When THIS persona IS the primary champion

- Subscription billing tooling decisions (RevOps + CTO co-decide)
- Dunning / retry-logic infrastructure
- Salesforce ↔ billing integration
- Revenue analytics stack
- Pricing-experiment infrastructure
- **Pattern:** RevOps champions; CFO + CTO co-approve. RevOps owns the technical evaluation + integration handoff.

### When this persona is NOT the buyer (still primary champion)

- Strategic vendor decisions (CFO + Founder)
- International PG (CFO drives)
- Capital / financing (CFO + Founder)
- **Pattern:** RevOps almost always champions; arm them with recovery-rate benchmarks + peer-RevOps references + API depth proof

---

## mothi-specific outreach hooks for this persona

| Hook angle | Example opener |
|---|---|
| Recovery rate benchmark | "Send 1000 of your historical failed payments (anonymized) — our SE backtests mothi retry-logic; delivers recovery-rate benchmark + timing-window analysis in 7 days. Free." |
| AutoPay coverage | "Saw {SaaS} runs subscription billing. UPI AutoPay coverage at 98% (vs industry 82%) cuts involuntary churn 40-60%. {Peer RevOps} cut churn 6 → 2.4% in 4mo. 20-min walkthrough?" |
| API depth | "India-specific subscription primitives (mandate-state webhook, COD-for-SaaS workflows, RBI mandate-revoke handling) — most platforms miss these. 20-min API walkthrough on your edge cases?" |
| Salesforce / Looker | "Native Salesforce connector + Looker block + Webhook handlers — mothi SE ships them. Your data-pipeline maintenance hours drop 60%. 20-min integration demo?" |
| Webhook reliability | "Webhook delivery 99.7% + 14-day replay (vs Stripe 7d / Razorpay 5d). 12B+ events YTD audit available. Worth a 20-min reliability deep-dive?" |
| Peer RevOps reference | "{Peer SaaS RevOps lead} happy to share their mothi migration story — including the bumpy parts. 30-min peer-RevOps call?" |

---

## Anti-pattern outreach (DO NOT use with this persona)

- ❌ Slide-based pitches
- ❌ "Schedule a demo" without data offer
- ❌ Generic "we recover more"
- ❌ D2C / retail framing
- ❌ Long unstructured emails
- ❌ Pricing-led pitch
- ❌ Webinar invites

---

## Channel + cadence preferences

| Channel | When | Cadence |
|---|---|---|
| LinkedIn DM (peer-RevOps reference) | First touch | 1-2 messages, 5d apart |
| Cold email (recovery-rate benchmark offer) | First or second touch | 2 emails 4d apart |
| Phone | After 1 reply | Scheduled |
| Slack (RevOps Co-op) | Conversation-based | As relevant |
| In-person | RevOps Co-op summit / SaaSBoomi | Quarterly+ |
| Loom video walkthrough | After 1 reply | Once |

**Volume cap:** 5 touches per quarter; RevOps leads are responsive to data-backed offers.

---

## Prior known instances

(populated by `drive-transcript-extractor` from real calls; placeholder)

- `Anna Vempaty @ Freshworks — Head of Revenue Operations`
- `Vinay Bansal @ Postman — Director RevOps`
- `Surya Panicker @ Browserstack — Senior Manager RevOps`

## Source

Primary: `llm-wiki/wiki/sources/mothi-synthetic-developer-icp.md` + Mothi-conducted SaaS-RevOps interviews
Secondary: RevOps Co-op community + SaaStr benchmarks
Continuous: `drive-transcript-extractor` updates this file as real RevOps calls accumulate
