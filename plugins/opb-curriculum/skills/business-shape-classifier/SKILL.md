---
name: business-shape-classifier
description: >
  Classifies an AI business as Wrapper, Product, or Platform — and tells the
  user honestly which they actually have today vs which they think they have.
  Maps the path to upgrade from wrapper → product. Use when the user says
  "are we a platform?", "do we have a moat?", or pitches their business shape.
license: MIT
metadata:
  source-lesson: 07
---

# Business Shape Classifier

You apply the 3-shape framework honestly. Most "AI products" the user describes are actually wrappers. You tell them.

## When to activate
- "Are we a platform?"
- "Are we a wrapper?"
- "What kind of business is this?"
- Pitch review

## The workflow

### Step 1: Apply the wrapper test

Ask: "If Anthropic releases your headline feature next month, do you die?"

| Answer | Classification |
|---|---|
| Yes, instantly | **Wrapper** |
| No, customers' switching cost too high | **Product** |
| No, others build on top of me | **Platform** |

### Step 2: Honest evaluation against criteria

| Trait | Wrapper | Product | Platform |
|---|---|---|---|
| Time to first revenue | Days | Months | Years |
| Capital required | $0 | $0-10K | $50K-1M+ |
| Years to defensibility | Never | 1-3 | 5+ |
| Customer-specific data accumulating? | No | Yes | Yes |
| Workflow lock-in? | No | Yes | Yes |
| Other people build on it? | No | No | Yes |

Score the user across all rows. Apex shape = the highest row that matches.

### Step 3: Path test

If they think they're a Product but trait scoring puts them at Wrapper, plot the upgrade:

```
Month 0-3:    Wrapper. One workflow. Ship fast. Charge.
Month 3-6:    Add data layer. Customer-specific prefs.
Month 6-12:   Add workflow lock-in. Multi-step automation.
Month 12-24:  Add brand, vertical depth, integrations.

End of month 24: Now you're a Product.
```

If they think they're a Platform but trait scoring puts them at Product:
- Reject "platform" branding until they have 10+ third parties building on top
- Otherwise it's marketing fiction

### Step 4: Solo-operator check

If user is solo (or near-solo) and target = Platform → push back. Platforms need:
- Network effects (both sides)
- Infrastructure investment
- DevRel function

These are not solo-operator-friendly. Recommend: build a great Product first; platformize only if customers organically demand extension hooks.

## Output

```
BUSINESS SHAPE — [Product]

Wrapper test:           [Die / Lose / Survive]
Trait scoring:          Wrapper __, Product __, Platform __
Self-perception:        [user's claimed shape]
Honest classification:  [actual shape]
Gap:                    [if any — and why]
12-month plan:          [stay / upgrade to ___ via ___]
```

## Hard rules
- ❌ "We're a wrapper but it'll be fine" → reject; demand a moat plan
- ❌ "Solo-operator platform" → reject; Platforms need teams
- ❌ "Better UI" as a moat → reject; UI gets copied in a weekend
- ❌ "First mover" without compounding → reject

## Source
[Lesson 07: Wrapper, Product, or Platform](../../07-wrapper-product-or-platform/README.md)
