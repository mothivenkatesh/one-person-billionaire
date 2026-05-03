---
name: multi-touch-attribution-contact-level
description: >
  Use this skill whenever the user wants to allocate Closed-Won revenue across
  contact-level touchpoints using customizable multi-touch attribution models
  (linear / W-shaped / U-shaped / time-decay). Trigger when the user mentions
  phrases like "multi-touch attribution", "MTA contact-level", "revenue
  allocation across touches", "U-shaped attribution", or shares multi-touch
  data.
---

# Multi-Touch Attribution (Contact-Level)

Allocates Closed-Won revenue across all contact-level touchpoints using configurable attribution models. Output: revenue per channel / campaign / asset under chosen model.

## Hard Constraints
- Required: Closed-Won deals with all contact-level touchpoints, attribution model picked (linear / W-shaped / U-shaped / time-decay)
- Refuse: comparison without 2+ models for sensitivity check

## Workflow
1. Pull Closed-Won deals + all contact-level touchpoints in 90-day pre-close window
2. Apply chosen model weights (W-shaped: 30/30/30/10 for first / lead-create / opportunity / last)
3. Aggregate revenue per touchpoint (channel / campaign / asset)
4. Compare to single-model baseline (first-touch or last-touch)
5. Output ranked attribution view + sensitivity comparison

## Required Output Format
```
### Multi-Touch Attribution (Contact-Level) — [Window]

**Model:** [Linear / W-shaped / U-shaped / Time-decay]

**Top channels:**
| Channel | MTA revenue | First-touch revenue | Disparity |
|---------|-------------|---------------------|-----------|

**Top campaigns:**
| Campaign | MTA revenue | Touches | Avg revenue/touch |
|----------|-------------|---------|-------------------|

**Top assets:**
| Asset | MTA revenue | Stage typically used in |
|-------|-------------|-------------------------|

**Sensitivity check:** Compared to first-touch / last-touch — significant disparities flagged.
```

## Common Mistakes
- Single-model attribution (always sensitivity-check)
- Treating model output as ground truth (it's a useful estimate, not a fact)
- Window too short (< 30 days) or too long (> 180) for B2B
- Ignoring buying-group / multi-contact deals (just primary contact's touches)

## Tooling
- GTM analytics MCP, Bizible / Dreamdata / Demandbase, custom SQL

## Source
Industry GTM analytics pattern — Marketing
