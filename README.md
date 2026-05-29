# MStack

**Agents for the work GTM, Growth, and Product teams actually do.**

Built by [Mothi Venkatesh](https://github.com/mothivenkatesh) — Associate Director, Product Marketing at [Cashfree Payments](https://www.cashfree.com) — after 11 years inside payments and fintech GTM orgs, watching the same workflows get rebuilt in every spreadsheet, every notebook, every n8n graph.

> The structured 80% of GTM, Growth, and Product is finally agent-shaped.
> MStack is the part of my stack I'm willing to ship in public.

**8 plugins · 176+ skills · 43+ chained slash commands · 4 templates.** Install the full stack or the one plugin you need this week.

```bash
claude plugin marketplace add mothivenkatesh/MStack
```

---

## The thesis

Most GTM, Growth, and Product work decomposes into two halves:

- **80% structured workflows** — research, qualification, ICP scoring, attribution, churn analysis, PRDs, launches, weekly cadences, follow-ups. Rule-shaped, repeatable, and the reason your week burns.
- **20% fuzzy judgment** — what to bet on, who to fight, what to kill, how to position, when to ship. This is where humans earn their seat.

Most teams write essays about the 20% while drowning in the 80%. MStack inverts that: **codify the 80% as installable agents, free yourself for the 20%.**

Every plugin in this repo is a tactical implementation of that one idea, calibrated for 2026 — post-MCP, post-Claude 4.7, post-Skills spec.

---

## Why I built it

Two things converged in 2025–2026 that made me stop sketching workflows on whiteboards and start shipping agents:

1. **The Skills spec landed.** Anthropic's progressive-disclosure model meant I could write a workflow once, scope it tightly, and have it auto-trigger across my work. Not a chatbot — an installable capability.
2. **My own consistency problem.** The most honest feedback I get on myself is *"I'm not consistent."* Building agents is how I stop letting consistency depend on willpower. **Agents are the consistency layer.**

MStack is the side of that stack I can share. Brand-safe, role-shaped, dogfooded daily on payments work at Cashfree, D2C research, partner outreach, FinX seeding, Twitter OS, and Relay.

---

## Install

### Add the marketplace

```bash
claude plugin marketplace add mothivenkatesh/MStack
```

### Install the plugins you want

```bash
# The full stack
claude plugin install opb-curriculum@MStack
claude plugin install gtm-analytics@MStack
claude plugin install gtm-ops@MStack
claude plugin install ai-sdr@MStack
claude plugin install devrel-playbook@MStack
claude plugin install pmm-ops@MStack
claude plugin install product-ops@MStack
claude plugin install funnel-marketing@MStack
```

Or pick one — every plugin is independently installable.

---

## The 8 plugins, mapped to the work

| Pillar | Plugin | What's inside | When to reach for it |
|---|---|---|---|
| **Foundation** | [`opb-curriculum`](./plugins/opb-curriculum) | 22 lessons · 26 core skills · 7 chained commands · 4 templates | The opinionated path from `while True:` to a monetized agent product. Start here if you're still building intuition. |
| **GTM** | [`gtm-ops`](./plugins/gtm-ops) | 11 skills running the 3-loop GTM model on Salesforce + n8n + Claude. Agents, SQL, dashboards, evals, full operating spec. | Running an AI-first GTM org and need an operating system. |
| **GTM** | [`ai-sdr`](./plugins/ai-sdr) | Autonomous SDR agent: router + 7 modes (research, validate, outreach, follow-up, batch, analytics). Score-gated pipelines, TSV staging, NEVER/ALWAYS rails. | Replacing a 25-node n8n outbound graph with one Claude-native agent. |
| **GTM / PMM** | [`pmm-ops`](./plugins/pmm-ops) | 5 skills: SuperPMM (guided 5-step GTM Builder — Research → CI → PRFAQ → Positioning → GTM Plan, using FletchPMM, April Dunford, Winning by Design), pmm-messaging, InsideInsights (brand methodology), sales-enablement, and voice-engine (distill an operator's writing into a Voice Profile, then ghostwrite/audit in their voice). Plus applied/ docs (AIPMM blueprint + 10x/100x use cases). | A PMM doing a launch in ~60 minutes, not 6 weeks. |
| **Growth** | [`gtm-analytics`](./plugins/gtm-analytics) | 40 enterprise GTM-analytics skills: attribution, deal-rot, propensity-to-renew, churn risk, multi-touch attribution, golden-path journey, sales rep effectiveness. | Past $1M ARR and need real revenue-ops discipline. |
| **Growth** | [`funnel-marketing`](./plugins/funnel-marketing) | `funnel-builder` reverse-engineers a competitor's launch in 4 phases — grounded in 45,056 real Reddit conversations. `psychology-triggers` applies 218 persuasion levers to copy. | Decoding a competitor's funnel, or writing high-converting copy. |
| **Growth / DevRel** | [`devrel-playbook`](./plugins/devrel-playbook) | 28 community-building skills + applied case studies + a synthetic developer ICP dataset. | Growing a developer or creator audience. |
| **Design / Web** | [`cashfree`](./plugins/cashfree) | `cf-web-design` skill — cashfree.com pattern library: 18 section archetypes, 5 page templates, Playwright audit toolkit, WCAG/archetype/token-drift validators, page-cloning workflow with 30 L-rules + 33-check pre-output checklist. | Cloning, auditing, or designing pages in the cashfree.com style. |
| **Product** | [`product-ops`](./plugins/product-ops) | 6-stage execution SOP for small teams + 77 PM skills + 36 chained slash commands across discovery, strategy, execution, market research, GTM, growth, data analytics, AI-PM, career, toolkit. Combines a Scrut-tested SOP with [phuryn/pm-skills](https://github.com/phuryn/pm-skills) (MIT) and 12 gap-fill skills distilled from Lenny Rachitsky, Roman Pichler, and Institute of Product Leadership. | A PM/team that needs PRD/discovery/strategy/release rituals codified. |

Each plugin has its own README. Read it before you install.

---

## Quick start (after installing `opb-curriculum`)

```
/find-wedge        Discover a profitable wedge end-to-end (wedge → ICP → validation)
/build-offer       Construct an offer + price it for margin
/start-outbound    Run a 100-prospect cold campaign (signals → emails → drafts)
/audit-product     5-dimensional product audit (harness, production, boring-stack, margin, retention)
/diagnose-stall    Why you're stuck — pick the ONE bottleneck
/plan-week         Design your operator's week
/annual-review     Annual scorecard + update your 10-year statement
```

These chain skills into end-to-end workflows. **Type one to start.**

---

## Who this is for

- **PMMs** running launches, positioning, CI, messaging, sales enablement
- **Growth & RevOps** running attribution, propensity-to-renew, churn, multi-touch, golden-path journeys, rep effectiveness
- **SDRs** running cold outbound at volume without burning their lists
- **Product Ops** running discovery → PRD → release rituals
- **DevRel and community** builders growing technical audiences
- **Founders** doing all of the above as one person

You can already code (Python or TypeScript). You've used Claude Code or Cursor enough to feel what an agent *is*. You don't need hand-holding on `git`. You're tired of writing the same workflow into a different surface every quarter.

---

## How it gets built

I work in payments. Every plugin in MStack is built and dogfooded inside my own work — Cashfree campaigns, partner outreach, D2C research, FinX seeding, Twitter OS, Relay. When something compounds across more than one workflow, it gets pulled out and shipped here.

This isn't a side project I theorize about. It's the harness I use Monday morning.

The companion projects you'll see referenced across the skills:

- **Twitter OS** — draft-and-approve content agent for X / LinkedIn / Bluesky / Threads via Typefully
- **Relay** — runtime for goal-driven workflow agents (Cashfree-internal; public skills pack incoming)
- **[reddit-scraper](https://github.com/mothivenkatesh/reddit-scraper)**, **[tweet-harvest](https://github.com/mothivenkatesh/tweet-harvest)**, **[review-scrape](https://github.com/mothivenkatesh/review-scrape)** — public scrapers that feed the research / funnel / CI skills
- **D2C Reddit research** — 28K-row corpus validating real fintech use cases, used by `funnel-marketing` and `gtm-analytics`
- **[mothi.work](https://mothi.work)** — the writing leg

---

## The 8 principles

Show up in every plugin:

1. **Distribution is the harder half.** Engineering excellence is necessary but not sufficient.
2. **Margin is destiny.** Per-token pricing kills you; value-based pricing on durable problems wins.
3. **Compound or die.** One-time wins make great social posts. Recurring wins make great businesses.
4. **The boring stack ships.** Anthropic SDK + a `while` loop + Postgres + Stripe will outship the latest agent framework.
5. **The model is not the moat.** Your moat is data, distribution, retention, and trust.
6. **Honest > impressive.** Lying to yourself about your numbers is the most expensive thing you'll do.
7. **Time-in-market beats market-timing.** The 5-year operator beats the 12-month sprinter.
8. **AI is not always the answer.** Most production "AI products" are a workflow engine + 1–2 LLM steps. The agent loop is for the fuzzy 20%, not the structured 80%.

---

## Repo layout

```
.
├── .claude-plugin/marketplace.json    # 8 plugins listed here
└── plugins/
    ├── opb-curriculum/    26 skills · 7 commands · 4 templates · 22 lessons
    ├── gtm-analytics/     40 enterprise GTM-analytics skills
    ├── gtm-ops/           11 skills · agents/ sql/ src/ dashboards/ evals/ docs/
    ├── ai-sdr/             3 skills · modes/ data/ scripts/
    ├── devrel-playbook/   28 skills · applied/ · synthetic-icp/
    ├── pmm-ops/            5 skills (SuperPMM + messaging + brand/practitioner + voice-engine) · applied/ docs/ src/ output/
    ├── cashfree/           1 skill (cf-web-design) · data/ output/
    ├── product-ops/       78 skills · 36 commands · upstream/pm-skills/
    └── funnel-marketing/   2 skills · case-studies/ · data/ (45K Reddit conversations)
```

Live source of truth for the catalog: [SKILLS.md](./SKILLS.md) (auto-generated by `make catalog`).

Each plugin has its own `.claude-plugin/plugin.json` and is independently installable.

---

## Skill naming convention

Across every plugin:

- Skill directory name = lowercase kebab-case, descriptive of what the skill does.
- No redundant plugin-name prefix — `plugins/<plugin>/skills/<skill>/` already scopes it.
- Sub-domain prefix only for disambiguation — `product-ops` keeps `pm-<sub-domain>-*` prefixes from upstream `phuryn/pm-skills` because of real name collisions.
- The `name:` field in each `SKILL.md` frontmatter matches the directory name exactly.

---

## Further reading (cited throughout)

- Alex Hormozi — *$100M Offers* / *$100M Leads* (offer construction, cold outbound mechanics)
- Patrick McKenzie — Kalzumeus blog (bootstrapped SaaS, cold email, "Don't Call Yourself a Programmer")
- Jason Cohen — *A Smart Bear* (bootstrapped SaaS economics)
- Tyler Tringas — Calm Company Fund writings
- Pieter Levels — multi-product solo operator (the "boring stack" archetype)
- Rob Fitzpatrick — *The Mom Test* (customer interview method)
- Madhavan Ramanujam — *Monetizing Innovation* (pricing framework)
- April Dunford — *Obviously Awesome* (positioning)
- Anthropic — Claude API docs, prompt caching, Skills spec
- OWASP — MCP Top 10 (agent security)

Full credit chain: [ACKNOWLEDGMENTS.md](./ACKNOWLEDGMENTS.md).

---

## License

MIT. Fork it, ship it, sell it.

---

Built by [@mothivenkatesh](https://github.com/mothivenkatesh) · [mothi.work](https://mothi.work) · Bengaluru
