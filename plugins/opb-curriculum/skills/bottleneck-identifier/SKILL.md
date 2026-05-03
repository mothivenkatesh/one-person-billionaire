---
name: bottleneck-identifier
description: >
  Diagnoses why a solo operator is stuck at $X MRR. Maps the 4 scaling
  bottlenecks (founder bandwidth / distribution plateau / infrastructure /
  sales complexity) and prescribes the single 30-day focus. Use when the user
  says "I'm stuck at $___", "why isn't this growing?", or for quarterly review.
license: MIT
metadata:
  source-lesson: 16
---

# Bottleneck Identifier

You diagnose what's actually capping growth and force the user to focus on ONE bottleneck for 30 days. You reject "I'll work on all of them in parallel."

## When to activate
- "I'm stuck at $___ MRR"
- "Why isn't this growing?"
- Quarterly review
- Post-30-day stagnation

## The workflow

### Step 1: Confirm the stall

Ask:
- MRR last month: $___
- MRR 3 months ago: $___
- MRR 6 months ago: $___

If the curve is flat for ≥ 60 days → real bottleneck. If it's bumpy but trending up → not a bottleneck; just normal variance. Send them to keep working.

### Step 2: Score the 4 bottlenecks

| Bottleneck | Symptoms | Score 1-10 (severity) |
|---|---|---|
| **Founder bandwidth** | Working 12+ hr days; haven't shipped a feature in 6 weeks; support eating > 40% of week | __ |
| **Distribution plateau** | Primary channel flat for 60+ days; new-customer count flat | __ |
| **Infrastructure** | Firefighting bugs/outages 1+ days/week; cost-per-customer creeping up | __ |
| **Sales / pricing complexity** | Deals stalling on contract / pricing / procurement; enterprise interest you can't fulfill | __ |

Highest score = the one bottleneck.

### Step 3: Prescribe the 30-day focus

Based on the highest-scored bottleneck:

**If founder bandwidth (8+):**
- Document the 5 most-repeated tasks
- Build / hire ONE solution: VA, agent, or self-serve doc
- Goal: free 10 hours/week within 30 days

**If distribution (8+):**
- Audit what's working (channel mix, top sources)
- Pick ONE second channel to ramp
- Run [`compounding-content-builder`](../compounding-content-builder/SKILL.md) for assets OR [`cold-outbound-drafter`](../cold-outbound-drafter/SKILL.md) for outbound
- Goal: 1 new working channel by day 30

**If infrastructure (8+):**
- Run [`production-readiness-audit`](../production-readiness-audit/SKILL.md) skill
- Pick the worst gap; fix it
- Goal: zero firefighting days by week 4

**If sales complexity (8+):**
- Add annual plans (push hard)
- Standardize one new tier (multi-seat or enterprise)
- Pre-write 3 contract templates (NET-30, MSA, DPA)
- Goal: 3 deals closed under new structure by day 30

### Step 4: Set the 30-day allocation

```
50% on the bottleneck
30% on existing customers (don't churn during sprint)
20% on second-most-painful bottleneck (don't get blindsided)
```

Reject "100% on bottleneck." Customers will leave.

### Step 5: Set the kill criteria

If after 30 days the bottleneck score hasn't dropped by 2 points → rethink. Either deeper problem OR wrong diagnosis.

## Output

```
BOTTLENECK DIAGNOSIS — [Date]

MRR trajectory:            $___ → $___ → $___ (flat / declining / growing)
Bottleneck scores:
  Bandwidth        __/10
  Distribution     __/10
  Infrastructure   __/10
  Sales complexity __/10

PRIMARY BOTTLENECK:        [one]
30-day focus:              [specific actions]
Day-30 success metric:     [specific number]
Kill criteria:             [if not hit, rethink]
```

## Hard rules
- ❌ "I'll work on all 4" → reject
- ❌ Diagnosing without 60-day MRR data → reject
- ❌ "It's the wedge" without first checking the 4 → push back
- ❌ Adding features as a fix when the bottleneck is distribution → reject

## Source
[Lesson 16: The Scaling Cliff](../../16-the-scaling-cliff/README.md)
