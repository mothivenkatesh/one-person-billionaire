# AIPMM Agent — Blueprint

> *"If I was a startup CEO I would have a single product marketer run my marketing. Don't tell me that with AI you'd rather be any other kind of marketer than the ultimate jack of all trades."* — Logan Hendrickson
>
> This blueprint answers: **can we assemble an AI Product Marketing Manager from what MStack already has?** Mostly yes. It maps the canonical PMM function set to existing MStack skills, names the real gaps, and proposes an architecture + build sequence. It uses the `voice-engine` Logan Hendrickson profile as the **taste layer** — the operating principles that keep the agent's output sounding like a great PMM, not a content mill.
>
> Origin: distilled from the May-2026 session that harvested Logan Hendrickson's 29 LinkedIn posts and asked "what can I build with this?"

---

## 1. The PMM capability map (function → existing skill → gap)

Coverage legend: ✅ strong · 🟡 partial · ❌ gap

| PMM function | Existing MStack skill(s) | Coverage | Gap to close |
|---|---|---|---|
| Market & customer research (ICP, TAM, personas, segmentation, JTBD) | `product-ops`: pm-market-research-* (market-sizing, user-personas, user-segmentation, market-segments), pm-go-to-market-ideal-customer-profile; `pmm-ops/superpmm` step 1 | ✅ | — |
| Competitive intelligence (battlecards, analysis) | `product-ops`: pm-go-to-market-competitive-battlecard, pm-market-research-competitor-analysis; `superpmm` step 2 | ✅ one-shot | 🟡 **always-on CI monitoring** (Logan built this himself; not a skill) |
| Positioning | `pmm-ops/pmm-messaging`; `product-ops`: pm-product-strategy-positioning, pm-marketing-growth-positioning-ideas; `superpmm` step 4 | ✅ | — |
| Messaging (the PMM core) | `pmm-ops/pmm-messaging` (3-tier, message house) | ✅ | 🟡 **messaging test/validation loop** (instrument, not just doctrine) |
| Brand insight / cultural conflict | `pmm-ops/insideinsights` (Amit Kumar conflict framework); `~/.claude/skills/tension-radar` | ✅ | — |
| Voice, POV & thought leadership | **`pmm-ops/voice-engine`** (NEW — this session) | ✅ | *was a gap; now filled* |
| Product launch / GTM plan | `superpmm` step 5; `product-ops`: pm-go-to-market-gtm-strategy, gtm-motions, beachhead-segment, growth-loops | ✅ | 🟡 **launch-cadence orchestration** (Logan's "ship continuously, launch quarterly" system) |
| Content engine | `voice-engine` apply-mode + `product-ops`: pm-marketing-growth-marketing-ideas, value-prop-statements; `product-ops` pm-execution-release-notes | 🟡 | 🟡 **corpus → content calendar** pipeline (Voice Profile + product facts → scheduled drafts) |
| Sales enablement | `pmm-ops/sales-enablement` | ✅ | — |
| Pricing & packaging | `product-ops`: pm-product-strategy-pricing-strategy, monetization-strategy | ✅ | — |
| Product naming | `product-ops`: pm-marketing-growth-product-name | ✅ (Logan: low-leverage anyway) | — |
| Analytics & measurement | `gtm-analytics` (40 skills); `product-ops`: pm-marketing-growth-north-star-metric, pm-data-analytics-* | ✅ | 🟡 **PMM-specific attribution** (influence on pipeline, not just funnel) |
| Win/loss analysis | — | ❌ | ❌ **win/loss skill** |
| Narrative / category design | referenced (Andy Raskin) in pmm-messaging, not operational | 🟡 | 🟡 **narrative-design skill** |
| Analyst & influencer relations | — | ❌ | ❌ (low priority) |

**Read:** ~70% of a full PMM's job is already covered by MStack skills. The high-value open gaps are **always-on CI**, **launch-cadence orchestration**, **win/loss**, and a **corpus→content pipeline**. The voice/POV gap was the one this session closed.

---

## 2. Architecture — how the skills compose into an agent

The AIPMM agent is not a new monolith. It's a **router + the existing skills + a taste layer**, organized as an org chart (this mirrors SuperPMM's documented 16-agent V5 vision — see `../docs/vision/product-vision.md`; don't rebuild it, extend it).

```
                         ┌─────────────────────────┐
                         │   AIPMM ROUTER (intake)  │  ← classifies the ask, sequences skills
                         └─────────────┬───────────┘
                                       │
   ┌───────────────┬───────────────┬──┴────────────┬───────────────┬──────────────┐
   ▼               ▼               ▼               ▼               ▼              ▼
RESEARCH        POSITION/        LAUNCH/GTM      CONTENT/         MEASURE       TASTE LAYER
(product-ops    MESSAGE          (superpmm s5,   ENABLE           (gtm-         (voice-engine
 research +     (pmm-messaging,  product-ops     (voice-engine,   analytics,    Voice Profile +
 superpmm s1,2) insideinsights,  gtm-* skills)   sales-enable,    north-star)   Logan POV as
                 superpmm s4)                     content gap)                   operating rules)
```

**The taste layer is the differentiator.** Every output passes through Logan's POV (`voice-engine/data/logan-hendrickson_voice-profile.md`) as an opinion-checker:

| Logan POV line | Becomes an agent operating rule |
|---|---|
| "The best messaging is boring" | Reject hype/jargon copy; enforce the sweatshirt test (clear → boring → elicits a question). |
| "Customers > competitors" | When CI output threatens to dominate, re-weight toward customer JTBD. |
| "Specificity wins; bigger TAM is a trap" | Push back on "sell to everyone"; force a beachhead. |
| "Positioning is a choice; the work is backing it up" | After a positioning claim, demand the proof points before declaring done. |
| "Ship continuously, launch quarterly" | Default launch-plan output to a quarterly theme, not per-feature. |
| "Brand + PMM are connected forces" | Couple every messaging deliverable to a brand/visual context, not a doc in isolation. |
| "Functional > industry experience" | Don't over-index on industry jargon; optimize for clarity a non-expert understands. |

This is what makes it an *AIPMM* and not "ChatGPT with PMM prompts": it has a **defensible POV**, sourced from a real practitioner, that it refuses to violate.

---

## 3. Build sequence (close the gaps in leverage order)

1. **`pmm-content-engine`** (highest leverage) — input: a Voice Profile (from `voice-engine`) + product facts/launches → output: a 30-day content calendar of drafts in that voice, each tied to a POV line. Reuses voice-engine apply-mode + pm-marketing-growth-marketing-ideas.
2. **`ci-monitor`** — Logan built a CI workflow that "does what you'd hire an early-career CI pro to do." Turn the one-shot battlecard into a scheduled diff (competitor site/pricing/launch watch → battlecard delta). Pairs with `gtm-analytics` + a scraper skill.
3. **`launch-cadence`** — orchestrate the "ship continuously, launch quarterly" system: theme selection, cutoff dates, PM/CS/sales/marketing notify matrix. Reuses product-ops release + stakeholder skills.
4. **`win-loss`** — interview script → deal-loss taxonomy → messaging feedback loop. New skill; pairs with product-ops pm-product-discovery-interview-script.
5. **`messaging-test`** — turn pmm-messaging's "testing" doctrine into an instrument (5-second test, comprehension scoring, A/B copy harness).

---

## 4. What this is NOT

- Not a replacement for SuperPMM — SuperPMM is the *guided GTM builder* (one project, 60 min). The AIPMM agent is the *always-on operator* that runs the PMM function continuously. They share skills; SuperPMM is one entry point into the same skill library.
- Not autonomous publishing. The taste layer drafts; a human ships. (Logan: don't outsource your critical thinking.)
- Not industry-locked. Per Logan, functional excellence + fast learning beats deep industry priors — the agent should onboard to a new domain from a company KB, not require a vertical rebuild.
