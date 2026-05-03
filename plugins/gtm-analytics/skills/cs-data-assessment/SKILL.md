---
name: cs-data-assessment
description: >
  Use this skill whenever the user wants to audit Customer Success data fields
  in their CRM or data warehouse for presence, completeness, standardization,
  and cleanup. Trigger when the user mentions phrases like "CS data audit",
  "customer success data hygiene", "CSM data quality", "fix my CS data", or
  shares CRM CS field data. Always use this skill before building CS dashboards
  or running churn analysis — bad data = bad decisions.
---

# CS Data Assessment

Audits CS-relevant fields in CRM/warehouse for completeness, standardization, and gaps. Output is a prioritized cleanup list.

## Hard Constraints
- Required: list of CS fields tracked, sample of records, definition of "complete"
- Refuse: assessment without sample data; force user to provide ≥ 100 records

## Workflow
1. Inventory CS fields (CSM owner, health score, renewal date, ARR, segment, last QBR, NPS, escalation flag, etc.)
2. Compute % completion per field across sample
3. Identify standardization issues (free-text where pick-list expected, etc.)
4. Cross-check linkage (CSM owner ↔ user table; account ↔ opportunities)
5. Prioritize cleanup by (impact × effort)

## Required Output Format
```
### CS Data Assessment

| Field | Completion % | Standardized? | Issue | Priority | Cleanup effort |
|-------|--------------|---------------|-------|----------|----------------|
| Health score | __% | Y/N | | High/Med/Low | hrs |
```

## Common Mistakes
- Auditing without a target completion threshold
- Cleanup priorities ignoring impact (fix the high-leverage fields first)
- Manual cleanup at scale (use bulk update with QA)

## Tooling
- GTM analytics MCP, Salesforce / HubSpot, Looker / Tableau for visualization

## Source
Industry GTM analytics pattern — CX
