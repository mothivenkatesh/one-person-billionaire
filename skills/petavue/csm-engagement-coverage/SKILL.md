---
name: csm-engagement-coverage
description: >
  Use this skill whenever the user wants to analyze how CSM engagement frequency
  correlates with renewal, expansion, and churn outcomes to determine the
  impact of touchpoint cadence. Trigger when the user mentions phrases like
  "CSM cadence", "engagement frequency vs retention", "CSM ROI", "touchpoint
  optimization", or shares CSM activity + renewal data. Use this skill to
  optimize CSM headcount allocation.
---

# CSM Engagement Coverage

Correlates CSM touchpoint frequency with renewal / expansion / churn outcomes. Answers: "what's the optimal CSM cadence per ARR tier?"

## Hard Constraints
- Required: CSM activity data (last 12 months), renewal outcomes per account, ARR per account
- Refuse if no activity classification (touch type matters: QBR vs check-in)

## Workflow
1. Bucket accounts by CSM touch frequency (none / monthly / bi-weekly / weekly)
2. Compute renewal rate, expansion rate, churn rate per bucket
3. Cross-cut by ARR tier (small / mid / enterprise)
4. Identify optimal cadence per tier (where outcomes peak)
5. Recommend CSM ratio per tier

## Required Output Format
```
### CSM Engagement Coverage Analysis

| ARR tier | None | Monthly | Bi-weekly | Weekly | Optimal cadence |
|----------|------|---------|-----------|--------|-----------------|
| < $20K | _% renew | _% | _% | _% | |
| $20-100K | _% | _% | _% | _% | |
| $100K+ | _% | _% | _% | _% | |

Recommendation: CSM ratio of 1:N per tier
```

## Common Mistakes
- Treating all touchpoints as equal (a QBR ≠ a Slack ping)
- Not adjusting for selection bias (high-value accounts already get more touch)
- Recommending one cadence for all tiers

## Tooling
- Petavue MCP, Salesforce, Gainsight, ChurnZero

## Source
[Petavue — CSM Engagement Coverage](https://www.petavue.com/resources/prompts) — CX
