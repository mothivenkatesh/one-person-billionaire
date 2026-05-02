---
name: lead-deal-conversion-by-speed
description: >
  Use this skill whenever the user wants to segment Closed-Won deals by
  days-to-close cohorts, measure win rates and deal size per cohort, and
  recommend SLA tweaks. Trigger when the user mentions phrases like "deal
  velocity by speed", "fast vs slow deals", "days to close cohorts", "SLA
  optimization", or shares cycle-length data.
---

# Lead → Deal Conversion by Speed

Segments Closed-Won deals by cycle length, computes win rate + deal size per cohort, and recommends SLA tweaks.

## Hard Constraints
- Required: Closed-Won deals last 4 quarters with first-touch + close dates
- Refuse: cohorts with < 30 deals (sample noise)

## Workflow
1. Bucket Closed-Won deals into cycle-length cohorts (< 30 days, 30-60, 60-90, 90-180, 180+ days)
2. Compute win rate per cohort (vs Closed-Lost in same window)
3. Compute avg deal size per cohort
4. Compute total revenue per cohort
5. Recommend: which cohorts to push toward (faster = better margin if quality holds)

## Required Output Format
```
### Lead → Deal Conversion by Speed — [Window]

| Cohort | Closed-Won | Closed-Lost | Win rate | Avg deal size | Total revenue |
|--------|------------|-------------|----------|---------------|---------------|
| < 30 days | | | __% | $ | $ |
| 30-60 days | | | __% | $ | $ |
| 60-90 days | | | __% | $ | $ |
| 90-180 days | | | __% | $ | $ |
| 180+ days | | | __% | $ | $ |

**Insight:** Sweet spot cohort: [N days] — best win rate × deal size.
**SLA recommendation:** Push deals beyond [threshold] for re-evaluation.
```

## Common Mistakes
- Optimizing for fastest only (sometimes slow + big > fast + small)
- Ignoring win rate when picking sweet spot
- Cohort comparison without segment cut (enterprise deals are slower; that's normal)
- Setting SLAs without rep input (rep-impossible SLAs get ignored)

## Tooling
- Petavue MCP, Salesforce, HubSpot Sales, Clari

## Source
[Petavue — Lead — Deal Conversion by Speed](https://www.petavue.com/resources/prompts) — Sales / RevOps
