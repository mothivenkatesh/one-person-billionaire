# Lesson 07: Wrapper, Product, or Platform

## TL;DR

Every AI business is one of three shapes. **Wrappers** are easy to start and easy to die. **Products** are the right bet for solo operators. **Platforms** take 10 years and a team. Pick consciously, not by default. Most failed AI startups were wrappers that thought they were products.

## Core idea

```
WRAPPER     →  Thin layer over an LLM. Sells access + slight UX.
PRODUCT     →  LLM is the engine; the value is workflow + data + retention.
PLATFORM    →  Other people build on top of you.
```

The honest test: *if Anthropic releases the same feature next month, do you die?*
- Wrapper: yes, instantly
- Product: no, you have data/workflow/trust
- Platform: no, your customers' switching cost is too high

## How it works in practice

### Wrappers — when they work, when they don't

**Definition:** thin UI + system prompt + API call. The LLM is doing 90% of the work; you're charging for the access.

**When wrappers work (briefly):**
- A new model capability lands and you're first to ship a focused use case
- A specific niche the model providers won't touch (e.g., NSFW, regulated workflows)
- Distribution moat — you can reach customers cheaper than anyone else

**Why most wrappers die:**
- The model improves and your differentiator vanishes (Jasper → ChatGPT)
- The model provider ships the same feature in their core product
- Switching cost is zero — customers leave for the next $5/mo wrapper
- You can't build moat fast enough before commodity catches up

**Survival rate:** ~10% of AI wrappers from 2023 still exist in 2026. Almost all that survived added depth (data, workflow, integrations) — they became products.

### Products — the solo operator's sweet spot

**Definition:** the LLM is one component; the value is in the workflow, the data, the integrations, the brand, the retention. The model is a commodity input; the product is the system around it.

**Examples that survived 2023–2026:**
- Cursor: IDE integration + tab-completion model routing + repo indexing → not a wrapper
- Perplexity: search infra + source ranking + citation → not a wrapper
- Granola: meeting bot + structured notes + calendar integration → not a wrapper
- Decagon: customer service workflows + CRM integration + escalation logic → not a wrapper

**The product test:**
| Question | Wrapper says | Product says |
|---|---|---|
| What's your moat? | "Better prompts" | "5 years of customer-specific data + workflow lock-in" |
| What if Anthropic ships this? | "I die" | "I integrate it" |
| Why do customers stay? | "It works for now" | "They've configured 6 months of preferences/data" |
| Where's the data? | "All in the LLM call" | "In our DB, getting richer monthly" |

If you answer like the right column, you have a product.

### Platforms — the longest, hardest, biggest

**Definition:** other people build on top of you. You provide the infrastructure; your customers build the value.

**Examples:**
- Vercel for AI apps
- LangChain (the hosted version, not the OSS lib)
- Supabase for AI-native apps
- The MCP ecosystem (Anthropic is building the platform)

**Why solo operators almost never start as platforms:**
- Platforms need network effects → need a critical mass of both sides
- Platforms need infrastructure investment → cost-heavy upfront
- Platforms need a developer relations/community function → not a solo job
- Platform unit economics only work at scale

The honest path: build a great **product** first. If product success creates demand for platform features (other devs want to extend it), platformize *then*.

### The decision matrix

| Trait | Wrapper | Product | Platform |
|---|---|---|---|
| Time to first revenue | Days | Months | Years |
| Capital required | $0 | $0–$10K | $50K–$1M+ |
| Founders needed | 1 | 1–3 | 3+ |
| Years to defensibility | Never | 1–3 | 5+ |
| Realistic exit | $1M–$10M | $10M–$500M | $100M–$10B |
| Honest survival rate | 10% | 30% | 5% |
| Right for solo operator? | Only as a Trojan horse → product | **Yes** | No |

## The "wedge → product" path (recommended)

You can start as a wrapper to **validate**, but the plan must be to become a product. Concretely:

```
Month 0–3:    Wrapper. One workflow. Ship fast. Charge.
Month 3–6:    Add data layer. Customer-specific prefs. Integrations.
Month 6–12:   Add workflow lock-in. Multi-step automation. History.
Month 12–24:  Add brand, community, vertical depth. Now you're a product.
```

Most "wrappers that died" stayed at month 0–3 forever. They never built the moat.

## Common traps

| Trap | Why |
|---|---|
| Calling yourself a "platform" before having a product | Platforms = the hardest path; don't pick it accidentally |
| Building features instead of moats | Features get copied in a weekend; moats compound |
| "We're a wrapper but we'll be a product later" — without a roadmap | "Later" is when you die |
| Choosing a wedge where data doesn't compound | If every customer is a fresh start, you're a wrapper forever |
| Competing on UI alone | UI gets copied. Workflow + data don't. |
| Trying to be horizontal (everyone) too early | Horizontal beats vertical only after you've won 1 vertical |

## Exercise

Take your wedge + your validated buyer from Lesson 06. Classify yourself honestly:

```
TODAY (be honest):  Wrapper / Product / Platform
TARGET (12 months): Wrapper / Product / Platform

If TODAY = wrapper and TARGET = wrapper:
   → You will probably die. What's the moat plan?

If TODAY = wrapper and TARGET = product:
   → What 3 things must be true in 12 months?
   → 1. Customer-specific data layer  (e.g., ___)
   → 2. Workflow lock-in              (e.g., ___)
   → 3. Vertical depth or brand       (e.g., ___)

If TODAY = product:
   → Why? Be specific about your moat.

If TODAY = platform:
   → How are you funded? You probably need it.
```

Write the answers. Pin them somewhere visible. Re-check every quarter.

## Further reading

- Ben Thompson, [Aggregation Theory](https://stratechery.com/aggregation-theory/) — why platforms compound
- David Cancel, [The MOAT Framework](https://drift.com/insider/learn/podcasts/) — for SaaS specifically
- Tomasz Tunguz, [Defensibility in AI](https://tomtunguz.com/) — the post-2023 thinking
- a16z, [The Rise of the AI Product](https://a16z.com/) — the survivor analysis

---

[← Lesson 06](../06-riskiest-assumption-test/README.md) | [Next → Lesson 08: The Smallest Paid Thing](../08-the-smallest-paid-thing/README.md)
