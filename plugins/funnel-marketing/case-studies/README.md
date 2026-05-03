# Funnel-Marketing Case Studies

Worked examples produced by running the `funnel-builder` skill on real targets. Each case study is a complete intelligence report — the kind of output the skill is designed to produce.

Use these as:
- **Calibration material** — what "good" looks like at the depth bar the skill enforces
- **Counter-examples to info-coaching defaults** — the existing `funnel-templates.md` reference is grounded in 45,056 Reddit conversations skewed toward DTC / info-product / agency funnels. Case studies covering different verticals (OSS, dev tools, B2B platforms) sharpen the pattern library
- **Reverse-engineering reference** — when you encounter a similar target, scan the closest case study first

## Index

| Case study | Target type | Why it's interesting |
|---|---|---|
| [hermes-agent.md](./hermes-agent.md) | Open-source dev tool (AI agent runtime) by Nous Research | Open-core funnel where free runtime feeds paid API subscription. Outsourced content engine via creator/dev army. Bottom of funnel deliberately invisible. 130K GitHub stars in 10 weeks. |

## Adding a new case study

1. Run the full 4-phase `funnel-builder` workflow on a target
2. Save the final intelligence report (the 7-section Phase 4 deliverable) here as `<target-slug>.md`
3. Add a row to the index above with one sentence on why the target is worth studying
4. If the case study reveals a pattern not yet captured in the references, add it to the relevant reference file (e.g. `references/funnel-templates.md` for new template variants, `references/info-coaching-patterns.md` for vertical patterns, `references/hook-psychology.md` for new hook sub-patterns)
