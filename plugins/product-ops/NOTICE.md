# Attribution

This plugin includes work from two sources:

## SuperPMM / pmm-ops contribution
The `playbook` skill was authored by **Mothi Venkatesh**, MIT-licensed, originally
published at https://github.com/mothivenkatesh/product-ops-playbook. It's a
lightweight product operations SOP for small teams (1-2 PMs, 3-4 devs).

## phuryn/pm-skills contribution

The 65 `pm-*` skills and 36 `pm-*` commands in this plugin are derived from
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
