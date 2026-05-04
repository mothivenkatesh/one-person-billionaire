---
name: icp-scout
description: Daily prospect ingestion + ICP scoring against mothi ICP across BFSI, D2C, SaaS, and Marketplace verticals. Returns 0-5 ICP fit score with evidence trail.
version: 0.1.0
owner: pmm@mothi.com
status: draft
depends_on: [content-strategist, dpdp-compliance]
tested_with: claude-haiku-4-5
loads_for_agents: [icp-scout, cross-sell-detector]
---

# icp-scout — mothi ICP scoring skill

## When to use this skill

Load this skill when an agent needs to:
- Score a new lead/account against mothi's ICP (output: 0-5)
- Tier the account (A · B · C · plg · long_tail)
- Decide whether to enrich further, route to AE, or disqualify
- Generate a one-paragraph evidence summary citing concrete signals

This skill is invoked by:
- `icp-scout` agent (daily 6am cron + Google Forms inbound webhook)
- `cross-sell-detector` agent (when scoring an existing merchant against a new product's ICP)

## Inputs expected

The agent provides a JSON object:

```json
{
  "account": {
    "name": "string",
    "domain": "string",
    "industry": "string | null",
    "employees": "int | null",
    "annual_revenue_inr": "int | null",
    "vertical_hint": "bfsi | d2c | saas | marketplace | other | unknown"
  },
  "enrichment": {
    "tech_stack": ["array of detected vendors"],
    "linkedin_company_url": "string | null",
    "recent_funding": "string | null",
    "recent_news_summary": "string | null",
    "ahrefs_traffic_30d": "int | null",
    "ahrefs_traffic_change_pct": "float | null",
    "intent_signals": ["array of intent signal types"]
  },
  "contact_persona": "cfo | cto | founder | head_of_payments | head_of_growth | other | unknown"
}
```

## Outputs expected

Return a JSON object (validated by Pydantic on the agent side):

```json
{
  "icp_score": 0.0,
  "intent_score": 0.0,
  "tier": "A | B | C | plg | long_tail | disqualified",
  "vertical": "bfsi | d2c | saas | marketplace | other",
  "evidence_summary": "1-2 sentence cited evidence string",
  "recommended_action": "route_to_ae | route_to_sdr | nurture | disqualify | needs_more_data",
  "disqualification_reason": "string | null",
  "next_signal_to_watch": "string | null"
}
```

## Body — the scoring logic

mothi's ICP is **not horizontal**. We sell payments + payouts + Secure ID + Payroll + Capital + International PG into specific verticals. Score by composite of fit + intent + accessibility.

### Vertical disqualifiers (apply first — these are auto-low scores)

| Vertical | Disqualify if |
|---|---|
| **BFSI / lending** | <₹50 Cr book · no NTC use case · locked into Karza/HyperVerge with active multi-year contract |
| **D2C / ecom** | <₹5 Cr GMV · pure marketplace seller (no own checkout) · using Razorpay <12 months |
| **SaaS subscription** | <₹5 Cr ARR · no recurring billing model · Stripe-locked global SaaS with dedicated payments engineer |
| **Marketplaces** | <₹100 Cr GMV · no payout volume · no escrow requirements |

If disqualified → `tier: "disqualified"` with `disqualification_reason` cited. Score = 0.

### ICP fit scoring (0-5)

Apply weighted composite:

| Dimension | Weight | Signals |
|---|---|---|
| **Vertical fit** | 1.5 | BFSI · D2C · SaaS · Marketplaces = +1.5; adjacent (EdTech, HealthTech) = +0.75; off-vertical = 0 |
| **Size fit** | 1.0 | 100-1000 employees = +1.0 (mid-market sweet spot); 1000-5000 = +0.75 (strategic); 5000+ = +0.5 (enterprise — longer cycle); <100 = +0.25 (PLG) |
| **Tech stack signal** | 1.0 | Currently uses competitor (Razorpay, PayU, Stripe, BillDesk) = +1.0 (displacement opportunity); has Shopify/Magento + no payment gateway flagged = +0.75; no signal = +0.25 |
| **Intent signal** | 1.5 | Bombora intent surge (when present) = +1.0; Ahrefs traffic spike >30% MoM = +0.75; recent funding announcement = +1.5; hiring "Head of Payments" = +1.5; G2 review of competitor = +1.0 |

**Cap at 5.0.** Round to 1 decimal.

### Tier assignment from composite score

| ICP score | Tier | Treatment |
|---|---|---|
| 4.5+ | A (Lighthouse) | 1:1 ABM, exec-led, AE+PMM ownership |
| 3.5-4.5 | B (Strategic) | 1:few ABM, AE-led with agent assist |
| 2.5-3.5 | C (Mid-market) | Automated outbound (Smartlead + 20-domain rotation) |
| 1.5-2.5 | plg | Self-serve nurture, MoEngage lifecycle only |
| 0-1.5 | long_tail | Disqualify or annual re-evaluation |

### Persona modifier

If `contact_persona` is decision-maker for the spear product, add +0.5 to ICP score:
- BFSI vertical × persona_type = `head_of_payments` or `cto` → +0.5
- D2C vertical × persona_type = `founder` or `head_of_growth` → +0.5
- SaaS vertical × persona_type = `cfo` or `cto` → +0.5
- Marketplaces × persona_type = `head_of_ops` or `cfo` → +0.5

### Evidence summary requirements

Always cite at least 2 specific signals from the input. Example good output:

> "Mid-market D2C cosmetics brand (₹18 Cr GMV est., 280 employees), currently on Razorpay per BuiltWith, traffic +47% MoM per Ahrefs, hiring Head of Finance per LinkedIn — strong displacement window."

## Examples

### Good input → good output

**Input:**
```json
{
  "account": {"name": "Plum Skincare", "domain": "plumgoodness.com", "industry": "D2C cosmetics", "employees": 320, "vertical_hint": "d2c"},
  "enrichment": {"tech_stack": ["Shopify", "Razorpay", "Klaviyo"], "ahrefs_traffic_change_pct": 0.42, "recent_news_summary": "Series C funded ₹450 Cr Mar 2026", "intent_signals": ["g2_competitor_view"]},
  "contact_persona": "head_of_growth"
}
```

**Expected output:**
```json
{
  "icp_score": 4.7,
  "intent_score": 3.8,
  "tier": "A",
  "vertical": "d2c",
  "evidence_summary": "Mid-market D2C with strong displacement signal: on Razorpay per BuiltWith, +42% traffic 30d, Series C just closed (₹450Cr budget), Head of Growth as champion-fit persona for D2C motion.",
  "recommended_action": "route_to_ae",
  "disqualification_reason": null,
  "next_signal_to_watch": "Pricing page visit OR Razorpay contract renewal date (typical India fintech 12-18mo cycle)"
}
```

### Bad input → disqualification

**Input:**
```json
{
  "account": {"name": "Tiny Fashion Store", "industry": "ecommerce", "employees": 8, "vertical_hint": "d2c"},
  "enrichment": {"tech_stack": ["Wix"], "ahrefs_traffic_30d": 1200, "intent_signals": []},
  "contact_persona": "founder"
}
```

**Expected output:**
```json
{
  "icp_score": 0.0,
  "tier": "disqualified",
  "vertical": "d2c",
  "evidence_summary": "Sub-scale D2C: 8 employees, 1200 monthly visits = under <₹5Cr GMV threshold. No intent signals, no competitor displacement opportunity.",
  "recommended_action": "disqualify",
  "disqualification_reason": "Below D2C size threshold (employees<100, traffic<5K/mo); should self-serve via PLG funnel only.",
  "next_signal_to_watch": "Re-evaluate annually OR if hits 50+ employees"
}
```

## Composition rules

This skill loads alongside:
- **Always:** `dpdp-compliance` (DPDP signals-not-scores rule applies to scoring)
- **Always:** `content-strategist` (for evidence_summary phrasing)
- **For BFSI accounts:** `secure-id-comms` + `dpdp-act` deeper context
- **For D2C accounts:** `d2c-india-context` (vertical playbook)
- **For SaaS accounts:** `saas-india-context`

## Anti-patterns to avoid

- ❌ Don't score on title alone — title without signals = `needs_more_data`
- ❌ Don't apply persona modifier without verified contact_persona — keep at base score
- ❌ Don't disqualify silently — always populate `disqualification_reason`
- ❌ Don't recommend `route_to_ae` for tier C/below — capacity constraint
- ❌ Don't invent signals not in input — fabrication breaks the audit chain
