---
name: lead-deal-conversion-overall-by-stage
description: >
  Use this skill whenever the user wants to build a multi-stage conversion
  funnel for the past two quarters, report conversion rates and stage durations,
  and surface stalled large deals. Trigger when the user mentions phrases like
  "multi-stage funnel", "stage conversion", "stalled deals", "pipeline funnel",
  or shares stage-level data.
---

# Lead → Deal Conversion (Overall & By Stage)

Builds a multi-stage funnel (Lead → MQL → SQL → Opp → Closed-Won) with conversion rates AND stage durations. Surfaces stuck large deals.

## Hard Constraints
- Required: stage history per Lead/Opp from last 2 quarters
- Refuse: per-stage analysis without stage definitions confirmed (different orgs use different names)

## Workflow
1. Build the funnel: count of records at each stage, conversion to next stage
2. Compute avg duration per stage
3. Identify stuck cohorts (deals taking 2-3× avg in any stage)
4. Filter stuck cohorts to large deals (above-median ARR)
5. Surface for management attention

## Required Output Format
```
### Multi-Stage Conversion Funnel — [Last 2 quarters]

| Stage | Entered | Converted | Conv % | Avg duration |
|-------|---------|-----------|--------|--------------|
| Lead | | | __% | __ days |
| MQL | | | __% | __ days |
| SQL | | | __% | __ days |
| Opp | | | __% | __ days |
| Closed-Won | | — | — | — |

### Stuck Large Deals (above-median ARR, 2× avg stage duration)

| Deal | ARR | Stage | Days in stage | Avg | Owner | Action |
|------|-----|-------|---------------|-----|-------|--------|
```

## Common Mistakes
- Funnel without stage durations (rate alone misses where time is lost)
- Not filtering stuck list to large deals (too noisy)
- Treating different segments as one funnel (enterprise vs SMB have different stages)
- Reporting funnel quarterly only (weekly catches issues earlier)

## Tooling
- GTM analytics MCP, Salesforce, HubSpot, Clari

## Source
Industry GTM analytics pattern — Sales / RevOps
