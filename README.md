# One Person Billionaire

**A library of 7 installable Claude Code plugins for engineers who want to build, ship, and monetize agent-powered products as a (near-)solo operator.**

> **Build, ship, and monetize an agent-powered product as a solo operator targeting outlier outcomes ($5M-$50M ARR over 5-7 years).**

174 skills, 43 chained slash commands, 4 templates, 22 lessons, plus a full GTM / GTM Analytics / SDR / DevRel / PMM / Product Ops harness — split into 7 plugins you can install together or à la carte.

---

## Install

### Add the marketplace

```bash
claude plugin marketplace add mothivenkatesh/one-person-billionaire
```

### Install the plugins you want

```bash
# The full bundle
claude plugin install opb-curriculum@one-person-billionaire
claude plugin install gtm-ops@one-person-billionaire
claude plugin install ai-sdr@one-person-billionaire
claude plugin install devrel-playbook@one-person-billionaire
claude plugin install product-ops@one-person-billionaire

# Or pick what you need
claude plugin install opb-curriculum@one-person-billionaire   # start here
```

---

## Install everything

```bash
claude plugin install opb-curriculum@one-person-billionaire
claude plugin install gtm-analytics@one-person-billionaire
claude plugin install gtm-ops@one-person-billionaire
claude plugin install ai-sdr@one-person-billionaire
claude plugin install devrel-playbook@one-person-billionaire
claude plugin install pmm-ops@one-person-billionaire
claude plugin install product-ops@one-person-billionaire
```

## The 7 plugins

| Plugin | What's inside | Install when… |
|---|---|---|
| **[opb-curriculum](./plugins/opb-curriculum)** | 22 lessons · 26 core skills · 7 chained slash commands · 4 templates | You're starting from zero — this is the curriculum |
| **[gtm-analytics](./plugins/gtm-analytics)** | 40 enterprise GTM-analytics skills: attribution, deal-rot, propensity-to-renew, churn risk, multi-touch attribution, golden-path journey, sales rep effectiveness | You're scaling past $1M ARR and need real revenue-ops discipline |
| **[gtm-ops](./plugins/gtm-ops)** | 11 skills running the 3-loop GTM model (Acquisition · Nurture · Re-engagement) on Salesforce + n8n + Claude. Includes agents, SQL, dashboards, evals, full operating spec | You're running an AI-first GTM org and need an operating system |
| **[ai-sdr](./plugins/ai-sdr)** | Autonomous SDR agent: router + 7 modes (research, validate, outreach, follow-up, batch, analytics). Score-gated pipelines, TSV staging, NEVER/ALWAYS rails | You're running cold outbound and want to replace n8n |
| **[devrel-playbook](./plugins/devrel-playbook)** | 27 community-building skills + applied case studies + a synthetic developer ICP dataset | You're building a developer/creator community |
| **[pmm-ops](./plugins/pmm-ops)** | SuperPMM — guided 5-step GTM Builder (Research → CI → PRFAQ → Positioning → GTM Plan). Frameworks: FletchPMM, April Dunford, Winning by Design | You're a PMM doing a launch in ~60 minutes, not 6 weeks |
| **[product-ops](./plugins/product-ops)** | 6-stage execution SOP for small teams + 65 PM skills + 36 chained slash commands across discovery, strategy, execution, market research, GTM, marketing/growth, data analytics, toolkit. Combines a Scrut-tested SOP with [phuryn/pm-skills](https://github.com/phuryn/pm-skills) (MIT, Pawel Huryn) | You're a PM/team that needs PRD/discovery/strategy/release rituals |

---

## Quick start (after installing `opb-curriculum`)

```
/find-wedge        Discover a profitable wedge end-to-end (wedge → ICP → validation)
/build-offer       Construct the Hormozi Grand Slam offer + price it for max margin
/start-outbound    Run a 100-prospect cold campaign (signals → emails → drafts)
/audit-product     5-dimensional audit (harness, production, boring-stack, margin, retention)
/diagnose-stall    Why you're stuck at $X MRR — pick the ONE bottleneck
/plan-week         Design your 4-day operator's week
/annual-review     Annual scorecard + update your 10-year statement
```

These chain the curriculum's 29 skills into end-to-end workflows. **Type one to start.**

If you prefer reading first → start with [Lesson 00: The Honest Premise](./plugins/opb-curriculum/lessons/00-the-honest-premise/README.md). It tells you what's actually achievable (spoiler: not a billion in solo revenue, but $5M-$50M is) so you don't quit when the math hits.

---

## Read this first

The phrase **"one-person billionaire"** is mostly fan-fiction in 2026. Zero have been confirmed. The honest ladder:

| Stage | ARR | Solo? | Known cases |
|---|---|---|---|
| Side project | $0 – $10K | ✅ | Most attempts |
| Ramen profitable | $10K – $100K | ✅ | Thousands of indie hackers |
| Sustainable solo | $100K – $1M | ✅ | Hundreds globally |
| Mid solo | $1M – $10M | ✅ with agents | ~50–200 globally |
| Outlier solo | $10M – $100M | Possible with agents + automation | ~5–20 globally |
| Solo $100M+ ARR | $100M+ | Hypothetically possible 2030+ | None proven |
| Solo $1B exit / $1B founder net worth | — | Possible at high multiples + held equity | None proven *as solo* |

This curriculum trains you for the realistic ladder. **Read [Lesson 00](./plugins/opb-curriculum/lessons/00-the-honest-premise/README.md) before anything else** — it does the math so you don't quit when the math hits.

---

## Repo layout

```
.
├── .claude-plugin/marketplace.json    # lists all 7 plugins
└── plugins/
    ├── opb-curriculum/    26 skills · 7 commands · 4 templates · 22 lessons · code/
    ├── gtm-analytics/     40 enterprise GTM-analytics skills (own README)
    ├── gtm-ops/           11 skills · agents/ sql/ src/ dashboards/ evals/ docs/
    ├── ai-sdr/             3 skills · modes/ data/ scripts/
    ├── devrel-playbook/   27 skills · applied/ · synthetic-icp/
    ├── pmm-ops/            1 skill (SuperPMM) · docs/ src/ output/
    └── product-ops/       66 skills · 36 commands · upstream/pm-skills/ · NOTICE.md
```

Each plugin has its own `.claude-plugin/plugin.json` and is independently installable.

## Skill naming convention

Skills follow a consistent rule across all plugins:

- **Skill directory name = lowercase kebab-case**, descriptive of what the skill does.
- **No redundant plugin-name prefix** — the path `plugins/<plugin>/skills/<skill>/` already scopes it.
- **Sub-domain prefix allowed only for disambiguation** — e.g. `product-ops` includes 65 imported skills with `pm-<sub-domain>-*` prefixes (`pm-execution-create-prd`, `pm-data-analytics-cohort-analysis`) because the upstream marketplace had 8 sub-plugins with name collisions.
- The `name:` field in each `SKILL.md` frontmatter matches the directory name exactly.

---

## What this is — and is not

| ✅ This is | ❌ This is not |
|---|---|
| A 22-lesson opinionated path from `while True:` to monetized agent product | A get-rich-quick framework |
| Honest about distribution being the harder half | A "just code well" engineering deep-dive |
| Calibrated for 2026: post-MCP, post-Claude 4.7, post-Skills spec | A theoretical AI textbook |
| Each lesson ends with one concrete exercise | A motivational manifesto |
| Built to compound — short reads, durable principles | A library you'll reference once and forget |

---

## Who this is for

- You can already code (Python or TypeScript)
- You've shipped at least one thing to real users (or you're about to)
- You've used Claude Code / Cursor / Codex enough to feel what an agent *is*
- You don't need hand-holding on `git`
- You're tempted by the indie-hacker leg but realize engineering alone won't get you there

---

## The 5 Parts of the curriculum

```
PART 1   ENGINEERING       L01 → L04   The 100x agent engineer (compressed)
[INTERLUDE]                L04A        The boring stack first — when NOT to use AI
PART 2   PRODUCTIZING      L05 → L08   Engineering chops → a thing people pay for
[INTERLUDE]                L08A        The Grand Slam Offer — fix the offer before scaling distribution
PART 3   DISTRIBUTION      L09 → L12   The half engineers always skip
PART 4   MONETIZATION      L13 → L16   Pricing, margin, retention, scaling
PART 5   LEVERAGE          L17 → L20   Compounding into outlier outcomes
```

Full lesson list: [`plugins/opb-curriculum/lessons/`](./plugins/opb-curriculum/lessons/).

---

## The 8 Principles

1. **Distribution is the harder half.** Engineering excellence is necessary but not sufficient. Most failed indie attempts had the better product.
2. **Margin is destiny.** Per-token pricing kills you. Value-based pricing on durable problems wins.
3. **Compound or die.** One-time wins make great Twitter posts. Recurring wins make great businesses.
4. **The boring stack ships.** Anthropic SDK + a `while` loop + Postgres + Stripe will outship the latest agent framework every time.
5. **The model is not the moat.** Your moat is data, distribution, retention, and trust.
6. **Honest >> impressive.** Lying to yourself about your numbers is the most expensive thing you'll do.
7. **Time-in-market beats market-timing.** The 5-year operator beats the 12-month sprinter every time.
8. **AI is not always the answer.** Most production "AI products" are a workflow engine + 1-2 LLM steps. The agent loop is for the fuzzy 20%, not the structured 80%.

---

## Further reading (educational sources cited throughout)

- Alex Hormozi — *$100M Offers* and *$100M Leads* (offer construction)
- Patrick McKenzie — bootstrapped SaaS economics, cold email, "Don't Call Yourself a Programmer"
- Jason Cohen — A Smart Bear blog (bootstrapped SaaS)
- Tyler Tringas — Calm Company Fund (alternative to VC)
- Pieter Levels — bootstrapped multi-product solo operator (the "boring stack" example)
- Rob Fitzpatrick — *The Mom Test* (customer interview method)
- Madhavan Ramanujam — *Monetizing Innovation* (pricing framework)
- Anthropic — Claude API docs, prompt caching docs, Skills specification
- OWASP — MCP Top 10 (agent security)

For the full credit list — books, authors, open patterns, frameworks, and tools that shaped this synthesis — see [ACKNOWLEDGMENTS.md](./ACKNOWLEDGMENTS.md).

---

## License

MIT. Fork it, ship it, sell it.
