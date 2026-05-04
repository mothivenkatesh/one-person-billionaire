# Operator Quickstart

> **You are a GTM operator. You have 60 seconds. Read this.**

---

## What gtm-ops is

A working spec + reference architecture for running GTM operations on Claude + n8n + the tools you already pay for (Salesforce, Smartlead, MoEngage, Clay, ZoomInfo, Sales Nav, Ahrefs, Drive, Sheets, Metabase, QuickSight).

It's built around a 3-loop model — **Acquisition → Nurture → Re-engagement** — with 7 agents covering all three loops, 13 reliability rules so nothing breaks, and a single canonical reporting record (`mart_buyer_journey`) that every dashboard rolls up from.

---

## The 7 agents (what each one does, in plain language)

### Acquisition loop

| Agent | When it fires | What it does |
|---|---|---|
| **ICP-Scout** | Daily 6am + Google Forms webhook | Scans new prospects from Sales Nav / Ahrefs / SimilarWeb / inbound forms · enriches via Clay+ZoomInfo · scores 0-5 against ICP · routes to A/B/C tier |
| **Outreach-Writer** | Triggered by new high-score leads | Reads the prospect's website + LinkedIn + recent news · drafts 3-touch personalized Smartlead sequence |
| **Reply-Classifier** | On Smartlead reply webhook | Claude classifies reply intent (positive · objection · not now · unsubscribe · referral) · logs SF activity · alerts AE only on positive |

### Nurture loop

| Agent | When it fires | What it does |
|---|---|---|
| **Stage-Mover** | Daily 7am + Calendar webhook | Flags opportunities stuck >14d in stage; OR auto-fires meeting-prep brief 2h before any AE meeting · pulls Drive transcripts of past calls + SF context |
| **Cross-Sell-Detector** | Weekly Monday | Scans merchants heavy in Product A absent in Product B · drafts personalized cross-sell pitch with merchant's actual usage data |

### Re-engagement loop

| Agent | When it fires | What it does |
|---|---|---|
| **Dormant-Detector** | Weekly Tuesday | Scans for accounts with no meaningful activity in 30/60/90d · fires personalized re-engagement |
| **Churn-Saver** | Daily 6am | Composite churn signal (usage drop + support tickets + competitor mentions in transcripts + low NPS) · CSM alert with talking points |

Plus 3 utility agents: `drive-transcript-extractor` · `forms-router` · `din-watchdog` (the campaign approval enforcement bot).

---

## The 3 reporting surfaces (anti-sprawl rule)

**One surface per audience. Same data, different presentations.**

| Audience | Surface | What they see |
|---|---|---|
| **AE / SDR / CSM** | Google Sheets (12 operational sheets) | My pipeline, my queue, my next actions, agent recommendations |
| **PMM / Demand Gen / RevOps** | Metabase | Channel performance, DIN-leaderboard, funnel cohorts, deliverability |
| **VP Sales / VP Marketing / Founders** | AWS QuickSight | Pipeline:revenue ratio, forecast vs actual, vertical mix, QoQ trends |

**No metric is defined twice.** Every metric lives in one SQL view, surfaced to all 3 places.

---

## The 13 reliability rules (one-line summary each)

1. **One MCP per tool** — agents stay vendor-agnostic
2. **Pydantic schemas everywhere** — type validation at every boundary
3. **LiteLLM/Claude Max proxy** — cost caps + model fallback
4. **Prompt caching** — 90% cost reduction on repeated context
5. **Batch API for non-realtime** — 50% cost reduction
6. **Circuit breakers** — trip after 5 consecutive API failures
7. **Rate limits at MCP boundary** — token-bucket per tool
8. **Retries with exponential backoff** — max 3, idempotency keys
9. **HITL approval** — every CRM write, every outbound, every ad audience change
10. **Unleash feature flags** — 10% → 50% → 100% rollout per agent
11. **Immutable audit log** — every Claude decision in ClickHouse/Postgres
12. **Kill switch UI** — one-click disable per agent / segment / globally
13. **eSignature finality** — DIN approval not "approved" until Workspace eSignature complete

---

## DIN approval workflow (the campaign brief gate)

> **Every campaign gets a DIN. No DIN = no send. No exceptions.**

```
PMM drafts brief in Gdoc → Slack discussion → Workspace eSignature → n8n flips status to 'live' → only NOW can a campaign launch
```

9 mandatory uploads per DIN: brief, creative, audience list, compliance check, approval audit trail, test send results, UTM verification, frequency-cap impact analysis, post-launch retro template.

3 layers of skip-detection: pre-launch n8n gate · 15-min anomaly watchdog · daily 9am reconciliation.

Cultural rule: **"If you launched without a DIN, you didn't launch — you leaked it. The system tells on you in 15 min."**

---

## UTM scheme (every link, every send)

```
utm_source    = {channel_tool}        # smartlead | moengage | linkedin_ads | sales_nav | meta_ads | etc
utm_medium    = {channel_type}        # email | push | whatsapp | sms | in_app | paid | social | inmail
utm_campaign  = {DIN_ID}              # e.g., AGS-GTM-20260424-001
utm_content   = {variant_id}          # v1 | v2 | v3
utm_term      = {audience_segment}    # bfsi_tierA | d2c_midmkt | etc
+ cf_din={DIN_ID}                     # custom redundancy
+ cf_owner_email={pmm_owner_email}    # accountability
```

---

## Where to look for what

| Question | File |
|---|---|
| What's the full spec? | [`docs/gtm-context.md`](docs/gtm-context.md) |
| What's the architecture? | [`docs/architecture.md`](docs/architecture.md) |
| How do I add a new agent? | [`CONTRIBUTING.md`](CONTRIBUTING.md) |
| What's planned next? | [`ROADMAP.md`](ROADMAP.md) |
| Where are the SQL marts? | [`sql/`](sql/) — `mart_buyer_journey` is the spine |
| Where are the Claude Code skills? | [`skills/`](skills/) |
| Where are the n8n agent exports? | [`agents/`](agents/) |
| Where are the dashboard templates? | [`dashboards/`](dashboards/) |

---

## Your first 4 weeks if you're shipping this

| Week | Ship |
|---|---|
| **1** | n8n + Postgres + Langfuse stand up · ICP-Scout agent live on 100 SF leads · `mart_buyer_journey` view created |
| **2** | Outreach-Writer + Reply-Classifier · Smartlead campaigns with frequency caps · DIN gate enforced |
| **3** | Stage-Mover + Cross-Sell-Detector · MoEngage integration · cross-sell pilot on 1 vertical |
| **4** | Dormant-Detector + Churn-Saver · weekly digest agent · first Slack #gtm-weekly post Monday 9am |

After Week 4 you'll have all 7 agents live + the canonical reporting record + the weekly digest. Everything in v2 (Bombora, Gong, PostHog, Hightouch) is *only if* the v1 KPIs justify the spend.

---

## What this is NOT

- ❌ A SaaS product (it's a spec + reference architecture)
- ❌ A replacement for Salesforce / Marketo / Clay (it sits *on top of* them)
- ❌ Free plug-and-play (you build the n8n workflows; the spec tells you what + why)
- ❌ A 41-agent monstrosity (we cut from 41 to 7 for v1; rest deferred to v2/v3)
- ❌ Public — this is private; do not distribute

---

## Next step

Read [`docs/gtm-context.md`](docs/gtm-context.md) end-to-end (~25 min). That's the operating manual.
