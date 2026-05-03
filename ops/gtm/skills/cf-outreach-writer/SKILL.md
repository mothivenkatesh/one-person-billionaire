---
name: cf-outreach-writer
description: Per-tier personalized cold email + InMail draft generator for Cashfree outbound. Reads prospect website + LinkedIn + recent news + Cashfree ICP context. Outputs tier-appropriate 3-touch sequence with hook/body/CTA per touch.
version: 0.1.0
owner: pmm@cashfree.com
status: draft
depends_on: [content-strategist, follow-up-email, psy-trigs, cashfree-outreach-agent, dpdp-compliance]
tested_with: claude-haiku-4-5
loads_for_agents: [cf-outreach-writer]
---

# cf-outreach-writer — Cashfree outbound draft generator

## When to use this skill

Load when an agent needs to:
- Draft a 3-touch personalized cold sequence for a scored lead
- Write a single InMail / email reply / nurture-arc message
- Tier-aware: tone/depth varies by Tier A vs B vs C

Invoked by:
- `cf-outreach-writer` agent (after cf-icp-scout returns tier ≥ C)
- HITL approval queue for Tier A/B (PMM reviews before send)
- Tier C is auto-send post-DIN-approval

## Inputs expected

```json
{
  "prospect": {
    "name": "string",
    "title": "string",
    "company": "string",
    "domain": "string",
    "linkedin_url": "string | null"
  },
  "context": {
    "tier": "A | B | C | plg",
    "vertical": "bfsi | d2c | saas | marketplace",
    "icp_score": 0.0,
    "evidence_summary": "string from cf-icp-scout",
    "spear_product": "secure-id | payments-core | payouts | payroll | capital | international-pg",
    "competitor_in_use": "razorpay | payu | stripe | billdesk | none | unknown",
    "recent_company_signals": "string (1-2 lines, e.g., 'Series C closed Mar 2026, hiring Head of Growth')"
  },
  "campaign": {
    "din_id": "CF-GTM-YYYYMMDD-NNN",
    "channel_pool": "smartlead_tier_c | cashfree_warmed_tier_b | linkedin_inmail",
    "send_window": "morning | afternoon | evening_ist",
    "frequency_cap_remaining": "int (max touches remaining for this prospect this quarter)"
  }
}
```

## Outputs expected

```json
{
  "din_id": "CF-GTM-...",
  "touch_1": {
    "subject": "string (35-55 chars, hook-first)",
    "body": "string (markdown, ≤120 words)",
    "cta": "string (specific ask, ≤12 words)"
  },
  "touch_2": {
    "subject": "string",
    "body": "string",
    "cta": "string",
    "trigger_after_days": 4
  },
  "touch_3": {
    "subject": "string",
    "body": "string (breakup-style for Tier C; soft-close for Tier A/B)",
    "cta": "string",
    "trigger_after_days": 7
  },
  "personalization_evidence": "string (explains which input signals were used)",
  "compliance_check": {
    "dpdp_consent_basis": "legitimate_interest | explicit_consent",
    "unsubscribe_link_present": true,
    "no_alternate_data_claims": true
  }
}
```

## Body — drafting logic by tier

### Tier A (Lighthouse) — 1:1 personal email tone

- **Length:** 80-120 words per touch (concise, exec-time-respectful)
- **Voice:** Senior peer-to-peer; no marketing speak; reference one specific signal
- **Hook:** Industry-aware insight or named-mutual-relationship reference
- **CTA:** Calendar-direct ("15 min next Tuesday at 4pm IST?") or specific resource
- **Touch 3:** Soft close — "Acknowledging this isn't a fit for now; will circle back in Q3"

### Tier B (Strategic) — peer-to-peer with named playbook

- **Length:** 100-150 words per touch
- **Voice:** Practitioner-to-practitioner; cite a similar customer pattern
- **Hook:** Pain-named-with-data ("teams at your size typically lose 3-5% MDR to recon errors")
- **CTA:** Offer of specific deliverable ("happy to share our reconciliation benchmark for your stack")
- **Touch 3:** Breakup-soft — "If timing is off, here's the case study and I'll step back"

### Tier C (Mid-market) — automated, scannable

- **Length:** 60-90 words per touch (tight, mobile-readable)
- **Voice:** Direct value statement; data-led
- **Hook:** Numerical lift mentioned in Cashfree-public case study, tied to vertical
- **CTA:** Demo link OR landing page (UTM-tagged with DIN_ID)
- **Touch 3:** Breakup-direct — "Closing your file unless you reply"

### plg / self-serve — no AE outbound

- Use MoEngage lifecycle journey instead. This skill should respond with `recommended_motion: "moengage_lifecycle"` and skip drafting.

## Universal rules (apply to ALL tiers)

| Rule | Why |
|---|---|
| **Mention 1 specific signal from `recent_company_signals`** | Avoids generic "I noticed your company..." | proves the agent did its homework |
| **Mention 1 specific Cashfree differentiator** | Not "Cashfree is great" — specific: NTC coverage / cross-border PG / DPDP-ready |
| **Frequency cap respect** | If `frequency_cap_remaining < 3`, return only the next-needed touch, not full sequence |
| **DPDP compliance** | No claims about "we have your data" · use legitimate-interest basis · include unsubscribe |
| **No alternate-data claims** | RBI rule — "signals not scores" — never imply we use credit-bureau data we don't |
| **UTM tagging** | Every link includes `utm_campaign={din_id}`, `utm_source`, `utm_medium`, `utm_content`, `utm_term` |
| **Subject line variants** | When generating multiple touches, vary subject style (hook → benefit → breakup) |
| **No emojis in subject** | India enterprise context — emojis read as spam |
| **No `Hi {first_name}` if name unknown** | Use `Hi there` or skip greeting — broken merge tags kill credibility |

## Spear-product hooks library

Reuse these as starting points (paraphrase, don't copy verbatim):

| Spear product | Hook angle |
|---|---|
| `secure-id` | "190M+ NTC coverage we built for {similar_company} — your fraud cost looks like it's at {industry_benchmark}%" |
| `payments-core` | "Saw you're on {competitor_in_use} — typical merchants at {employee_size} migrate when MDR + recon hours cross ₹X" |
| `payouts` | "Vendor payouts for {vertical} typically take {benchmark} hours; our customers run them in {cashfree_speed}" |
| `international-pg` | "Cross-border PG MDR sub-2% for INR settlement; {similar_co_name} cut FX cost by ~30%" |
| `payroll` | "Payroll + Payouts + Capital from one stack — {peer_company} saved {hours_per_month} on reconciliation" |

## Examples

### Good — Tier A, BFSI vertical, Secure ID spear

**Input prospect:** Head of Payments at HDFC Bank, BFSI Tier A, competitor in use = Karza, recent signal = "Hiring 2 Senior PMs for Onboarding".

**Touch 1 (output):**
```
Subject: Karza renewal coming up?

Hi Anita,

Saw HDFC's hiring 2 Senior Onboarding PMs — usually a signal that the V-CIP + KYC stack is being re-evaluated.

Quick context: Cashfree's Mobile360 layer adds NTC coverage (190M Indian adults) on top of bureau prefill — typically reduces dropout 18-22% vs Karza-only stack at peer banks.

Worth 15 min next week to compare against your current numbers? Tuesday 4pm IST works on my end.

Mothi
PMM, Cashfree Secure ID
```

CTA: Calendar-direct, specific time slot.
Personalization evidence: hiring signal + named competitor + named product (Mobile360).

### Bad — generic, no signal

❌ "Hi {first_name}, I came across your company and thought you might be interested in our payment solution. Can we set up a quick call to discuss?"

This violates: no specific signal, no spear product mention, no differentiator, generic CTA. Auto-reject in HITL review.

## Anti-patterns to avoid

- ❌ Sending Tier A copy to Tier C lists (over-personalization burns budget)
- ❌ Sending Tier C breakup email to Tier A prospect (insulting)
- ❌ Mentioning competitor pricing as "we're cheaper" (race-to-bottom; talk value)
- ❌ Using "AI-generated" tells: "I hope this email finds you well", "circling back", "touching base"
- ❌ Writing a 4th touch when frequency_cap_remaining = 0
- ❌ Skipping the unsubscribe link (DPDP violation + spam-complaint risk)

## Composition rules

Always loaded with:
- `content-strategist` (voice + 6-framework copy base)
- `follow-up-email` (2-touch cap, nudge-not-pushy patterns)
- `psy-trigs` (specific persuasion triggers per tier)
- `dpdp-compliance` (regulatory guardrails)

For Cashfree-specific brand voice, also load:
- `cashfree-outreach-agent` (existing cold outreach skill)
- `cashfree-brand-guidelines` (do/don't)
