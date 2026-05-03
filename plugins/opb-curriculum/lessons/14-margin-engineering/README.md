# Lesson 14: Margin Engineering

## TL;DR

The reason most AI startups die in 2026 isn't lack of customers — it's **negative gross margin at scale**. They sell $99/mo plans that cost them $120/mo in LLM bills. They look like growth darlings on top-line; they implode when the LLM bill catches up. **You will not have this problem if you measure cost-per-customer from day 1 and engineer your stack to keep gross margin above 70%.** This lesson is the playbook — the deepest one in Part 4.

## Core idea

```
Gross Margin  =  (Revenue per customer  −  Cost to serve per customer)  / Revenue per customer

Healthy SaaS:        80%+
Healthy AI product:  70%+
Death zone:          <50%
```

Software historically had 90%+ margins because the marginal cost was near zero. AI products have a real marginal cost (LLM tokens, model runtime, vector DB queries, third-party APIs). If you don't actively engineer the margin, you're a "negative-margin startup at scale" — the modal pattern of failed 2024-2025 AI companies.

The good news: **3 weekends of engineering work** typically lifts a 50% margin to 90%. The fixes are well-known; most operators just don't apply them.

## How it works in practice

### Step 0: instrument FIRST (refuse to skip)

You cannot engineer what you don't measure. Build per-customer cost tracking on day 1:

```python
# Tag every LLM call with customer_id
# Postgres table:
CREATE TABLE llm_usage (
  id SERIAL PRIMARY KEY,
  ts TIMESTAMP DEFAULT NOW(),
  customer_id TEXT NOT NULL,
  session_id TEXT,
  model TEXT NOT NULL,
  input_tokens INT,
  cached_input_tokens INT,
  output_tokens INT,
  cost_usd DECIMAL(10, 6),
  endpoint TEXT,
  metadata JSONB
);

# Also track:
# - Tool/API call costs (Apollo, Hunter, search APIs)
# - Storage cost (DB rows / blob storage per customer)
# - Hosting cost (amortized)
```

If the user can't tell you per-customer cost right now, **the rest of this lesson is theoretical**. Stop reading; instrument first.

### Step 1: measure current gross margin per customer

```
Cost per customer = (total LLM + tools + infra) / number of active customers
Gross margin %    = (ARPU − cost per customer) / ARPU
```

Verdict:
| Gross margin | Verdict | Action |
|--------------|---------|--------|
| ≥ 80% | Healthy | Protect; continue scaling |
| 70-80% | OK | Maintain; scale carefully |
| 50-70% | Fixable | This lesson; achievable in 2-3 weeks |
| < 50% | DEATH ZONE | Emergency; nothing else ships until margin > 70% |

If margin < 50%, treat as a P0 incident. New features wait. Marketing spend pauses. The next 2 weeks are about cost engineering.

### Step 2: model routing (the highest-ROI fix)

Use the **cheapest model that passes evals** for each step. Most products use one model for everything; you're paying 3-10× more than you need.

```
Step type                    Model           Cost vs Sonnet    Use when
Intent classification        Haiku 4.5       0.10×             Pre-routing decisions
Information retrieval        Sonnet 4.6      1.00×             Default
Complex reasoning           Opus 4.7         3.00×             Hard logic only
Output formatting           Haiku 4.5        0.10×             Templated responses
Safety classification       Haiku 4.5        0.10×             Pattern matching
Summarization               Sonnet 4.6       1.00×             Default
Simple tool selection       Haiku 4.5        0.10×             5-15 tools
Complex tool selection      Sonnet 4.6       1.00×             50+ tools or context-sensitive
```

Architecture:
```
User Query
    │
    ▼
[Router (Haiku)] → classify intent, pick downstream model
    │
    ├─ Simple intent → Haiku ($)
    ├─ Standard intent → Sonnet ($$)
    └─ Complex intent → Opus ($$$)
```

**Typical savings: 50-70% on LLM cost** without quality loss (when routing is calibrated by evals).

### Step 3: prompt caching (free money)

Anthropic charges 10% for cached prefixes. If your system prompt is 10K tokens (skill descriptions + tool schemas + few-shot examples), caching saves 90% on every subsequent call within the cache TTL (5 min default).

```python
# Without caching:
10K tokens × $3/M × 100 calls/customer/mo = $3.00/customer/mo

# With caching (cache lasts 5 min; ~80% reuse rate during active sessions):
First call:    10K × $3/M = $0.030 (cache write — costs 1.25× normal)
Reuse (80%):   10K × $0.30/M × 80 = $0.024
Cache misses:  10K × $3/M × 20 = $0.600
Total:         $0.654/customer/mo

Savings: 78%
```

**Typical savings: 80-95% on the cached portion.** This is **free money** — one config change. Every cacheable prefix you don't cache is a leak.

```python
# Anthropic SDK example
client.messages.create(
    model="claude-sonnet-4-6",
    system=[
        {
            "type": "text",
            "text": LARGE_SYSTEM_PROMPT,
            "cache_control": {"type": "ephemeral"}  # ← this line
        }
    ],
    messages=[...],
)
```

Tools and few-shot examples can also be cached. Cache anything that's stable across requests.

### Step 4: semantic + exact + tool-result caching

For common queries:

| Cache type | When | Hit rate | Tool |
|------------|------|----------|------|
| **Exact match** | FAQ-style; same input repeated | 5-15% | Redis / Postgres |
| **Semantic match** | Same meaning, different words ("how do I cancel" vs "cancel my subscription") | 20-40% | Helicone semantic cache / pgvector |
| **Tool-result cache** | Stable data (catalog, prices, schemas) | 50-90% | Redis with TTL |

**Typical savings: 30-60% additional** on top of model routing + prompt caching.

Don't semantic-cache personalized responses (different customers should get different answers even for similar queries).

### Step 5: token discipline

Many cost wins are just tighter prompts:

| Slop | Fix | Savings |
|------|-----|---------|
| 5KB system prompt with everything | 1KB system prompt + skill loading | 60-80% |
| Dumping full HTML to model | Extract relevant text first (cheerio / readability) | 80-95% |
| Tool schemas for 50 tools loaded every call | Show only the 5 relevant tools per turn | 70-85% |
| Long conversation history kept verbatim | Summarize-and-replace at threshold | 50-70% |
| Verbose JSON schema in every call | Reference, don't inline | 40-60% |
| Image attachments at full resolution | Resize to 1024px max | 60-80% per image |

**Typical combined savings: 20-40%.** Not free money — requires engineering — but compounds with caching.

### Step 6: per-customer hard caps

Doesn't directly save cost; protects you from one user blowing P&L:

```python
# Tier example
TIER_TOKEN_BUDGETS = {
    "starter": 100_000,    # $99/mo
    "pro": 500_000,        # $299/mo
    "enterprise": 5_000_000  # $999/mo + custom
}

# Hard cap behavior:
# 80% of cap → email warning
# 100% of cap → polite cutoff: "Upgrade or wait until next cycle"
```

This both protects margin AND creates upgrade paths (forcing upgrades is good for business).

### The math: combined impact

For your average customer, after engineering all 5 fixes:

| Stack | Cost/customer/mo | Margin at $99 ARPU |
|-------|------------------|---------------------|
| Naive (Sonnet only, no cache, no routing) | $40-80 | 20-60% (bad) |
| + Model routing | $20-40 | 60-80% |
| + Prompt caching | $10-25 | 75-90% |
| + Semantic / tool-result cache | $5-15 | 85-95% (great) |
| + Token discipline + caps | $5-10 | 90%+ |

**The difference between "death" and "fundable business" is about 3 weekends.** Most operators never do it.

### The top-5 customer audit

Power users hide in averages. Pull the top 5 by token spend monthly:

```sql
SELECT customer_id, 
       SUM(cost_usd) AS monthly_cost,
       (SELECT plan_arr FROM customers WHERE id = customer_id) AS arpu_monthly
FROM llm_usage
WHERE ts >= NOW() - INTERVAL '30 days'
GROUP BY customer_id
ORDER BY monthly_cost DESC
LIMIT 5;
```

For each sub-margin customer, recommend:
- **Move to higher tier** (most common)
- **Add usage cap** (force upgrade trigger)
- **Custom enterprise contract** (if value justifies)
- **Fire** (yes, sometimes the right move; rare but real)

### When margin is *supposed* to be lower

Exceptions:
- **High-touch enterprise** ($50K+ ACV) — lower gross margin OK if account is sticky
- **Land-and-expand SaaS** — starter tier can be near-zero margin if it converts to a $10K/yr plan
- **Network effect plays** — subsidize early users to get to critical mass (rare for AI products in 2026)

These are exceptions. Default rule: **70%+ gross margin**.

### The 5 numbers to know weekly

1. Gross margin % (overall)
2. Cost per active customer (avg)
3. Top 5 most expensive customers (and their margin)
4. Cost per LLM call (averaged)
5. Cache hit rate (semantic + prompt)

If any move the wrong direction for 2 consecutive weeks → drop everything and investigate.

## Common traps

| Trap | Why |
|---|---|
| Measuring cost monthly instead of per-customer | Misses heavy users killing your average |
| One-model-for-everything | 3-10× over-spending on simple steps |
| Ignoring prompt caching | Free money left on the table; literally one config change |
| "We'll fix margin at scale" | At scale, low margin × big revenue = big losses |
| Free-tier users without token caps | One Reddit moment = $10K bill overnight |
| Long context windows by default | Each token is paid; load on demand |
| Not tracking per-customer cost | If you don't measure it, you can't fix it. **#1 failure mode.** |
| Pricing the average user, ignoring heavy 5% | Heavy users at low tier kill margin; force them to higher tier |
| Trusting LLM provider's cost dashboard alone | Per-customer breakdown requires your own tagging |
| Optimizing margin by reducing quality | Routing is fine; cutting needed tools is not |
| Letting one customer go > 5× average cost | Always add per-customer caps |

## Margin targets by stage

| Stage | Target margin | If below |
|-------|---------------|----------|
| Pre-revenue | n/a | n/a |
| < $10K MRR | 70%+ | Fix before scaling acquisition |
| $10-100K MRR | 75%+ | Run [`margin-auditor`](../skills/margin-auditor/SKILL.md); achievable in weeks |
| $100K-1M MRR | 80%+ | Compounding architecture work; quarterly audit |
| $1M+ MRR | 85%+ | Hire dedicated SRE / cost engineer |

## Reasonable cost-per-customer ranges (2026)

For B2B AI products at $99-999/mo ARPU:

| ARPU | Cost ceiling for 70% margin | Cost ceiling for 80% margin |
|------|------------------------------|------------------------------|
| $99 | $30 | $20 |
| $299 | $90 | $60 |
| $999 | $300 | $200 |

If your cost is above the 70% ceiling, run the [`margin-auditor`](../skills/margin-auditor/SKILL.md) skill this week.

## Exercise

For your current product (or your prototype):

1. **Pick your highest-token customer/session** in the last 30 days
2. **Calculate the actual cost** (LLM + tools + infra)
3. **Implement the 3 cheapest wins** (model routing, prompt caching, tool result truncation)
4. **Re-run the same workload**
5. **Calculate the new cost**

Aim for **50%+ reduction**. If you don't hit it, you have more headroom you haven't found.

Repeat quarterly. **This is the only "growth hack" that compounds.**

## Further reading

- Hamel Husain, [LLM cost engineering](https://hamel.dev/) — the practical guide
- Anthropic, [Prompt caching docs](https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching) — the official
- Helicone, [Caching for AI products](https://helicone.ai/) — semantic cache implementation
- Eugene Yan, [Cost-quality tradeoffs](https://eugeneyan.com/) — the framework
- This repo's [`margin-auditor`](../skills/margin-auditor/SKILL.md) skill — runs this audit on your data

---

[← Lesson 13](../13-pricing-ai-products/README.md) | [Next → Lesson 15: The Retention Problem](../15-the-retention-problem/README.md)
