---
name: data-assessment-opportunities
description: >
  Use this skill whenever the user wants to audit Opportunity data for stuck
  stages, missing close dates, role gaps, or fields that slow conversion.
  Trigger when the user mentions phrases like "opp data quality", "stuck deals",
  "missing close dates", "opp hygiene", or shares opportunity data. Use before
  forecast review meetings.
---

# Data Assessment — Opportunities

Audits Opportunity-object completeness, stage progression, and field hygiene.

## Hard Constraints
- Required: open opps + closed opps from last 4 quarters, stage definitions
- Refuse: forecast review without this audit (garbage in = garbage forecast)

## Workflow
1. Inventory critical opp fields (amount, close date, stage, owner, primary contact, next step, competitor)
2. Compute completion % per field
3. Detect stuck stages (opps in same stage > avg duration × 2)
4. Detect missing close dates (or close dates in past for open opps)
5. Detect missing primary contact / role linkage
6. Detect single-threaded opps (only 1 contact involved)

## Required Output Format
```
### Opportunity Data Assessment

| Field | Completion % | Issue | Priority |
|-------|--------------|-------|----------|

**Stuck opps:** ___ ( > avg stage duration × 2 )
**Missing close dates:** ___
**Past-due open opps:** ___
**Single-threaded opps:** ___ (risk: champion leaves = deal dies)

**Top 3 forecast risks:**
1. [opp + reason]
2. [opp + reason]
3. [opp + reason]
```

## Common Mistakes
- Cleaning historical data before fixing rep behavior (recurring issue)
- Ignoring single-threading (the stealth pipeline killer)
- Forecast adjustments without first cleaning data
- Not enforcing required fields at stage-progression

## Tooling
- Petavue MCP, Salesforce, HubSpot Sales, Clari, Gong

## Source
[Petavue — Data Assessment Opportunities](https://www.petavue.com/resources/prompts) — Systems & Data / RevOps
