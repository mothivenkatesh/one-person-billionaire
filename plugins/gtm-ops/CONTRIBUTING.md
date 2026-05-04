# Contributing to gtm-ops

> How to extend the system without breaking it.

---

## The golden rules (read first)

1. **Spec changes BEFORE code changes.** Every new agent/skill/mart is added to [`docs/gtm-context.md`](docs/gtm-context.md) before any implementation. The spec is the source of truth; code follows.
2. **No agent ships without an eval.** Promptfoo cases for the new prompt go in `evals/cases/` before the n8n workflow goes live.
3. **No metric is defined twice.** New metric? Add it to the canonical metric-definitions Sheet first; surface it in BI second.
4. **Every change is reversible.** Feature-flag new agents via Unleash; never enable for 100% on day one.
5. **No DIN, no send.** Any new campaign type respects the DIN approval gate. Period.

---

## Adding a new Claude Code skill

**Where it lives:** `skills/{skill-name}/SKILL.md`

**Skill structure:**

```markdown
---
name: skill-name
description: One-sentence what-this-skill-does (used by Claude to decide when to load it)
version: 0.1.0
owner: pmm-name@mothi.com
status: draft | stable | stale
depends_on: [other-skill, another-skill]   # optional, for composition
tested_with: claude-haiku-4.5              # which model this is calibrated for
---

# Skill Title

## When to use this skill

(Plain English: under what conditions does this skill get loaded by an agent?)

## Inputs expected

(What variables / context the agent provides when invoking)

## Outputs

(What format the skill returns: text, structured, decision, etc.)

## Body

(The actual skill instructions — markdown, examples, dos/don'ts)

## Examples

### Good
(Example input → ideal output)

### Bad
(Example input → undesirable output to avoid)
```

**Required steps:**

1. Write the skill markdown
2. Add 5+ Promptfoo eval cases at `evals/cases/{skill-name}/`
3. Run `npx promptfoo eval` — must pass ≥90% of baseline cases
4. Update `skills/README.md` index
5. PR with eval results screenshot + 2 reviewers

---

## Adding a new n8n agent (workflow)

**Where it lives:** `agents/{agent-name}.json` (n8n workflow export)

**Pattern every agent must follow:**

```
1. Trigger (cron / webhook)
2. Pre-launch DIN gate                       ← rule #8 (skip-detection)
3. Fetch context (SF + Postgres + Drive + LLM-extracted properties)
4. Load skill from Shared Drive
5. Claude API call
6. Pydantic schema validation on output      ← rule #2
7. Frequency cap check                       ← rule #4
8. HITL approval (if rule #9 applies)
9. Writeback (SF + MoEngage + Slack + Sheets)
10. Audit log entry to Postgres `agent_decisions` ← rule #11
11. UTM tagging on every link                ← rule #9
```

**Required steps:**

1. Add the agent to `docs/gtm-context.md` §3 with: trigger, what-it-does, MCPs used
2. Build the workflow in n8n
3. Test on staging Postgres + sandbox SF
4. Add Promptfoo evals for any new Claude prompts
5. Export workflow JSON to `agents/{agent-name}.json`
6. Update `agents/README.md` index with status (`scaffolded` / `live` / `deprecated`)
7. Wrap with Unleash feature flag — start at 10% rollout

---

## Adding a new SQL mart

**Where it lives:** `sql/marts/{mart_name}.sql`

**Convention:**

- `stg_*` views = staging (cleanup, type-cast, dedupe)
- `mart_*` views = metric-ready aggregations
- All marts are materialized views with nightly refresh

**Required steps:**

1. Add the mart to `docs/gtm-context.md` §8.4 with: purpose, columns, source tables
2. If introducing a new metric, add it to the `gtm.metric-definitions` Sheet FIRST
3. Write the SQL view
4. Add a `REFRESH MATERIALIZED VIEW CONCURRENTLY` to the nightly cron
5. Test query latency (<3s for AE-facing marts)
6. Update `sql/README.md` index

---

## Adding a new dashboard

**Three-surface rule (anti-sprawl):**

| Audience | Surface | Format |
|---|---|---|
| AE / SDR / CSM | Google Sheets | Sheet template URL + Apps Script source in `dashboards/sheets/` |
| PMM / Demand Gen / RevOps | Metabase | Exported question/dashboard JSON in `dashboards/metabase/` |
| VP Sales / VP Marketing / Founders | AWS QuickSight | Analysis definition in `dashboards/quicksight/` |

**Required steps:**

1. Identify the audience — pick exactly one surface
2. Verify every metric on the dashboard is in `gtm.metric-definitions` (the canonical list)
3. Build the dashboard
4. Export the template/JSON to the appropriate `dashboards/` subfolder
5. Add a row to the relevant README index
6. Schedule monthly review — any chart not viewed in 30 days gets archived

---

## Modifying the spec (`gtm-context.md`)

The spec is canonical. Changes require:

1. PR with the diff
2. Reviewer must check: doesn't break a reliability rule, doesn't double-define a metric, doesn't bypass DIN gate
3. Bump version in CHANGELOG.md
4. If structural change (new section / renumbered): update README.md links + OPERATOR-QUICKSTART.md cross-refs

---

## When NOT to contribute

- ❌ Adding a tool just because it's available. Every tool earns its slot. See spec §4.
- ❌ Adding a metric without defining it in the canonical Sheet first.
- ❌ Building an agent that bypasses DIN gate, HITL, or frequency caps.
- ❌ Adding to v1 anything that's already in v2/v3 deferred list. Argue for re-prioritization in ROADMAP.md instead.
- ❌ Renaming the repo or breaking the *-ops pattern without team alignment.

---

## Code style

- Python: Ruff lint + format. `make lint` must pass.
- SQL: lowercase keywords, snake_case names, comment intent at top of view.
- Markdown: tight tables, sentence-case headings, link don't dump.
- n8n: descriptive node names, credentials never inline (use env), every workflow has a description block.

---

## Review checklist (paste into your PR)

```
- [ ] Spec updated (docs/gtm-context.md)
- [ ] Promptfoo evals pass ≥90% baseline
- [ ] DIN gate respected (if launches a campaign)
- [ ] Audit log writes happen
- [ ] Unleash flag in place
- [ ] HITL on writes (if applicable)
- [ ] Frequency cap respected (if outbound)
- [ ] UTM tagging present (if outbound)
- [ ] CHANGELOG.md updated
- [ ] README.md status table updated
- [ ] Tested on staging Postgres + SF sandbox
```
