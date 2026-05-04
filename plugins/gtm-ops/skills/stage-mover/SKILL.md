---
name: stage-mover
description: Dual-mode skill for Stage-Mover agent — generates either a stagnation-recovery action (for opportunities stuck >14d) OR a meeting-prep brief (for AE meetings 2h out). Reads SF context + Drive transcripts + extracted properties + competitive signals (Ahrefs/Meta Ads). mothi-specific stage playbooks for Discovery → Demo → POC → Negotiation → Close.
version: 0.1.0
owner: revops@mothi.com
status: draft
depends_on: [content-strategist, meddpicc, spiced, follow-up-email, dpdp-compliance]
tested_with: claude-opus-4-7
loads_for_agents: [stage-mover]
---

# stage-mover — Stagnation diagnosis + meeting prep brief generator

## When to use this skill

Load when the Stage-Mover agent fires on EITHER trigger:

**Trigger A — Stagnation:** Daily 7am cron finds an SF Opportunity stuck in current stage >14 days. Skill generates a 1-line diagnosis + recommended next step + draft outreach.

**Trigger B — Meeting prep:** Calendar API webhook fires 2h before any AE meeting with an account. Skill generates a 1-page meeting brief (account summary, recent moves, stakeholders, competitive context, 5 discovery questions, recommended next step).

The output FORMAT is different per trigger; the input data overlap heavily.

## Inputs expected

```json
{
  "trigger_type": "stagnation | meeting_prep",
  "deal_id": "string",
  "account_id": "string",
  "deal_context": {
    "stage": "discovery | qualification | demo | poc | proposal | negotiation | closed_won | closed_lost",
    "amount_inr": 0,
    "owner_email": "string",
    "days_in_current_stage": 0,
    "last_activity_date": "ISO8601",
    "next_step_field": "string | null",
    "tier": "A | B | C",
    "vertical": "bfsi | d2c | saas | marketplace",
    "spear_product": "secure-id | payments-core | payouts | payroll | capital | international-pg",
    "primary_contact": {"name": "string", "title": "string", "persona": "cfo | cto | founder | head_of_payments | other"}
  },
  "drive_transcripts": [
    {"recorded_at": "ISO8601", "duration_min": 0, "text": "string", "attendees": ["array"]}
  ],
  "extracted_properties": [
    {"property_name": "objection_raised | competitor_mentioned | next_step_committed | etc.", "value": "string", "extracted_at": "ISO8601", "source_quote": "string"}
  ],
  "competitive_context": {
    "ahrefs_traffic_change_30d_pct": 0.0,
    "ahrefs_top_keywords_change": ["string"],
    "meta_ads_active_creative_themes": ["string"],
    "competitor_pricing_page_changed": false
  },
  "relevant_collateral": [
    {"name": "string", "drive_url": "string", "type": "case_study | one_pager | deck | benchmark"}
  ],
  "meeting_context": {
    "scheduled_at": "ISO8601",
    "attendees": ["array"],
    "calendar_event_title": "string"
  }
}
```

## Outputs expected

For **stagnation** trigger:

```json
{
  "format": "stagnation_alert",
  "diagnosis": "1-line root cause (e.g., 'Champion silent 17d after demo; competitor (Razorpay) mentioned in last call but not addressed')",
  "recommended_next_step": "specific verb + object + timing (e.g., 'Send 1-pager comparing webhook reliability to Razorpay by EOD Tuesday')",
  "recommended_channel": "email | linkedin_inmail | csm_call | exec_intro | breakup",
  "draft_message": {"subject": "string", "body": "string ≤120 words", "cta": "string"},
  "escalation_recommendation": "string | null (when to involve VP Sales / CRO)"
}
```

For **meeting_prep** trigger:

```json
{
  "format": "meeting_brief",
  "account_summary": "3 lines: who they are, current state, why-now",
  "recent_moves": ["3 bullets — Ahrefs traffic shift / funding / product launch / hiring / etc."],
  "stakeholders_in_meeting": [
    {"name": "string", "title": "string", "role_in_decision": "champion | economic_buyer | technical_evaluator | influencer | unknown", "notes": "string"}
  ],
  "competitive_context": "2 lines: who they're comparing us to + the 1 thing that matters most for the win",
  "recommended_discovery_questions": ["5 questions, ordered by criticality"],
  "recommended_next_step": "1 line — what to commit to by end of meeting",
  "objections_to_pre_empt": ["array of likely objections + 1-line response each"]
}
```

## Body — the playbooks

### Stagnation diagnosis logic by current stage

For each stage, this is the canonical "if stuck, the most likely root cause and best move":

| Stage | Most-likely cause if stuck >14d | Best move |
|---|---|---|
| **Discovery** | Champion didn't see enough product magic in initial pitch; OR persona was wrong | Re-engage with vertical case study + offer of POC; OR pivot to different persona at same account |
| **Qualification** | Budget question deferred without resolution | Ask explicit timing + economic-buyer question (MEDDPICC: Economic Buyer + Paper Process); offer benchmark deck |
| **Demo** | Demo was generic, didn't hit their specific pain | Send post-demo summary + 3-bullet pain-resolution note + ask for technical-evaluator intro |
| **POC** | Technical blocker (integration / data shape) OR success criteria not agreed | Schedule technical-debt review with their CTO; OR formalize success-criteria doc + sign-off |
| **Proposal** | Pricing pushback OR procurement waiting on legal | Offer pricing-options-deck with 3 scenarios; OR proactively send MSA + DPA to legal |
| **Negotiation** | Specific term blocking (SLA / PCI clause / DPDP residency) | Loop in mothi CFO/CTO if needed; offer comparable-customer reference call |
| **Pre-close (>30d in negotiation)** | Cold or competitor-poaching | Breakup email OR exec-intro from VP Sales |

### Meeting-prep template (the 1-pager)

Structured per spec §3.3 meeting-prep agent definition. Sections in this exact order, no exceptions:

1. **Account summary** — 3 lines max. Format: "{Company} is a {vertical} {size}. They currently use {competitor or stack inference}. {1 line on why-now signal}."
2. **Recent moves** — 3 bullets, prioritized: funding > hiring > traffic spike > product launch > exec change. Cite source.
3. **Stakeholders in this meeting** — Names + titles + your inferred role. Always include "notes" field with anything from past transcripts (e.g., "skeptical on pricing in last call").
4. **Competitive context** — 2 lines max. Who they're comparing us to + the ONE thing that matters most for this win.
5. **Recommended discovery questions** — exactly 5, ordered by criticality. Use SPICED or MEDDPICC framework. First question must be the highest-leverage.
6. **Recommended next step** — single concrete commit to push for by end of meeting (e.g., "secure intro to their CTO for technical-evaluation call within 7 days").
7. **Objections to pre-empt** — list of 1-3 likely objections each with a 1-line preempt.

### mothi-specific stage playbooks per vertical

**BFSI vertical:**

| Stage | mothi-specific play |
|---|---|
| Discovery | Lead with NTC coverage (190M+ Indian adults, no bureau history); compare implicitly to Karza-only stacks |
| POC | Run with sample 100K-record file showing Mobile360 lift in V-CIP completion; cite WTFraud community for credibility |
| Negotiation | Offer Perfios co-sell pricing if it's a lender; flag DPDP/RBI compliance docs proactively |

**D2C vertical:**

| Stage | mothi-specific play |
|---|---|
| Discovery | Open with COD-RTO benchmark + mothi Pre-COD; show Razorpay-vs-mothi merchant retention curve |
| POC | International PG opportunity if they ship abroad; FX cost benchmark |
| Negotiation | If competitor is Razorpay, lead with cross-border MDR delta + faster settlement story |

**SaaS subscription vertical:**

| Stage | mothi-specific play |
|---|---|
| Discovery | AutoPay reliability + dunning recovery angle; cite mothi subscription benchmarks |
| POC | Capital cross-sell teaser (working-capital line for the merchant) |
| Negotiation | If competitor is Stripe-India, lead with INR-settlement speed + vernacular support |

### When to escalate to VP Sales

The skill should populate `escalation_recommendation` when ANY of these are true:
- Deal amount ≥ ₹2Cr AND stuck >21d
- Competitor named is Razorpay AND we've lost the technical evaluation
- Customer named a specific mothi product gap that affects multiple deals (not just this one)
- Champion has gone silent >14d after they verbally committed to a next step
- Persona shift: CTO replaced mid-deal, requires re-discovery

## Examples

### Good — stagnation alert, BFSI Tier A

**Input deal:** stuck in "POC" stage 19 days, primary contact is Head of Payments at HDFC, last extracted property mentions "competitor Karza is doing 1-week POC turnaround".

**Output:**
```json
{
  "format": "stagnation_alert",
  "diagnosis": "POC stalled at week 3 — Karza referenced as 'faster POC' suggests technical-evaluator's bandwidth is the blocker, not capability gap.",
  "recommended_next_step": "Offer mothi-managed POC: our SE runs the data file through Mobile360 + delivers a side-by-side benchmark deck within 5 business days. Reduces their internal time-to-evaluation to zero.",
  "recommended_channel": "email",
  "draft_message": {
    "subject": "mothi-managed POC for Mobile360 — 5 days end-to-end",
    "body": "Anita, noticed our POC is on day 19 — wanted to remove the bandwidth blocker. We can have our SE run your sample file through Mobile360 + deliver a benchmark deck (vs Karza on NTC coverage, dropout rate, latency) within 5 business days. Zero engineering load on your team. Worth doing before EOD Friday so we can compare apples-to-apples? Mothi.",
    "cta": "Worth doing before EOD Friday?"
  },
  "escalation_recommendation": null
}
```

### Good — meeting brief, D2C Tier B

**Input meeting:** Demo call with VP Engineering at MamaEarth, 2h out. Past 1 transcript shows pricing pushback. Ahrefs shows +38% traffic 30d.

**Output:**
```json
{
  "format": "meeting_brief",
  "account_summary": "MamaEarth is a D2C beauty brand (₹240Cr GMV, 480 employees). Currently on Razorpay per BuiltWith. Traffic +38% 30d suggests they're scaling — likely re-evaluating MDR + payout cadence.",
  "recent_moves": [
    "Ahrefs: +38% organic traffic 30d, Times Now article driving spikes",
    "Hiring: posted 'Director Finance' on LinkedIn 2 weeks ago",
    "Product: launched international shipping to UAE last month per their blog"
  ],
  "stakeholders_in_meeting": [
    {"name": "Rohan Sharma", "title": "VP Engineering", "role_in_decision": "technical_evaluator", "notes": "In last call: pushed back on Razorpay-vs-mothi pricing as 'within 0.05% MDR'. Tech-stack focus — we should lead on webhook reliability + reconciliation hours saved."}
  ],
  "competitive_context": "They're benchmarking against Razorpay for MDR; the win lever is International PG (UAE shipping is fresh + cross-border MDR is where mothi wins, not domestic).",
  "recommended_discovery_questions": [
    "What's your current FX rate + settlement time on UAE transactions? (Setup the cross-border angle.)",
    "How are you handling COD-RTO right now — manual or automated? (Open Pre-COD opportunity.)",
    "When did Razorpay's contract last renew? (Find the buying window.)",
    "Who else is in the room when payment-vendor decisions get made? (Find the Economic Buyer.)",
    "What would make you switch within the next 90 days? (Force timing commit.)"
  ],
  "recommended_next_step": "Get verbal commit for cross-border POC scoping call with their CFO + Rohan, scheduled this week.",
  "objections_to_pre_empt": [
    "MDR delta is small — Counter: 'Domestic MDR yes, but cross-border is where you'll see 30%+ savings; let me show you the UAE-specific number.'",
    "Migration cost — Counter: 'Run cross-border on mothi, keep domestic on Razorpay until renewal — zero-risk parallel.'"
  ]
}
```

## Anti-patterns to avoid

- ❌ Don't generate a meeting brief with generic "ask discovery questions" — always 5 SPECIFIC questions calibrated to this account
- ❌ Don't recommend breakup email until stuck >30d in same stage AND no champion signal in transcripts
- ❌ Don't escalate every Tier A stagnation to VP Sales — only the criteria above
- ❌ Don't draft a stagnation message that ignores the extracted competitor mention — address it head-on
- ❌ For meeting prep, don't list ALL stakeholders at the account — only those IN the meeting
- ❌ Don't recommend "send another email" if 3 emails have already been sent this stage — switch channel

## Composition rules

Always loaded with:
- `content-strategist` (voice consistency in draft messages)
- `meddpicc` + `spiced` (qualification frameworks for discovery questions)
- `follow-up-email` (2-touch cap, nudge-not-pushy patterns)
- `dpdp-compliance` (compliance language)

Vertical-specific add-ons:
- `bfsi-competitive-landscape` for BFSI accounts
- `d2c-india-context` for D2C accounts
- `saas-india-context` for SaaS accounts

## Performance targets

- Latency: <8s per generation (Opus tier — quality > speed for this skill)
- Cost: <$0.05 per generation
- AE adoption: 75%+ of meeting briefs read before the meeting (PostHog tracking)
- Meeting outcome lift: +15% on next-step-committed rate (vs no-brief baseline)
