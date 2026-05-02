---
name: propensity-to-renew
description: >
  Use this skill whenever the user wants to cluster customer accounts by
  feature/module usage and predict renewal and expansion likelihood per
  account. Trigger when the user mentions phrases like "propensity to renew",
  "renewal prediction", "expansion likelihood", "account scoring for
  renewal", or shares feature-usage + renewal data.
---

# Propensity to Renew

Clusters customer accounts by usage pattern and predicts renewal + expansion likelihood per cluster.

## Hard Constraints
- Required: account-level feature/module usage (last 90 days), historical renewal outcomes for similar usage patterns
- Refuse: prediction without ≥ 2 quarters of historical renewal data per cluster

## Workflow
1. Cluster accounts by usage pattern (k-means or rule-based on top features)
2. For each cluster, compute historical renewal rate + expansion rate
3. Score current accounts by cluster (highest renewal-likely cluster = "safe", lowest = "at-risk")
4. Cross with renewal date (urgency)
5. Recommend per cluster: account-management playbook

## Required Output Format
```
### Propensity to Renew — [Date]

| Cluster | Account count | Total ARR | Historical renewal % | Historical expansion % | Risk tier |
|---------|---------------|-----------|----------------------|------------------------|-----------|
| Power users | | $ | __% | __% | Safe |
| Steady users | | $ | __% | __% | Watch |
| Low-engagement users | | $ | __% | __% | At-risk |
| Inactive users | | $ | __% | __% | Critical |

### Recommended Playbooks per Cluster
- Power users → expansion outreach
- Steady users → maintain engagement
- Low-engagement → re-onboard
- Inactive → save action this week
```

## Common Mistakes
- Cluster count too high (3-5 clusters max for actionability)
- Predicting from pattern without intervention validation
- Treating cluster as static (accounts move between clusters)
- Ignoring time-in-cluster (someone in "low" for 90 days vs 7 days are different)

## Tooling
- Petavue MCP, Pendo / Mixpanel / Amplitude, Gainsight, custom ML in Python / R

## Source
[Petavue — Propensity to Renew](https://www.petavue.com/resources/prompts) — CX
