# Contributing

PRs welcome. Two rules:

1. **Lessons must be opinionated.** "It depends" is not a lesson. Pick a side; explain the trade-off honestly.
2. **Each lesson must end with one concrete exercise.** No exercise = not merged.

## Lesson template

```markdown
# Lesson NN: title

## TL;DR
One paragraph: what this lesson teaches and why it matters for a solo operator targeting outlier outcomes.

## Core idea
The 1–3 framework-level points.

## How it works in practice
Examples, decision matrices, code, math, whatever fits.

## Common traps
Things smart people get wrong here.

## Exercise
One actionable thing to do in the next 1–7 days.

## Further reading
2–5 links. No more.
```

## Style

- **Terse.** Cut the fluff. If a sentence isn't earning its keep, delete it.
- **Specific over general.** "Charge $99/seat/mo" beats "price appropriately."
- **Numbers where possible.** Show the math.
- **Honest about failure modes.** What kills people doing this? Say so.
- **No hype.** "AI changes everything" is a tell that the writer hasn't shipped.

## Things we will not merge

- Lessons that boil down to "use [my framework]"
- Lessons that promise outcomes without explaining the survivorship bias
- Lessons that confuse "tools I like" with "tools that win"
- Posts about LangChain (sorry)

## Plugin granularity

A plugin is the unit of installation. Pick this scope on purpose:

- **5-50 skills** = real plugin. Own theme, own README, own data/ if needed.
- **<5 skills** = should fold into an adjacent plugin under a `<theme>-*` namespace prefix. Standalone tiny plugins fragment the marketplace and burn marketplace.json line-budget.
- **>50 skills** = consider splitting along a sub-domain boundary so each install is reachable cognitively.

Known violations to revisit when they bite:
- `cashfree` (1 skill) — could fold into a future `design-systems` plugin, or stay if it grows past 5
- `pmm-ops` (5 skills) — now at threshold after adding voice-engine; OK
- `product-ops` (78 skills) — heavy; could split into `pm-strategy`, `pm-discovery`, `pm-execution`, etc. if discovery friction shows up

## Tooling

- `make lint` — frontmatter + dup-name + conflict-marker checks (CI-safe)
- `make catalog` — regenerate [SKILLS.md](./SKILLS.md) from frontmatter (source of truth)
- `make check` — lint + sweep + catalog (CI entry point)

Run `make check` before opening a PR.

## License

By contributing, you agree your contributions are licensed under MIT.
