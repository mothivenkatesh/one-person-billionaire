---
name: retention-cohort-analyzer
description: >
  Use this skill whenever the user wants to diagnose churn, run cohort retention
  analysis, or understand why customers leave their AI product. Trigger when the
  user mentions phrases like "why are customers churning?", "review my retention",
  "cohort analysis", "M0 to M1 cliff", "novelty churn", "30-day churn", "churn
  spike", or shares retention data. Also trigger before scaling acquisition
  (refuses to bless acquisition spend at < 30% M3 retention) and after a churn
  spike. Always use this skill instead of guessing — it forces 5 mandatory churn
  interviews and rejects "I'll do interviews later".
---

# Retention Cohort Analyzer Skill

This skill defines the workflow for diagnosing **AI-product churn**. Traditional SaaS churn is mostly "failed to deliver value." AI products have an additional churn cliff: **novelty churn** — users sign up for the magic, get the magic 3-5 times, then stop using it. The 30-day churn cliff is brutal and predictable. This skill identifies it, diagnoses the cause via 5 mandatory churn interviews, and prescribes the retention mechanic to fix it.

The skill enforces:
- **Cohort data REQUIRED** — refuses to proceed without it
- **5 mandatory churn interviews** — refuses to diagnose without talking to churned customers
- **Single retention mechanic prescription** — pick ONE; don't try all 4
- **30-day intervention playbook** with mandatory founder touches
- **Refusal to scale acquisition at < 30% M3 retention** — leaky bucket

---

## Hard Constraints (Check First)

### Constraint 1 — Cohort Data REQUIRED

If the user can't provide cohort retention data (M0 / M1 / M2 / M3 minimum), STOP:

> "⚠️ I can't diagnose retention without cohort data. Aggregate churn rate hides the M0→M1 cliff that's specific to AI products. Build cohort tracking FIRST. Tools: Posthog (free tier), Amplitude, Mixpanel, or DIY with Postgres + a window function. Come back with the table."

DO NOT proceed with aggregate churn rates. They lie.

### Constraint 2 — 5 Churn Interviews REQUIRED

Before diagnosing causes, the user MUST do 5 churn interviews:

> "⚠️ I can't diagnose causes without talking to churned customers. Email your last 5 churns. Offer $50 gift cards if needed. Ask the 3 honest questions. Bring me the answers. I'll wait."

If the user says "I'll do them later" → REFUSE. Diagnosis without interviews = guessing. Most "retention strategies" fail because the operator skipped this.

### Constraint 3 — Refuse to Bless Acquisition at < 30% M3 Retention

If the user wants to scale acquisition and M3 retention < 30%:

> "⚠️ Scaling acquisition into a leaky bucket = burning money. Fix retention first. Even a 5-point M3 lift makes acquisition 2× more cost-effective."

Don't bless paid ads, sales hires, or content sprints until retention is stable.

---

## Workflow Overview

```
Step 1: Pull cohort data + identify the cliff
Step 2: Force 5 churn interviews (3 questions each)
Step 3: Cluster the answers → diagnose dominant cause
Step 4: Prescribe ONE retention mechanic
Step 5: Build the 30-day intervention playbook
Step 6: Set re-measurement date + kill criteria
Step 7: Output the analysis
```

---

## Step 1 — Pull Cohort Data + Identify the Cliff

Force a table:

```
Cohort      M0    M1    M2    M3    M6    M12
Jan        100%  ___   ___   ___   ___   ___
Feb        100%  ___   ___   ___
Mar        100%  ___   ___
Apr        100%  ___
```

Identify the biggest drop. For most AI products, it's M0→M1 (the novelty cliff).

Benchmarks for AI products in 2026:
| M1 retention | Verdict |
|--------------|---------|
| > 70% | Above industry; protect this |
| 50-70% | Typical; fixable |
| 30-50% | Bad; AI novelty churn |
| < 30% | Severe; product-market mismatch |

| M3 retention | Verdict |
|--------------|---------|
| > 50% | Healthy |
| 30-50% | Fixable |
| < 30% | Don't scale acquisition; fix first |

---

## Step 2 — Force 5 Churn Interviews

Email script for the user to send:

```
Subject: 15 minutes — what went wrong with [Product]?

Hi [Name],

I noticed you canceled [Product] last week. I'm not asking you to come back.
I just want to understand what didn't work, so I can build it better for the
next person.

15 minutes on Zoom. I'll send a $50 [Amazon / Starbucks] gift card afterward
either way.

Can you do [day] at [time]?

[Founder name]
```

Most will say yes. The 3 questions to ask:

1. **What was your job-to-be-done?** (Why did you sign up? In your own words.)
2. **Did you accomplish it?** (Once is OK; repeatedly is the bar.)
3. **Why did you stop using it?** (Specific reason, not "I was busy.")

Ask FOLLOW-UP: "tell me more about that" — twice. The first answer is rarely the real reason.

If the user can't get 5 interviews in 14 days → diagnose: maybe the customer relationship was too thin (no real connection), or the wedge attracts low-commitment buyers.

---

## Step 3 — Cluster the Answers → Diagnose Dominant Cause

Group the 5 interviews into causes:

| Cause | Signals from interview | Frequency |
|-------|----------------------|-----------|
| **Novelty churn** | "Cool but I only needed it once" / "Got bored" | __ /5 |
| **Setup friction** | "Couldn't get it working" / "Too complicated" | __ /5 |
| **One-shot use case** | "Job's done; uninstalled" / "Solved my problem" | __ /5 |
| **Wrong fit** | "Not what I expected" / "I thought it did X" | __ /5 |
| **Better alternative** | "Switched to X" / "Found a competitor" | __ /5 |
| **Unreliable** | "It broke" / "Got bad results" | __ /5 |
| **Too expensive** | "Wasn't worth $X" / "Couldn't justify cost" | __ /5 |

Identify the DOMINANT cause (≥ 3/5 same cause). If no clear pattern → 5 isn't enough; do 5 more.

---

## Step 4 — Prescribe ONE Retention Mechanic

Based on the dominant cause:

| Cause | Prescribed mechanic | Why |
|-------|---------------------|-----|
| Novelty churn / one-shot use case | **Accumulating data lock-in** | Make the product get better the more they use it (their data compounds) |
| Setup friction | **Done-for-you onboarding** | Remove the work; concierge for first 100 customers |
| Wrong fit | **Acquisition / positioning fix** | Not a retention problem; fix wedge or messaging upstream |
| Better alternative | **Competitive / moat work** | Lesson 02 — what's your harness moat? |
| Unreliable | **Production-readiness fix** | Run [`production-readiness-audit`](../production-readiness-audit/SKILL.md) |
| Too expensive | **Pricing or value gap** | Run [`pricing-tripler`](../pricing-tripler/SKILL.md) — could be over-priced for value delivered |

DON'T try all 4 mechanics simultaneously. Pick ONE based on dominant cause. Implement for 30 days. Re-measure.

### The 4 retention mechanics (deep dive)

**1. Accumulating data lock-in (most common fix)**

The product gets *better* the more the customer uses it because their data compounds:
- Notion: notes accumulate; switching cost = re-entering everything
- Cursor: codebase indexing improves with use
- Granola: meeting notes archive becomes searchable history

For your agent: **what data does the customer feed in that becomes uniquely THEIRS?** If the answer is "nothing — every session starts fresh," you're a wrapper, not a product.

How to add lock-in:
- Save user preferences over time (style, tone, taxonomy)
- Build a knowledge graph from their inputs
- Personalize outputs based on past interactions
- Show usage history that becomes valuable retroactively

**2. Workflow integration**

The product becomes part of a recurring workflow they can't easily replace:
- Stripe → financial reporting workflow
- Linear → engineering planning workflow

For your agent: **where does it slot into a recurring workflow?** Daily morning brief? Weekly recap? Pre-meeting prep?

**3. Habit formation**

Earn a slot in their routine via time-bounded triggers:
- "Send me my daily brief at 8am" creates a habit
- "Use me whenever you need" doesn't

Make the value time-bounded, not on-demand.

**4. Network / team effects**

Multi-user accounts churn 60% less. Make it natural for customers to invite teammates:
- Collaboration features (shared workspaces)
- Per-seat pricing (more users = more lock-in for the company)
- Referral incentives that benefit BOTH inviter and invitee

---

## Step 5 — Build the 30-Day Intervention Playbook

For days 0-30 of every NEW customer (the make-or-break window):

```
Day 0:   Onboarding email — "what would success look like in 30 days?"
Day 1:   Personal welcome from founder (Loom or written, not auto)
Day 3:   "Are you stuck?" check if usage is low
Day 7:   First-week recap: "you've done X; here's the next thing to try"
Day 14:  1:1 call offer (15 min) — even at scale, do this for first 100
Day 21:  Showcase a use case the customer hasn't tried
Day 28:  Honest survey — "are we delivering value?"
Day 30:  Renewal nudge if monthly; success story ask if engaged
```

Reject auto-only onboarding for the first 100 customers. Force unscalable touches. The unscalable phase is the LEARNING phase.

---

## Step 6 — Set Re-Measurement Date + Kill Criteria

```
Re-measure cohort retention in 60 days.

Kill criteria:
- If M1 doesn't lift by 5+ points → wrong mechanic; redo Step 4
- If interviews show new dominant cause → that's the new mechanic
- If retention worsens → roll back mechanic; investigate
- If user keeps adding mechanics in parallel → enforce ONE-AT-A-TIME rule
```

---

## Required Output Format

```
### 📈 Retention Analysis — [Product]
**Date:** [today]

### Cohort Table

Cohort   M0    M1    M2    M3    M6    M12
___      100%  ___   ___   ___   ___   ___

### The Cliff

Biggest drop:           M__ → M__  ([X]% drop)
M3 retention:           __% (Benchmark: ≥ 30% to scale acquisition)

### Verdict

[Above industry / Typical / Bad / Severe]

### Churn Interview Summary (5 customers)

| # | Job-to-be-done | Accomplished? | Why stopped? |
|---|----------------|---------------|--------------|
| 1 | | | |
| 2 | | | |
| 3 | | | |
| 4 | | | |
| 5 | | | |

Dominant cause:         [from cluster]
Frequency:              __/5

### Prescribed Mechanic

[ONE: Data lock-in / Workflow / Habit / Network]

### 30-Day Intervention Playbook

[Customized day 0-30 touches]

### Re-Measure

Date:                   [60 days from now]
Success metric:         M1 retention up by 5+ points
Kill criteria:          [list]
```

---

## Worked Example

**User input:**
- Product: AI weekly newsletter generator for B2B founders
- M0: 100% (50 signups)
- M1: 38% (19 of 50 still active)
- M2: 18%
- M3: 12% — DON'T SCALE
- 5 churn interviews completed.

**Cohort cliff:** M0→M1 (62% drop) — severe novelty.

**Churn interviews clustered:**
1. "Loved the first 2 newsletters. Then I got busy and forgot." (Novelty / habit)
2. "I generated 3 newsletters; my pipeline went up; I just stopped because I felt I had the format." (One-shot)
3. "Couldn't figure out how to add my brand voice." (Setup friction)
4. "I needed it to also schedule the post; it didn't." (Wrong fit)
5. "Used 4 times; the outputs felt the same." (One-shot / no compounding)

**Dominant cause:** **One-shot / no compounding** (3/5 mention "I felt I had it" or "outputs felt the same").

**Prescribed mechanic:** **Accumulating data lock-in.** Currently the product is stateless — every newsletter starts fresh. Fix: build a "your voice" profile that learns from each newsletter the user edits, plus a "what worked" memory that tracks engagement on past newsletters.

**30-day intervention:**
- D0: "Tell me about your audience and your brand voice" (1-min Typeform)
- D1: Founder Loom: "I read your D0 form — here's how I'd think about your first newsletter"
- D7: "Compare your last week's newsletter to top performers in your space" (data report)
- D14: 15-min call: "What's working? What's not?"
- D21: "Try this new style we built based on your feedback" (custom prompt)
- D28: "Here's the engagement data on your 4 newsletters this month — see the pattern?"

**Re-measure:** Day 60. Goal: M1 from 38% → 50%.

---

## Common Mistakes to Avoid

- **Optimizing acquisition before retention.** Filling a leaky bucket. Wastes the next 6 months.
- **Retention metrics on aggregate, not cohort.** Hides the M0→M1 cliff entirely.
- **"We'll fix retention with email campaigns."** Retention is a product problem, not a marketing problem.
- **Chasing engagement metrics (DAU/MAU).** Engagement ≠ value; users can be engaged AND about to churn.
- **Building features instead of fixing the M0→M1 cliff.** Biggest leak is at the entrance.
- **Treating churn as inevitable.** Most "AI churn is inevitable" claims are excuses for bad products.
- **Skipping interviews.** Without 5 real conversations, you're guessing what to fix.
- **Trying all 4 mechanics simultaneously.** Pick ONE; measure; adjust.
- **Auto-onboarding from day 1.** First 100 customers need founder touches.
- **Blaming customers for "not understanding the value."** That's a product or onboarding problem, not a customer problem.
- **Surveying instead of interviewing.** Surveys lie; conversations don't.

---

## Notes on Tooling

For cohort tracking:

| Tool | Use |
|------|-----|
| **Posthog** (free tier) | OSS-friendly; cohort retention reports built-in |
| **Mixpanel** | Hosted; expensive at scale; great cohort UI |
| **Amplitude** | Hosted; enterprise focus |
| **DIY** (Postgres + window function) | Cheapest; works at any scale |

DIY query (Postgres):
```sql
WITH cohorts AS (
  SELECT user_id,
         DATE_TRUNC('month', created_at) AS cohort_month
  FROM users
),
activity AS (
  SELECT user_id,
         DATE_TRUNC('month', event_at) AS active_month
  FROM events
)
SELECT cohort_month,
       active_month,
       COUNT(DISTINCT activity.user_id)::FLOAT / 
         (SELECT COUNT(*) FROM cohorts c WHERE c.cohort_month = cohorts.cohort_month) AS retention
FROM cohorts
JOIN activity USING (user_id)
GROUP BY 1, 2
ORDER BY 1, 2;
```

For interviews:
- **Calendly + Zoom** — basic
- **Grain** — auto-records, transcribes, tags themes
- **Notion / Airtable** for tracking interview themes

For the 30-day intervention:
- **Customer.io / Loops** — drip email automation with branching logic
- **Slack channel** for first 100 customers
- **Loom** for personal video touches at scale

---

## Quick Reference — Retention Targets by Stage

| Stage | M1 target | M3 target | M12 target |
|-------|-----------|-----------|------------|
| < $10K MRR | 50%+ | 30%+ | n/a |
| $10-100K MRR | 60%+ | 40%+ | 25%+ |
| $100K-1M MRR | 70%+ | 55%+ | 40%+ |
| $1M+ MRR | 80%+ | 65%+ | 50%+ |

If you're below target → don't scale acquisition; fix retention first.

---

## Quick Reference — The 3 Honest Questions

For every churn interview:
1. **What was your job-to-be-done?**
2. **Did you accomplish it?**
3. **Why did you stop?**

Each followed by "tell me more about that" — twice.

---

## Source

Lesson 15: [The Retention Problem Unique to AI Products](../../15-the-retention-problem/README.md)

Pairs with:
- [`bottleneck-identifier`](../bottleneck-identifier/SKILL.md) — if retention is part of broader stall
- [`grand-slam-offer`](../grand-slam-offer/SKILL.md) — wrong-fit churn often = offer problem
- [`pricing-tripler`](../pricing-tripler/SKILL.md) — too-expensive churn = value/price mismatch
- [`production-readiness-audit`](../production-readiness-audit/SKILL.md) — unreliable churn = production gap
