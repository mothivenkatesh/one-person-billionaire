# Lesson 14: Margin Engineering

## TL;DR

The reason most AI startups die in 2026 isn't lack of customers — it's negative gross margin at scale. They sell $99/mo plans that cost them $120/mo in LLM bills. They look like growth darlings on top-line, then implode. **You will not have this problem if you measure cost per customer from day 1 and engineer your stack to keep gross margin above 70%.** This lesson is the playbook.

## Core idea

```
Gross Margin  =  (Revenue per customer  −  Cost to serve per customer)  / Revenue per customer

Healthy SaaS:        80%+
Healthy AI product:  70%+
Death zone:          <50%
```

Software historically had 90%+ margins because the marginal cost was near zero. AI products have a real marginal cost (LLM tokens, model runtime). If you don't actively engineer the margin, you're a "negative-margin startup at scale."

## How it works in practice

### Step 1: measure cost per customer (today)

You can't engineer what you don't measure. Build this metric on day 1.

```python
# For each customer, track:
- LLM input tokens consumed (per session)
- LLM output tokens consumed (per session)
- Tool/API call costs (search APIs, third-party integrations)
- Storage / DB cost (usually small but track)
- Hosting cost (amortized per customer)

# Per-customer monthly cost:
total_cost / number_of_customers

# Per-customer revenue:
their_subscription_price

# Gross margin:
(revenue - cost) / revenue
```

If you don't know each customer's cost-to-serve right now, **stop reading and instrument it.**

### Step 2: model routing

Use the cheapest model that passes evals for each step. Most products use one model for everything; you're paying 3-10× more than you need to.

```
Intent classification         →  Haiku 4.5      ($)
Information retrieval         →  Sonnet 4.6     ($$)
Complex reasoning             →  Opus 4.7       ($$$)
Output formatting             →  Haiku 4.5      ($)
Safety / classification       →  Haiku 4.5      ($)
```

Real-world impact: a customer interaction that costs $0.30 with Sonnet across all steps drops to $0.08 with proper routing. **3.75× cost reduction without quality loss** if your routing is calibrated by evals.

### Step 3: prompt caching

Anthropic charges 10% for cached prefixes. If your system prompt is 10K tokens (skill descriptions, examples, etc.), caching saves 90% on every subsequent call.

```python
# Without caching:
10,000 tokens × $3/M × 100 calls/customer/mo = $3.00/customer/mo

# With caching:
First call:  10,000 × $3/M = $0.03 (write to cache)
Next 99:     10,000 × $0.30/M = $0.0003 each = $0.0297 total
Total: $0.06/customer/mo

Savings: 98%
```

This is **free** money. Every cacheable prefix you don't cache is a leak.

### Step 4: semantic + exact match caching

For common queries:

| Cache type | When to use | Hit rate |
|---|---|---|
| **Exact match** | FAQ-style queries; same input repeated | 5-15% |
| **Semantic match** | Same meaning, different words ("how do I cancel" vs "cancel my subscription") | 20-40% |
| **Tool result cache** | Stable data (product catalogs, schemas, prices) | 50-90% |

Tools: Anthropic's prompt cache (built-in), Helicone for semantic cache, Redis for tool-result cache.

### Step 5: token discipline

Many cost wins are just tighter prompts:

| Slop | Fix |
|---|---|
| 5KB system prompt with everything | 1KB system prompt + skills loaded on demand |
| Dumping full HTML to the model | Extract relevant text first |
| Tool schemas for 50 tools | Show only the 5 relevant ones per turn |
| Long conversation history | Summarize-and-replace at threshold |
| Verbose JSON schema in every call | Reference, don't inline |

Each fix typically saves 10-30%. Combined: 50%+.

### Step 6: per-customer hard limits

Set monthly token caps per customer. When hit:
- Polite degradation: "You've reached your fair-use limit. Upgrade or wait until next cycle."
- Don't let a single power user blow your monthly P&L

Tier example:

```
Starter   ($99/mo):   100K tokens included, $0.50/10K after
Pro       ($299/mo):  500K tokens included, $0.30/10K after
Enterprise ($999/mo): 5M tokens included, custom overage
```

This both protects margin **and** creates upgrade paths.

### The brutal math: the unit economics table

For your average customer, after engineering:

| Stack choice | Cost / customer / mo | Margin at $99 ARPU |
|---|---|---|
| Naive (Sonnet, no cache, no routing) | $40-80 | 20-60% (bad) |
| + Model routing | $20-40 | 60-80% |
| + Prompt caching | $10-25 | 75-90% |
| + Semantic cache | $5-15 | 85-95% (great) |

The difference between "death" and "fundable business" is about **3 weekends of engineering work**. Most operators never do it.

### When margin is *supposed* to be lower

- **High-touch enterprise**: lower gross margin is OK if account is sticky and ACV is high
- **Land-and-expand SaaS**: starter tier can be near-zero margin if it converts to a $10K/yr plan
- **Network effect plays**: subsidize early users to get to critical mass (rare for AI products)

These are exceptions. Default rule: 70%+ gross margin.

## Common traps

| Trap | Why |
|---|---|
| Measuring cost monthly instead of per-customer | You miss the heavy users killing your average |
| One-model-for-everything | 3-10× over-spending on simple steps |
| Ignoring prompt caching | Free money left on the table |
| "We'll fix margin at scale" | At scale, low-margin × big revenue = big losses |
| Free-tier users with no token limit | One Reddit moment = $10K bill |
| Long context windows by default | Each token is paid; load on demand |
| Not tracking per-customer cost | If you don't measure it, you can't fix it |

## The 5 numbers you must know weekly

1. Gross margin %
2. Cost per active customer
3. Top 5 most expensive customers (and why)
4. Cost per LLM call (averaged)
5. Cache hit rate (semantic + prompt)

If any move the wrong direction for 2 consecutive weeks, drop everything and investigate.

## Exercise

For your current product (or your prototype):

1. Pick your highest-token customer/session in the last 30 days
2. Calculate the actual cost
3. Implement the 3 cheapest wins (model routing, prompt caching, tool result truncation)
4. Re-run the same workload
5. Calculate the new cost

Aim for 50%+ reduction. If you don't hit it, you have more headroom you haven't found.

Repeat quarterly. **This is the only "growth hack" that compounds.**

## Further reading

- Hamel Husain, [LLM cost engineering](https://hamel.dev/) — the practical guide
- Anthropic, [Prompt caching docs](https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching) — the official
- Helicone, [Caching for AI products](https://helicone.ai/) — semantic cache implementation
- Eugene Yan, [Cost-quality tradeoffs](https://eugeneyan.com/) — the framework

---

[← Lesson 13](../13-pricing-ai-products/README.md) | [Next → Lesson 15: The Retention Problem](../15-the-retention-problem/README.md)
