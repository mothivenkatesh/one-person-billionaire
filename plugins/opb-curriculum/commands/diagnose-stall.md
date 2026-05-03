---
description: You're stuck at $X MRR. Diagnose the bottleneck (founder bandwidth / distribution / infrastructure / sales complexity) and prescribe the single 30-day focus.
argument-hint: "<current MRR + how long you've been stuck + symptoms>"
---

# /diagnose-stall — Why you're stuck at $X MRR

Chains 3 skills to diagnose a growth plateau and force focus on ONE bottleneck for 30 days. Refuses "I'll work on all 4 in parallel" framing.

## Use this when

- MRR has been flat for 60+ days
- You feel busy but nothing moves
- You're working 12+ hour days and shipping nothing
- After hitting a milestone ($10K / $50K / $100K MRR) and stalling

## Workflow

### Step 1: Identify the primary bottleneck

Activate [`bottleneck-identifier`](../skills/bottleneck-identifier/SKILL.md).

- Confirm the stall (≥ 60 days flat, not normal variance)
- Score 4 bottlenecks 1-10:
  - Founder bandwidth (working 12+ hr days, support eating > 40% of week)
  - Distribution plateau (primary channel flat for 60+ days)
  - Infrastructure (firefighting bugs/outages 1+ days/week)
  - Sales / pricing complexity (deals stalling on contracts / pricing)
- Pick the highest-scored bottleneck
- Output: the ONE bottleneck + 30-day focus + day-30 success metric

### Step 2: Deep-dive the bottleneck

Based on the diagnosis from Step 1:

**If founder bandwidth → run [`self-automation-mapper`](../skills/self-automation-mapper/SKILL.md):**
- Map the week
- Score the 5-criterion automation matrix
- Pick top 3 to automate

**If distribution plateau → check Lesson 09-12 channels:**
- What's working today (channel mix, top sources)
- Pick ONE second channel to ramp
- Run `/start-outbound` if outbound is the gap

**If infrastructure → run [`production-readiness-audit`](../skills/production-readiness-audit/SKILL.md):**
- Identify the worst gap; fix it

**If sales/pricing → run [`pricing-tripler`](../skills/pricing-tripler/SKILL.md):**
- Add annual plans
- Standardize one new tier
- Pre-write contract templates

### Step 3: Verify it's not a deeper problem

If the bottleneck is "distribution plateau" or "MRR flat," also run:

[`retention-cohort-analyzer`](../skills/retention-cohort-analyzer/SKILL.md) — because flat MRR with high acquisition often means churn is eating your gains. Acquisition fixes don't help a leaky bucket.

[`margin-auditor`](../skills/margin-auditor/SKILL.md) — because if margin is too thin, scaling makes losses worse, not better.

## After this command

- 30 days, 50% on the bottleneck, 30% on existing customers, 20% on second-most-painful bottleneck
- Day 30: re-run `/diagnose-stall`. Did the bottleneck score drop by 2+ points?
- If yes: continue. If no: deeper problem; rethink the wedge or the offer

## Refusal conditions

- < 60 days of flat MRR → not a bottleneck, just variance. Refuse to diagnose.
- "I'll work on all 4 bottlenecks in parallel" → refuse. Pick ONE.
- "Adding more features will fix it" when the diagnosis is distribution → refuse the framing.
