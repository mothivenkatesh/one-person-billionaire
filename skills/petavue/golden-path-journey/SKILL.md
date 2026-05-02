---
name: golden-path-journey
description: >
  Use this skill whenever the user wants to discover the most effective and
  repeatable GTM engagement sequences that consistently lead to Closed-Won
  outcomes. Trigger when the user mentions phrases like "golden path",
  "winning journey", "repeatable conversion sequence", "what wins deals", or
  shares GTM journey data. Use to design playbook based on data, not vibes.
---

# Golden Path Journey

Identifies the engagement sequences (multi-touch, multi-channel) that most reliably convert to Closed-Won. Used to design data-backed sales/marketing playbooks.

## Hard Constraints
- Required: full touchpoint history per Closed-Won deal (last 4 quarters), and per Closed-Lost deal
- Refuse: paths with < 30 deals (sample noise)

## Workflow
1. Build full sequence per deal (channel + asset + role + timing)
2. Cluster sequences by similarity (3-5 touch patterns)
3. Compute Closed-Won rate per cluster
4. Compare top sequences to baseline
5. Identify "golden paths" (top 5 sequences with ≥ 2× baseline)
6. Design playbook: how to engineer more deals into golden paths

## Required Output Format
```
### Golden Path Journey

**Baseline conversion:** __%
**Top 5 golden paths:**

| Rank | Sequence | Deals | Closed-Won % | Multiplier | Playbook design |
|------|----------|-------|--------------|------------|------------------|
| 1 | Demo → 2nd-call → Trial → ROI review → Close | | __% | 3.2× | Make ROI review a default step |

### Anti-paths (sequences that systematically LOSE)

| Sequence | Deals | Closed-Lost % | Recommendation |
|----------|-------|---------------|----------------|
| | | __% | Avoid this sequence |
```

## Common Mistakes
- Single-touch analysis (misses sequence value)
- Over-fitting to past patterns (market changes; refresh quarterly)
- Treating "longer = better" (faster paths are usually better; ICP fit matters more)
- Not building anti-paths (knowing what to avoid is as valuable as what to repeat)

## Tooling
- Petavue MCP, Salesforce, Bizible / Dreamdata, Clari for journey reconstruction

## Source
[Petavue — Golden Path Journey](https://www.petavue.com/resources/prompts) — RevOps / Marketing
