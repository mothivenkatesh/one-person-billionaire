---
name: low-account-health
description: >
  Use this skill whenever the user wants to diagnose and preempt at-risk
  accounts by analyzing low health scores to guide targeted retention actions.
  Trigger when the user mentions phrases like "low account health", "health
  score drill-down", "at-risk accounts by health", "CSM playbook for low
  health", or shares health-score data. Pairs with churn-risk-radar but is
  health-score-driven (single signal) vs multi-signal.
---

# Low Account Health

Drills into accounts with low health scores to diagnose root cause and recommend specific actions. Pairs with churn-risk-radar (multi-signal) — this skill is health-score-driven (faster but noisier).

## Hard Constraints
- Required: account list with health scores, health-score components (usage, support, engagement, NPS)
- Refuse: action recommendation without component breakdown (composite score alone is opaque)

## Workflow
1. Pull accounts with health < threshold (default: bottom 20% or score < 50)
2. Decompose: which component is dragging score (usage / support / engagement / NPS)
3. Cross with renewal date (closer = higher urgency)
4. Cross with ARR (high ARR = higher priority for human touch)
5. Recommend per account: action playbook based on dominant low component

## Required Output Format
```
### Low Account Health Diagnostic — [Date]

**Threshold:** Health score < ___
**Accounts flagged:** ___ (total ARR at risk: $___)

| Account | ARR | Health | Renewal | Dominant low component | Recommended action |
|---------|-----|--------|---------|------------------------|--------------------|
| | $ | | [date] | Usage / Support / Engagement / NPS | |

### Patterns

- Most-common dominant low component: [component]
- Industry / segment skew: [if any]
- Renewal-window urgency: __ accounts closing in 90 days
```

## Common Mistakes
- Acting on composite score alone (without knowing what's dragging it)
- Treating low NPS without context (NPS drops after big rollout aren't all churn)
- One-size-fits-all save playbook (low usage ≠ same fix as low engagement)
- Not validating health score formula (sometimes the score is wrong, not the customer)

## Tooling
- Petavue MCP, Gainsight, ChurnZero, Vitally, Salesforce, Pendo for usage

## Source
[Petavue — Low Account Health](https://www.petavue.com/resources/prompts) — CX
