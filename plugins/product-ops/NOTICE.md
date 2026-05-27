# Attribution

This plugin includes work from three sources:

## SuperPMM / pmm-ops contribution
The `playbook` skill was authored by **Mothi Venkatesh**, MIT-licensed, originally
published at https://github.com/mothivenkatesh/product-ops-playbook. It's a
lightweight product operations SOP for small teams (1-2 PMs, 3-4 devs).

## Canon gap-fill: Lenny / Pichler / Institute of Product Leadership

12 additional `pm-*` skills were distilled by **Mothi Venkatesh** from canonical
posts at three sources (used under fair-use; each SKILL.md links back to the
original):

- **Lenny Rachitsky** ([lennysnewsletter.com](https://www.lennysnewsletter.com/)):
  `pm-execution-ai-evals`, `pm-product-discovery-ai-prototyping`,
  `pm-execution-waterline-team-debug`, `pm-execution-unfair-pm-principles`,
  `pm-product-discovery-ai-product-sense`
- **Roman Pichler** ([romanpichler.com](https://www.romanpichler.com/)):
  `pm-product-strategy-vision-board`, `pm-execution-stakeholder-power-interest-grid`,
  `pm-execution-saying-no-framework`, `pm-execution-go-product-roadmap`,
  `pm-product-strategy-pichler-strategy-canvas`
- **Institute of Product Leadership** ([productleadership.com](https://www.productleadership.com/)):
  `pm-career-skills-that-compound`, `pm-execution-strategy-implementation-6step`

Each skill is a framework distillation — it summarizes the source's framework,
attributes the source in `Further Reading`, and does not reproduce the source's
prose. If you want the original posts, follow the `Further Reading` links.

## phuryn/pm-skills contribution

The 65 `pm-*` skills and 36 `pm-*` commands (excluding the 12 gap-fill skills
above) in this plugin are derived from
**phuryn/pm-skills** — a PM Skills Marketplace authored by **Pawel Huryn**.

- Source: https://github.com/phuryn/pm-skills
- License: MIT (Copyright (c) 2026 Pawel Huryn)
- Git history preserved via `git subtree --squash` under
  [`upstream/pm-skills/`](./upstream/pm-skills/)

### What was changed
Pawel's repo is itself a marketplace of 8 sub-plugins (pm-execution,
pm-product-discovery, pm-product-strategy, pm-go-to-market,
pm-marketing-growth, pm-market-research, pm-data-analytics, pm-toolkit).

To make all 65 skills available under one `product-ops` plugin, we:
1. Subtreed the upstream repo at `upstream/pm-skills/` (read-only reference).
2. Moved each skill from `upstream/pm-skills/<sub-plugin>/skills/<skill>` into
   `skills/pm-<sub-plugin-suffix>-<skill>/` so the merged plugin's `skills/`
   directory exposes all of them with namespaced directory names.
3. Did the same for commands → `commands/pm-<suffix>-<command>.md`.

The skills' SKILL.md content and frontmatter are unchanged from upstream.

If you want the original 8-plugin structure with its own marketplace.json,
install directly from https://github.com/phuryn/pm-skills.
