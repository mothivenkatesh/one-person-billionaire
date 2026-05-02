# Lesson 13: Pricing AI Products

## TL;DR

The single most leveraged decision in your business — and the one most engineers undervalue. **Per-token pricing is a death trap** (you scale customers and lose money on each one). **Free trial / freemium is a churn engine** (free users teach you nothing). The 3 pricing models that actually work for AI products in 2026: per-seat, capped-usage with margin, and value-based outcomes. Pick one. Charge more than feels comfortable.

## Core idea

```
Pricing changes by 2x can take 30 minutes.
The result on revenue is the same as a year of feature work.
Price is the highest-ROI thing you'll ever change.
```

Most engineers price too low because:
- They feel guilty about charging for software they made
- They're afraid of rejection
- They benchmark against free alternatives
- They confuse "cost-plus" with "value-based"

Stop. Charge more.

## How it works in practice

### The 3 models that work

**1. Per-seat (the gold standard for B2B)**

```
$99/user/mo     — starter / individual contributor
$299/user/mo    — pro / team leads
$999/user/mo    — enterprise / power users
```

Why it works:
- Linear scaling with customer headcount (predictable revenue)
- Customer growth = your growth automatically
- Buyers understand it instantly
- No surprise bills (sales-friendly)

When to use: clear individual user identity, B2B SaaS pattern.

**2. Capped usage with margin**

```
$299/mo  →  includes 1,000 agent-runs
+$0.50 per additional run
Hard cap configurable by customer
```

Why it works:
- Customer pays more as they use it more (alignment)
- You bake in margin per unit
- Cap protects both sides from runaway bills

When to use: variable usage products, where the value scales with consumption (lead enrichment, content generation, data processing).

**Critical:** the cap protects YOU as much as the customer. Without a cap, one over-eager user = a $5K LLM bill you eat.

**3. Value-based outcomes**

```
$10/successful lead enriched (not per API call)
$50/contract reviewed (not per token)
20% of cost-savings (not per usage)
```

Why it works:
- Customer only pays for results, not effort
- You absorb model cost optimization upside
- Premium pricing is justifiable

When to use: clear measurable outcome, ROI is computable, customer has a benchmark for what the outcome is worth (lawyer's hourly rate, etc.)

### The 3 models that DON'T work

**1. Pure per-token billing**

```
$0.0001 per input token + $0.0003 per output token
```

Why it kills you:
- Customer can't predict their bill (anxiety = churn)
- Your margin is thin and unpredictable
- You absorb every model price change directly
- Your "AI" looks like a utility, not a product
- Power users punish your unit economics

The exception: API-first products selling to developers (where customer is already calibrated for token-based pricing). Even then, package into tiers.

**2. Freemium with a free tier "for marketing"**

```
Free: 10 runs/mo
Paid: $99 for unlimited
```

Why it usually fails:
- Free users consume support, never convert (industry conversion: 1-3%)
- "Free" attracts the wrong kind of customer (price-sensitive, low-commitment)
- Your support burden grows linearly with non-paying users
- The free tier sets the perceived value of the paid tier (low)

The exception: viral products with strong network effects (Notion, Figma, Slack early). For most AI products, **you do not have viral mechanics.** Don't pretend you do.

**3. Free trial with no credit card**

```
30-day free trial — no credit card required!
```

Why it usually fails:
- Trial-without-CC conversion: <5%
- Trial-with-CC conversion: 30-50%
- The friction of entering a credit card is a *quality filter*, not a barrier
- Without it, your trial users are tire-kickers

If you do trials, **require a credit card.** Convert serious buyers. Skip the rest.

### Annual discounts (the cash-flow lever)

```
Monthly:  $299/mo
Annual:   $249/mo billed annually ($2,988 upfront, ~17% off)
```

Why annual matters:
- Cash upfront = runway / no churn worry for 12 months
- Lower CAC payback period
- Customers who commit annually churn 50% less (selection bias is real)

**Push annual hard** in your sales process. Even at 20% discount, an annual customer is 5× more valuable than a monthly one (longer LTV, less churn, less support).

### Charging "more than feels comfortable"

The test: if you've never had a prospect say *"that's expensive,"* you're under-priced. Some pushback on price means you're calibrated. Universal acceptance means you're leaving money on the table.

The honest exercise:
- Current price: ____
- Double it. New price: ____
- Send the new price to the next 5 prospects. Track close rate.
- If close rate halved: you were priced right
- If close rate stayed the same: you've been undercharging by 2x for months
- If close rate went to zero: you went too far; settle in the middle

Most operators discover the doubled price wins on revenue (fewer customers × higher price = more $$).

### Pricing page anatomy that converts

- **3 tiers** (most psychologically optimal)
- **Middle tier highlighted** ("Most popular")
- **Annual toggle** (default to annual to anchor the savings)
- **Specific feature differences** (not "everything in starter, plus more")
- **Outcome-oriented copy** ("Process 10,000 leads/mo" beats "10,000 API calls")
- **No "Contact us"** unless your enterprise tier is genuinely custom (and even then, list a starting price)

The "Contact us" tier kills small enterprise deals. Always list a number.

## Common traps

| Trap | Why |
|---|---|
| Pricing based on cost (cost-plus) | Customers don't care what it costs you; they care what it's worth to them |
| Anchoring to competitor prices | They might be wrong; you might be different |
| Lowering price to close | Trains customers to negotiate; signals desperation |
| "We'll figure out pricing later" | Pricing is product. Decide on day 1, iterate from there |
| One-size-fits-all single tier | Leaves money on the table from power users |
| Free forever tier | High support cost, low conversion, attracts wrong customers |
| Refund-friendliness as a moat | Refunds aren't a moat. Quality is. |

## The 5 questions to answer before you price

1. **Who's the buyer?** (not the user — the credit card holder)
2. **What's the manual workaround they're replacing?** (price 30-60% of that cost)
3. **What's the outcome worth?** (price 5-15% of the outcome value)
4. **Who's the comparable competitor?** (price near or above)
5. **What price makes you nervous?** (probably the right one)

## Exercise

**Triple your current price for the next 5 prospects.**

If you're at $99/mo, quote $297. If you're at $299, quote $899.

Track:
- Close rate at the new price
- Specific objections (what reasons given for "no")
- Revenue per customer at the new price

Most readers won't do this. They'll find a reason ("but my customer isn't ready"). The reader who does it discovers their pricing was wrong by 2-3x for months — and walks away with permanently better unit economics.

If revenue per close drops more than 60%, settle at 2x your old price (still 2x more revenue). If it doesn't drop more than 60%, you found the new floor.

## Further reading

- Patrick Campbell (ProfitWell), [Pricing research papers](https://www.priceintelligently.com/) — the data
- Jason Cohen, [Pricing for SaaS](https://blog.asmartbear.com/) — the bootstrapped operator angle
- Madhavan Ramanujam, *Monetizing Innovation* — the framework
- Kyle Poyar, [Growth Unhinged Substack](https://www.growthunhinged.com/) — modern SaaS pricing data

---

[← Lesson 12](../12-communities-and-affiliates/README.md) | [Next → Lesson 14: Margin Engineering](../14-margin-engineering/README.md)
