# gtm-ops

> **The GTM operating system for AI-first sales orgs.** Spec + scaffold + skills + agents + reporting, built on Salesforce + n8n + Claude.

A complete operational reference for running go-to-market in autopilot mode — humans-in-the-loop only for approval and strategy. One of a series of `*-ops` repos that automate functional domains.

---

## Who this is for

| Role | What you'll find here |
|---|---|
| 🛠️ **GTM Operators** (RevOps, Demand Gen, Marketing Ops) | The 7 agents that run the engine + the 3 BI surfaces that report on it |
| ⚙️ **GTM Engineers** | Reference architecture for an agent layer that sits above any CRM |
| 📣 **PMMs** | Lifecycle + cross-sell + churn-save motion playbooks |
| 👔 **CMOs / VPs** | Operating-model spec, comp implications, org structure (HoDG / GTM Engineer roles) |
| 🚀 **Indie builders** | Reference architecture for a productized "Developer Growth OS" |

---

## The 3-loop operating model

```
        ┌─────────────────────────────────────────┐
        │            ACQUISITION LOOP             │
        │  ICP-Scout · Outreach-Writer · Reply    │
        └────────────────┬────────────────────────┘
                         │
        ┌────────────────▼────────────────────────┐
        │             NURTURE LOOP                │
        │  Stage-Mover · Cross-Sell-Detector      │
        └────────────────┬────────────────────────┘
                         │
        ┌────────────────▼────────────────────────┐
        │         RE-ENGAGEMENT LOOP              │
        │  Dormant-Detector · Churn-Saver         │
        └─────────────────────────────────────────┘

  All running on:  Salesforce + n8n + Claude Max +
                   Drive AI + Google Forms/Sheets +
                   Smartlead (20 domains) + MoEngage +
                   Clay + ZoomInfo + Sales Nav +
                   Ahrefs + SimilarWeb +
                   Metabase + AWS QuickSight
```

**13 reliability rules · DIN approval gate · UTM tagging mandatory · 3-surface BI rule (anti-sprawl) · `mart_buyer_journey` as the spine of all reporting.**

---

## Pick your path

| You are... | Start here |
|---|---|
| **New here, want the 60-second tour** | 👉 [`OPERATOR-QUICKSTART.md`](OPERATOR-QUICKSTART.md) |
| **Hands-on: 7-day step-by-step walkthrough** | 🛠️ [`TUTORIAL.md`](TUTORIAL.md) — clone → seed → query → first DIN → first weekly digest |
| **Building it for your company** | 📘 [`docs/cf-gtm-context.md`](docs/cf-gtm-context.md) (the full ~1,400-line spec) |
| **Want the architecture diagram** | 🏗️ [`docs/architecture.md`](docs/architecture.md) |
| **Extending with new agents/skills** | 🤝 [`CONTRIBUTING.md`](CONTRIBUTING.md) |
| **What's planned for v1.5 / v2** | 🗺️ [`ROADMAP.md`](ROADMAP.md) |
| **Version history** | 📋 [`CHANGELOG.md`](CHANGELOG.md) |

---

## Status

| Component | Status | Notes |
|---|---|---|
| **Spec** (`docs/cf-gtm-context.md`) | ✅ Stable v0.1 | Industry-validated against CS2 / Domestique / Factors / Clay |
| **Python reference scaffold** (`src/`) | 🟡 Partial | 2 of 7 flows fully scaffolded (LangGraph). Use as a structural reference, not production code. |
| **Claude Code skills** (`skills/`) | 🔲 Not yet built | 11 skills planned per spec §5 |
| **n8n agents** (`agents/`) | 🔲 Not yet exported | 7 + 3 utility workflows planned |
| **dbt-lite marts** (`sql/`) | 🟡 Schema only | `mart_buyer_journey` (the spine) is P0 to build first |
| **Dashboard templates** (`dashboards/`) | 🔲 Not yet built | 12 Sheets · Metabase JSON · QuickSight definitions |
| **Production deployment** | 🔲 None | This is a private design repo; production lives inside Cashfree systems |

---

## Repo layout

```
gtm-ops/
├── README.md                    ← you are here
├── OPERATOR-QUICKSTART.md       ← 60-second tour for new operators
├── CONTRIBUTING.md              ← how to add a skill / agent / mart
├── ROADMAP.md                   ← v1 / v1.5 / v2 phasing
├── CHANGELOG.md                 ← version history
├── LICENSE.md
│
├── docs/
│   ├── README.md                ← documentation TOC
│   ├── cf-gtm-context.md        ← canonical Cashfree GTM spec (~1,400 lines)
│   ├── architecture.md          ← 3-layer architecture detail
│   └── internal/                ← confidential narrative (session log, pitch, demo script)
│
├── src/gtm_ops/                 ← Python LangGraph reference implementation
│   ├── flows/                   ← 7 agent flows (2 scaffolded, 5 stubbed)
│   ├── integrations/            ← 6 typed clients (HubSpot · OpenRouter · Fathom · Smartlead · Dripify · Typefully)
│   ├── cli.py                   ← `uv run gtm-ops <command>`
│   ├── config.py                ← typed settings
│   └── models.py                ← Pydantic schemas
│
├── skills/                      ← Claude Code skills (markdown-first)
├── agents/                      ← n8n workflow JSON exports
├── sql/                         ← dbt-lite marts (Postgres views)
├── dashboards/                  ← Sheets / Metabase / QuickSight templates
├── evals/                       ← Promptfoo prompt regression tests
└── notebooks/                   ← one-off analysis (forecasting, win/loss clustering)
```

---

## The `*-ops` meta-pattern

This repo sits inside a broader personal-OS pattern:

| Repo | Domain | Status |
|---|---|---|
| **`gtm-ops`** | Go-to-market operations (this repo) | spec stable, build pending |
| `mothi-os` (private) | Master personal OS — 23 active skills | live |
| `llm-wiki` ([github.com/mothivenkatesh/llm-wiki](https://github.com/mothivenkatesh/llm-wiki)) | Durable knowledge layer — entities, concepts, sources | live; cross-linked from cf-gtm-context |
| Future: `pmm-ops`, `partner-ops`, `content-ops`, `community-ops` | Per-domain operating systems | planned |

**Vision:** every functional domain runs in autopilot — humans-in-the-loop only for approval (DIN) and strategy. Each `*-ops` repo follows the same shape: spec markdown + Claude Code skills + workflow exports + SQL marts + dashboards.

---

## Quick setup (for the Python reference scaffold)

```bash
# 1. Copy env
cp .env.example .env   # fill in API keys

# 2. Spin up Postgres + Metabase + Redis
docker compose up -d

# 3. Install Python deps (uv recommended)
uv sync

# 4. Seed schema
make seed

# 5. Run the canonical flow
uv run gtm-ops meeting-prep --deal-id=1

# 6. Run evals
cd evals && npx promptfoo eval
```

> **Note:** the Python scaffold is a *reference implementation*. The production system runs on n8n + Claude Max API + the spec — not this Python code. Use this scaffold to understand the shape; build production in n8n.

---

## License

Private / proprietary. See [`LICENSE.md`](LICENSE.md). Do not distribute, fork, or share without explicit permission.
