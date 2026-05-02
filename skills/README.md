# Skills — the activatable harness

**66 skills total**: 22 curriculum skills + 4 Growton GTM imports + 40 Petavue GTM analytics skills.

Each lesson in the curriculum has a corresponding **Claude skill** here, plus a bundled **GTM toolkit** of 4 skills imported from Growton, plus 40 enterprise GTM analytics skills imported from [Petavue's prompt library](./petavue/README.md). Drop the `skills/` directory into any Claude Code / Cursor / Codex / Gemini CLI project and the skills auto-discover when relevant.

Skills follow the [agentskills.io spec](https://agentskills.io/specification): YAML frontmatter (`name`, `description`) + Markdown body + optional `references/`. Progressive disclosure means only `name + description` (~100 tokens each) load at startup; the full skill loads only when triggered.

## What "deep" vs "lean" means

The curriculum skills come in two depth tiers right now:

- **🟢 Deep (v2)** — full Growton-style structure: hard constraints checked first, workflow overview, step-by-step, required output format with tables, worked example, common mistakes, notes on tooling, quick reference. ~200-400 lines.
- **🟡 Lean (v1)** — frontmatter + activatable workflow + hard rules. ~80-130 lines. Functional but needs a deepening pass.

**A v1 skill is a working skill** — it will activate, walk the user through a workflow, and push back on bad inputs. The deepening pass adds worked examples, exact output formats, and tool-specific guidance.

## Index — 26 skills

### Curriculum skills (mapped to lessons)

#### Part 1 — Engineering
| Skill | Lesson | Tier | Use when |
|---|---|---|---|
| [`agent-builder`](./agent-builder/SKILL.md) | 01 | 🟡 v1 | "Build me an agent for X" / starting fresh |
| [`harness-auditor`](./harness-auditor/SKILL.md) | 02 | 🟢 v2 | "What's my actual moat?" / reviewing your stack (3-layer) |
| [`multi-agent-decision`](./multi-agent-decision/SKILL.md) | 03 | 🟡 v1 | "Should I split this into multiple agents?" |
| [`production-readiness-audit`](./production-readiness-audit/SKILL.md) | 04 | 🟡 v1 | Before you ship to a paying customer |

#### Interlude
| Skill | Lesson | Tier | Use when |
|---|---|---|---|
| [`boring-stack-auditor`](./boring-stack-auditor/SKILL.md) | 04A | 🟡 v1 | "Is AI even needed for this step?" |

#### Part 2 — Productizing
| Skill | Lesson | Tier | Use when |
|---|---|---|---|
| [`wedge-finder`](./wedge-finder/SKILL.md) | 05 | 🟢 v2 | "What should I build?" / picking a wedge |
| [`riskiest-assumption-tester`](./riskiest-assumption-tester/SKILL.md) | 06 | 🟡 v1 | Before you write code for an idea |
| [`business-shape-classifier`](./business-shape-classifier/SKILL.md) | 07 | 🟡 v1 | "Is this a wrapper, product, or platform?" |
| [`first-paid-thing-planner`](./first-paid-thing-planner/SKILL.md) | 08 | 🟡 v1 | Path to first $1K MRR |
| [`grand-slam-offer`](./grand-slam-offer/SKILL.md) | 08A | 🟢 v2 | Build the offer Hormozi-style |

#### Part 3 — Distribution
| Skill | Lesson | Tier | Use when |
|---|---|---|---|
| [`build-in-public-drafter`](./build-in-public-drafter/SKILL.md) | 09 | 🟡 v1 | Daily/weekly post drafting |
| [`cold-outbound-drafter`](./cold-outbound-drafter/SKILL.md) | 10 | 🟢 v2 | Plan a 100-prospect campaign (pairs with one-to-one-email-writing below) |
| [`compounding-content-builder`](./compounding-content-builder/SKILL.md) | 11 | 🟡 v1 | vs page / data report / free tool |
| [`community-engagement-planner`](./community-engagement-planner/SKILL.md) | 12 | 🟡 v1 | Plan useful presence in 1 community |

#### Part 4 — Monetization
| Skill | Lesson | Tier | Use when |
|---|---|---|---|
| [`pricing-tripler`](./pricing-tripler/SKILL.md) | 13 | 🟢 v2 | "What should I charge?" / raising price |
| [`margin-auditor`](./margin-auditor/SKILL.md) | 14 | 🟢 v2 | "Is my unit economics OK?" |
| [`retention-cohort-analyzer`](./retention-cohort-analyzer/SKILL.md) | 15 | 🟢 v2 | Diagnose churn / run interviews |
| [`bottleneck-identifier`](./bottleneck-identifier/SKILL.md) | 16 | 🟡 v1 | "Why am I stuck at $X MRR?" |

#### Part 5 — Leverage
| Skill | Lesson | Tier | Use when |
|---|---|---|---|
| [`self-automation-mapper`](./self-automation-mapper/SKILL.md) | 17 | 🟢 v2 | "What in my own work should I automate?" |
| [`agent-role-designer`](./agent-role-designer/SKILL.md) | 18 | 🟢 v2 | Design an agent "role" with KPIs and gates |
| [`weekly-cadence-designer`](./weekly-cadence-designer/SKILL.md) | 19 | 🟢 v2 | Design your operator's week |
| [`ten-year-statement-writer`](./ten-year-statement-writer/SKILL.md) | 20 | 🟢 v2 | Annual scorecard / 10-year statement |

### GTM toolkit (imported from Growton — credit below)

| Skill | Tier | Use when |
|---|---|---|
| [`icp-tam-research`](./icp-tam-research/SKILL.md) | 🟢 | Identify ICP + estimate TAM via Apollo (credit-safe) |
| [`buying-triggers-signals`](./buying-triggers-signals/SKILL.md) | 🟢 | Find specific buying signals for a target company |
| [`one-to-one-email-writing`](./one-to-one-email-writing/SKILL.md) | 🟢 | Construct individual cold emails (paired with `cold-outbound-drafter`) |
| [`email-waterfall-enrichment`](./email-waterfall-enrichment/SKILL.md) | 🟢 | Find verified emails via Clay's credit-safe waterfall |

### Petavue GTM Analytics (40 skills — adapted from [Petavue prompt library](./petavue/README.md))

Enterprise GTM analytics skills (Marketing / Sales / RevOps / CX / Systems & Data). Calibrated for $1M+ ARR teams with full GTM stack. See [`petavue/README.md`](./petavue/README.md) for full index, organized by category. All at tier 🟡 v1.5 (lean v2 structure; deepening welcomed).

## How the skills compose

A typical solo-operator workflow uses skills in sequence. Example for a fresh business:

```
1. wedge-finder            → narrow to ONE specific wedge (Lesson 05)
2. icp-tam-research        → ICP + TAM via Apollo (Growton)
3. riskiest-assumption-tester → validate willingness-to-pay (Lesson 06)
4. grand-slam-offer        → build the offer (Lesson 08A)
5. first-paid-thing-planner → ship v0 in 7 days (Lesson 08)
6. buying-triggers-signals → find prospects in-market (Growton)
7. email-waterfall-enrichment → get verified emails (Growton)
8. cold-outbound-drafter   → plan the 100-prospect campaign (Lesson 10)
9. one-to-one-email-writing → draft each message (Growton)
10. weekly-cadence-designer → operate the week sustainably (Lesson 19)
```

## Roadmap — v1 → v2 deepening

The 14 v1 skills above need a deepening pass to match the v2 / Growton structure: worked examples, exact output formats, decision matrices, tooling notes, common-mistakes lists. Roughly:

- v1 skill: ~100 lines, activatable, opinionated
- v2 skill: ~250 lines, with worked example + output spec + tooling notes

Targeted deepening order (highest leverage first):
1. `pricing-tripler` (Lesson 13)
2. `margin-auditor` (Lesson 14)
3. `retention-cohort-analyzer` (Lesson 15)
4. `riskiest-assumption-tester` (Lesson 06)
5. `agent-builder` (Lesson 01)
6. `production-readiness-audit` (Lesson 04)
7. `boring-stack-auditor` (Lesson 04A)
8. The remaining 7

PRs for any v1 → v2 deepening welcome (see [CONTRIBUTING.md](../CONTRIBUTING.md)).

## How to install

### Claude Code
```bash
cp -r skills/ .claude/skills/
```

### Cursor / Codex / Gemini CLI
Reference in your `AGENTS.md` / `CLAUDE.md` / `.cursorrules`:
```markdown
# Available skills
See ./skills/README.md for the full index. Skills auto-load by intent.
```

### Anthropic Skills format

Each skill folder bundles into a `.skill` zip:
```bash
cd skills/wedge-finder && zip -r ../wedge-finder.skill .
```

## Authoring guidelines

If you contribute a skill, follow the v2 (Growton) template. Hard rules:

1. **Be opinionated.** "It depends" is not a skill.
2. **Push back on vague inputs.** Force specificity. Reject anti-patterns.
3. **Hard constraints first.** Check max-N / required-fields / veto-list before any work.
4. **Output is structured.** Tables, headings, emoji-tagged sections — not a wall of prose.
5. **Worked example.** One concrete walkthrough with placeholder data.
6. **Common mistakes list.** Extensive — what kills people doing this work.
7. **Notes on tooling.** What to use, in what order, with credit thresholds.
8. **Quick reference at end.** Skim-readable summary.
9. **Single domain.** A skill does one thing well. If yours covers 3 things, it's 3 skills.
10. **Reference the source lesson.** The skill is the action; the lesson is the theory.

## Credits

The 4 GTM toolkit skills (`icp-tam-research`, `buying-triggers-signals`, `one-to-one-email-writing`, `email-waterfall-enrichment`) are imported from **Growton** (Claude Skills marketplace). They are included here for completeness so the curriculum + GTM workflow ships in one drop-in `skills/` directory. Original credit and ongoing maintenance: Growton team.

The v2 skill structure pattern (hard constraints first → workflow overview → step-by-step → required output format → worked example → common mistakes → notes on tooling → quick reference) is adapted from the Growton skill format. It's a strong template; we use it across this repo's skills as the v2 standard.

The curriculum's source lessons are listed in the [main README](../README.md).
