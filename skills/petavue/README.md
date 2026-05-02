# Petavue GTM Analytics Skills (40 skills)

Adapted from the [Petavue GTM Prompt Library](https://www.petavue.com/resources/prompts) — a curated set of analytical workflows for B2B SaaS GTM teams (Marketing / Sales / RevOps / CX / Systems & Data). Each skill is converted from Petavue's prompt format into the agentskills.io spec so it auto-discovers in Claude Code / Cursor / Codex / Gemini CLI.

## When to use these skills

Most Petavue skills assume:
- A connected CRM (Salesforce / HubSpot)
- Marketing automation (Marketo / HubSpot Marketing)
- A data warehouse (Snowflake / BigQuery / Postgres)
- Multiple reps and campaigns to analyze

These skills are sized for **$1M+ ARR teams with sales + marketing + CS functions**. For solo operators at < $1M ARR, the parent curriculum's skills (`wedge-finder`, `cold-outbound-drafter`, `retention-cohort-analyzer`, etc.) are calibrated to your stage.

## Index — by Petavue category

### Marketing (8)
- [`asset-engagement-analysis`](./asset-engagement-analysis/SKILL.md)
- [`campaign-leaderboard-analysis`](./campaign-leaderboard-analysis/SKILL.md)
- [`campaign-roi-analysis`](./campaign-roi-analysis/SKILL.md)
- [`content-influence-mapping`](./content-influence-mapping/SKILL.md)
- [`first-vs-last-touch-attribution`](./first-vs-last-touch-attribution/SKILL.md)
- [`multi-touch-attribution-contact-level`](./multi-touch-attribution-contact-level/SKILL.md)

### Sales (8)
- [`campaigns-meetings-booked`](./campaigns-meetings-booked/SKILL.md)
- [`deal-velocity-bottleneck`](./deal-velocity-bottleneck/SKILL.md)
- [`expansion-account-growth`](./expansion-account-growth/SKILL.md)
- [`forecast-accuracy-risk`](./forecast-accuracy-risk/SKILL.md)
- [`lead-conversion-analysis`](./lead-conversion-analysis/SKILL.md)
- [`rep-level-cohort-analysis`](./rep-level-cohort-analysis/SKILL.md)
- [`rep-performance-vs-activity`](./rep-performance-vs-activity/SKILL.md)
- [`sales-rep-effectiveness`](./sales-rep-effectiveness/SKILL.md)
- [`sales-data-assessment`](./sales-data-assessment/SKILL.md)

### RevOps + Systems & Data (10)
- [`campaigns-deals-influence`](./campaigns-deals-influence/SKILL.md)
- [`contacts-to-opportunity-analysis`](./contacts-to-opportunity-analysis/SKILL.md)
- [`data-assessment-accounts`](./data-assessment-accounts/SKILL.md)
- [`data-assessment-duplicates`](./data-assessment-duplicates/SKILL.md)
- [`data-assessment-leads`](./data-assessment-leads/SKILL.md)
- [`data-assessment-opportunities`](./data-assessment-opportunities/SKILL.md)
- [`data-assessment-utms`](./data-assessment-utms/SKILL.md)
- [`deal-rot-detector`](./deal-rot-detector/SKILL.md)
- [`first-touchpoint-contact-to-opp`](./first-touchpoint-contact-to-opp/SKILL.md)
- [`golden-path-journey`](./golden-path-journey/SKILL.md)
- [`inactive-at-risk-opportunities`](./inactive-at-risk-opportunities/SKILL.md)
- [`last-touch-attribution-opportunities`](./last-touch-attribution-opportunities/SKILL.md)
- [`lead-source-hygiene-audit`](./lead-source-hygiene-audit/SKILL.md)
- [`lead-deal-conversion-by-speed`](./lead-deal-conversion-by-speed/SKILL.md)
- [`lead-deal-conversion-overall-by-stage`](./lead-deal-conversion-overall-by-stage/SKILL.md)
- [`post-opp-touchpoint-summary`](./post-opp-touchpoint-summary/SKILL.md)
- [`stuck-pipeline-alerting`](./stuck-pipeline-alerting/SKILL.md)

### CX (Customer Experience) (8)
- [`churn-risk-radar`](./churn-risk-radar/SKILL.md)
- [`cs-data-assessment`](./cs-data-assessment/SKILL.md)
- [`csm-engagement-coverage`](./csm-engagement-coverage/SKILL.md)
- [`low-account-health`](./low-account-health/SKILL.md)
- [`product-usage-correlation`](./product-usage-correlation/SKILL.md)
- [`propensity-to-renew`](./propensity-to-renew/SKILL.md)
- [`pv-retention-cohort-breakdown`](./pv-retention-cohort-breakdown/SKILL.md) — Petavue version; for solo operators see [`retention-cohort-analyzer`](../retention-cohort-analyzer/SKILL.md)
- [`segment-insights`](./segment-insights/SKILL.md)

## Tier status

All 40 are at **v1.5** (lean v2 structure — frontmatter + workflow + output format + common mistakes + tooling notes, but condensed). They're activatable and immediately useful but lighter than the full Growton-structure v2 skills (~250 lines) used in the curriculum.

A future deepening pass would add:
- Worked example per skill
- Quick reference tables
- More extensive common-mistakes lists

PRs welcome. See [`../CHECKLIST.md`](../CHECKLIST.md) for v1 / v1.5 / v2 status across the full repo.

## Credit

Original prompts: **Petavue** ([petavue.com/resources/prompts](https://www.petavue.com/resources/prompts)).
Conversion to agent-skill format: this repo (MIT).

If you use these skills heavily, support Petavue by giving them a try — their MCP runs these prompts natively against your data warehouse, which is the practical execution layer for everything in this folder.

## Pairs with parent curriculum skills

| Petavue skill | Parent curriculum skill | Use together for |
|---------------|------------------------|------------------|
| `lead-source-hygiene-audit` | [`cold-outbound-drafter`](../cold-outbound-drafter/SKILL.md) | Clean source data → better outbound targeting |
| `pv-retention-cohort-breakdown` | [`retention-cohort-analyzer`](../retention-cohort-analyzer/SKILL.md) | Enterprise breakdown vs solo-operator interview-driven |
| `forecast-accuracy-risk` | [`bottleneck-identifier`](../bottleneck-identifier/SKILL.md) | Forecast risk = leading indicator of stall |
| `campaign-roi-analysis` | [`pricing-tripler`](../pricing-tripler/SKILL.md) | High-ROI campaigns earn higher pricing |
| `churn-risk-radar` + `low-account-health` | [`retention-cohort-analyzer`](../retention-cohort-analyzer/SKILL.md) | Multi-signal ranking + diagnostic interviews |
