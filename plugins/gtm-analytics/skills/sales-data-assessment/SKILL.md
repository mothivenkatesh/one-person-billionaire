---
name: sales-data-assessment
description: >
  Use this skill whenever the user wants to ensure CRM data is complete and
  standardized so they can trust rep performance metrics, diagnose pipeline
  health, and drive process improvements. Trigger when the user mentions
  phrases like "sales data audit", "CRM data quality", "rep activity data",
  "pipeline data hygiene", "broken sales metrics", or shares sales CRM data.
---

# Sales Data Assessment

Audits sales-relevant CRM fields (rep activity, opportunity, account) for completeness + consistency. Output: prioritized cleanup + enforcement roadmap.

## Hard Constraints
- Required: ≥ 200 records sample across reps, target completion thresholds, list of metrics that depend on the fields
- Refuse: cleanup without metric-dependency map (cleaning fields nobody reports on = wasted time)

## Workflow
1. Inventory sales-critical fields (next step, close date, amount, stage, decision criteria, competitor, primary contact, role)
2. Compute completion % per field overall + per rep
3. Detect rep-level outliers (rep X has 30% completion; team avg 80%)
4. Map fields to metrics (which dashboards / forecasts depend on this field?)
5. Prioritize cleanup by metric-impact
6. Recommend enforcement (required at stage progression)

## Required Output Format
```
### Sales Data Assessment

| Field | Avg completion | Worst rep completion | Metrics affected | Cleanup priority |
|-------|----------------|---------------------|------------------|------------------|

**Per-rep summary:**
| Rep | Avg completion | Reports affected | Coaching action |
|-----|----------------|------------------|-----------------|

**Top 3 enforcement rules to implement:**
1. [Field X required at stage progression to Demo]
2.
3.
```

## Common Mistakes
- Cleaning fields that nothing reports on (audit value chain first)
- Treating low rep-completion as "rep is bad" (often = process or training gap)
- One-time cleanup (recurs without enforcement)
- Manual enforcement (use validation rules, not nag emails)

## Tooling
- GTM analytics MCP, Salesforce, HubSpot, Outreach / Salesloft, Clari

## Source
Industry GTM analytics pattern — Sales
