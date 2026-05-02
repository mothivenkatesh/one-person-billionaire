---
name: pricing-tripler
description: >
  Use this skill whenever the user wants to set, raise, or audit the price of an
  AI/agent product. Trigger when the user mentions phrases like "what should I
  charge?", "should I raise prices?", "review my pricing page", "pricing model",
  "per-token billing", "free trial", "freemium", "annual discount", "should
  this be per-seat or usage-based?", or shares a current pricing page and asks
  for an audit. Also trigger when the user is preparing a launch, replacing
  a death-trap pricing model, or after Grand Slam Offer construction. Always
  use this skill instead of doing free-form pricing brainstorm — it enforces
  the death-trap rejection list, the 5-question test, and the 2-3× raise
  recommendation that most operators resist.
---

# Pricing Tripler Skill

This skill defines the workflow for **pricing AI/agent products** so they're not undercharged (the dominant failure mode) and not on a death-trap pricing model. Most operators undercharge by 2-3× because they confuse cost-plus with value-based and underestimate buyer willingness to pay. This skill fixes that.

The skill enforces:
- **Rejection of 3 death-trap models** (per-token billing, free trial without CC, free-forever without viral mechanics)
- **The 5-question undercharging test** — apply rigorously
- **2-3× raise recommendation** when the test indicates undercharging
- **Annual discount** as the cash-flow + retention lever
- **Test plan with kill criteria** — don't roll out price changes blind

---

## Hard Constraints (Check First)

### Constraint 1 — Required Inputs

Before recommending anything, confirm:
- **Current price per tier** (specific number)
- **Current ARPU** (avg revenue per customer per month)
- **Close rate on demos / trials** (last 30 days)
- **Last time price was raised** (months ago)
- **Has any prospect said "expensive" in last 30 days?** (Y/N)
- **Comparable manual workaround cost** (what they pay today to NOT use you)
- **Buyer type** (consumer, prosumer, SMB, mid-market, enterprise)
- **Average sales cycle length** (days)

If any are missing, ask before proceeding.

### Constraint 2 — Reject Death-Trap Models Immediately

Before scoring, check for the 3 death-trap models. If the user is on any, fix THIS first before raising price:

| Death-trap model | Why it kills |
|------------------|--------------|
| **Pure per-token billing** for end-user products | Customer can't predict bill = anxiety = churn. Your margin is thin and unpredictable. You absorb every model price change directly. Your "AI" looks like a utility, not a product. |
| **Free trial without credit card** | Trial-without-CC conversion: < 5%. Trial-with-CC conversion: 30-50%. The CC is a quality filter, not a barrier. |
| **Free-forever tier without viral mechanics** | Free users consume support, never convert (1-3% conversion industry-wide). Free attracts price-sensitive low-commitment buyers. The free tier sets perceived value of paid tier (low). |

If the user is on a death-trap, STOP and recommend the model fix BEFORE proceeding to pricing audit. Each fix is a separate skill invocation.

### Constraint 3 — Don't Bless Pricing Without the 5-Question Test

You MUST run the 5-question test before recommending any price. Skipping it = guesses, not data.

---

## Workflow Overview

```
Step 1: Confirm inputs + death-trap check
Step 2: Run the 5-question undercharging test
Step 3: Pick the right pricing model (per-seat / capped usage / value-based)
Step 4: Calculate the new price (2-3× current if undercharging)
Step 5: Add annual discount (15-20%) and tier structure
Step 6: Plan the 5-prospect test
Step 7: Set kill criteria
Step 8: Output the audit + new price + test plan
```

---

## Step 1 — Confirm Inputs + Death-Trap Check

Echo the inputs back to the user. Confirm no death-trap model. If death-trap detected:

> "⚠️ Your current model is [death-trap type]. This kills businesses faster than under-pricing. Before raising price, we need to migrate you off this model. Want me to walk through the migration path?"

Wait for confirmation before continuing.

---

## Step 2 — The 5-Question Undercharging Test

For each YES, the user is undercharged. Score honestly:

| # | Question | YES indicates |
|---|----------|---------------|
| 1 | Has nobody said "expensive" in the last 30 days? | Universal acceptance = under-priced |
| 2 | Has anyone said "what a steal" / "no-brainer" in the last 30 days? | Massive value gap above your price |
| 3 | Is your price below the manual workaround cost? | You're cheaper than the alternative they're using today |
| 4 | Is your price < 5% of the outcome value you provide to the customer? | Under-capturing value vs the result |
| 5 | Are you the lowest-priced option in the market? | You're racing to the bottom |

Verdict:
- **0 YES** → priced right; protect it
- **1 YES** → minor undercharging; raise 30-50%
- **2 YES** → moderate undercharging; raise 100% (2×)
- **3+ YES** → severe undercharging; raise 200% (3×)

---

## Step 3 — Pick the Right Pricing Model

The 3 models that actually work for B2B AI products in 2026:

| Model | When to use | Pros | Cons |
|-------|-------------|------|------|
| **Per-seat** | Clear individual user identity; default for B2B SaaS | Linear scaling, predictable, sales-friendly | Doesn't capture power-user upside |
| **Capped usage with margin** | Variable usage; value scales with consumption (lead enrichment, content gen, data processing) | Aligns price with value; protects against runaway via cap | More complex to communicate |
| **Value-based / per-outcome** | Measurable outcome ($/lead, $/contract, $/hour-saved) | Premium pricing justified | Requires outcome instrumentation |

**Default for most agent products:** per-seat.
**Switch to capped usage if:** usage is wildly variable (10× difference between light and heavy users).
**Switch to value-based if:** the outcome is objectively measurable and the customer benchmarks it against their alternative cost.

---

## Step 4 — Calculate the New Price

Floors for B2B AI products in 2026 (apply minimums; raise from there if undercharging test triggers):

| Tier | Floor | Target buyer |
|------|-------|--------------|
| Solo / individual | $99/mo | Individual contributor, solopreneur |
| Pro / team lead | $299/mo | Team lead, mid-level manager |
| Team / SMB | $999/mo | SMB or mid-market team |
| Enterprise | $2,000/mo+ (custom) | Enterprise buyer; list a starting number |

For consumer / prosumer products, floors are lower ($19-49/mo) but the same death-trap rules apply.

**Recommended new price:**
- Apply the multiplier from Step 2 (1.3×, 2×, or 3×) to current price
- Round to clean numbers ($99, $199, $299, $499, $999)
- Compare to floor; never go below
- If outcome value is high (audit defense, revenue impact, replacing a $60K/yr role), price 2-5× higher than floor

---

## Step 5 — Annual Discount + Tier Structure

### Annual plan (mandatory)

```
Monthly:  $___/mo
Annual:   $___/mo billed annually (15-20% off)
```

Annual customers churn 50% less + give you cash up front. Push annual hard in sales:
- Default to annual in pricing page toggle (lower number shown)
- Sales reps lead with annual quote
- Friction-free monthly is fine for v0; harder for $1K+/mo

### Tier structure (3 tiers max)

```
Starter ($X/mo)        →  Pro ($3X/mo)        →  Team ($9X/mo)
Most popular = Pro
Annual saves 15-20%
"Contact us" only for $5K+/mo enterprise (and even then, list a starting number)
```

NEVER use "Contact us" without a starting price. Kills small enterprise deals.

---

## Step 6 — The 5-Prospect Test Plan

Don't roll out price changes blind. Run a controlled test:

```
NEW PRICE TEST PLAN

Week 1:  Quote NEW price to next 5 prospects in pipeline.
Week 2:  Track close rate at new price vs historical close rate.

Decision rules:
- If close rate halved: settle 50% above old (you found ceiling)
- If close rate stable or down < 30%: ship the new price to all
- If close rate up: raise again next month

Don't change pricing for EXISTING customers without 60-day notice.
Grandfather them at old price for 6-12 months.
```

---

## Step 7 — Kill Criteria

If after 30 days of new pricing:
- Close rate dropped > 60% → settled too high; back off
- Refund rate spiked → buyers feel oversold; check whether GSO needs work
- Customer complaints about price → expected; ignore unless > 30% of new customers complain
- Revenue per close still below old × 0.7 → wrong direction; revert and re-diagnose

---

## Required Output Format

```
### 💰 Pricing Audit — [Product]

**Current price:**       $___/mo per [seat/usage unit/outcome]
**Current ARPU:**        $___
**Last raise:**          [N months ago]
**Death-trap?:**         [None / Per-token / Free trial / Free-forever]

### 5-Question Undercharging Test

| # | Question | Yes/No |
|---|----------|--------|
| 1 | Nobody said "expensive" in 30d? | __ |
| 2 | Anyone said "steal/no-brainer" in 30d? | __ |
| 3 | Below manual workaround cost? | __ |
| 4 | < 5% of outcome value? | __ |
| 5 | Lowest-priced option in market? | __ |
| **Total YES** | | **__/5** |

**Verdict:** [Priced right / Minor undercharging / Moderate / Severe]
**Recommended raise:** [1.0× / 1.3× / 2× / 3×]

### Recommended Pricing

| Tier | Old price | New price | Model | Annual (15-20% off) |
|------|-----------|-----------|-------|---------------------|
| Starter | | | Per-seat / Usage / Value | |
| Pro (most popular) | | | | |
| Team | | | | |
| Enterprise | | | | |

### Test Plan

Quote new price to next 5 prospects:
- Track close rate vs baseline
- Decision date: [day +14]
- Kill criteria: [specific numbers]

### Migration plan for existing customers

[Grandfather strategy — typically 6-12 months at old price]
```

---

## Worked Example

**User input:**
- Current price: $49/mo (single tier, per-seat)
- Current ARPU: $52/mo
- Close rate: 28% on demos
- Last raise: never (launched 8 months ago)
- "Expensive" in last 30d: 0 prospects
- "Steal" in last 30d: 2 prospects
- Manual workaround cost: $200/mo (offshore VA)
- Buyer: SMB ops manager
- Sales cycle: 14 days

**Death-trap check:** None. Continue.

**5-Question Test:**
1. Nobody said "expensive": YES
2. "Steal" in 30d: YES
3. Below workaround cost ($49 < $200): YES
4. < 5% of outcome value (claim: $5K/mo savings; 1% of value): YES
5. Lowest in market: NO (Lavender is $29; this product is $49)

**Score: 4/5 → Severe undercharging.**

**Recommended pricing:**
| Tier | Old | New | Model | Annual |
|------|-----|-----|-------|--------|
| Starter | $49 | $99 | Per-seat | $79/mo billed yearly |
| Pro | — | $299 | Per-seat | $239/mo billed yearly |
| Team | — | $999 | Per-seat | $799/mo billed yearly |

(Adding tiers is part of this audit — single-tier left money on the table for power users.)

**Test plan:** Quote $299 to next 5 prospects. Decision: day 14.

**Migration:** Grandfather existing customers at $49 for 12 months. Offer them annual at $49/mo billed yearly (still cheap, but locks in retention).

---

## Common Mistakes to Avoid

- **Pricing based on cost (cost-plus).** Customers don't care what it costs you; they care what it's worth to them.
- **Anchoring to competitor prices.** They might be wrong; you might be different.
- **Lowering price to close.** Trains customers to negotiate; signals desperation.
- **"We'll figure out pricing later."** Pricing is product. Decide on day 1; iterate from there.
- **One-size-fits-all single tier.** Leaves money on the table from power users.
- **Free-forever tier without viral mechanics.** High support cost, low conversion, attracts wrong customers.
- **"Contact us" without a starting price.** Kills small enterprise deals.
- **Changing existing-customer prices without notice.** 60-day notice + 6-12 month grandfather is standard.
- **Pure per-token billing for end-user products.** Death trap. Package into tiers.
- **Free trial without credit card.** < 5% conversion vs 30-50% with CC.
- **Same price for all geographies.** Often you can charge 2× in US vs India for the same product.
- **Skipping annual.** You're leaving 15-20% margin AND retention on the table.

---

## Notes on Tooling

For implementation:

| Need | Tool |
|------|------|
| Stripe billing | Stripe (no exceptions) |
| Tier-aware payment links | Stripe Payment Links + Subscriptions |
| Annual discount management | Stripe Coupons with `forever` duration |
| Grandfather pricing | Stripe Price Books + customer-specific Price IDs |
| Quote → CC capture | Stripe Checkout |
| Pricing page A/B test | GrowthBook / PostHog feature flags |
| Cancellation feedback | Cancellation flow with required reason capture |
| Refund automation | Stripe Refunds API |

For research:
- **Patrick Campbell (ProfitWell)** — pricing benchmarks by SaaS category
- **OpenView Partners** — annual SaaS pricing report
- **Kyle Poyar (Growth Unhinged)** — modern SaaS pricing data
- **Madhavan Ramanujam — Monetizing Innovation** — the framework

---

## Quick Reference — The Pricing Decision Tree

```
Is the user on a death-trap model?
├── YES → Fix the model FIRST (separate workflow)
└── NO  → Run 5-question test
          └── 0 YES   → Priced right; protect
              1 YES   → Raise 30-50%
              2 YES   → Raise 100% (2×)
              3+ YES  → Raise 200% (3×)
                        Add tiers if missing
                        Add annual plan
                        Test on 5 prospects
                        Roll out OR back off based on close rate
```

---

## Quick Reference — Floors by Buyer Type (2026)

| Buyer | Per-seat floor | Per-month floor (single-buyer) |
|-------|---------------|-------------------------------|
| Consumer | — | $9 |
| Prosumer | $19 | $19 |
| Solo SMB | $99 | $99 |
| Team SMB | $299 | $299/seat |
| Mid-market | $999 | $999/seat |
| Enterprise | $2,000+ | Custom |

If your price is below floor → fix this first.

---

## Source

Lesson 13: [Pricing AI Products](../../13-pricing-ai-products/README.md)

Pairs with:
- [`grand-slam-offer`](../grand-slam-offer/SKILL.md) — build the offer first
- [`margin-auditor`](../margin-auditor/SKILL.md) — make sure new price actually improves margin
- [`retention-cohort-analyzer`](../retention-cohort-analyzer/SKILL.md) — verify new pricing doesn't hurt retention
