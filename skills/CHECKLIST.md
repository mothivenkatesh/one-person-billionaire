# Skill Deepening Checklist

Track which skills are at v1 (lean, ~100 lines, activatable) vs v1.5 (~50-80 lines, lean structured) vs v2 (Growton-structure, ~250+ lines, with worked example + output format + tooling notes).

Run `make check-tiers` to see actual line counts vs intended tier.

## v2 Deep ✅ (12 skills, 4 Growton imports)

Curriculum:
- [x] `wedge-finder` — Lesson 05
- [x] `grand-slam-offer` — Lesson 08A
- [x] `cold-outbound-drafter` — Lesson 10
- [x] `pricing-tripler` — Lesson 13
- [x] `margin-auditor` — Lesson 14
- [x] `retention-cohort-analyzer` — Lesson 15
- [x] `self-automation-mapper` — Lesson 17
- [x] `agent-role-designer` — Lesson 18
- [x] `weekly-cadence-designer` — Lesson 19
- [x] `ten-year-statement-writer` — Lesson 20
- [x] `harness-auditor` — Lesson 02 (3-layer model)

Growton imports (already at v2 by definition):
- [x] `icp-tam-research`
- [x] `buying-triggers-signals`
- [x] `one-to-one-email-writing`
- [x] `email-waterfall-enrichment`

## v1.5 Lean Petavue (40 skills) — adapted from Petavue prompt library

All 40 at lean v2 structure (~50-80 lines each). Activatable + structured but lighter than full v2 (~250 lines). See [`petavue/README.md`](./petavue/README.md) for full list.

Highest-leverage to deepen first (most-used by solo + mid-market):
- [ ] `petavue/churn-risk-radar` — multi-signal early churn detection
- [ ] `petavue/lead-source-hygiene-audit` — pairs with cold-outbound-drafter
- [ ] `petavue/forecast-accuracy-risk` — pairs with bottleneck-identifier
- [ ] `petavue/stuck-pipeline-alerting` — weekly review essential
- [ ] `petavue/golden-path-journey` — playbook design
- [ ] `petavue/segment-insights` — LTV/CAC by segment
- [ ] `petavue/campaign-roi-analysis` — pairs with pricing-tripler

## v1 Lean → needs deepening (10 curriculum skills)

Ordered by priority:

- [ ] `riskiest-assumption-tester` — Lesson 06 — Mom-Test interview templates
- [ ] `agent-builder` — Lesson 01 — runnable Python/TS scaffolds
- [ ] `production-readiness-audit` — Lesson 04 — concrete checklist examples
- [ ] `boring-stack-auditor` — Lesson 04A — Inngest/Temporal/n8n decision tree
- [ ] `bottleneck-identifier` — Lesson 16 — diagnostic flowchart
- [ ] `compounding-content-builder` — Lesson 11 — vs-page + data-report templates
- [ ] `multi-agent-decision` — Lesson 03 — cost-math worked example
- [ ] `business-shape-classifier` — Lesson 07 — trait-scoring worksheet
- [ ] `first-paid-thing-planner` — Lesson 08 — 7-day sprint plan template
- [ ] `build-in-public-drafter` — Lesson 09 — 4 archetype worked examples
- [ ] `community-engagement-planner` — Lesson 12 — platform-specific sub-flows

## v2 standard (the deepening target)

Each v2 skill must have:
1. **Frontmatter** — rich `description` with explicit trigger phrases
2. **Hard Constraints (Check First)** — max-N caps, required input fields, veto-list
3. **Workflow Overview** — ASCII / code block summary
4. **Step-by-step workflow** — numbered steps with sub-instructions
5. **Required Output Format** — exact tables, headings, emoji-tagged sections
6. **Worked Example** — one concrete walkthrough with placeholder data
7. **Common Mistakes to Avoid** — extensive bullet list
8. **Notes on Tooling** — what to use, in what order, with cost thresholds
9. **Quick Reference** — skim-readable summary at end
10. **Source** — link to source lesson + Petavue/Growton attribution if applicable

Reference exemplars:
- `skills/wedge-finder/SKILL.md` (v2)
- `skills/grand-slam-offer/SKILL.md` (v2)
- `skills/pricing-tripler/SKILL.md` (v2)
- `skills/margin-auditor/SKILL.md` (v2)
- `skills/retention-cohort-analyzer/SKILL.md` (v2)
- `skills/harness-auditor/SKILL.md` (v2 with 3-layer model)
- `skills/icp-tam-research/SKILL.md` (Growton-imported, v2 standard)

## How to claim a deepening

Pick a skill from the v1 or v1.5 list. Open a PR titled `Deepen <skill-name> v1 → v2` (or `v1.5 → v2`). Match the v2 standard above. Update this checklist by checking the box. Update `skills/README.md` to flip the tier marker from 🟡 to 🟢.

PRs welcome. The deepening is the harder half of the curriculum.
