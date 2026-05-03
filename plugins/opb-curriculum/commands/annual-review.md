---
description: Run the annual scorecard and update your 10-year statement. Forces specific numbers, year-over-year comparison, failure-mode planning, and survivorship-bias check.
argument-hint: "<this year + last year's statement + scorecard inputs (ARR, customers, hours/week, audience, lessons)>"
---

# /annual-review — Annual scorecard + 10-year statement

Runs the [`ten-year-statement-writer`](../skills/ten-year-statement-writer/SKILL.md) skill end-to-end. Use annually OR at major transitions (quitting day job, considering exit, hitting milestones).

## Use this when

- End of year (December)
- Birthday or anniversary
- After hitting $1M / $10M ARR (the math changes)
- After a major life transition (quit, exit offer, burnout recovery)

## Refuse to run if

- The user wants to redo their 10-year statement more than 2-3x/year (this is avoidance, not work)
- The user gives vague "be successful" / "be free" framings (force specific numbers)

## Workflow

The skill runs 8 steps:

1. **Pull current state** + last year's statement (if any)
2. **Annual scorecard** — specific numbers across revenue, work hours, distribution, lessons, luck-vs-skill
3. **Dominant pattern of the year** — one sentence, year's lesson
4. **Calibrate the 10-year statement** — specific revenue, customers, hours/week, year-by-year milestones
5. **Name the failure modes** — 3 specific ways this dies + mitigations
6. **Survivorship-bias check** — who failed at this path; what's different about you (honest)
7. **Next 90 days** — 3 specific actions max
8. **Output the full statement** — print and tape to desk

## After this command

- Print the full statement; tape it somewhere visible
- Re-read monthly (10 min, no editing)
- Quarterly: scorecard mini + 90-day action recheck
- Re-run this command in 12 months (calendar reminder)

## Pairs with

- `/plan-week` — translate the 10-year statement into this week's cadence
- `/diagnose-stall` — if year-over-year revenue isn't moving, diagnose why
- `/audit-product` — if scorecard reveals the product side is weak

## What this command refuses

- Vague statements ("be successful")
- Statements without failure-mode planning
- Probability of success > 30% (most ambitious 10-year plans have < 15% honest odds)
- More than 3 next-90-day actions (more = none ship)
