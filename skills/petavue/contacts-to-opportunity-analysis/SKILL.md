---
name: contacts-to-opportunity-analysis
description: >
  Use this skill whenever the user wants to uncover the most common engagement
  paths that drive contacts to become Opportunities. Trigger when the user
  mentions phrases like "contact to opp path", "engagement journey",
  "conversion funnel", "what converts contacts", "common conversion paths", or
  shares contact + opportunity data. Use this skill to identify which sequences
  of touches actually convert vs which are noise.
---

# Contacts to Opportunity Analysis

This skill traces the most common engagement sequences that drive contacts to Opportunity creation. Output is a ranked list of "winning paths" you can replicate in playbooks.

The skill enforces:
- **Sequence-level analysis** — single-touch is misleading; sequences matter
- **Comparison to non-converting contacts** — winning paths vs losing paths
- **Minimum sample threshold** per path (≥ 20 contacts)
- **Stage-specific path recommendations** — not one playbook for all

---

## Hard Constraints

### Required Inputs
- All contact touchpoints (last 12 months)
- Opportunity creation events
- Contact-to-Opp linkage in CRM

### Refuse if < 20 per path
Paths with fewer than 20 converting contacts → exclude from ranking.

---

## Workflow

### Step 1: Build contact-touchpoint sequences
For each contact: ordered list of touchpoints (channel, asset, action) leading up to Opp creation OR end of analysis window.

### Step 2: Cluster sequences
Identify common 3-5 touch patterns (e.g., "ad → ebook → webinar" or "demo request → SDR call → trial").

### Step 3: Compute conversion rate per pattern
`Conversion = Patterns ending in Opp / Total contacts on pattern`

### Step 4: Compare to baseline
Average contact-to-Opp rate across all patterns. Patterns 2× baseline = winning.

### Step 5: Recommend playbook moves
For each winning pattern: how to design more contacts into it.

---

## Required Output Format

```
### 🛤️ Contact-to-Opportunity Paths

**Baseline conversion:** __% (all contacts)
**Window:** [12 months]

| Rank | Pattern | Contacts | Opps | Conv | Multiplier vs baseline | Playbook move |
|------|---------|----------|------|------|------------------------|---------------|
| 1 | Ad → Ebook → Webinar → Demo | | | __% | 3.2× | Promote webinar after ebook download |
| 2 | | | | __% | __× | |

### Insights

- Top channel sequence: [pattern]
- Most efficient path (fewest touches to Opp): [pattern]
- Surprising winner: [unexpected pattern with 2×+ baseline]
```

---

## Common Mistakes to Avoid

- Single-touch analysis (misses sequence value)
- Comparing winning paths without showing total cost / time
- Ignoring patterns with < 20 contacts (small sample noise)
- Treating "longer path = better" (faster path can be more efficient)

---

## Notes on Tooling

| Tool | Use |
|------|-----|
| Petavue MCP | Primary execution |
| Salesforce | Contacts + Opps |
| Marketo / HubSpot | Touchpoint data |
| Bizible / Dreamdata | Multi-touch sequence assembly |

---

## Source

Adapted from [Petavue's GTM Prompt Library — Contacts to Opportunity Analysis](https://www.petavue.com/resources/prompts).
Petavue category: RevOps / Marketing
