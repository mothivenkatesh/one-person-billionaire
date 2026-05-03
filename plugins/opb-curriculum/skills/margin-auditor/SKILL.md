---
name: margin-auditor
description: >
  Use this skill whenever the user wants to audit gross margin per customer
  for an AI product, identify the cheapest cost-reduction wins, or diagnose
  why their AI bill is high. Trigger when the user mentions phrases like
  "is my unit economics OK?", "why is my AI bill so high?", "gross margin",
  "cost per customer", "model routing", "prompt caching", "I'm losing money
  per customer", or shares per-customer cost data. Also trigger before
  raising prices (verify new price actually improves margin) and before
  scaling acquisition (refuses to bless scale at < 70% margin). Always use
  this skill if the user can't tell you per-customer cost — it forces
  instrumentation FIRST, before any pricing or scaling decisions.
---

# Margin Auditor Skill

This skill defines the workflow for auditing **gross margin per customer** for AI/agent products and identifying the 5 highest-impact cost reductions: model routing, prompt caching, semantic caching, token discipline, per-customer hard caps. Most "AI startups" die at scale because they never measure per-customer cost; they look like growth darlings on top-line revenue, then implode when the LLM bill catches up.

The skill enforces:
- **Per-customer cost data REQUIRED** — refuses to proceed without it
- **Brutal honest gross margin computation** — no fudging
- **5-fix priority order** — model routing → caching → token discipline → caps
- **Top-5 customer audit** — the heavy users that kill your average
- **Kill recommendations** for sub-margin customers
- **Refusal to bless scale at < 70% margin** — scale amplifies losses

---

## Hard Constraints (Check First)

### Constraint 1 — Per-Customer Cost Data REQUIRED

If the user can't tell you cost-per-customer-per-month (LLM + tools + infra), STOP and refuse to proceed:

> "⚠️ I can't audit margin without per-customer cost data. Total monthly LLM bill / total customers gives you an average that hides the heavy users killing your unit economics. Build per-customer instrumentation FIRST. Tools: Helicone / Langfuse / your own logging. Come back with the numbers."

DO NOT estimate or guess. DO NOT proceed with averages.

### Constraint 2 — Required Inputs

After per-customer cost is available:
- **ARPU** (avg revenue per customer per month)
- **Total active customers**
- **Top 5 most expensive customers by token spend** (with their tier + ARPU)
- **Cache hit rate** (semantic + prompt — even rough estimate is fine)
- **Current model(s) in use** (Sonnet / Haiku / Opus / Gemini / mix)
- **Per-step model assignment** (or "all Sonnet" if none)

If any are missing, ask before scoring.

### Constraint 3 — Refuse to Bless Scaling at < 70% Margin

If the user wants to spend on acquisition and gross margin < 70%:

> "⚠️ Scaling a < 70% margin business amplifies the losses, not the wins. We need to fix margin BEFORE acquisition spend. The 5 fixes below typically lift margin 20-30 points in 2-3 weeks of work."

---

## Workflow Overview

```
Step 1: Compute current gross margin
Step 2: Audit the 5 cheapest fixes (in priority order)
Step 3: Project new margin after fixes
Step 4: Audit top 5 customers individually
Step 5: Recommend tier changes / kills for sub-margin customers
Step 6: Set ongoing tracking + kill criteria
Step 7: Output the audit
```

---

## Step 1 — Compute Current Gross Margin

```
Cost per customer = (total LLM + tools + infra) / customers
Gross margin %    = (ARPU - cost per customer) / ARPU
```

Verdict:
| Margin | Verdict | Action |
|--------|---------|--------|
| ≥ 80% | Healthy | Protect it |
| 70-80% | OK | Maintain; scale is OK |
| 50-70% | Fixable | Run this skill; achievable in 2-3 weeks |
| < 50% | Death zone | Emergency mode; fix before any new feature work |

If margin < 50%, treat as a P0 incident: nothing else ships until margin is above 70%.

---

## Step 2 — The 5 Cheapest Fixes (in priority order)

### Fix 1: Model Routing (highest ROI)

Use the cheapest model that passes evals for each step. Most products use one model for everything; you're paying 3-10× more than you need.

```
Default routing for AI products in 2026:

Step type                    Model           Cost vs Sonnet
Intent classification        Haiku 4.5       0.10×
Information retrieval        Sonnet 4.6      1.00×
Complex reasoning           Opus 4.7         3.00×
Output formatting           Haiku 4.5        0.10×
Safety classification       Haiku 4.5        0.10×
Summarization               Sonnet 4.6       1.00×
Tool selection (simple)     Haiku 4.5        0.10×
Tool selection (complex)    Sonnet 4.6       1.00×
```

**Typical savings:** 50-70% on LLM cost without quality loss (if routing is calibrated by evals).

### Fix 2: Prompt Caching

Anthropic charges 10% for cached prefixes. If your system prompt is 10K tokens (skill descriptions + examples + tool schemas), caching saves 90% on every subsequent call within the cache TTL (5 min default).

```
Without caching:
  10K tokens × $3/M × 100 calls/customer/mo = $3.00/customer/mo

With caching (cache lasts 5 min; ~80% reuse rate):
  First call:    10K × $3/M = $0.030 (cache write)
  Reuse (80%):   10K × $0.30/M × 80 = $0.024
  Cache misses:  10K × $3/M × 20 = $0.600
  Total: $0.654/customer/mo

Savings: 78%
```

**Typical savings:** 80-95% on the cached portion of your prompts.

This is **free money**. Every cacheable prefix you don't cache is a leak.

### Fix 3: Semantic + Exact + Tool-Result Caching

For common queries:

| Cache type | Use case | Hit rate | Tool |
|------------|----------|----------|------|
| **Exact match** | FAQ-style queries; same input repeated | 5-15% | Redis / Postgres |
| **Semantic match** | Same meaning, different words | 20-40% | Helicone semantic cache / pgvector |
| **Tool result cache** | Stable data (product catalog, prices, schemas) | 50-90% | Redis with TTL |

**Typical savings:** 30-60% additional on top of model routing + prompt caching.

### Fix 4: Token Discipline

Many cost wins are just tighter prompts:

| Slop | Fix |
|------|-----|
| 5KB system prompt with everything | 1KB system prompt + skill loading |
| Dumping full HTML to model | Extract relevant text first (cheerio / readability) |
| Tool schemas for 50 tools loaded every call | Show only the 5 relevant tools per turn |
| Long conversation history kept verbatim | Summarize-and-replace at threshold |
| Verbose JSON schema in every call | Reference, don't inline |
| Image attachments at full resolution | Resize to 1024px max |

**Typical savings:** 20-40%.

### Fix 5: Per-Customer Hard Caps

Doesn't directly save cost; protects you from one user blowing P&L:

```
Tier example:

Starter   ($99/mo):   100K tokens included, $0.50/10K after
Pro       ($299/mo):  500K tokens included, $0.30/10K after
Enterprise ($999/mo): 5M tokens included, custom overage

Hard cap behavior:
- 80% of cap → email warning
- 100% of cap → polite cutoff: "Upgrade or wait until next cycle"
```

This both protects margin AND creates upgrade paths.

---

## Step 3 — Project the New Margin

For your average customer, after engineering all 5 fixes:

| Stack choice | Cost / customer / mo | Margin at $99 ARPU |
|---|---|---|
| Naive (Sonnet, no cache, no routing) | $40-80 | 20-60% (bad) |
| + Model routing | $20-40 | 60-80% |
| + Prompt caching | $10-25 | 75-90% |
| + Semantic / tool-result cache | $5-15 | 85-95% (great) |

The difference between "death" and "fundable business" is about **3 weekends of engineering work**. Most operators never do it.

Compute projection:
```
Current cost per customer:    $___
Fix 1 (routing) saves:        ~50%
Fix 2 (prompt cache) saves:   ~30% additional
Fix 3 (semantic cache) saves: ~25% additional
Fix 4 (token discipline):     ~20% additional
Fix 5 (caps):                 protects, no $ savings

Projected cost per customer:  $___
Projected gross margin:       __%
Projected annual savings:     $___
```

---

## Step 4 — Audit the Top 5 Customers Individually

Power users hide in averages. Pull the top 5 by token spend:

| Customer | Tier | ARPU | Cost/mo | Margin |
|----------|------|------|---------|--------|
| 1 | | | | |
| 2 | | | | |
| 3 | | | | |
| 4 | | | | |
| 5 | | | | |

For each sub-margin customer, recommend:
- **Move to higher tier** (most common)
- **Add usage cap** (force upgrade trigger)
- **Custom enterprise contract** (if value justifies)
- **Fire** (yes, sometimes the right move; rare but real)

---

## Step 5 — Set Ongoing Tracking + Kill Criteria

Required weekly tracking:
1. Gross margin % (overall)
2. Cost per active customer
3. Top 5 most expensive customers (and their margin)
4. Cost per LLM call (averaged)
5. Cache hit rate (semantic + prompt)

If any move the wrong direction for 2 consecutive weeks → drop everything and investigate.

Kill criteria for the audit:
- If after 30 days of fixes margin hasn't lifted by 10+ points → instrumentation problem (you're measuring wrong) OR a hidden cost source (third-party APIs, infrastructure)
- If a specific fix doesn't move the needle → the fix doesn't apply to your specific architecture; skip and move to next

---

## Required Output Format

```
### 💸 Margin Audit — [Product]
**Date:** [today]

### Current State

Gross margin:           __% [Healthy ≥ 80% / OK 70-80% / Fixable 50-70% / DEATH < 50%]
Cost per customer:      $___
ARPU:                   $___
Top expensive customer: $___ cost vs $___ ARPU (margin __%)

### The 5 Fixes (Priority Order)

| # | Fix | Effort | Est savings | Status |
|---|-----|--------|-------------|--------|
| 1 | Model routing | 1-2 days | 50-70% | [TODO/DONE] |
| 2 | Prompt caching | 2-4 hours | 80-95% on cached portion | [TODO/DONE] |
| 3 | Semantic + tool-result cache | 1-2 weeks | 30-60% additional | [TODO/DONE] |
| 4 | Token discipline | Ongoing | 20-40% | [TODO/DONE] |
| 5 | Per-customer hard caps | 1-2 days | Protective | [TODO/DONE] |

### Top 5 Customer Audit

| Customer | Tier | ARPU | Cost/mo | Margin | Action |
|----------|------|------|---------|--------|--------|
| | | | | | [Move tier / Add cap / Custom / Fire] |

### Projected Margin (after fixes)

Current:                __%
After Fix 1 (routing):  __%
After Fix 2 (cache):    __%
After Fix 3 (semantic): __%
After Fix 4 (token):    __%

Projected:              __% in 2-3 weeks of work
Annual savings:         $___

### Action This Week

[The single highest-impact fix to ship this week]

### Kill Criteria (re-audit in 30 days)

- If margin doesn't lift by 10 points → instrumentation problem
- If [specific fix] doesn't move needle → architecture-specific; skip
```

---

## Worked Example

**User input:**
- ARPU: $99/mo
- Total customers: 80
- Total LLM bill: $4,200/mo
- Cost/customer (average): $52.50
- Top customer's cost: $312/mo (still on $99 plan)
- Cache hit rate: ~5% (no real strategy)
- Current model: All Sonnet

**Step 1 — Margin:**
($99 - $52.50) / $99 = **47% gross margin → DEATH ZONE**

**Step 2 — The 5 fixes applied:**

1. **Model routing:** they classify intent, route, then summarize. Move classify + summarize to Haiku. Estimated savings: 60% on LLM bill = $2,520/mo savings = $31.50/customer savings.
2. **Prompt caching:** their system prompt is ~8K tokens (skills + tool schemas) and they call ~50 times/customer/mo. Implementing prompt cache saves another 40% on remaining bill = $670/mo = $8.40/customer.
3. **Semantic cache:** ~30% of their queries are FAQ-style ("how do I X?"). Implementing semantic cache saves $300/mo = $3.75/customer.
4. **Token discipline:** their tool schemas are loaded every call (15 tools, 6KB total). Show only 3 relevant per turn = $200/mo = $2.50/customer.

**Step 3 — Projection:**
- Cost/customer before: $52.50
- After routing: $21
- After prompt cache: $12.60
- After semantic cache: $8.85
- After token discipline: $6.35
- **New cost/customer: $6.35 → margin = 94%**

**Step 4 — Top customer:**
$312 cost, $99 ARPU = -$213/customer/month loss. Action: force upgrade to $299 Pro tier OR add hard cap at 100K tokens/month. Either way, fix this week.

**Step 5 — Action this week:** Model routing (Fix 1). Single highest-impact win. Ship by Friday.

---

## Common Mistakes to Avoid

- **Measuring cost monthly instead of per-customer.** You miss the heavy users killing your average.
- **One model for everything.** 3-10× over-spending on simple steps.
- **Ignoring prompt caching.** Free money left on the table; literally one config change.
- **"We'll fix margin at scale."** At scale, low margin × big revenue = big losses.
- **Free-tier users without token caps.** One Reddit moment = $10K bill overnight.
- **Long context windows by default.** Each token is paid; load on demand.
- **Not tracking per-customer cost.** If you don't measure it, you can't fix it. This is the #1 failure mode.
- **Pricing the average user, ignoring the heavy 5%.** Heavy users at low tier kill margin; force them to higher tier.
- **Trusting the LLM provider's cost dashboard alone.** Per-customer breakdown requires your own tagging.
- **Optimizing margin by reducing quality.** Routing is fine; cutting tools that customers need to save tokens is not.
- **Letting one customer go > 5× average cost.** Always add per-customer caps.

---

## Notes on Tooling

For per-customer cost tracking:

| Tool | Use |
|------|-----|
| **Langfuse** (free tier) | OpenTelemetry-based; tag every LLM call with customer ID; dashboard ready |
| **Helicone** | Hosted; semantic cache built-in; cost per user / model / endpoint |
| **Anthropic console** | Per-API-key totals; tag API keys per customer for crude breakdown |
| **DIY** | Postgres table: `(customer_id, ts, model, input_tokens, output_tokens, cost)` |

For prompt caching:
- **Anthropic prompt caching** — built-in; just add `cache_control: {"type": "ephemeral"}` to message blocks
- **5-min TTL** by default; renew on each hit
- **Cache writes cost 1.25× normal**; cache reads cost 0.10× normal — break-even at 2 reuses per write

For semantic cache:
- **Helicone semantic cache** — easiest hosted option
- **Self-host: pgvector** — embed query, search prior queries, return cached response if similarity > 0.95
- **Use only for stable-answer queries** (NOT for personalized responses)

For token discipline:
- **tiktoken** — count tokens before sending
- **html2text / cheerio** — strip HTML before passing to LLM
- **JSON-mode** — structured output uses fewer tokens than parsing prose

---

## Quick Reference — Margin Targets by Stage

| Stage | Target margin | If below |
|-------|---------------|----------|
| Pre-revenue | n/a | n/a |
| < $10K MRR | 70%+ | Fix before scaling acquisition |
| $10-100K MRR | 75%+ | Run this skill; achievable in weeks |
| $100K-1M MRR | 80%+ | Compounding architecture work; quarterly audit |
| $1M+ MRR | 85%+ | Hire dedicated SRE / cost engineer |

---

## Quick Reference — Reasonable Cost-per-Customer Ranges

For B2B AI products at $99-999/mo ARPU in 2026:

| ARPU | Cost ceiling for 70% margin | Cost ceiling for 80% margin |
|------|------------------------------|------------------------------|
| $99 | $30 | $20 |
| $299 | $90 | $60 |
| $999 | $300 | $200 |

If your cost is above the 70% ceiling, this skill applies.

---

## Source

Lesson 14: [Margin Engineering](../../14-margin-engineering/README.md)

Pairs with:
- [`pricing-tripler`](../pricing-tripler/SKILL.md) — pair margin fix with price raise
- [`production-readiness-audit`](../production-readiness-audit/SKILL.md) — observability is prerequisite
- [`bottleneck-identifier`](../bottleneck-identifier/SKILL.md) — if margin issue is part of broader stall
