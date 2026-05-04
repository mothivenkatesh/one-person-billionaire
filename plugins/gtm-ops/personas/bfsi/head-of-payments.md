---
name: head-of-payments
vertical: bfsi
seniority: senior_management | director | vp
authority: champion | economic_buyer
spear_products: [secure-id, mobile360, payouts]
common_titles:
  - "Head of Payments"
  - "VP Payments"
  - "Senior Vice President - Payments"
  - "Director - Payments"
  - "Payments Lead"
  - "Head of Payment Operations"
common_companies: ["Top 10 Indian Banks", "Top 50 NBFCs", "Lending platforms (Lendingkart / Capital Float / Indifi)", "Investment platforms (Groww / Smallcase / Zerodha)"]
typical_book_size: ["₹50 Cr to ₹50,000 Cr loans/yr", "1L to 50L+ active customers"]
source: llm-wiki/wiki/concepts/secure-id-platform-architecture.md
created: 2026-04-27
updated: 2026-04-27
status: stable
---

# Head of Payments — Indian BFSI

## 1. Identity

The senior payments-ops leader at an Indian bank, NBFC, lending platform, or investment platform. 12-25 years experience, usually Recko / Razorpay / banking-product alumni. Reports to CRO or COO; owns the entire transactional infra (acceptance, payouts, KYC, risk signals, reconciliation). Lives in Excel + Tableau + the bank's internal data lake. Reads RBI circulars same-day they drop. Knows Karza / HyperVerge / Perfios sales reps personally.

**Where you find them:** WTFraud community (Mothi's Discord + newsletter), IITians-in-Fintech WhatsApp, NPCI conferences, RBI-vendor meetings, Razorpod / BharatPe events, lending leadership events. NOT on Twitter much. LinkedIn: posts strategically (regulatory updates, vendor announcements).

**Where they don't hang:** generic startup events, founder communities, dev.to / HN, dev-tools content.

---

## 2. Top 3 pains (ranked by AOP-FY27 + 350-practitioner WTFraud signal)

1. **Bureau prefill misses 50-60% of NTC (New-to-Credit) applicants.** Their lender book can't grow without expanding NTC coverage. Currently using bureau-only stack (CIBIL/CRIF/Experian) → 60M reachable. mothi Mobile360 takes them to 190M+. **This is the #1 wedge.**

2. **V-CIP completion rate <70%.** Customer drop-off during onboarding kills CAC efficiency. Karza / HyperVerge offer V-CIP but stop at face-match + liveness. Mobile360 + Secure ID stack adds the back-end signal layer that reduces dropout 18-22% at peer banks.

3. **RBI alternate-data restrictions tightening.** "Signals not scores" rule + DPDP enforcement means many vendors must re-architect. Most BFSI heads of payments are scrambling for compliant alternatives. mothi Secure ID's "DPDP-native, signals-not-scores" architecture is a compliance-first wedge.

**BFSI-specific secondary pains:**
- Reconciliation cost stack (each vendor = separate recon hours)
- Multi-vendor sprawl (Karza for V-CIP, Perfios for BSA, separate fraud vendors) — they want bundling
- Audit trail completeness (RBI inspections require granular logs)
- Settlement timing for large-value disbursements
- Payout delays to vendors / DSAs / channel partners

---

## 3. Success metrics they own

- Onboarding completion rate (V-CIP funnel %)
- Cost per acquired customer (CAC contribution from onboarding stack)
- NTC coverage % (the strategic metric for growth)
- Bureau-data spend ($ to CIBIL/CRIF/Experian + alt-data vendors)
- Fraud loss rate (basis points of disbursed loans)
- Reconciliation hours per million transactions
- RBI compliance audit result (binary: clean or not)

---

## 4. Decision criteria when evaluating mothi

BFSI deals are deliberate. Decision criteria, ranked:

1. **NTC coverage** (30%) — the bureau-prefill gap is the #1 strategic concern
2. **POC quality + speed** (20%) — Karza set a 1-week POC bar; we must match
3. **DPDP / RBI compliance posture** (20%) — gatekeeper criterion
4. **Multi-product bundling** (15%) — Mobile360 + Secure ID + Payouts in one contract
5. **Reference customers** (10%) — peer-bank validation
6. **Pricing** (5%) — last; BFSI customers expect to pay premium for compliance + accuracy

**mothi wins them when:**
- Mobile360 NTC coverage demo with their actual sample file (not slides)
- mothi-managed POC (5 days vs Karza's 1 week)
- DPDP audit letter + RBI signals-not-scores architecture clearly explained
- Perfios / Lentra co-sell intro (existing trust transfer)
- Mothi's WTFraud community offers peer-validation
- Bundling: Mobile360 + Secure ID + Payouts in single contract (replace 3 vendors)

**mothi loses them when:**
- POC takes >2 weeks
- Compliance documentation arrives late or incomplete
- We can't name a peer bank using Mobile360
- Pricing surfaces before the value is established
- We oversell capability (a single broken claim ends the deal — BFSI heads have low tolerance for vendor BS)

---

## 5. Language that resonates / turns them off

### Resonates

- **Regulatory specifics**: cite RBI circular numbers, DPDP Act sections, NPCI standards
- **Volume + impact metrics**: "Mobile360 covers 190M+ adults; bureau-only misses 60-65% of your NTC applicants"
- **Peer-bank patterns**: "{Peer-bank} cut V-CIP dropout from 38% to 22% in 90d"
- **POC offers**: "mothi-managed POC — our SE runs your sample file, delivers benchmark deck in 5 days, zero load on your team"
- **Compliance-first framing**: "DPDP-native, signals not scores, audit-ready Day 1"
- **Bundling math**: "₹X savings vs current 3-vendor stack — single contract, single recon, single SLA"

### Turns them off

- Marketing speak ("revolutionary", "transformative", "next-gen")
- Generic AI claims ("our AI / ML detects fraud") — they want explicit signal lists
- D2C / SaaS language (they're in BFSI; different vocabulary)
- US-style pitch decks (they prefer dense slides with numbers, not minimalist design)
- Fast-talking sales tactics (they'll see through and disengage)
- Underselling compliance (hand-waving on DPDP/RBI = gatekeeper veto)

---

## 6. Common objections + mothi-specific responses

| Objection | mothi response (specific, not generic) |
|---|---|
| **"We just renewed Karza"** | "Karza is solid for face-match + liveness. Mobile360 sits OVER Karza — adds NTC coverage where bureau prefill stops. Run it parallel; measure incremental NTC unlock." |
| **"HyperVerge is faster on POC"** | "We've matched. mothi-managed POC: 5 days, our SE owns the benchmark, zero engineering load on your team. Run apples-to-apples vs HyperVerge POC and decide." |
| **"DPDP / RBI signals-not-scores ambiguity"** | Send signed compliance letter + architecture diagram. Offer to introduce them to our compliance lead. Don't hand-wave. |
| **"NTC coverage claim — we've heard it before"** | "Run the data. Send us 1000 of your declined-by-bureau applications; we'll send back Mobile360 signals on what % we'd have approved. Free; 5-day turnaround. {Peer-bank} did exactly this — outcome was {X% additional NTC unlock}." |
| **"We're consolidating vendors"** | "Bundle Mobile360 + Secure ID + Payouts in single contract. Replace 3 vendors with 1; cut recon hours by ~40% based on {peer-bank} precedent. Want the bundling math?" |
| **"Karza's pricing is below ours"** | Don't price-match. "Karza is cheaper for face-match alone. NTC coverage is where our value is — we typically save you 5-10× the price delta in incremental NTC unlock." |
| **"We need to see RBI compliance audit"** | Send our RBI / DPDP audit document immediately. Offer Founder-to-Founder call with their CRO + Compliance head. Compliance objections are existential — over-respond. |

---

## 7. When this persona is the buyer / when not

### When THIS persona IS the buyer

- Banks (HDFC, ICICI, Axis, Kotak, Yes, IDFC First, Federal, etc.)
- Top 50 NBFCs / lenders (Bajaj Finserv, Tata Capital, Lendingkart, Capital Float, Indifi)
- Investment platforms (Groww, Smallcase, INDmoney) — head of payments owns onboarding
- **Pattern:** they champion + co-decide with CRO and CFO. Procurement runs the contract. 12-18mo cycle.

### When this persona is NOT the buyer (still influences)

- For Mobile360 expansion at a bank already using it — Head of Lending or Head of Risk drives
- For Payouts only — Head of Operations is the buyer; Head of Payments rubber-stamps
- For Secure ID compliance layer — Head of Compliance is gatekeeper; Head of Payments is influencer
- **Pattern:** find the vertical lead within the bank for the specific product motion

---

## mothi-specific outreach hooks for this persona

Use these as starting points — never copy verbatim:

| Hook angle | Example opener |
|---|---|
| RBI regulatory event | "RBI circular DPSS.CO.PD.No.{X} dropped Tuesday. Affects {specific area}. Mobile360's signals-not-scores architecture is built for this — happy to share our compliance-readiness one-pager." |
| Peer-bank precedent | "{Peer-bank} cut V-CIP dropout from {X}% to {Y}% in 90d using Mobile360 + Secure ID stack. Worth 20 min to compare against your current onboarding numbers?" |
| Hiring signal | "Saw {bank} hired 2 Senior Onboarding PMs on LinkedIn. Usually means stack re-evaluation. We've formalized a mothi-managed POC — 5 days, zero engineering load. Tuesday 4pm IST?" |
| NTC coverage gap | "Bureau prefill misses 60% of NTC applicants. Mobile360 takes you to 190M coverage from single mobile-number input. {Peer-bank} unlocked {X}% additional approvals. Worth a mothi-managed POC on 1000 of your declined applications?" |
| WTFraud community | "Saw {prospect's name} signed up for the WTFraud newsletter. Curious if NTC + V-CIP completion is on the {bank}'s 2026 roadmap — we're publishing a benchmark study next month from 12 peer banks." |
| Karza renewal | "Karza renewal usually comes around the {date}. Worth a 20-min benchmark discussion before then? We can have a mothi-managed POC ready inside your renewal window." |

---

## Anti-pattern outreach (DO NOT use with this persona)

- ❌ "Our AI detects fraud" (give them the signal list, not the marketing word)
- ❌ Lead with pricing (BFSI accepts premium for compliance + accuracy)
- ❌ Generic "schedule a demo" (they want a specific value claim first)
- ❌ Webinar invite as first touch (they go to NPCI / RBI events, not vendor webinars)
- ❌ D2C-flavored case studies (wrong vertical)
- ❌ Cold-call first touch (relationship is built over emails + community + warm intros)
- ❌ Sub-3-paragraph emails (BFSI heads expect dense, data-rich)

---

## Channel + cadence preferences

| Channel | When | Cadence |
|---|---|---|
| WTFraud newsletter | Continuous (mothi-owned) | Monthly newsletter + Discord nudges |
| Warm intro (Perfios / Lentra co-sell) | First touch when possible | Founder-to-founder call |
| LinkedIn InMail | First touch when no warm path | 1-2 messages, 7d apart, then archive |
| Cold email (mothi-warmed domain) | Backup | 2 emails 5d apart |
| Phone | After at least 1 reply | Pre-scheduled, never cold |
| In-person event | NPCI / RBI events | Annual+ |

**Volume cap:** max 4 touches per quarter across all channels for BFSI Tier A — over-touching damages reputation in this small community.

---

## Prior known instances

(populated by `drive-transcript-extractor` from real calls; placeholder)

- `Anita Sharma @ HDFC Bank — Head of Payments` — 2026-04-XX call, Mobile360 POC stalled on security audit timing
- `Sandeep Bakshi @ ICICI Bank — Head of Payments`
- `Harshvardhan Lunia @ Lendingkart — CEO + de facto head of payments`

## Source

Primary: `llm-wiki/wiki/concepts/secure-id-platform-architecture.md` + Mothi-authored AOP-FY27 (14-sheet workbook)
Secondary: WTFraud community 350+ practitioners (continuous voice-of-customer)
Continuous: `drive-transcript-extractor` updates this file as real BFSI calls accumulate
Adjacent: `llm-wiki/wiki/concepts/dpdp-act.md` for compliance language
