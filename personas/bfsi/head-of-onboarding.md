---
name: head-of-onboarding
vertical: bfsi
seniority: senior_management | director
authority: champion | technical_evaluator
spear_products: [secure-id, mobile360]
common_titles:
  - "Head of Onboarding"
  - "Head of Customer Onboarding"
  - "VP Onboarding"
  - "Director - Customer Acquisition"
  - "Head of Digital Onboarding"
  - "Head of KYC Operations"
  - "Senior Onboarding PM"
common_companies: ["Banks (HDFC, ICICI, Axis, Kotak)", "NBFCs (Bajaj, Tata Capital, Lendingkart)", "Lending platforms", "Investment platforms (Groww, Smallcase)", "Insurance (Acko, Digit)"]
typical_book_size: ["1L to 50L applications/year", "V-CIP completion target: 70-85%"]
source: llm-wiki/wiki/concepts/secure-id-platform-architecture.md
created: 2026-04-27
updated: 2026-04-27
status: stable
---

# Head of Onboarding — Indian BFSI

## 1. Identity

The execution-focused leader at an Indian bank, NBFC, or lending platform who owns the customer-acquisition funnel from application → activated account. 8-15 years experience, often product-management background. Reports to Head of Payments OR Head of Retail Banking. Owns the V-CIP funnel, document-OCR vendors, KYC vendor stack, drop-off optimization, and onboarding CSAT. Lives in Mixpanel / Amplitude + Excel + the bank's data lake. Knows every percentage point of dropout in the funnel.

**Where you find them:** Mixpanel/Amplitude India events, Product Management India (PMI) chapters, Headstart fintech meetups, Razorpod, BharatPe events, NPCI conferences (junior level). Active on LinkedIn for PM job posts + funnel-optimization content.

**Where they don't hang:** RBI conferences (too senior), generic SaaS webinars, dev communities.

---

## 2. Top 3 pains (ranked by Mothi's onboarding-PM interviews)

1. **V-CIP completion rate <70%.** They've optimized everything they can — UX, document quality, retry logic. They're stuck at the structural gap: the back-end signal layer that decides which customers pass V-CIP and which need manual review. Karza / HyperVerge handle face-match + liveness, but the decisioning layer underneath is theirs to build. **Cashfree wedge:** Mobile360 + Secure ID stack adds the back-end signal layer that lifts V-CIP completion 18-22%.

2. **NTC drop-off — bureau-prefill misses + manual-KYC switch frustrates customer.** When bureau prefill fails, customer is shunted to manual KYC (10-30 min slowdown). Customer drops off at this step. **Cashfree wedge:** Mobile360 alt-data signals enable instant prefill on NTC applicants.

3. **Vendor sprawl + integration burden.** Karza for V-CIP, Perfios for BSA, separate vendor for OCR, separate for face-match. Each integration is its own engineering effort + maintenance. **Cashfree wedge:** single API surface (Mobile360 + Secure ID) replaces 3 integrations.

**Onboarding-head secondary pains:**
- Manual KYC team cost (operational expense growing)
- TAT for activation (customer expectation: <5 min; reality: 30-90 min)
- CSAT on onboarding flow (regulatory expectation + brand trust)
- Re-KYC at renewal (RBI periodic-KYC mandate)
- Cross-product KYC reuse (one customer, multiple bank products)

---

## 3. Success metrics they own

- V-CIP completion rate (% of applications that pass)
- Time-to-activation (median + p90)
- Manual KYC cost per application
- Drop-off rate at each funnel step
- NTC application approval rate
- Customer CSAT on onboarding journey
- Re-KYC compliance rate

---

## 4. Decision criteria when evaluating Cashfree

Heads of Onboarding are execution-focused. Decision criteria:

1. **V-CIP completion lift (measurable in their funnel)** (35%) — primary success metric
2. **API quality + integration time** (25%) — they want days not months
3. **Manual KYC cost reduction** (15%) — operational savings
4. **NTC prefill coverage** (15%) — strategic growth metric
5. **Reference customers** (5%) — peer validation
6. **Pricing** (5%) — last

**Cashfree wins them when:**
- Mobile360 funnel-impact demo on their actual sample data
- Cashfree-managed POC delivers measurable V-CIP lift in 5-day window
- Single API surface (one integration, not three) = clear engineering win
- Peer-bank onboarding head validates the lift numbers
- Cashfree SE pairs with their PM for integration handoff

**Cashfree loses them when:**
- POC requires their engineering team's time (they're already stretched)
- Lift numbers are slide-deck claims, not data-backed
- Integration takes >2 weeks
- Cannot articulate which specific funnel step Cashfree improves

---

## 5. Language that resonates / turns them off

### Resonates

- **Funnel specifics**: "V-CIP completion 68% → 84% in 90d at {peer-bank}; the lift came from {specific signal}"
- **API examples**: "Mobile360 returns 23 signals in <300ms; here's the JSON; sample integration code in Java/Python"
- **Time-to-activation**: "Drop median TTA from 32 min to 4 min"
- **Operational ROI**: "Replace 3 vendor integrations with 1; cut maintenance hours 60%"
- **Peer-onboarding-PM stories**: "{Peer-bank} PM cut manual-KYC team cost 40% in 6 months"
- **Sandbox quality**: "Test cards + V-CIP simulation + edge-case generator built in"

### Turns them off

- Marketing speak ("revolutionary onboarding")
- Generic "we improve onboarding" without funnel specifics
- Pitching to them as if they own pricing decisions (they don't)
- Pitching to them as if they own vendor selection (they propose; CRO + Compliance approve)
- Webinar invites
- Long emails

---

## 6. Common objections + Cashfree-specific responses

| Objection | Cashfree response (specific, not generic) |
|---|---|
| **"Karza covers V-CIP already"** | "Karza handles face-match + liveness — that's the front-end. Mobile360 sits BEHIND Karza on the decisioning layer (alt-data + bureau + device signals). Run them together; measure incremental V-CIP completion." |
| **"Integration takes too long"** | "Mobile360 single-API integration: 3 days for sandbox-to-prod. Cashfree SE pairs with your PM; we own the integration burden, your team reviews PRs." |
| **"V-CIP lift claim — show me proof on MY funnel"** | Cashfree-managed POC: "Send 5000 of your decline cohort + 5000 manual-KYC cohort. Our SE delivers funnel-impact analysis in 5 days — what % we'd have approved + what % we'd have auto-passed." |
| **"My team can't take on another vendor integration"** | "We do the integration. SE writes the SDK glue + tests; your team reviews. Time-on-your-side: 4 hours total for PR review." |
| **"NTC coverage claim"** | "Mobile360 covers 190M+ Indian adults vs ~60M bureau-only. {Peer-bank} grew NTC approval rate from 22% to 41% in 6mo. Want the funnel-step-by-step before-after?" |
| **"Cashfree doesn't have product X (e.g., document OCR)"** | Triage: (a) on roadmap → share roadmap + date; (b) integrates with existing OCR vendor → demo; (c) not roadmap → admit + show how Mobile360 reduces dependency on OCR for V-CIP-passing cohort. |

---

## 7. When this persona is the buyer / when not

### When THIS persona IS the buyer (champion)

- Champions Mobile360 + Secure ID with internal stakeholders
- Drives the technical evaluation + POC
- Owns the integration timeline
- Reports lift back to CRO + Head of Payments
- **Pattern:** Onboarding head is the internal champion; the "deal" is them defending Cashfree to CRO + Compliance + Head of Payments

### When this persona is NOT the buyer (still primary champion)

- Final contract signing: CRO + Head of Payments + CFO
- Compliance approval: Head of Compliance
- Procurement: separate function
- **Pattern:** support the onboarding head with all the ammunition (compliance docs, peer references, funnel-impact decks) so they can win the internal sell

---

## Cashfree-specific outreach hooks for this persona

| Hook angle | Example opener |
|---|---|
| LinkedIn job-post signal | "Saw {bank} hired 2 Senior Onboarding PMs on LinkedIn — usually means stack re-evaluation. Cashfree-managed POC delivers V-CIP lift benchmark in 5 days, zero engineering load. Tuesday 4pm IST?" |
| Funnel-impact peer story | "{Peer-bank} onboarding PM lifted V-CIP completion from 67% to 83% in 90d using Mobile360 + Secure ID. Worth a 20-min walkthrough of their funnel-step-by-step before-after?" |
| NTC growth signal | "Bureau prefill misses 60% of NTC applicants. Mobile360 adds device + behavior + alt-data signals → {peer-bank} grew NTC approval rate from 22% to 41% in 6mo. Send the funnel deck?" |
| Vendor consolidation | "Heard {bank} is reducing onboarding vendors. Mobile360 + Secure ID = single API replaces 3 integrations. Your team's maintenance hours drop 60%." |
| Manual KYC cost | "Your earnings call mentioned ops-cost focus. Manual KYC team is usually a top-5 ops line. {Peer-bank} cut manual-KYC cost 40% by lifting auto-pass rate via Mobile360. 20-min benchmark call?" |

---

## Anti-pattern outreach (DO NOT use with this persona)

- ❌ Lead with strategic / regulatory framing (they're execution; that's CRO/Compliance language)
- ❌ "Schedule a demo" without funnel-impact specifics
- ❌ Generic "improve your KYC"
- ❌ Webinar invites
- ❌ Sub-paragraph emails (they want the funnel-impact data, in writing)
- ❌ Pricing-led pitches (they're not price-decision-makers)

---

## Channel + cadence preferences

| Channel | When | Cadence |
|---|---|---|
| LinkedIn DM (peer reference) | First touch | 1-2 messages, 7d apart |
| Cold email (funnel-impact angle) | First or second touch | 2 emails 5d apart |
| Phone | After at least 1 reply | Scheduled |
| In-person event | Headstart / PM India / Razorpod | Annual+ |
| WTFraud newsletter | Continuous | Monthly |
| Slack/community | Specific PM communities | Conversation-based |

**Volume cap:** 4 touches per quarter; onboarding heads are responsive if the value is funnel-specific.

---

## Prior known instances

(populated by `cf-drive-transcript-extractor` from real calls; placeholder)

- `Sandeep Bhalla @ HDFC Bank — Head of Digital Onboarding`
- `Anuradha Aggarwal @ ICICI Bank — VP Onboarding`
- `Sumit Gwalani @ Niyo — Co-Founder + de facto onboarding head`

## Source

Primary: `llm-wiki/wiki/concepts/secure-id-platform-architecture.md` + Mothi-authored onboarding-PM interviews
Secondary: WTFraud community + funnel-impact case studies
Continuous: `cf-drive-transcript-extractor` updates this file as real onboarding-head calls accumulate
