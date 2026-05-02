---
name: pv-retention-cohort-breakdown
description: >
  Use this skill whenever the user wants a detailed retention cohort breakdown
  with churn timing, net vs expansion retention, segment cuts, and key churn
  driver analysis. Trigger when the user mentions phrases like "retention
  cohort breakdown", "net vs expansion retention", "NDR by cohort", "churn
  driver analysis", or shares retention data. NOTE: this is the Petavue
  enterprise-flavored skill; for solo-operator AI products, use the parent
  retention-cohort-analyzer skill which adds churn-interview enforcement.
---

# Petavue Retention Cohort Breakdown

Detailed cohort retention analysis with: churn timing distribution, Net Dollar Retention vs Gross Retention, segment cuts, and churn-driver attribution.

## Hard Constraints
- Required: cohort start dates, monthly retention data (M0-M24), expansion vs churn vs downgrade per cohort
- Refuse: NDR computation without expansion data

## Workflow
1. Build cohort table (start month → M0-M24 retention)
2. Compute Gross Dollar Retention (excludes expansion)
3. Compute Net Dollar Retention (includes expansion)
4. Cut by segment (size, industry, product tier)
5. Identify churn timing distribution (M3 cliff, M6 cliff, M12 renewal cliff)
6. Attribute top churn drivers per cohort

## Required Output Format
```
### Retention Cohort Breakdown — [Cohorts: Y month YYYY through Z month YYYY]

**Aggregate metrics:**
- Net Dollar Retention: __%
- Gross Dollar Retention: __%
- Logo retention: __%

**Cohort table:**
| Cohort | M0 | M3 | M6 | M12 | M18 | M24 | NDR |

**Churn timing:**
| Window | Churn % | Top driver |
|--------|---------|------------|
| M0-M3 | __% | |
| M3-M6 | __% | |
| M6-M12 | __% | |
| M12-M18 | __% | |

**By segment:**
| Segment | NDR | GDR | Notable |
```

## Common Mistakes
- NDR vs GDR confusion (NDR > 100% is possible with strong expansion; GDR can't exceed 100%)
- Cohort comparison without controlling for tenure
- Reporting NDR alone (always pair with GDR)
- Single-quarter view (need 4+ quarters for trend)

## Tooling
- Petavue MCP, Salesforce / HubSpot, ChartMogul, ProfitWell, Gainsight

## Source
[Petavue — Retention cohort breakdown](https://www.petavue.com/resources/prompts) — CX

For solo / smaller AI products, use [`retention-cohort-analyzer`](../../retention-cohort-analyzer/SKILL.md) which enforces 5-mandatory-churn-interviews and is calibrated for sub-$10M ARR products.
