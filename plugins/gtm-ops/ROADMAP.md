# Roadmap

> Versioning the build sequence. v0.1 = current spec stable. v1.0 = production-ready.

---

## v0.1 — Spec stable (current state, 2026-04-26)

✅ Canonical spec (`docs/gtm-context.md`, ~1,400 lines)
✅ 7 agents specified across 3 loops
✅ 13 reliability rules
✅ DIN approval workflow + eSignature finality
✅ UTM tagging schema + 3-layer skip-detection
✅ 3-surface BI rule (Sheets / Metabase / QuickSight)
✅ 12 Day-1 operational Sheets specified
✅ 7 dbt-lite marts specified (`mart_buyer_journey` is the spine)
✅ Skills repository structure (Google Shared Drive)
✅ Industry-validated against CS2 / Domestique / Factors / Clay frameworks
✅ Razorpay-derived lifecycle benchmarks (29/25/19/16%) as the floor
✅ Python LangGraph reference scaffold (2 of 7 flows scaffolded)

---

## v1.0 — Production v1 (target: weeks 1–4 of build)

**Goal:** ship the smallest 4-week subset that proves the loop on real mothi data.

| Week | Deliverable |
|---|---|
| **1** | n8n + Postgres + Langfuse + audit log live · ICP-Scout shipped · `mart_buyer_journey` view created · 100 SF leads enriched end-to-end |
| **2** | Outreach-Writer + Reply-Classifier · Smartlead campaigns with frequency caps + 20-domain rotation · HITL approval queue for first 100 sends |
| **3** | Stage-Mover + Cross-Sell-Detector · MoEngage integration · cross-sell pilot on 1 vertical (D2C Payments → Payouts likely) |
| **4** | Dormant-Detector + Churn-Saver · weekly digest agent · first Slack #gtm-weekly post |

**v1 success criteria** (per spec §14):
- AE calendar fill rate 80%+
- Net-new pipeline / week 2× baseline
- 30+ agent-sourced demos / week
- Reply rate ≥3% on cold outbound
- MoEngage onboarding +25% (vs Razorpay 29% target)
- Churn save rate 30%+
- 5+ cross-sell deals closed
- Agent operating cost <$500/mo
- AE adoption 75%+
- 100% campaigns DIN-approved + UTM-tagged

If <7 of 10 hit, v1.5 retro before scaling.

---

## v1.5 — Hardening + missing pieces (months 4–6)

**Adds (only if v1 KPIs justify):**

| Add | Source | Why |
|---|---|---|
| **Pipeline Risk & Forecasting agent** | Domestique #13 | Exec-facing; missing piece for QuickSight dashboard |
| **Objection-Handling Copilot** | Domestique #9 | AE adoption driver; living skill in Shared Drive + Slack slash command |
| **Sales Content Recommendation** | Domestique #11 | Converts Drive collateral into agent-callable matcher |
| **Lead-to-Account Matching agent** | CS2 framework | If SF native L2A proves inadequate |
| **SLA timers per stage transition** | CS2 framework | Postgres triggers + Slack alerts |
| **Recycled/Disqualified loop** | CS2 framework | Dead leads → return-to-nurture rules |
| **dbt-core migration** | when mart count > 30 | Replace manual mart maintenance |

---

## v2.0 — Scale + new motions (months 7–12)

**Adds (only if pipeline justifies $-spend):**

| Tool | Spend | Trigger to add |
|---|---|---|
| **Gong or Fathom paid tier** | $30K/yr | If Drive AI transcription quality insufficient for objection extraction |
| **Bombora intent network** | $15K/yr | If outbound reply rate plateau + need 3rd-party intent |
| **Common Room** | $30K+/yr | If community signals (GitHub/Slack/Discord) become critical |
| **PostHog (paid)** | $0-15K/yr | If product-usage signal pipe needed for PLG |
| **Hightouch / Multiwoven** | $10-50K/yr | If reverse ETL volume justifies (today n8n covers this) |
| **Multi-Channel Campaign Optimization** | LLM cost | A/B/n testing agent across channels |
| **Proactive Support Ticket Triage** | dev time | Only if Freshdesk/Zendesk integration exists |

**Architectural additions:**
- Migrate Postgres mirror to BigQuery (if data volume requires)
- Add reverse ETL layer (Multiwoven) above ontology
- Add Vertex AI for custom embeddings (if OpenAI embedding cost becomes material)
- Multi-region HA on Postgres + ClickHouse

---

## v3.0 — Org maturity (year 2)

**The 41-agent virtual GTM org chart from `llm-wiki/wiki/concepts/virtual-gtm-org-chart.md`:**

- 1 C-suite agent (CMO synthesizer)
- 10 Heads (PMM · Growth · Demand Gen · Brand · Customer Marketing · DevRel · Marketing Ops · Analytics · Sales Ops · CS)
- 30 Manager/IC agents (per-product PMMs · Growth specialists · Content/Events · Customer marketing · etc.)

**Trigger to expand:** when v2 metrics prove the agent-layer-above-CRM thesis works at scale, expand to specialized per-role agents.

---

## Out-of-scope (will not build)

- ❌ Custom CDP (BigQuery + dbt + reverse ETL is enough)
- ❌ ML churn prediction model in v1 (rules + Claude composite scoring is enough)
- ❌ Custom UI (Sheets is the lightweight UI layer)
- ❌ Salesforce replacement (we work *on top of* SF)
- ❌ Public open-source release (private until indie-product strategy decides otherwise)
- ❌ AI-Powered Change Management & Training (Domestique #20 — internal HR/L&D, not GTM)

---

## Decision log — major scope cuts

| Date | Cut | Rationale |
|---|---|---|
| 2026-04-26 | 41 agents → 7 for v1 | "Simple, stable, reliable" constraint; scope discipline |
| 2026-04-26 | BigQuery / Snowflake → Postgres + ClickHouse for v1 | No new spend; sufficient for mothi v1 scale |
| 2026-04-26 | LangGraph orchestration → n8n + Claude Max | Existing tools; n8n is sufficient for v1 complexity |
| 2026-04-26 | Gong / Fathom → Drive AI transcription | Saves $30K/yr; quality sufficient for v1 |
| 2026-04-26 | Typeform → Google Forms | Already paid; one less SaaS |
| 2026-04-26 | Hightouch / Census → n8n reverse ETL | n8n handles v1 scale; defer real reverse-ETL to v2 |
| 2026-04-26 | dbt Cloud → manual SQL views (dbt-lite) | Migrate to dbt-core when mart count > 30 |
| 2026-04-26 | Custom UI → Google Sheets | The "lightweight UI" pattern works for AE/SDR/CSM |
| 2026-04-26 | DIN approval moved from v1.5 → v1 mandatory | Compliance + brand-safety + auditability non-negotiable for fintech |
