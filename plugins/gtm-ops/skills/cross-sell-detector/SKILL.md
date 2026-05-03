---
name: cross-sell-detector
description: Weekly product-pair gap scanner for Cashfree merchants. Identifies merchants heavy in product A but absent in product B (where the A→B attach pattern is proven), scores cross-sell readiness 0-5, generates personalized pitch using merchant's actual usage data. Vertical-aware product pairs (Payments→Payouts for D2C, Secure ID→Mobile360 for BFSI, etc.).
version: 0.1.0
owner: pmm@cashfree.com
status: draft
depends_on: [content-strategist, hormozi-value-eq, psy-trigs, dpdp-compliance]
tested_with: claude-opus-4-7
loads_for_agents: [cf-cross-sell-detector]
---

# cf-cross-sell-detector — Cashfree merchant cross-sell pitch generator

## When to use this skill

Load when the Cross-Sell-Detector agent (weekly Monday 6am cron) needs to:
- Score cross-sell readiness for a merchant who is heavy on product A but absent on product B
- Generate personalized pitch that uses merchant's ACTUAL usage data (volume, tenure, vertical) — not generic claims
- Decide channel: CSM Slack alert (>₹10L/mo GMV merchants) vs MoEngage in-app + email + WhatsApp (SMB)

Invoked by:
- `cf-cross-sell-detector` agent (weekly Monday 6am)

This is a **revenue-direct skill**: a single closed cross-sell of Payments→Payouts for a ₹50L/mo D2C merchant pays back the entire stack for a year.

## Inputs expected

```json
{
  "merchant": {
    "account_id": "string",
    "name": "string",
    "vertical": "bfsi | d2c | saas | marketplace",
    "tenure_days": 0,
    "monthly_gmv_inr": 0,
    "primary_persona": "founder | cfo | cto | head_of_growth | head_of_ops"
  },
  "current_product_usage": {
    "payments_core": {"monthly_txn_count": 0, "monthly_volume_inr": 0, "active_since": "ISO8601"},
    "payouts": {"monthly_txn_count": 0, "monthly_volume_inr": 0, "active_since": null},
    "secure_id": {"monthly_lookup_count": 0, "active_since": null},
    "payroll": {"monthly_active_employees": 0, "active_since": null},
    "capital": {"outstanding_inr": 0, "active_since": null},
    "international_pg": {"monthly_volume_usd": 0, "active_since": null},
    "autopay": {"active_subscriptions": 0, "active_since": null}
  },
  "candidate_product": "payouts | secure_id | payroll | capital | international_pg | autopay | mobile360",
  "attach_pattern_history": {
    "similar_merchants_who_added_this_product": "int",
    "median_time_to_attach_days": "int",
    "common_trigger_signals": ["array of strings observed in past attaches"]
  },
  "moengage_engagement": {
    "open_rate_30d": 0.0,
    "click_rate_30d": 0.0,
    "in_app_session_count_30d": 0
  },
  "recent_extracted_properties": [
    {"property_name": "expansion_signal", "value": "string", "source_quote": "string", "extracted_at": "ISO8601"}
  ]
}
```

## Outputs expected

```json
{
  "readiness_score": 0.0,
  "readiness_tier": "hot | warm | cold | not_ready",
  "top_3_reasons": ["array of cited reasons with numerical evidence"],
  "recommended_channel": "csm_slack | moengage_lifecycle | both",
  "personalized_pitch": {
    "email_subject": "string ≤55 chars",
    "email_body": "string ≤120 words",
    "email_cta": "string ≤15 words",
    "in_app_banner_text": "string ≤20 words (for MoEngage banner)",
    "whatsapp_message": "string ≤160 chars (for MoEngage WhatsApp)",
    "csm_talking_points": ["3 bullets if recommended_channel includes csm_slack"]
  },
  "expected_attach_probability_pct": 0.0,
  "estimated_arr_lift_inr": 0
}
```

## Body — the cross-sell logic

### Cashfree product-pair attach matrix (vertical-aware)

| Vertical | Strongest A→B pair | Median attach time | Trigger signal |
|---|---|---|---|
| **D2C / ecom** | Payments → Payouts | 90 days | Vendor count >50 OR vendor-payout volume mentioned |
| D2C / ecom | Payments → International PG | 120 days | Cross-border shipping launched / mentioned |
| D2C / ecom | Payments → AutoPay | 60 days | Subscription product launched (skincare refills, fashion subscription) |
| **BFSI / lending** | Secure ID → Mobile360 | 45 days | NTC use case OR completion-rate optimization mentioned |
| BFSI / lending | Mobile360 → Payments (acceptance side) | 180 days | Loan disbursal automation discussion |
| **SaaS subscription** | Payments → AutoPay | 60 days | Recurring billing model OR dunning recovery mentioned |
| SaaS subscription | AutoPay → Capital | 180 days | Cash-flow concerns mentioned OR working-capital line interest |
| SaaS subscription | Payments → International PG | 120 days | Global customer base launched |
| **Marketplaces** | Payments → Payouts | 60 days | Vendor count >100 (always-true for marketplaces typically) |
| Marketplaces | Payouts → Secure ID | 90 days | Compliance / KYB / new-vendor-onboarding bottleneck mentioned |

### Readiness scoring — 0 to 5 composite

| Dimension | Weight | Signals |
|---|---|---|
| **Product A usage depth** | 1.5 | Monthly volume above merchant's vertical median = +1.5; below = +0.5 |
| **Tenure** | 1.0 | 90-365 days = +1.0 (sweet spot); <90 = +0.25 (too new); >365 = +0.75 (mature, may resist change) |
| **Engagement (MoEngage)** | 1.0 | Open rate >25% AND click rate >5% = +1.0; below = +0.25 |
| **Expansion signal** | 1.5 | Recent extracted_property of type `expansion_signal` matching the candidate product = +1.5; absent = 0 |

**Cap at 5.0. Round to 1 decimal.**

### Readiness tier from score

| Score | Tier | Channel |
|---|---|---|
| 4.0+ | hot | both (CSM + MoEngage parallel — high-conviction, give them both touch + automation) |
| 2.5–4.0 | warm | moengage_lifecycle (automated; CSM only if monthly_gmv >₹10L) |
| 1.0–2.5 | cold | moengage_lifecycle (single soft touch, low-frequency) |
| <1.0 | not_ready | skip — try again next quarter |

### Pitch personalization rules

The pitch MUST:
1. **Cite their actual numbers** — "you process ₹47 lakh/mo in Payments" not "you process payments"
2. **Reference attach-pattern history** — "merchants like you who added Payouts saw X% reduction in Y"
3. **Use Cashfree-specific differentiators** for the candidate product:

| Candidate product | Differentiator to lead with |
|---|---|
| Payouts | T+0 settlement to vendors, single-API for IMPS+UPI+RTGS+NEFT |
| International PG | Sub-2% MDR on USD settlement, FX hedging built-in |
| AutoPay | India's deepest UPI AutoPay coverage, dunning recovery engine |
| Capital | Pre-approved working-capital line based on Cashfree transaction history |
| Mobile360 | NTC coverage 190M+ Indian adults via single mobile-number input |
| Secure ID | DPDP-native, signals-not-scores, no alternate-data violations |
| Payroll | Cross-sell from Payouts; salary + reimbursements + statutory in one stack |

4. **Match channel to copy length**:
   - Email: 80-120 words
   - In-app banner: ≤20 words (one-liner with CTA button)
   - WhatsApp: ≤160 chars (template-message format)
   - CSM talking points: 3 bullets, AE-grade not marketing copy

5. **Compliance respect**: never imply we have data we don't (DPDP); never make alternate-data claims (RBI); always include unsubscribe hint in email if it's first cross-sell touch

### When to recommend CSM vs MoEngage

| Trigger | Channel |
|---|---|
| `monthly_gmv_inr >= ₹10L AND readiness_tier in (hot, warm)` | **both** (CSM does the human touch, MoEngage runs the digital sequence in parallel) |
| `monthly_gmv_inr < ₹10L AND readiness_tier in (hot, warm)` | **moengage_lifecycle** only (SMB scale; CSM bandwidth doesn't justify) |
| `readiness_tier = cold` | **moengage_lifecycle** only (single soft touch) |
| `readiness_tier = not_ready` | skip — return empty pitch with reason |

## Examples

### Good — hot D2C Payments→Payouts cross-sell

**Input excerpt:**
- D2C cosmetics brand, 320 employees, ₹47L/mo Payments volume, 240 days tenure
- Payouts: 0 active. Payouts hint in latest call: "we manage 80+ influencer payments manually each month"
- MoEngage 30d: 31% open, 7% click, 12 in-app sessions
- Attach pattern: 47 similar D2C merchants added Payouts in 90 days, common signal "vendor/influencer payment volume mentioned"

**Output:**
```json
{
  "readiness_score": 4.6,
  "readiness_tier": "hot",
  "top_3_reasons": [
    "Payments volume ₹47L/mo is 2.1× D2C cosmetics median — heavy user, room to expand",
    "Tenure 240d is in attach sweet spot (90-365d window)",
    "Recent expansion signal: 80+ manual influencer payments/month — exact pain Payouts solves"
  ],
  "recommended_channel": "both",
  "personalized_pitch": {
    "email_subject": "Stop manually paying 80+ influencers each month",
    "email_body": "Saw the line about 80+ influencer payments handled manually — running the math, that's ~12 hours/month of Anjali's time + reconciliation risk. Our Payouts API runs IMPS/UPI/RTGS in T+0, single bulk file, auto-reconciled back to your Payments dashboard. 47 D2C brands like yours added Payouts in 90 days; median Ops-time saved was 18 hrs/mo. 15-min walkthrough next Tuesday?",
    "email_cta": "Tuesday 4pm IST work?",
    "in_app_banner_text": "T+0 vendor payouts — same dashboard. See setup guide →",
    "whatsapp_message": "Hi Rohan — Payouts API can clear your 80+ influencer payments in T+0 from one bulk file, auto-reconciled with your Payments dashboard. 15 min walkthrough? — Mothi, Cashfree",
    "csm_talking_points": [
      "Lead with the 80-influencer manual payment pain extracted from their last call",
      "Show side-by-side: current ops hours vs Payouts API; cite the 47-merchant attach precedent",
      "Offer a no-cost POC week — pre-load their next vendor batch into Payouts sandbox"
    ]
  },
  "expected_attach_probability_pct": 62.0,
  "estimated_arr_lift_inr": 240000
}
```

### Bad — should skip (not_ready)

**Input excerpt:**
- New D2C merchant, 12 days tenure, ₹2L/mo Payments
- All other product usage: 0
- MoEngage 30d: 8% open, 0.5% click

**Output:**
```json
{
  "readiness_score": 0.7,
  "readiness_tier": "not_ready",
  "top_3_reasons": [
    "Tenure 12 days — too new, no attach signal possible yet",
    "Payments volume ₹2L/mo well below D2C median — not at expansion threshold",
    "MoEngage engagement weak (8% open / 0.5% click) — won't open a cross-sell email yet"
  ],
  "recommended_channel": "skip",
  "personalized_pitch": null,
  "expected_attach_probability_pct": 5.0,
  "estimated_arr_lift_inr": 0
}
```

## Anti-patterns to avoid

- ❌ Generic pitch: "Cashfree Payouts is the best in India" — must cite their numbers
- ❌ Cross-selling within first 60 days of tenure (too soon, kills trust)
- ❌ CSM alert for SMB merchants — wastes CSM bandwidth; use MoEngage
- ❌ Recommending all 3 channels (email + in_app + WhatsApp) for cold tier — overwhelming
- ❌ Citing attach_pattern_history that doesn't exist (made-up "47 merchants" claim) — must come from real data
- ❌ Cross-selling Capital to a merchant in distress (low engagement + declining volume) — predatory; defer

## Composition rules

Always loaded with:
- `content-strategist` (voice + persuasion frameworks)
- `hormozi-value-eq` (dream outcome × likelihood / time × effort framing for the value prop)
- `psy-trigs` (specific persuasion triggers per persona)
- `dpdp-compliance` (no data claims we shouldn't make)

Vertical-specific:
- `d2c-india-context` for D2C cross-sell
- `bfsi-competitive-landscape` for BFSI Secure ID → Mobile360
- `saas-india-context` for SaaS AutoPay → Capital

## Performance targets

- Latency: <6s per merchant (Opus tier required for personalization quality)
- Cost: <$0.04 per merchant
- Attach rate lift: +20% on hot-tier merchants vs control (no-pitch)
- Razorpay benchmark to beat: their cross-sell adoption boost was +16% (per public MoEngage case study) — Cashfree target +20%
