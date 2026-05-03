---
name: stuck-pipeline-alerting
description: >
  Use this skill whenever the user wants to identify stalled deals by stage,
  trigger follow-ups, and give managers clear visibility into pipeline
  slippage. Trigger when the user mentions phrases like "stuck pipeline",
  "pipeline alerting", "stalled deals", "deal slippage", "manager pipeline
  review", or shares stage-level pipeline data. Use weekly + daily in
  last-3-weeks of quarter.
---

# Stuck Pipeline Alerting

Identifies stalled deals by stage and generates manager-ready alerts with recommended action per stuck deal.

## Hard Constraints
- Required: open opps with stage history + last activity, avg duration per stage
- Refuse: blanket close-out (some stuck = real customer-side delay)

## Workflow
1. Compute avg duration per stage (last 90 days won deals)
2. For each open opp: time in current stage vs avg
3. Tier: Watch (1.5×), Concern (2×), Critical (3×+)
4. Cross with last-activity date
5. Identify stuck-by-stage patterns (which stage has most stuck deals?)
6. Generate per-deal action recommendations

## Required Output Format
```
### Stuck Pipeline Alerting — [Date]

**Tier Critical (3×+ avg stage duration):**
| Deal | ARR | Owner | Stage | Days in stage | Last activity | Action |
|------|-----|-------|-------|---------------|---------------|--------|

**Tier Concern (2×):**
| Deal | ARR | Owner | Stage | Action |

**Tier Watch (1.5×):**
| Count | $ at risk |

**Patterns:**
- Most-stuck stage: [stage] — coach team on stage-progression criteria
- Most-stuck rep: [rep] — 1:1 coaching needed
- Most-stuck source: [source] — lead-quality issue

**Manager dashboard summary:**
- Total at risk: $___ (across __ deals)
- New stuck this week: __ deals (movement is the signal)
- Recovered this week: __ deals (positive trend)
```

## Common Mistakes
- Using one threshold across stages (Discovery normally takes longer than Negotiation)
- Treating "stuck" as one-snapshot (movement matters)
- Auto-emailing reps without manager involvement (annoying noise)
- Ignoring buyer-side delays (ask rep before flagging as "rep needs coaching")

## Tooling
- GTM analytics MCP, Salesforce (with stage history enabled), Clari, Gong, Outreach for follow-up

## Source
Industry GTM analytics pattern — RevOps / Sales
