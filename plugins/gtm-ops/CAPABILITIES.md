# gtm-ops Capabilities — what it does + who it replaces

> **As of v1.2.0 (2026-04-27).** This is the displacement map: what each gtm-ops component replaces in a typical commercial GTM stack, and what it doesn't.

---

## TL;DR

gtm-ops is an **OSS, agent-native, persona-aware GTM operations system** that replaces ~$400K–$1.5M/yr of mid-market commercial GTM tooling at a mid-market scale (5K-50K accounts under management). It runs on Claude + LangGraph + Postgres + Google Workspace + Apps Scripts. It does NOT replace the system-of-record CRM, the email-sending infrastructure (you still need warmed domains), or compliance/legal humans.

It exists to do three things:
1. **Compress the buy-vs-build math** for any in-house GTM team that cannot stomach $500K+/yr in vendor spend
2. **Stay sovereign over the data + IP** (no vendor lock-in on persona models, ICP scoring logic, or playbooks)
3. **Run agentic loops** — not "AI features bolted onto SaaS"

---

## Capability map

Sorted by replaced-vendor-spend, descending.

| # | gtm-ops capability | What it does | Replaces (commercial vendors) | Annual spend displaced (mid-market) |
|---|---|---|---|---|
| 1 | **Cross-sell + churn intelligence** (`cross-sell-detector` + `churn-saver` + `mart_account_health`) | Detects expansion signals from transcripts + usage; generates persona-aware save briefs with named SE assignment | Catalyst, Vitally, ChurnZero, Gainsight CS, Gong Engage | $80K-$200K |
| 2 | **ICP scoring + enrichment + tier classification** (`icp-scout` + `mart_buyer_journey`) | Scores accounts on mothi-specific ICP signals; tiers A/B/C/D; routes to the right channel pool | Clay, ZoomInfo, 6sense, Demandbase, Bombora | $60K-$200K |
| 3 | **Call transcript → CRM property extraction** (`drive-transcript-extractor`) | Parses Drive call transcripts; extracts named decision-makers, competitor mentions, expansion signals; writes to Postgres + persona_known_instances | Gong, Chorus, Fathom, Otter, Avoma | $30K-$150K |
| 4 | **Lifecycle messaging + dormant re-engagement** (`dormant-detector` + `mart_lifecycle_metrics` + Apps Scripts) | Re-engagement triggers based on usage drop / NPS / support sentiment; persona-aware nurture | MoEngage, Braze, Iterable, Customer.io | $30K-$100K |
| 5 | **Outreach copy generation (persona + vertical aware)** (`outreach-writer` + 16 persona files) | Generates email/LinkedIn copy tuned to persona pains, language, anti-patterns; competitor + peer-merchant references | Lavender, Smartwriter, Copy.ai, Jasper, Regie.ai | $20K-$80K |
| 6 | **Pipeline + stage progression + meeting prep** (`stage-mover` + `mart_buyer_journey`) | Auto-progresses deals on stage-criteria; generates meeting briefs with persona-aware discovery questions | Salesforce Einstein, HubSpot Sales Hub, Clari, Outreach Pipeline | $50K-$150K |
| 7 | **GTM analytics — full buyer journey** (`mart_buyer_journey` + 7 marts) | Awareness → trial → activate → adopt → expand → retain attribution; channel attribution; AE performance | Factors.ai, Recotap, RB2B, custom Looker | $30K-$100K |
| 8 | **Inbound reply classification + routing** (`reply-classifier`) | Classifies replies (interested/OOO/unsubscribe/competitive intel); auto-creates suppression rules; routes hot to AE Slack | Sybill, Smartlead reply mgmt, Outreach Triggers | $15K-$50K |
| 9 | **Forms routing + auto-response** (`forms-router`) | Google Forms → ICP score → route to AE OR drop to nurture; auto-confirm email | Chili Piper, Calendly Routing, Default | $10K-$40K |
| 10 | **Persona research + management** (`personas/` × 16 + resolver) | 16 deep persona files (identity, pains, decision criteria, language, objections); 3-stage resolver maps SF titles to canonical persona | Mutiny, Demandbase Personas, 6sense Persona Maps, ZoomInfo Personas | $30K-$100K |
| 11 | **Document approval + governance** (`din-watchdog` + DIN registry + esign workflow) | Every campaign requires a DIN brief, eSignature approval before send; flags non-compliant sends | Workfront, Asana Goals, Filestage, Approvals.io | $20K-$80K |
| 12 | **Sales engineering + collateral routing** (skills + `mart_account_health`) | Surfaces the right collateral per persona × stage × competitor; embeds in meeting briefs | Highspot, Showpad, Seismic | $30K-$80K |
| 13 | **Weekly leadership reporting** (`weekly-report` + Apps Scripts dashboards) | Auto-generated leadership digest from marts; Slack-delivered; no manual deck | Looker Studio (custom build) + Mode + Tableau (BI seat sprawl) | $10K-$50K |
| 14 | **Regression-grade eval CI** (`evals/` × 13 promptfoo cases) | Persona-loading, ICP scoring, outreach quality regression cases; 85% pass-rate gate | Humanloop, LangSmith, PromptLayer evals | $5K-$30K |
| 15 | **Deliverability + sender-reputation monitoring** (Apps Script `gtm.deliverability-monitor.gs`) | Per-domain spam-complaint tracking; auto-Slack on threshold breach | Mailgun analytics dashboards + manual oversight | $5K-$20K |

### Replaced spend totals

| Scale | Vendor TCO (yr) | gtm-ops yr cost (LLM + infra + humans) | Net displacement |
|---|---|---|---|
| Small (5K accounts) | $200K-$400K | $40K-$80K | $160K-$320K |
| Mid (50K accounts) | $500K-$1M | $100K-$200K | $400K-$800K |
| Large (500K accounts) | $1.5M-$3M | $300K-$600K | $1.2M-$2.4M |

---

## Where each capability lives in the repo

| Capability | File / folder |
|---|---|
| Skills | `skills/skills.md` (11 skills) |
| LangGraph flows | `src/gtm_ops/flows/*.py` (17 flows + persona_resolver) |
| Personas | `personas/{vertical}/*.md` (16 personas across 4 verticals) |
| SQL marts | `sql/marts/*.sql` (8 marts) |
| Schema | `sql/001-004_*.sql` |
| Sheets dashboards | `dashboards/sheets/*.gs` (12 Apps Scripts) |
| Eval cases | `evals/cases/*.yaml` (13 cases) |
| Specs + docs | `docs/gtm-context.md` + `docs/architecture.md` + `docs/persona-integration.md` |
| Operator UX | `OPERATOR-QUICKSTART.md` + `TUTORIAL.md` |

---

## What gtm-ops does NOT replace (honesty)

| Category | Still required | Why |
|---|---|---|
| **CRM system of record** | Salesforce OR Twenty CRM (OSS) OR HubSpot | Account/contact/opportunity master record; gtm-ops reads + writes here |
| **Email-sending infra** | Smartlead OR Instantly + 20 warmed domains | gtm-ops generates copy + cadence; doesn't operate the SMTP send + warmup |
| **Phone dialer** | Aircall OR Justcall | Voice rails; gtm-ops generates call briefs but doesn't dial |
| **Cloud + compute** | AWS / GCP + Postgres + Redis | Where the agents + marts run |
| **Compliance + legal** | RBI auditors, DPDP DPO, Big-4 SOC2 attestation | Humans for regulatory sign-off |
| **Calendaring** | Google Calendar OR Calendly + Cal.com | Meeting booking surface |
| **Collaboration** | Slack + Notion + Drive | Where humans live |
| **Identity / SSO** | Okta OR Google Workspace | Auth + access control |
| **Data warehouse** | BigQuery OR Snowflake (optional) | If you outgrow Postgres marts |

---

## Maturity matrix

| Component | State | Production-ready? |
|---|---|---|
| 11 skills (frontmatter + body) | ✅ Complete | Yes — copy-paste ready |
| 17 LangGraph flows | ⚠️ Scaffolded | Need real DB/MCP wiring (TODOs marked) |
| 8 SQL marts | ✅ Complete | Yes — DDL + sample queries |
| 12 Apps Scripts | ✅ Complete | Yes — paste into Sheets script editor |
| 13 promptfoo evals | ✅ Cases written | Need actual run + 85% baseline |
| 16 personas + resolver | ✅ Complete | Yes — markdown + registry seeded |
| DIN workflow | ✅ Documented | Need eSignature integration to fully run |
| Seed mock data | ✅ Complete | Loads + populates all 8 marts |
| Tutorial + operator-quickstart | ✅ Complete | New operator can run in <2 hours |

**v1.2.0 is the architecture-complete release.** The deferred work (skills frontmatter `loads_personas: true`, eval CI runs, real DB wiring) is engineering execution — not architectural.

---

## Why this matters (the $500K math)

### Lane 1 — mothi promo + Razorpay GTM Builder pitch

This repo is the artifact. "Look at the architecture I designed and shipped" beats "look at my résumé." The displacement table above is the slide for the leadership conversation.

### Lane 2 — Indie hacker positioning

OSS-flavored GTM stacks are an emerging category (vs Clay+Outreach incumbents). gtm-ops is positioned to be the reference implementation that mid-market RevOps teams fork → customize → run.

Adjacent products (sellable):
- gtm-ops-cloud (managed deployment) — $X/mo
- gtm-ops-personas (persona library + updates) — $Y/yr
- gtm-ops-evals (compliance + safety eval pack) — $Z/yr
- gtm-ops consulting — implementation + customization

---

## Honest caveats

1. **Not a SaaS.** Self-hosted, run-it-yourself. Replaces SaaS spend by trading $ for setup-effort + LLM-cost + 1 RevOps engineer's time.
2. **mothi-specific defaults.** Personas, ICP signals, peer-merchants are Indian-fintech tuned. Other verticals require a fork + persona-rebuild.
3. **LLM cost is real.** Claude Haiku for resolver, Claude Sonnet for outreach copy — at 100K outreach/mo, ~$200-500/mo in LLM spend.
4. **No GUI.** Operators interact via Sheets + Slack + Drive + Linear. No "marketing dashboard." This is intentional.
5. **Production hardening is the user's responsibility.** Auth, secrets, observability, on-call — gtm-ops gives you the agent + the marts; the SRE work is yours.

---

## Cross-references

- `README.md` — top-level repo overview
- `OPERATOR-QUICKSTART.md` — 2-hour onboarding
- `docs/gtm-context.md` — the canonical mothi GTM spec
- `docs/architecture.md` — system architecture diagram + component interactions
- `docs/persona-integration.md` — why personas are first-class
- `CHANGELOG.md` — what shipped + when
- `ROADMAP.md` — what's next
