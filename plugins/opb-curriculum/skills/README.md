# Skills — the activatable harness

**66 skills total**: 22 curriculum skills + 4 GTM toolkit skills + 40 enterprise GTM analytics skills.

Each lesson in the curriculum has a corresponding **Claude skill** here, plus a bundled **GTM toolkit** for outbound/research/email work, plus 40 **enterprise GTM analytics** skills (in [`gtm-analytics/`](./gtm-analytics/README.md)) for when the operator scales past $1M ARR. Drop the `skills/` directory into any Claude Code / Cursor / Codex / Gemini CLI project and the skills auto-discover when relevant.

Skills follow the [agentskills.io spec](https://agentskills.io/specification): YAML frontmatter (`name`, `description`) + Markdown body + optional `references/`. Progressive disclosure means only `name + description` (~100 tokens each) load at startup; the full skill loads only when triggered.

## What "deep" vs "lean" means

The curriculum skills come in two depth tiers:

- **🟢 v2 deep** — full structure: hard constraints first, workflow overview, step-by-step, required output format with tables, worked example, common mistakes, notes on tooling, quick reference. ~250-400 lines.
- **🟡 v1 / v1.5 lean** — frontmatter + activatable workflow + hard rules. ~80-130 lines (v1) or ~50-80 lines (v1.5). Functional but lighter.

A v1 skill is a working skill — it will activate, walk the user through a workflow, and push back on bad inputs. The deepening pass adds worked examples, exact output formats, and tool-specific guidance.

## Index — 66 skills

### Curriculum skills (mapped to lessons)

#### Part 1 — Engineering
| Skill | Lesson | Tier | Use when |
|---|---|---|---|
| [`agent-builder`](./agent-builder/SKILL.md) | 01 | 🟢 v2 | "Build me an agent for X" / starting fresh (with runnable scaffolds) |
| [`harness-auditor`](./harness-auditor/SKILL.md) | 02 | 🟢 v2 | "What's my actual moat?" (3-layer: Personal / Runtime / Product) |
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
| [`riskiest-assumption-tester`](./riskiest-assumption-tester/SKILL.md) | 06 | 🟢 v2 | Before you write code for an idea |
| [`business-shape-classifier`](./business-shape-classifier/SKILL.md) | 07 | 🟡 v1 | "Is this a wrapper, product, or platform?" |
| [`first-paid-thing-planner`](./first-paid-thing-planner/SKILL.md) | 08 | 🟡 v1 | Path to first $1K MRR |
| [`grand-slam-offer`](./grand-slam-offer/SKILL.md) | 08A | 🟢 v2 | Build the offer Hormozi-style |

#### Part 3 — Distribution
| Skill | Lesson | Tier | Use when |
|---|---|---|---|
| [`build-in-public-drafter`](./build-in-public-drafter/SKILL.md) | 09 | 🟡 v1 | Daily/weekly post drafting |
| [`cold-outbound-drafter`](./cold-outbound-drafter/SKILL.md) | 10 | 🟢 v2 | Plan a 100-prospect campaign (pairs with one-to-one-email-writing) |
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

### GTM toolkit (cross-cutting outbound / research)

These four skills are the operational backbone for all customer-acquisition work in Parts 2-3:

| Skill | Tier | Use when |
|---|---|---|
| [`icp-tam-research`](./icp-tam-research/SKILL.md) | 🟢 | Identify ICP + estimate TAM via Apollo (credit-safe) |
| [`buying-triggers-signals`](./buying-triggers-signals/SKILL.md) | 🟢 | Find specific buying signals for a target company |
| [`one-to-one-email-writing`](./one-to-one-email-writing/SKILL.md) | 🟢 | Construct individual cold emails (paired with `cold-outbound-drafter`) |
| [`email-waterfall-enrichment`](./email-waterfall-enrichment/SKILL.md) | 🟢 | Find verified emails via Clay's credit-safe waterfall |

### GTM Analytics — 40 skills (for $1M+ ARR scale)

Enterprise-grade skills for revenue operations as you scale past $1M ARR. See [`gtm-analytics/README.md`](./gtm-analytics/README.md) for the full index by category (Marketing / Sales / RevOps / CX / Systems & Data).

These are the second-stage skills in the curriculum's [10-year compound](../20-the-10-year-compound/README.md) trajectory — used in Year 2-3+ when you're building real GTM operations.

## How to install

### Claude Code
```bash
claude plugin marketplace add mothivenkatesh/agentic-gtm-stack
claude plugin install agentic-gtm-stack@agentic-gtm-stack
```

### Manual install (any tool)
```bash
git clone https://github.com/mothivenkatesh/agentic-gtm-stack.git
cp -r agentic-gtm-stack/skills .claude/skills/
# OR for Cursor: cp -r agentic-gtm-stack/skills .cursor/skills/
```

## Authoring guidelines

If you contribute a skill, follow the v2 template. Hard rules:

1. **Be opinionated.** "It depends" is not a skill.
2. **Push back on vague inputs.** Force specificity. Reject anti-patterns.
3. **Hard constraints first.** Check max-N / required-fields / veto-list before any work.
4. **Output is structured.** Tables, headings, emoji-tagged sections — not a wall of prose.
5. **Worked example.** One concrete walkthrough with placeholder data.
6. **Common mistakes list.** Extensive — what kills people doing this work.
7. **Notes on tooling.** What to use, in what order, with cost thresholds.
8. **Quick reference at end.** Skim-readable summary.
9. **Single domain.** A skill does one thing well. If yours covers 3 things, it's 3 skills.
10. **Reference the source lesson.** The skill is the action; the lesson is the theory.
