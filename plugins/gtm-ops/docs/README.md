# docs/

Documentation for gtm-ops. Read order depends on who you are.

---

## If you're a GTM operator landing here for the first time

1. **Top-level [`OPERATOR-QUICKSTART.md`](../OPERATOR-QUICKSTART.md)** — 60-second tour
2. **[`gtm-context.md`](gtm-context.md)** — the full operating manual (~1,400 lines, ~25-min read)
3. **[`architecture.md`](architecture.md)** — the 3-layer reference architecture

## If you're a GTM engineer building on top

1. Top-level [`README.md`](../README.md) — repo overview + status
2. [`architecture.md`](architecture.md) — what each integration does
3. Top-level [`CONTRIBUTING.md`](../CONTRIBUTING.md) — patterns for adding agents/skills/marts
4. [`gtm-context.md`](gtm-context.md) — full spec (reference, don't read linearly)

## If you're a CMO / VP / leader evaluating

1. Top-level [`README.md`](../README.md) — the audience targeting + status
2. [`architecture.md`](architecture.md) — the 3-layer model
3. Top-level [`ROADMAP.md`](../ROADMAP.md) — phasing + decision log
4. Skim [`gtm-context.md`](gtm-context.md) §1 (north-star) + §6 (reliability rules) + §14 (success criteria)

---

## File index

| File | What it is | Lines |
|---|---|---|
| [`gtm-context.md`](gtm-context.md) | **Canonical mothi GTM Operations spec.** 7 agents · 13 reliability rules · DIN workflow · UTM scheme · 3-surface BI rule · `mart_buyer_journey` spine · 4-week build sequence · Razorpay benchmarks. | ~1,400 |
| [`architecture.md`](architecture.md) | The 3-layer reference architecture (INPUT → BRAIN → OUTPUT) with 28 tools mapped to 10 GTM flows. | ~60 |
| [`internal/`](internal/) | Confidential narrative — session log, pitch, demo script. Not for external sharing. | various |

---

## Internal docs (`internal/`)

These are kept separate so they don't dominate the docs landing page. They contain:

- **[`internal/SESSION-LOG-2026-04-26.md`](internal/SESSION-LOG-2026-04-26.md)** — synthesis of the multi-hour design session that produced the spec. Includes major decisions, sparring pushbacks, deferred items, and the going-forward cadence.
- **[`internal/razorpay_pitch.md`](internal/razorpay_pitch.md)** — pitch document for the Razorpay GTM Builder application (was the trigger for building the architecture). Confidential — do not share externally.
- **[`internal/demo_script.md`](internal/demo_script.md)** — 90-second demo walkthrough for showing the system to recruiters / stakeholders.

---

## Cross-references to external knowledge

The spec cross-links to wiki concepts in [llm-wiki](https://github.com/mothivenkatesh/llm-wiki):

- `llm-wiki/wiki/concepts/gtm-ai-stack.md` — the tool catalog (~28 tools, 3 layers)
- `llm-wiki/wiki/concepts/modern-gtm-stack-blueprint.md` — the 41-agent virtual org architecture
- `llm-wiki/wiki/concepts/virtual-gtm-org-chart.md` — agents-as-org-chart mapping
- `llm-wiki/wiki/concepts/ten-k-gtm-stack.md` — extreme-budget reference ($10K/yr full stack)
- `llm-wiki/wiki/concepts/skills-master-map.md` — 180+ existing Mothi skills cross-index
- `llm-wiki/wiki/concepts/dpdp-act.md` — compliance layer

These resolve only on Mothi's local machine where llm-wiki is cloned alongside gtm-ops.
