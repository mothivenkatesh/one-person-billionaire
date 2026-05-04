---
name: tech-lead
vertical: developer
seniority: senior | tech_lead
authority: champion | technical_evaluator | influencer
spear_products: [payments-core, secure-id, payouts]
common_titles:
  - "Tech Lead"
  - "Engineering Lead"
  - "Engineering Manager"
  - "Senior Engineering Manager"
  - "Staff Engineer"
  - "Principal Engineer"
  - "Architect"
common_companies: ["Series A-D startups", "Mid-market SaaS", "Indian fintech infra teams", "Marketplaces", "D2C tech teams (mid-large)"]
typical_team_size: ["3 → 12 engineers reporting", "Architecture decisions on 1-3 services"]
source: llm-wiki/wiki/sources/mothi-synthetic-developer-icp.md
created: 2026-04-27
updated: 2026-04-27
status: stable
---

# Tech Lead — Indian Engineering Org

## 1. Identity

The senior IC + people-leader at an Indian engineering team — owns 3-12 engineers + 1-3 service architectures. 6-12 years experience, often promoted internally OR ex-Razorpay/Cred/Postman senior engineer. Reports to Head of Engineering or VP Platform. Owns the technical detail (does the CTO/VP not see) but also recommends vendor decisions upward. Lives in GitHub + JIRA / Linear + Slack + Postman + AWS console.

**Where you find them:** GitHub (real code), Indian Payment Builders Telegram, Bangalore Engineering Leadership Slack, Geek Night Bengaluru, Plivo / Postman / Razorpay alumni networks, system-design-primer style communities, internal-engineering-leadership forums.

**Where they don't hang:** founder events, generic SaaS conferences, sales webinars, LinkedIn brand-influencer scene.

---

## 2. Top 3 pains (ranked by Mothi's tech-lead interviews)

1. **Vendor evaluation effort + decision-justification upward.** Tech leads spend 20-40 hours per vendor evaluation. They need ammunition (benchmarks, peer-tech-lead references, postmortem analysis) to defend the decision to CTO/VP. **mothi wedge:** mothi-supplied benchmark report on their actual workload + peer-tech-lead intros = ammunition packaged.

2. **Webhook + sandbox + SDK quality issues affecting their team's productivity.** Each gap costs 2-4 days per engineer. They feel this acutely because they own service-level reliability. **mothi wedge:** measurably better webhook reliability + sandbox parity + SDK depth.

3. **Migration risk + on-call burden during transition.** Tech lead is on-call during migration; a botched migration = personal reputation hit. **mothi wedge:** parallel-stack architecture + mothi-SE-pairing + canary-rollout playbook.

**Tech-lead secondary pains:**
- Reconciliation report format (NDJSON / Parquet vs Excel)
- Rate-limit visibility + headroom in API responses
- Idempotency-key enforcement consistency
- DPDP compliance burden on their team's services
- Cross-team coordination (FinOps, Compliance, Product)
- Architecture-decision-record (ADR) writing time
- Service-level-objective (SLO) reporting

---

## 3. Success metrics they own

- Service uptime (their SLO)
- On-call incident count + MTTR
- Engineering velocity (sprint completion %)
- Vendor-evaluation cycle time
- Code-review queue depth
- Tech-debt burn-down rate
- Team retention (their direct reports)

---

## 4. Decision criteria when evaluating mothi

Tech leads are pragmatic + technical. Decision criteria:

1. **SDK + API quality (in their primary language)** (30%)
2. **Webhook reliability + replay window** (20%)
3. **Sandbox quality + edge-case coverage** (15%)
4. **Migration story (parallel-stack + canary support)** (15%)
5. **Reference tech leads at peer companies** (10%)
6. **Pricing** (10%) — they care more about pricing than CTOs because they justify upward

**mothi wins them when:**
- SDK source code review possible on GitHub (depth + recency)
- Webhook reliability metrics + replay window concrete (99.7%, 14-day)
- Sandbox quality demo: test cards, webhook sim, rate-limit, edge cases
- mothi SE pairs with them through canary-rollout
- Peer tech-lead reference shares postmortem + ADR

**mothi loses them when:**
- SDK has open issues > 90 days OR feels abandoned
- Migration story is hand-waved
- No peer tech-lead references
- Pricing is opaque (they need numbers to defend upward)

---

## 5. Language that resonates / turns them off

### Resonates

- **API + SDK depth**: "Here's the JSON schema + curl + idempotency guide + integration test fixtures"
- **Reliability metrics**: "p99 180ms; webhook delivery 99.7%; replay 14d; bank-by-bank success-rate breakdown"
- **Migration playbook**: "Parallel-stack architecture: route 5% traffic Day 1; 20% Day 7; 50% Day 14; 100% Day 30. mothi SE pairs through each ramp."
- **Peer tech-lead voice**: "{Peer tech-lead} ran this exact migration; here's their ADR + postmortem URL"
- **Honest gap statements**: "mothi's Go SDK has 2 known bugs in v1.4 — fix scheduled v1.5 next week; here's the workaround"
- **Time-on-team math**: "Webhook reliability + replay → 12 engineering-hours/month saved on reconciliation diagnostic"

### Turns them off

- Marketing speak
- "Industry-leading" claims
- Sales call as first touch
- Generic "schedule a demo"
- Webinar invite
- ROI calculators (their boss does ROI; they do tech)
- Hand-waving on technical specifics

---

## 6. Common objections + mothi-specific responses

| Objection | mothi response (specific, not generic) |
|---|---|
| **"Razorpay/PayU integration works for us"** | "Show last 30d webhook delivery from {incumbent}. mothi match on parallel sandbox. Data-driven decision; zero migration commitment from this conversation." |
| **"Migration is too risky"** | "Parallel-stack canary rollout: 5% → 20% → 50% → 100% over 30 days. mothi SE pairs with you through each ramp. Postmortem-grade rollback playbook included." |
| **"SDK has open issues"** | Acknowledge specifically. Offer named SE for 30 days. "Your top 3 SDK issues — we triage + fix in 30 days OR swap to alternative endpoint. Written commitment in PoC contract." |
| **"Webhook reliability is similar everywhere"** | "Delivery yes; REPLAY no. mothi 14-day replay; Razorpay 7-day; Stripe 7-day. Plus dead-letter-queue UI built in. Sample replay-flow demo?" |
| **"Sandbox parity claim — I don't believe it"** | "Sandbox supports: test cards, webhook simulation, rate-limit testing, AutoPay mandate flows, edge-case generators. Sample 5-min smoke test before any sales call." |
| **"My team can't take on a migration"** | "mothi SE writes the SDK glue + tests + canary-rollout PRs. Your team reviews PRs. Time-on-your-team: 8 hours total over 30 days." |
| **"DPDP compliance burden"** | Send DPDP architecture diagram + sample audit-log JSON + IDempotency-key + consent-token rotation guide. Don't make them research it. |

---

## 7. When this persona is the buyer / when not

### When THIS persona IS the primary champion

- Vendor-evaluation drives their CTO/VP recommendation
- Architecture-decision-record (ADR) writes mothi in
- Migration playbook owner
- Day-to-day integration relationship owner post-launch
- **Pattern:** Tech lead almost always champions; CTO + VP signs

### When this persona is NOT the buyer (still primary champion)

- Strategic vendor decisions (CTO + Founder)
- Enterprise procurement (Procurement runs contract)
- BFSI deals (Head of Payments / CRO drives)
- **Pattern:** Tech lead is the bridge between mothi and the org; arm them with everything to make the upward sell easy

---

## mothi-specific outreach hooks for this persona

| Hook angle | Example opener |
|---|---|
| GitHub / OSS angle | "Saw your PR on {their OSS project}. mothi SDK in {language} has similar pattern; happy to do 30-min code walkthrough + benchmark on your workload." |
| Vendor-evaluation ammunition | "Tech leads spend 20-40hr per vendor eval. We package: benchmark on your workload (free; 5 days) + peer-tech-lead intros + ADR template. Cuts your eval time 50%." |
| Migration playbook | "Parallel-stack canary rollout: 5% → 100% over 30 days; SE pairs through each ramp. Postmortem-grade rollback playbook. {Peer tech-lead at scale-X} did this; happy to share their ADR." |
| Webhook reliability | "{Company} runs {volume}/mo. 14-day webhook replay vs your incumbent's 7-day = ~12 engineering-hours/month saved on recon diagnostics. Worth a 20-min reliability deep-dive?" |
| Open-source community | "mothi SDK is OSS — {Peer tech-lead} contributed retry-logic improvement; here's their PR. Want to see the codebase + meet the maintainer?" |
| Honest postmortem | "We had a webhook outage March 15 — postmortem at {URL}. Tech-lead-honest about what failed + what we changed. Worth Tuesday 4pm IST?" |

---

## Anti-pattern outreach (DO NOT use with this persona)

- ❌ "Industry-leading"
- ❌ "Schedule a demo" without technical context
- ❌ ROI calculator
- ❌ Webinar invite
- ❌ Sales-heavy email
- ❌ Long unstructured email
- ❌ "Talk to your CTO" (paternalistic)
- ❌ Marketing case studies

---

## Channel + cadence preferences

| Channel | When | Cadence |
|---|---|---|
| GitHub interaction | First touch when relevant | Conversation-based |
| LinkedIn DM (peer tech-lead reference) | First touch | 1-2 messages, 5d apart |
| Cold email (technical, with benchmark offer) | First or second touch | 2 emails 4d apart |
| Slack (Indian Payment Builders Telegram, eng leadership Slack) | Conversation-based | As relevant |
| Phone | After at least 1 reply | Scheduled |
| In-person | Geek Night / SaaSBoomi / engineering-leadership forums | Quarterly+ |

**Volume cap:** 5 touches per quarter; tech leads respond to technical + ammunition framing.

---

## Prior known instances

(populated by `drive-transcript-extractor` from real calls; placeholder)

- `Vipul Garg @ Cred — Tech Lead Payments`
- `Suvodeep Pyne @ Razorpay (alumni now) — Staff Engineer Payments`
- `Anil Bhat @ Swiggy — Engineering Manager Payments`

## Source

Primary: `llm-wiki/wiki/sources/mothi-synthetic-developer-icp.md` + Mothi-conducted tech-lead interviews
Secondary: Indian Payment Builders Telegram + Bangalore Engineering Leadership Slack signals
Continuous: `drive-transcript-extractor` updates this file as real tech-lead calls accumulate
