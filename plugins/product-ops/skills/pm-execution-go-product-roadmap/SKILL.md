---
name: pm-execution-go-product-roadmap
description: "Build Roman Pichler's GO Product Roadmap — a goal-oriented format with columns Date · Name · Goal · Features · Metrics. Each row = one release tied to ONE outcome goal. Use when replacing a feature-list roadmap, aligning a team on outcomes not output, or communicating roadmap to execs without committing to features-by-date."
---

# GO Product Roadmap (Roman Pichler)

## Purpose

Feature roadmaps commit to outputs ("ship X by Q3") and rot the moment market reality shifts. Pichler's Goal-Oriented (GO) Roadmap commits to outcomes ("acquire enterprise users by Q3") and leaves the features as the variable. It's the bridge between product strategy and execution — and the format execs actually understand.

This skill applies Roman Pichler's framework.

## When to Use

- Replacing a Gantt-chart feature roadmap that keeps slipping
- Communicating direction to execs without locking specific features
- Aligning a team on WHAT outcome we're chasing this release, not WHICH features
- Onboarding new hires — one page captures the next 6-12 months
- Defending the roadmap from "just add this one thing" requests

## The Five Columns

| Column | What It Holds | Example |
|---|---|---|
| **Date** | Release timeframe (quarter or month). Avoid exact day-of dates. | Q3 2026 |
| **Name** | Release codename, easy to refer to | "Enterprise GA" |
| **Goal** | The single outcome this release achieves. Goal-types: acquire, activate, engage, retain, monetize, reduce cost. | "Acquire 20 enterprise customers" |
| **Features** | High-level capability list (3-5 max) that serves the goal. NOT detailed specs. | SSO · Audit log · Role-based permissions · Custom contracts |
| **Metrics** | How we measure the goal was met | 20 signed enterprise contracts · $500K ARR added |

**One row = one release = one goal.** That's the discipline.

## Goal Types (Pichler's Six Common Goals)

1. **Acquire** new users / customers / segments
2. **Activate** users to first value
3. **Engage** existing users (depth, frequency)
4. **Retain** users (reduce churn, increase renewal)
5. **Monetize** (revenue per user, conversion to paid)
6. **Reduce cost** (operational, support, infrastructure)

If you can't classify your goal as one of these, the row probably has two goals tangled together.

## How It Differs From Feature Roadmaps

| Feature Roadmap | GO Roadmap |
|---|---|
| Output-oriented | Outcome-oriented |
| Lists features by date | Lists goals by date |
| Slips when scope grows | Holds even when features change |
| Hard to defend in tradeoffs | Easy — the goal is the anchor |
| Suggests features are commitments | Suggests outcomes are commitments |

## Cadence

- **Plan horizon:** 6-12 months
- **Granularity:** One row per quarter (or per release, if releases are bigger than quarters)
- **Update cadence:** Review monthly. Update when learning lands, not when calendars flip.
- **Communication cadence:** Share with execs quarterly; share with team weekly via standup link.

## Worked Example

| Date | Name | Goal | Features | Metrics |
|---|---|---|---|---|
| Q3 2026 | Enterprise GA | Acquire 20 enterprise customers | SSO · Audit log · RBAC · Custom MSAs | 20 signed contracts · $500K ARR added |
| Q4 2026 | Activation Push | Activate 60% of new signups to first checkout in 7 days | Onboarding overhaul · Sample-data import · In-app checklist | Activation 35% → 60% |
| Q1 2027 | Retention Engine | Reduce 90-day churn from 12% to 7% | Health-score dashboard · Auto-renewal workflows · CSM playbook | Churn 12% → 7% |

## Process

1. **Start from product strategy.** Each row's Goal must trace to a strategic priority.
2. **One goal per release.** If you have two, split into two releases or rewrite the goal.
3. **Features serve the goal — list 3-5 max.** More features = your goal is too broad.
4. **Define the metric BEFORE the features.** If you can't measure it, it's not a goal.
5. **Review with team monthly.** Capture which features changed (expected) and whether the goal still holds (the important question).
6. **Share with execs as-is.** No need for a "leadership version." If they ask for one, the GO format is already the right level.

## Output

A one-page GO Roadmap (Notion / Miro / spreadsheet) with:
- 3-6 rows (next 6-12 months)
- All five columns filled
- Owner per row
- Linked to product strategy doc and live metrics dashboard
- Last-updated date

## Tips

- The Features column is the most-edited; the Goal column should be the least-edited. If goals are shifting weekly, the strategy is the actual problem.
- "Increase engagement" is not a goal — it's a category. The metric forces specificity.
- Avoid more than 6 rows. A 12-row roadmap is a wishlist, not a plan.
- When a stakeholder requests a feature, ask "which row's goal does this serve?" — kills 80% of off-strategy asks.

---

### Further Reading

- Roman Pichler, *Agile Product Management with Scrum* and *Strategize* (books) — extended treatment of GO Roadmap
- [The Product Vision Board — Roman Pichler](https://www.romanpichler.com/blog/the-product-vision-board/)
- Existing skill: `pm-execution-outcome-roadmap` (generic outcome-oriented roadmap; GO is Pichler's specific format)
