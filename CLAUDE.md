# CLAUDE.md

This file is for Claude Code specifically. For other AI coding agents (Cursor, Codex, Gemini CLI, OpenHands), see [AGENTS.md](./AGENTS.md) — same instructions, AGENTS.md is the cross-tool standard.

> All conventions, repo structure, and contribution rules: see [AGENTS.md](./AGENTS.md).

## Claude Code specifics

This repo (**MStack**) is a Claude Code marketplace containing 8 plugins:

```
.claude-plugin/marketplace.json     # marketplace manifest
plugins/
├── opb-curriculum/    26 skills · 7 commands · 4 templates · 22 lessons · code/
├── gtm-analytics/     40 skills (own README)
├── gtm-ops/           11 skills · agents/ sql/ src/ dashboards/ evals/ docs/
├── ai-sdr/             3 skills · modes/ data/ scripts/
├── devrel-playbook/   27 skills · applied/ · synthetic-icp/
├── pmm-ops/            1 skill (SuperPMM) · docs/ src/ output/
├── product-ops/       78 skills · 36 commands · upstream/pm-skills/
└── funnel-marketing/   2 skills · case-studies/ · data/
```

Each plugin has its own `.claude-plugin/plugin.json` and `skills/` dir.

### Install

```bash
claude plugin marketplace add mothivenkatesh/MStack
claude plugin install opb-curriculum@MStack
# …or any of the other 7 plugins
```

Once installed, skills auto-load based on the `description` field in each SKILL.md frontmatter — Claude activates them when your prompt matches.

### Recommended slash commands

The `opb-curriculum` plugin ships 7 chained slash commands (`/find-wedge`, `/build-offer`, `/start-outbound`, `/audit-product`, `/diagnose-stall`, `/plan-week`, `/annual-review`) under [`plugins/opb-curriculum/commands/`](./plugins/opb-curriculum/commands/).

You can also invoke individual skills via natural language ("build me a wedge finder for X").

### MCP integration

Optional MCPs that pair well with these plugins:
- **Inngest MCP** — for the workflow specs under `plugins/opb-curriculum/code/`
- **GitHub MCP** — for repo operations
- **Stripe MCP** — for the pricing + margin skills' worked examples

None are required; the skills work without MCP.

## Conventions specific to Claude Code

When generating code or content for this repo:
- Default model: Claude Sonnet 4.6
- For skill `description` fields (which load at startup): keep under 200 tokens
- For SKILL.md bodies: target ≤ 5,000 tokens (enforced by spec for performance)
- For lesson READMEs: 800-1500 words for v2 lessons; 200-500 for short ones
- Skills live under `plugins/<plugin-name>/skills/` — never at the repo root
