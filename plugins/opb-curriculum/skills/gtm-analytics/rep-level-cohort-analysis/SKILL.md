---
name: rep-level-cohort-analysis
description: >
  Use this skill whenever the user wants to optimize AE onboarding and ramp by
  comparing pipeline creation and conversion performance across hiring cohorts.
  Trigger when the user mentions phrases like "rep cohort analysis",
  "onboarding ramp", "AE ramp time", "hiring cohort performance", or shares
  rep-tenure + performance data.
---

# Rep-Level Cohort Analysis

Compares AE/SDR performance across hiring cohorts to optimize onboarding and ramp time.

## Hard Constraints
- Required: rep list with hire dates, monthly performance metrics (pipeline created, deals won, ARR closed)
- Refuse: cohort comparison with < 5 reps per cohort (sample noise)

## Workflow
1. Group reps by hire-month cohort
2. For each cohort: month-by-month performance from hire date (Month 1, Month 2, ... Month 12)
3. Compare ramp curves across cohorts
4. Identify cohorts that ramped fastest / slowest
5. Cross with onboarding changes (which cohort got which version of training)
6. Recommend onboarding process improvements

## Required Output Format
```
### Rep-Level Cohort Analysis — Hire Month Cohorts

| Cohort | Rep count | Month 3 ARR | Month 6 ARR | Month 12 ARR | Ramp time (months to quota) |
|--------|-----------|-------------|-------------|--------------|------------------------------|

### Insights
- Fastest-ramping cohort: [cohort + onboarding version]
- Slowest-ramping cohort: [cohort + likely cause]

### Recommendations
- Replicate: [onboarding element from fast-ramp cohort]
- Cut: [onboarding element from slow-ramp cohort]
- Test next: [hypothesis-driven change for next cohort]
```

## Common Mistakes
- Cohort comparison without onboarding-version tagging (can't tell what changed)
- Ignoring market conditions (Q4 hires ramp differently than Q1)
- Treating quota attainment as the only ramp metric (pipeline-create speed is leading indicator)
- Not separating BDR-promoted-to-AE vs external hires (different ramp curves)

## Tooling
- GTM analytics MCP, Salesforce, BambooHR / Lever for hire-date data, Gong / Outreach for activity

## Source
Industry GTM analytics pattern — Sales
