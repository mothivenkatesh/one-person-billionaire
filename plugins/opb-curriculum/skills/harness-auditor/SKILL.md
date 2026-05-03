---
name: harness-auditor
description: >
  Use this skill whenever the user wants to audit the harness around their AI
  product across all 3 layers (Personal / Runtime / Product) and identify which
  layer their actual moat lives in. Trigger when the user mentions phrases like
  "what's my moat?", "review my agent stack", "is my product defensible?", "am
  I just a wrapper?", "audit my harness", "harness layers", or "what should I
  invest in next?". Also trigger when the user is preparing for a competitor
  threat, planning a 12-month roadmap, or feeling stuck despite shipping fast.
  Always use this skill instead of free-form moat brainstorm — it forces the
  3-layer breakdown, scores each layer, and rejects "personal stack as moat"
  framings.
---

# Harness Auditor Skill

This skill defines the workflow for auditing the **3-layer harness** around an AI/agent product (Personal / Runtime / Product) and telling the user — bluntly — where their moat actually lives. The Layer 3 / Product harness is the only one that's defensible vs commoditization. Most operators over-invest in Layer 1 (personal velocity) and under-invest in Layer 3 (business moat). This skill identifies the gap.

The skill enforces:
- **3-layer breakdown** — Personal / Runtime / Product (refuses single-layer framing)
- **Time-allocation honesty** — measures where the user actually spent the last quarter
- **Layer 3 priority** — pushes back if user calls Layer 1 or 2 their "moat"
- **30-day investment plan** with specific Layer 3 actions
- **Wrapper test** — applied separately for each layer

---

## Hard Constraints (Check First)

### Constraint 1 — Required Inputs

Before scoring, confirm the user has provided:
- **Product description** (1-2 sentences)
- **Wedge / target buyer**
- **Last 90 days** — what specific work was done across personal stack / runtime / product?
- **Time allocation** estimate: % of last quarter on each layer
- **Top 5 churned customers' reasons for leaving** (if any churn happened)
- **Closest direct competitor** (named)

If any are missing, ask before continuing.

### Constraint 2 — Reject Single-Layer Framing

If the user says "my harness is great because of [X]" referring to ONE thing, push back:

> "There are 3 distinct harness layers — Personal, Runtime, Product. They serve different purposes. Let's break down each. A great Layer 1 (your Claude Code setup) doesn't translate to a Layer 3 moat (product defensibility)."

### Constraint 3 — Refuse "Personal Stack as Moat" Claims

If the user calls their Claude Code setup, custom MCPs, or builder tooling a "moat":

> "Personal harness is a builder's accelerator, not a moat. Your competitors have access to Claude Code too. They can install your published skills. The moat lives in Layer 3 (product harness) — what makes the customer-facing PRODUCT harder to leave or replicate."

---

## Workflow Overview

```
Step 1: Confirm inputs + classify layer-by-layer
Step 2: Score each layer 1-10 on owned vs rented
Step 3: Apply the wrapper test PER LAYER
Step 4: Identify the moat type (5 options) in Layer 3
Step 5: Audit time allocation vs target
Step 6: Pick ONE 30-day Layer 3 sprint
Step 7: Output the audit
```

---

## Step 1 — Classify the 3 Layers

### Layer 1: Personal Harness (builder's stack)

What the user uses while BUILDING. Doesn't transfer to customers.

Inventory:
- Claude Code / Cursor / Codex setup
- Custom skills they use as a builder (e.g., `wedge-finder`, `cold-outbound-drafter`)
- MCPs (GitHub, Stripe, scrapers, etc.)
- Hooks (auto-context, post-tool validation)
- Slash commands
- Personal CLAUDE.md / AGENTS.md / .cursorrules

### Layer 2: Runtime Harness (production infra)

What runs CUSTOMER-FACING agents in production at request time.

Inventory:
- Workflow engine (Inngest / Temporal / Cloudflare Workflows / Hive / Step Functions / DIY cron)
- Observability stack (Langfuse / Helicone / OpenTelemetry / DIY)
- Eval harness (Promptfoo / Inspect / Braintrust / DIY)
- Reliability primitives (idempotency, retries, DLQs, circuit breakers — see [`boring-stack-auditor`](../boring-stack-auditor/SKILL.md))
- Permission / sandbox layer
- Cost control (per-customer caps, model routing — see [`margin-auditor`](../margin-auditor/SKILL.md))

### Layer 3: Product Harness (the actual moat)

What makes the PRODUCT defensible vs competitors using the same model + runtime.

Classify against the 5 moat types:
- **Data moat** — customer-specific data accumulating over time
- **Workflow moat** — multi-step lock-in across customer's daily routine
- **Distribution moat** — you reach customers cheaper
- **Brand moat** — trust in a specific vertical
- **Integration moat** — plugged into customer's other tools

---

## Step 2 — Score Each Layer

For each layer, score 1-10:

```
Layer 1: Personal Harness
- Sophistication of own toolkit (1-10): __
- Velocity multiplier estimated (1-10): __
- Layer 1 total: __ /20

Layer 2: Runtime Harness
- Reliability primitives in place (1-10): __
- Observability completeness (1-10): __
- Cost discipline (1-10): __
- Layer 2 total: __ /30

Layer 3: Product Harness (THE MOAT)
- Data moat (1-10): __
- Workflow moat (1-10): __
- Distribution moat (1-10): __
- Brand moat (1-10): __
- Integration moat (1-10): __
- Layer 3 total: __ /50
```

The scores aren't equal-weighted: Layer 3 carries the most because it's the only layer that compounds into defensibility.

---

## Step 3 — Apply the Wrapper Test (Per Layer)

For each layer separately:

**Layer 1:** "If Anthropic ships a better Claude Code with everything I built, do I lose anything important?"
- YES → your Layer 1 was your "moat" (it isn't); push back
- NO → healthy; you're using Claude Code as the accelerator it's meant to be

**Layer 2:** "If Anthropic ships an Agent Engine with built-in workflows / observability, do I lose competitive advantage?"
- YES → you over-invested in proprietary runtime; commoditize and move on
- NO → you picked a sustainable runtime layer

**Layer 3:** "If Anthropic releases your headline product feature in their next release, do you die?"
- YES instantly → wrapper. Layer 3 is non-existent. THIS IS THE EMERGENCY.
- NO, but you'd lose 30%+ users → fragile Layer 3
- NO, customers can't easily leave → real Layer 3 moat

---

## Step 4 — Identify the Moat Type in Layer 3

For Layer 3 specifically, classify:

| Moat type | Score 1-10 | Specific example in your product |
|-----------|-----------|----------------------------------|
| Data moat | __ | (e.g., "We have 6 months of customer-specific tone preferences") |
| Workflow moat | __ | (e.g., "We're in their Monday morning routine") |
| Distribution moat | __ | (e.g., "We own the FL paralegal Slack") |
| Brand moat | __ | (e.g., "We're known for compliance in fintech") |
| Integration moat | __ | (e.g., "We sync with HubSpot + Stripe + Slack natively") |

The HIGHEST-scoring moat type is your strategy. Don't try to build all 5.

If all 5 score below 6 → you have no moat. Customer churn will be a forever problem. Run [`retention-cohort-analyzer`](../retention-cohort-analyzer/SKILL.md) and consider whether the wedge needs revisiting.

---

## Step 5 — Audit Time Allocation

The user must report HONESTLY on last quarter:

```
Last quarter actual time allocation:
- Layer 1 (personal stack work): __%
- Layer 2 (runtime infra work): __%
- Layer 3 (product moat work): __%
```

Compare to target by year:

| Stage | Target L1 | Target L2 | Target L3 |
|-------|-----------|-----------|-----------|
| Year 1 | 40% | 30% | 30% |
| Year 2 | 20% | 30% | 50% |
| Year 3+ | 10% | 20% | 70% |

If actual L3 is < 50% of target → user is over-investing in non-moat work. This is the dominant solo-operator failure mode.

---

## Step 6 — Pick ONE 30-Day Layer 3 Sprint

Based on the highest-scoring moat type from Step 4, prescribe ONE specific 30-day investment:

**Data moat sprint:**
- Identify what customer-specific data could compound
- Add storage + retrieval layer
- Make next session BETTER because of past sessions
- Measure: % of returning customers whose outputs improved over 30 days

**Workflow moat sprint:**
- Identify the customer's recurring routine where you could embed
- Add a time-bound trigger (8am brief, Monday recap, pre-meeting prep)
- Measure: % of customers using the trigger weekly

**Distribution moat sprint:**
- Pick ONE community/channel to own
- Spend 30 days being USEFUL there (no promotion)
- Measure: inbound DMs / signups / brand mentions

**Brand moat sprint:**
- Pick ONE vertical to dominate
- Build 1 compounding asset (data report, vs page, free tool)
- Measure: top-of-funnel from the vertical

**Integration moat sprint:**
- Pick ONE adjacent tool your customer also uses
- Build a deep, native integration (not just an API call)
- Measure: % of customers who connect the integration in first 14 days

DON'T try multiple sprints in parallel. Pick ONE; execute; re-audit in 60 days.

---

## Required Output Format

```
### 🛡️ Harness Audit — [Product]
**Date:** [today]
**Stage:** [Year 1 / 2 / 3+]

### Layer 1: Personal Harness
Score:                __/20
Wrapper test:         [Healthy / Over-invested]
Investment last Q:    __% (target [40/20/10])

### Layer 2: Runtime Harness
Score:                __/30
Wrapper test:         [Healthy / Over-invested]
Investment last Q:    __% (target [30/30/20])

### Layer 3: Product Harness (THE MOAT)
Score:                __/50
Wrapper test:         [Real moat / Fragile / NONE = wrapper]
Investment last Q:    __% (target [30/50/70])

Moat type breakdown:
| Moat | Score | Specific example |
|------|-------|------------------|
| Data | __ | |
| Workflow | __ | |
| Distribution | __ | |
| Brand | __ | |
| Integration | __ | |

DOMINANT MOAT TYPE:   [pick highest]

### Honest verdict

[Wrapper / Fragile product / Real product / Strong product]

### 30-Day Sprint

Type:                 [Data / Workflow / Distribution / Brand / Integration]
Specific actions:
1.
2.
3.
Success metric:       [specific number]
Re-audit date:        [60 days]
```

---

## Worked Example

**User input:**
- Product: AI bookkeeping for $1M+ Shopify sellers
- Wedge: SMB e-commerce founders / CFOs
- Last 90 days: built 4 new skills for personal use, set up Inngest, added 1 customer-specific feature
- Time allocation: L1: 60% / L2: 30% / L3: 10%
- 5 churned: 3 said "I don't trust AI with my books" / 2 said "switched to my CPA"
- Closest competitor: Pilot.com (well-funded)

**Layer 1 score: 16/20** (great Claude Code stack; lots of personal velocity).
**Layer 2 score: 18/30** (Inngest set up; observability missing; cost tracking missing).
**Layer 3 score: 12/50** (only 1 product feature shipped that compounds — customer-specific Shopify rules).

**Moat type breakdown:**
- Data: 4 (some customer rule storage but doesn't compound)
- Workflow: 2 (not in customer's daily routine)
- Distribution: 1 (no owned channel)
- Brand: 2 (no vertical authority)
- Integration: 3 (basic Shopify + Stripe sync)

**Wrapper test:**
- Layer 1: Healthy
- Layer 2: Healthy
- Layer 3: **WRAPPER**. If Pilot.com adds AI auto-categorization (likely Q2), this product dies.

**Time allocation:** L1: 60% / L3: 10%. Year 2 target: L1: 20% / L3: 50%. **Severe under-investment in moat.**

**Verdict:** Fragile wrapper masquerading as a product.

**30-day sprint:**
- Type: **Brand moat** (vertical: Shopify Plus brands $1-10M GMV)
- Actions:
  1. Survey 50 Shopify Plus founders on their bookkeeping pain → publish data report
  2. Build "Shopify P&L Calculator" free tool with email capture
  3. Get 5 named case studies from existing customers (named, with $ saved)
- Success metric: 200 email captures from the report + tool by day 30
- Re-audit date: day 60

---

## Common Mistakes to Avoid

- **Calling personal stack a moat.** It isn't. Push back hard.
- **Calling runtime (Inngest / Hive) a moat.** It isn't. Commodity infra.
- **Trying to build all 5 moat types simultaneously.** Pick ONE.
- **"Better prompts" as a moat.** Get copied in a weekend.
- **"We're cheaper" as a moat.** Race to the bottom kills startups.
- **"We're first" as a moat (without compounding).** First-mover advantage requires accumulating data/network effects.
- **Spending Q after Q on Layer 1 polish.** Diminishing returns; should be < 20% of time after Year 1.
- **No instrumented time tracking.** "I think I spent 30% on moat" without data = you spent 5%.
- **Skipping the wrapper test.** It's brutal but reveals the truth.
- **Refusing to ship moat work because "it's not as fun as building."** Yes — and that's why most operators stay wrappers.

---

## Notes on Tooling

For tracking time allocation honestly:
- **RescueTime** — passive tracker
- **Toggl** — active categorization
- **Sunsama** — daily intentional planning + retro
- **DIY** — Notion table with weekly time-spent buckets

For Layer 3 moat work specifically:
- **Customer interview tools:** Grain (auto-record + transcribe), Tella, Riverside
- **Data accumulation patterns:** see [`retention-cohort-analyzer`](../retention-cohort-analyzer/SKILL.md)
- **Distribution: see** [`build-in-public-drafter`](../build-in-public-drafter/SKILL.md), [`compounding-content-builder`](../compounding-content-builder/SKILL.md), [`community-engagement-planner`](../community-engagement-planner/SKILL.md)
- **Brand work:** [`grand-slam-offer`](../grand-slam-offer/SKILL.md) for naming + positioning

---

## Quick Reference — The 3 Layers at a Glance

| Layer | What it is | What runs there | Is it a moat? |
|-------|-----------|-----------------|---------------|
| **1: Personal** | Your builder's stack | Claude Code, Cursor, your skills, your MCPs | **NO** (accelerator) |
| **2: Runtime** | Production infra for customer-facing agents | Inngest, Temporal, Cloudflare Workflows, Hive | **NO** (commodity) |
| **3: Product** | Wedge-specific defensibility layer | Data, workflow, distribution, brand, integrations | **YES** (compounds) |

---

## Quick Reference — Time Allocation by Stage

```
Year 1    Year 2    Year 3+
L1 (Personal)         40%       20%       10%
L2 (Runtime)          30%       30%       20%
L3 (Product moat)     30%       50%       70%   ← THE COMPOUNDING ONE
```

If L3 is < 50% in Year 2+, that's the problem. Re-allocate.

---

## Source

Lesson 02: [The Harness Is the Moat](../../02-the-harness-is-the-moat/README.md)

Pairs with:
- [`boring-stack-auditor`](../boring-stack-auditor/SKILL.md) — Layer 2 reliability
- [`production-readiness-audit`](../production-readiness-audit/SKILL.md) — Layer 2 production
- [`retention-cohort-analyzer`](../retention-cohort-analyzer/SKILL.md) — measure if Layer 3 is working
- [`compounding-content-builder`](../compounding-content-builder/SKILL.md) — Layer 3 distribution moat
