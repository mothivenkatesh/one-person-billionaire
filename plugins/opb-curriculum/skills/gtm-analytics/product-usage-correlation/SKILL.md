---
name: product-usage-correlation
description: >
  Use this skill whenever the user wants to identify usage thresholds tied to
  high renewal rates and surface at-risk accounts based on product engagement.
  Trigger when the user mentions phrases like "product usage correlation",
  "usage threshold for retention", "magic number", "aha moment metric",
  "activation thresholds", or shares usage + renewal data.
---

# Product Usage Correlation

Identifies the product-usage thresholds that correlate with high renewal rates. Output: the "magic numbers" that distinguish renewing customers from churners.

## Hard Constraints
- Required: account-level product usage data, renewal outcomes per account, usage taxonomy (which features count)
- Refuse: analysis without ≥ 200 accounts (small sample obscures threshold)

## Workflow
1. Bucket accounts by usage level on each key feature (low / medium / high — quartiles)
2. Compute renewal rate per bucket per feature
3. Identify features where high-usage cohort has > 90% renewal vs < 60% for low-usage
4. These are "magic number" features (e.g., "uses feature X 5+ times per week")
5. Surface at-risk accounts (below magic-number threshold)
6. Recommend in-product nudges or CSM action

## Required Output Format
```
### Product Usage Correlation — Magic Numbers

**Top magic-number features:**

| Feature | Threshold | Renewal rate above | Renewal rate below |
|---------|-----------|--------------------|--------------------|
| | "X uses/week" | __% | __% |
| | | __% | __% |

**At-risk accounts (below ≥ 1 magic threshold):**
| Account | ARR | Below thresholds | Renewal date | Action |
|---------|-----|------------------|--------------|--------|

**Recommended interventions:**
- In-product nudge: feature X
- CSM playbook: train customers below magic threshold
- Onboarding goal: hit magic threshold by day 30
```

## Common Mistakes
- Treating correlation as causation (high usage might just mean "good fit," not "usage drives renewal")
- Single-feature focus (combine 2-3 magic features for stronger signal)
- Ignoring segment (enterprise magic numbers ≠ SMB)
- Not testing the threshold via intervention (correlation needs experimentation to validate)

## Tooling
- GTM analytics MCP, Pendo / Mixpanel / Amplitude, Salesforce / Gainsight

## Source
Industry GTM analytics pattern — CX
