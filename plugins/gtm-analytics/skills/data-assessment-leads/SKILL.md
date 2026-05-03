---
name: data-assessment-leads
description: >
  Use this skill whenever the user wants to audit Lead data completeness and
  standardization for better segmentation, scoring, and routing. Trigger when
  the user mentions phrases like "lead data quality", "lead scoring data",
  "lead routing data", "fix my leads", or shares lead data. Always use before
  redesigning lead scoring or routing rules.
---

# Data Assessment — Leads

Audits Lead-object data for fields critical to segmentation, scoring, and routing.

## Hard Constraints
- Required: ≥ 500 leads sample, lead-source field defined, target completion thresholds
- Refuse: assessment without scoring rules in mind (you need a goal for the audit)

## Workflow
1. Inventory critical lead fields (source, source detail, country, company, title, industry, employee count, persona)
2. Compute completion % per field
3. Detect standardization issues (e.g., country: "USA" vs "United States" vs "US")
4. Detect routing-blockers (missing fields that prevent assignment)
5. Score data quality per source (which sources deliver clean leads vs garbage)

## Required Output Format
```
### Lead Data Assessment

| Field | Completion % | Standardized? | Routing-critical? | Priority |
|-------|--------------|---------------|-------------------|----------|

**By source:**
| Source | Lead volume | Avg completion % | Quality grade |
|--------|-------------|------------------|---------------|

**Top 3 fixes:**
1.
2.
3.
```

## Common Mistakes
- Auditing without a routing/scoring goal
- Ignoring source-level quality (some sources are systematically dirty)
- Manual standardization at scale (use rules + enrichment)
- Not enforcing required fields at form-submit (cleanup is endless without prevention)

## Tooling
- GTM analytics MCP, Salesforce, HubSpot, Clearbit / Apollo for enrichment, ZoomInfo

## Source
Industry GTM analytics pattern — Marketing / Systems & Data / RevOps
