---
name: sales-rep-effectiveness
description: >
  Use this skill whenever the user wants to rank SDRs / AEs by quality of
  pipeline using a weighted composite score of win rate, average ACV, and
  opportunity volume. Trigger when the user mentions phrases like "rep
  effectiveness", "rep ranking", "SDR quality score", "AE composite ranking",
  or shares per-rep performance data.
---

# Sales Rep Effectiveness

Ranks reps by a composite quality-of-pipeline score combining win rate, ACV, and volume. Used to inform variable comp design and territory assignment.

## Hard Constraints
- Required: per-rep deal data last 4 quarters (pipeline created, won, lost, ACV)
- Refuse: ranking with < 10 deals per rep (small sample)

## Workflow
1. Compute per rep: win rate, avg ACV, total ARR closed, pipeline created
2. Normalize each metric (0-1 scale)
3. Composite score = (win rate × 0.4) + (avg ACV percentile × 0.3) + (volume percentile × 0.3)
4. Rank reps
5. Identify outliers: high-volume low-quality vs low-volume high-quality
6. Recommend territory / comp adjustments

## Required Output Format
```
### Sales Rep Effectiveness — [Window]

| Rank | Rep | Win rate | Avg ACV | ARR closed | Pipeline created | Composite | Note |
|------|-----|----------|---------|------------|------------------|-----------|------|

### Outliers
- High-volume low-quality: [rep] — coach quality, slow volume
- Low-volume high-quality: [rep] — coach activity, protect from over-quota
- Balanced top: [rep] — promote / mentor others

### Recommendations
- Territory adjustment: [based on top reps' segment fit]
- Comp design implication: [reward composite, not just volume]
```

## Common Mistakes
- Volume-only ranking (Sandbagging the deal type)
- Win rate-only ranking (favors enterprise reps with small pipelines)
- Ignoring lead source (some reps get richer source mix)
- Not adjusting for tenure (1-quarter rep vs 8-quarter rep)

## Tooling
- Petavue MCP, Salesforce, Clari, Gong, Xactly for comp design

## Source
[Petavue — Sales Rep Effectiveness](https://www.petavue.com/resources/prompts) — Sales
