# AGENTS.md

Instructions for AI coding agents (Claude Code, Cursor, Codex, Gemini CLI, OpenHands, etc.) working in this repository.

## What this repo is

**MStack** — a Claude Code marketplace built by Mothi Venkatesh (PMM at Cashfree Payments). 8 plugins / 176+ skills / 43+ chained slash commands codifying the structured 80% of GTM, Growth, and Product work as installable agents. Read [README.md](./README.md) before changing anything.

## Repo structure

```
.
├── README.md                          Master index
├── .claude-plugin/marketplace.json    Lists all 7 plugins
├── plugins/
│   ├── opb-curriculum/                The original 22-lesson curriculum
│   │   ├── .claude-plugin/plugin.json
│   │   ├── lessons/00-…20-*/README.md  22 lessons
│   │   ├── skills/                     26 skills
│   │   ├── commands/                   7 chained slash commands
│   │   ├── templates/                  4 fillable canvases
│   │   └── code/                       Workflow specs (Inngest examples)
│   ├── gtm-analytics/                 40 enterprise GTM-analytics skills
│   │   ├── skills/                     40 skills (was nested under opb-curriculum)
│   │   └── README.md                   index by category (Marketing/Sales/RevOps/CX)
│   ├── gtm-ops/                       GTM OS — 11 skills
│   │   ├── skills/                     11 skills
│   │   ├── agents/ sql/ src/ dashboards/ evals/ docs/
│   │   └── (own README, Makefile, pyproject.toml, docker-compose.yml)
│   ├── ai-sdr/                        Autonomous SDR — router + 7 modes
│   │   ├── skills/                     3 skills (pipeline, analytics, followup)
│   │   ├── modes/ data/ scripts/
│   │   └── (own README, ARCHITECTURE.md, SETUP.md)
│   ├── devrel-playbook/               27 community-building skills
│   │   ├── skills/                     27 skills
│   │   └── applied/ synthetic-icp/
│   ├── pmm-ops/                       SuperPMM — guided 5-step GTM Builder
│   │   ├── skills/superpmm/SKILL.md
│   │   └── docs/ src/ output/
│   └── product-ops/                   Product ops harness
│       ├── skills/                     78 skills (1 native + 65 pm-* upstream + 12 gap-fill from Lenny/Pichler/IPL)
│       ├── commands/                   36 chained slash commands
│       ├── upstream/pm-skills/         git subtree of phuryn/pm-skills
│       └── NOTICE.md                   attribution to Pawel Huryn
├── ACKNOWLEDGMENTS.md                 Credits chain
├── CONTRIBUTING.md                    Lesson + skill template
├── LICENSE                            MIT
└── Makefile                           Common commands
```

## Conventions

### When adding a new plugin

- Top-level dir under `plugins/<plugin-name>/`
- Required: `.claude-plugin/plugin.json` with `name`, `version`, `description`, `skills: "./skills"`
- Required: `skills/` dir with at least one SKILL.md
- Add an entry to root `.claude-plugin/marketplace.json`

### When adding / editing a lesson (opb-curriculum only)

- Each lesson lives in `plugins/opb-curriculum/lessons/NN-kebab-case-name/README.md`
- Always end with one concrete exercise
- Cross-link to `[← prev]` and `[next →]` at bottom
- Keep opinions; "it depends" is not a lesson

### When adding / editing a skill

**Naming convention (consistent across all plugins):**

- Each skill lives in `plugins/<plugin>/skills/<skill-name>/SKILL.md`
- Skill directory name: **lowercase kebab-case, descriptive**
- **No redundant plugin-name prefix** (the path already scopes it). For example, a `gtm-ops` skill is named `icp-scout`, not `gtm-icp-scout` or `icp-scout`.
- **Sub-domain prefix allowed only when needed for disambiguation.** The `product-ops` plugin includes 65 skills imported from phuryn/pm-skills (8 sub-domains with real name collisions). Those keep their `pm-<sub-domain>-<name>` prefix (e.g. `pm-execution-create-prd`, `pm-data-analytics-cohort-analysis`).
- The `name:` field in `SKILL.md` frontmatter MUST exactly match the directory name.
- Frontmatter required: `name`, `description` (rich, with trigger phrases)
- v2 standard: hard constraints first → workflow overview → step-by-step → required output format → worked example → common mistakes → notes on tooling → quick reference
- See `plugins/opb-curriculum/skills/wedge-finder/SKILL.md` or `plugins/opb-curriculum/skills/grand-slam-offer/SKILL.md` for the pattern

### Naming sweep

To verify naming consistency across all plugins:

```bash
find plugins -path '*/skills/*/SKILL.md' | while read f; do
  dir=$(basename "$(dirname "$f")")
  name=$(awk '/^---$/{c++; if(c==2)exit} /^name:/{gsub(/^name: */,""); gsub(/[\"\x27]/,""); print; exit}' "$f")
  [ "$dir" != "$name" ] && echo "MISMATCH dir=$dir name=$name $f"
done
```

### When committing

- Use the GitHub no-reply email format for commit author (already configured per-repo)
- Honest, descriptive commit messages — no AI emojis, no "✨ Initial commit ✨"
- Commit messages explain the *why*, not just the *what*

### Things to NEVER do without explicit user request

- Push to remote (commit yes, push no — let the user decide when to push)
- Change git config global settings
- Modify the Premise lesson's honesty about realistic outcomes
- Add hype language ("revolutionary", "world-class", "10x")
- Add emojis to lesson bodies (only used in skill output formats)
- Inflate scope — small surgical edits beat sprawling rewrites

## How to test changes

```bash
make lint            # Validate skill frontmatter + cross-links (per plugin)
```

## When in doubt

- **For a lesson:** does it pass the "would I be embarrassed reading this in 5 years?" test
- **For a skill:** does it push back when the user gives vague input?
- **For a template:** does it produce a fillable artifact, not free-form prose?
- **For the marketplace:** does each plugin still install and work standalone?

## Honest scope guard

If asked to "improve everything" or "make the whole repo deeper," push back: identify the highest-leverage 3 files to change. Sprawling rewrites lose to small surgical edits.
