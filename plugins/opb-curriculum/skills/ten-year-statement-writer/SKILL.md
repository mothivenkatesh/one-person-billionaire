---
name: ten-year-statement-writer
description: >
  Use this skill whenever the user wants to write or update their 10-year
  statement, run an annual scorecard, or set the long-term direction.
  Trigger when the user mentions phrases like "10-year plan", "annual
  scorecard", "yearly retro", "where am I going?", "build my long-term
  statement", or end-of-year review prompts. Also trigger at meaningful
  transitions (quitting job, hitting $1M ARR, considering exit, hitting
  burnout). Always use this skill instead of doing free-form goal-setting —
  it forces specificity, year-over-year comparison, and the survivorship-
  bias check that most "vision exercises" skip.
---

# Ten-Year Statement Writer Skill

This skill defines the workflow for writing a 10-year statement and running an honest annual scorecard. Based on Lesson 20's principle: *time-in-market beats market-timing; the 5-7-year operator beats the 12-month sprinter every time.*

The skill enforces:
- **Specific, time-bound, measurable** statements (no vague "be successful")
- **Failure-mode planning** (what kills this — name it)
- **Year-over-year comparison** (the diff is the asset, not the snapshot)
- **Survivorship-bias check** (you see the survivors, not the quitters)

---

## Hard Constraints (Check First)

### Constraint 1 — Annual or Major Transition Only

This skill is for:
- Annual / quarterly review (recurring)
- Major life transitions (quitting, hitting milestones, considering exit)

NOT for:
- Daily / weekly use
- Mood-induced re-planning ("I'm tired today; let me redo my 10-year plan")

If the user wants to redo their 10-year plan more than 2-3 times a year, push back: "The point of the 10-year statement is stability under noise. If you're rewriting it monthly, you're not doing the work; you're avoiding it."

### Constraint 2 — Required Inputs

Before writing, the user must share:
- **Current state** — annual income, current ARR (if applicable), customers, team size, hours/week worked
- **Last year's statement** (if any) — for delta comparison
- **3 things they're proudest of** in the last 12 months
- **3 things they'd undo** in the last 12 months
- **Honest assessment of luck vs skill** in their current outcomes

If any are missing, ask before writing.

### Constraint 3 — Reject Vague "Be Successful" Statements

If the user proposes:
- "Be financially independent" → reject; force specific number + date
- "Build a great company" → reject; force ARR, customers, team size
- "Help people" → reject; force specific people, specific help, specific count
- "Be happy" → reject; not measurable

This skill is operational. Save the existential questions for therapy.

---

## Workflow Overview

```
Step 1: Pull current state + last year's statement (if any)
Step 2: Run the annual scorecard (specific numbers)
Step 3: Identify dominant pattern of the year
Step 4: Calibrate the 10-year statement (specific, measurable, dated)
Step 5: Name the failure modes (what kills this)
Step 6: Apply the survivorship-bias check
Step 7: Set the next 90-day actions
Step 8: Output the complete statement + scorecard
```

---

## Step 1 — Pull Current State

Document the user's current situation:

```
DATE: [today]
YEARS INTO THIS WORK: [N]

Current state:
- Day job income: $___/year
- Side / indie ARR: $___
- Total customers: ___
- Team size (incl agents): ___
- Hours/week working: ___
- Audience size (X / LinkedIn / email list): ___
- Net worth: $___
- Months of personal runway: ___

Last year's statement:
[paste / "none"]
```

If there's no prior statement, this is year 0 of the journey. If there is, calculate every delta.

---

## Step 2 — The Annual Scorecard

Force the user through every section. Be specific. No platitudes.

### Required Output Format

```
📊 ANNUAL SCORECARD — [Year]

REVENUE & OUTCOMES
- ARR start of year: $___
- ARR end of year: $___
- Growth %: ___
- Customers start: ___ → end: ___
- Churn rate: ___% (industry benchmark: 30%+ for AI products)
- Gross margin: ___% (target: ≥ 70%)
- Cumulative revenue (lifetime): $___

WORK & HOURS
- Hours/week (avg): ___
- Days off taken: ___
- Burnout level (1-10): ___

DISTRIBUTION & AUDIENCE
- Followers gained: ___
- Email list growth: ___ → ___
- Inbound leads / month: ___
- Top working channel: ___
- Channel that disappointed: ___

LESSONS
3 things I'm proudest of:
1.
2.
3.

3 things I'd undo:
1.
2.
3.

3 specific things I learned (not generic):
1.
2.
3.

3 patterns I notice across this year:
1.
2.
3.

LUCK vs SKILL
- % of outcome attributable to skill (1-100): ___
- % attributable to luck / market: ___
- % attributable to brand / network: ___

If the user can't give specific numbers / sentences here, push back. Vague answers = no learning.
```

---

## Step 3 — Dominant Pattern

From the scorecard, force a single sentence:

> "The dominant pattern of the last 12 months was: ____________________"

This is the year's lesson. Examples:
- "I shipped fast but talked to too few customers."
- "I optimized for engagement instead of revenue."
- "I delayed the offer rebuild for 6 months and paid for it."
- "I underpriced for 9 months before raising and converted 80% of new prospects at the new price."

The dominant pattern is what the user takes into next year. If the user can't name it, they didn't learn from the year.

---

## Step 4 — Calibrate the 10-Year Statement

Force this exact structure (no free-form):

### Required Output Format

```
🎯 10-YEAR STATEMENT — Updated [date]

By [year + 10]:

I will be running [a product / a category / a company]
that solves [specific pain] for [specific people],
generating [specific revenue], with [specific work hours/week]
and [specific quality of life].

Specifically:
- ARR: $___M
- Customers: ___
- Team size (humans + agents): ___
- Hours/week: ___
- Days off / year: ___
- Net worth target: $___M
- Personal: [non-revenue goal — e.g., "live in 3 countries", "raise 2 kids"]

I commit to showing up [days/week] for the next 10 years
on this work, even when it's hard, even when it's slow,
even when others quit.

Year-by-year milestones:
| Year | ARR target | Key milestone |
|------|-----------|---------------|
| 1    |           |               |
| 3    |           |               |
| 5    |           |               |
| 7    |           |               |
| 10   |           |               |
```

Constraints on the statement:
- **Revenue must be a specific number** — not "millions"
- **Audience must be a specific person/role** — not "everyone"
- **Pain must be a specific pain** — not "X is hard"
- **Hours/week must be a specific number** — forces work-life tradeoff explicitness

---

## Step 5 — Name the Failure Modes

Most 10-year plans fail. Force the user to name HOW it fails for them, specifically:

```
HOW THIS DIES:

Risk 1: [specific failure mode] → mitigation: [specific action]
Risk 2: [specific failure mode] → mitigation: [specific action]
Risk 3: [specific failure mode] → mitigation: [specific action]
```

Examples:
- "I burn out by year 4 because I never built a real team / agentified team" → mitigation: hire fractional contractor by month 18
- "Anthropic releases the same feature in their core product and my moat evaporates" → mitigation: build customer-data lock-in by month 24
- "I get bored with the wedge by year 6" → mitigation: build a sustainable business so I can hire someone to run it while I start the next thing

If the user can't name 3 specific failure modes → they haven't thought about it enough. Push back.

---

## Step 6 — The Survivorship-Bias Check

Force the user to answer:

```
SURVIVORSHIP CHECK:

1. Who attempted my path 10 years ago and FAILED?
   List 3-5 specific people / projects:
   - ___
   - ___
   - ___

2. What did they have in common?
   [1-2 sentences]

3. What's different about my situation that I'm not just survivorship-biased?
   [be honest — could be: "nothing — I might be them in 10 years"]

4. What's my honest probability of hitting the 10-year statement?
   ___%
```

If the answer to #4 is > 50%, the user is being naïve. Median honest answer for ambitious 10-year plans: 5-15%.

If the user gives a number > 30%, push back: "Most successful operators rate their year-1 odds at < 20%. Calibrate down or articulate what makes you exceptional."

---

## Step 7 — Next 90-Day Actions

The 10-year statement is anchored in the next 90 days. Force:

```
NEXT 90 DAYS:

Action 1 (highest leverage): _____________________
By: [date]
Success metric: _____________________

Action 2: _____________________
By: [date]
Success metric: _____________________

Action 3: _____________________
By: [date]
Success metric: _____________________

Re-check date: [90 days from now]
```

Reject more than 3 actions. More than 3 = none get done.

---

## Step 8 — Output the Full Statement

### Required Output Format

```
═══════════════════════════════════════════════════════════════
  10-YEAR STATEMENT
  Date: [today]
  Year of journey: [N]
  Last reviewed: [date]
═══════════════════════════════════════════════════════════════

📊 ANNUAL SCORECARD ([year-1] → [year]):
[full scorecard from Step 2]

🔍 DOMINANT PATTERN OF THE YEAR:
"____________"

🎯 10-YEAR STATEMENT:
[full statement from Step 4 + year-by-year table]

⚠️ HOW THIS DIES:
[3 risks + mitigations from Step 5]

🤔 SURVIVORSHIP CHECK:
- Failed attempts:
- Common cause:
- My differentiator:
- Honest probability: __%

🏃 NEXT 90 DAYS:
[3 actions + success metrics]

📅 NEXT REVIEW: [date — 12 months out]

[Sign + print + tape to desk]
```

Force the user to actually print and tape it somewhere visible. Digital-only doesn't work; it disappears into Notion archaeology.

---

## Worked Example — Solo Indie at Year 3

**Current state:**
- Day job: ₹50L/yr ($60K)
- Indie ARR: $40K
- Customers: 95
- Hours/week: 60 (40 day job + 20 indie)
- Audience: 8K X followers, 2K email list

**Last year's statement:** "Hit $100K ARR by year 3, quit by year 5."

**This year's scorecard:**
- ARR: $20K → $40K (100% growth)
- Customers: 50 → 95
- Churn: 22% (down from 35%)
- Gross margin: 72% (up from 60%)
- Pattern: "Underpriced by 2× for the first 9 months; raised in Q3 and close rate held."

**10-year (revised):**
- By 2036: $5M ARR, 1500 customers, 0 employees + 5 agent roles, 25 hrs/week, $20M net worth, family + 2 sabbaticals taken.
- Y3: $100K ARR
- Y5: $500K ARR (quit job at $200K)
- Y7: $2M ARR
- Y10: $5M ARR

**How this dies:**
1. Anthropic releases the same vertical feature → mitigation: customer-data lock-in by Y4
2. Burn out at year 6 → mitigation: hire ops contractor at Y4; force 4-day week
3. Wedge gets boring → mitigation: build sustainable business so I can hire in Y6

**Survivorship check:**
- Failed attempts I know: 5 indie hackers who quit at $20K-$50K
- Common cause: distribution plateau without retention discipline
- My differentiator: I have a wedge with 75% gross margin and < 10% monthly churn after pricing fix
- Honest probability: 15-20% I hit the 10-year, 40% I hit $1M ARR

**Next 90 days:**
1. Ship Lesson 14-style margin audit; lift to 80% margin
2. Run [`retention-cohort-analyzer`](../retention-cohort-analyzer/SKILL.md); diagnose churn cohort
3. Friday post weekly without exception (12 posts in 90 days)

---

## Common Mistakes to Avoid

- **Do not write a vague statement.** "Be successful" is not a goal. Force specifics.
- **Do not skip the survivorship check.** Most ambitious plans fail; pretending otherwise = blind spot.
- **Do not commit to > 3 next-90-day actions.** More than 3 = none ship.
- **Do not redo the statement more than 2-3x/year.** Stability under noise is the point.
- **Do not skip the "how this dies" section.** Knowing failure modes = first-line defense.
- **Do not compare year-1 to others' year-5.** Survivorship bias kills careers.
- **Do not optimize for revenue alone.** Hours/week and quality-of-life are part of the statement.
- **Do not skip the "luck vs skill" honest assessment.** Most outcomes are 30-50% luck. Knowing this keeps you humble.

---

## Notes on Cadence

- **Annual:** full statement rewrite + scorecard (December or birthday)
- **Quarterly:** scorecard mini (numbers + pattern) + 90-day action recheck
- **Monthly:** read the statement aloud (10 min). Don't edit. Just read.
- **Weekly:** Friday review checks in against the 3 next-90-day actions

---

## Quick Reference — Specific Numbers to Force

If the user gives a vague answer, push back with the question:

| Vague | Force this question |
|-------|---------------------|
| "Successful" | "What's your specific ARR number? Your team size? Your hours/week?" |
| "Help people" | "Specifically which people? How many? What's the help worth?" |
| "Build a great product" | "Specifically what product? For whom? At what price?" |
| "Be financially free" | "Specifically what number, and on what date?" |
| "Have impact" | "Measured how? Counted in what unit?" |
| "Make great content" | "Read by whom? Driving what action? At what frequency?" |

Vague answers = no commitment. Specific answers = a contract with future you.

---

## Source

Lesson 20: [The 10-Year Compound](../../20-the-10-year-compound/README.md)
