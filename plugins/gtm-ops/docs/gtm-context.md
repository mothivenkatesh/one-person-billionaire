# gtm-context — mothi GTM Lead-Gen + Lifecycle Engine

**Purpose:** Operational spec for an always-on lead-gen machine that fills the sales team's calendars and continuously nurtures merchants across acquisition → nurture → expansion → churn-save. Designed to be **simple, stable, reliable** using mothi's existing stack + Claude Max + Claude Code. No new SaaS spend in v1.

**Owner:** Mothi (PMM) · co-owners: RevOps, Demand Gen, VP Sales
**Date:** 2026-04-25 · v0.1 working spec

---

## 1. North-star + non-negotiables

| Field | Spec |
|---|---|
| **North-star metric** | Sales team **calendar fill rate ≥ 80%** of bookable hours per AE per week |
| **Secondary metrics** | Net-new pipeline / week · MQL→SQL conv · stage-velocity · churn save rate · % calendar from agent-sourced demos |
| **Lifecycle benchmarks (Razorpay-derived public floor)** | Onboarding +29% · Retention +25% · Re-engagement +19% · Adoption +16% — mothi must match within 6 months, beat within 12 |
| **Brand safety** | No auto-send on Tier A/B accounts. PMM-reviewed first 100 sends per template. mothi-warmed inboxes only for enterprise. |
| **Compliance gates** | DPDP · TRAI DLT · PCI · RBI signals-not-scores |
| **What v1 is NOT** | Multi-touch attribution model · custom CDP build · ML churn model · 41-agent org · enterprise-tier SaaS adds |

---

## 2. Architecture — 1 ontology · 1 brain · 3 loops

```
┌─── ONTOLOGY (Salesforce SOR + n8n-managed Postgres mirror) ───┐
│  Account · Contact · Opportunity · Signal · Interaction       │
│  Extracted_property (Claude-derived: objections, intents,…)   │
└──────────────────────────▲──────────────────────────────────────┘
                           │
┌─── BRAIN (Claude Max API via n8n + Claude Code skills) ────────┐
│  No separate orchestration framework. n8n IS the orchestrator. │
│  Claude does: enrich, classify, score, draft, summarize.       │
└──────────────────────────▲──────────────────────────────────────┘
                           │
┌─── 3 LOOPS (each an n8n schedule + webhook bundle) ────────────┐
│  Acquisition  → keeps calendars full                            │
│  Nurture      → moves opportunities + drives lifecycle          │
│  Re-engagement → dormant + churn save                           │
└────────────────────────────────────────────────────────────────┘
```

**Why this shape:** stable because every component is something mothi already pays for. Simple because n8n is the only orchestrator and Claude is the only LLM. Reliable because the ontology lives in SF (rep-visible) + Postgres (agent-visible) with bidirectional sync, no third storage layer.

---

## 3. The 7 agents (covers all 3 loops, MVP scope)

> Strip from 41-agent blueprint to **7 essentials**. More agents added only after v1 KPIs prove out.

### Acquisition loop (3 agents)

| # | Agent | Trigger | What it does | Output |
|---|---|---|---|---|
| **1** | **ICP-Scout** | Daily 6am cron + Google Forms webhook (real-time) | Pulls Sales Nav new prospects + Ahrefs traffic-spike accounts + SimilarWeb signals + Bombora intent (when added) → Clay enrich → Claude scores 0-5 vs ICP → tier (A/B/C). **Google Forms inbound = real-time path:** demo requests / content downloads / webinar reg / partner signups → Claude parses + scores + routes immediately (skip-tier-A for explicit demo requests) | New SF Lead with `icp_score`, `intent_score`, `tier`, `evidence_summary`, `inbound_form_id` (if applicable) |
| **2** | **Outreach-Writer** | New Lead with score ≥ 3 | Claude reads website + LinkedIn profile + recent news + Ahrefs traffic context → drafts 3-touch personalized Smartlead sequence with hook/body/CTA per touch | Smartlead campaign added to lead with sender domain assigned per pool rules |
| **3** | **Reply-Classifier** | Smartlead reply webhook | Claude classifies intent: `positive` / `objection` / `not_now` / `unsubscribe` / `referral` / `oof` → maps to SF activity + alert | SF Activity logged, Slack DM to AE if `positive` (with full context), auto-nurture for `not_now`, suppression for `unsubscribe` |

### Nurture loop (2 agents)

| # | Agent | Trigger | What it does | Output |
|---|---|---|---|---|
| **4** | **Stage-Mover** | Daily 7am cron + Calendar API webhook (meeting-in-2h trigger) | **Trigger A (stagnation):** Scans SF Opportunities for any stuck >14d in current stage. Reads SF activity + **Drive transcripts of past calls with this account** (auto-pulled via Drive API filter on attendee email = account contact) → drafts contextual move-forward action.<br/>**Trigger B (meeting-prep):** When Calendar shows AE meeting in 2h with an account, auto-fire: pull SF context + Drive transcripts of past meetings + recent signals (Ahrefs/SimilarWeb/Sales Nav) + relevant collateral from Drive → 1-pager brief delivered to AE Slack DM | AE Slack alert with (a) stagnation-recovery action OR (b) full meeting prep brief — both formats include cited evidence from Drive transcripts |
| **5** | **Cross-Sell-Detector** | Weekly Mon 6am | Scans merchant product DB. Identifies "heavy in Payments / absent in Payouts" (or any product-pair gap). Claude drafts personalized cross-sell pitch with merchant's actual usage data | MoEngage in-app banner + email triggered; CSM Slack alert for high-value (>₹10L/mo GMV) accounts |

### Re-engagement loop (2 agents)

| # | Agent | Trigger | What it does | Output |
|---|---|---|---|---|
| **6** | **Dormant-Detector** | Weekly Tue 6am | Scans accounts/merchants for no meaningful activity in 30/60/90d windows. Claude generates personalized re-engagement reasons + drafts win-back sequence | MoEngage journey enrollment by tier; Slack to AE for ₹50L+ accounts |
| **7** | **Churn-Saver** | Daily 6am + Google Forms webhook (NPS responses + churn-exit) | For active merchants: composite signal — usage drop >50% over 14d + support ticket sentiment + **competitor mention in Drive transcripts of recent calls** + low NPS response (Form trigger) + churn-exit survey responses. Claude generates save-brief with talking points + cites specific transcript evidence | CSM Slack alert with full context + draft outreach; MoEngage WhatsApp + email auto-fire only for SMB tier; new churn-exit responses auto-feed to product team via Drive doc |

---

## 4. Tooling stack — existing only, no new spend in v1

| Layer | Tool | Role | Notes |
|---|---|---|---|
| **CRM SOR** | Salesforce | Source of truth for accounts, contacts, opportunities, activities | Out-of-box Campaign Influence used for attribution |
| **B2B data + enrichment** | Clay + ZoomInfo + LinkedIn Sales Navigator | Account + contact data + LinkedIn intel + champion tracking | Clay orchestrates the waterfall |
| **Web + SEO signals** | Ahrefs + SimilarWeb | Traffic velocity, backlink gaps, keyword competition, organic-search trend | Ahrefs as primary; SimilarWeb as backup |
| **Cold outbound** | Smartlead + 20 domains | Tier C automated outbound at scale | Inbox rotation across pools; CFree-warmed inboxes for Tier A/B |
| **Lifecycle marketing** | MoEngage | Email + push + WhatsApp + in-app journeys for merchants | Razorpay benchmark to match: 25% retention, 29% onboarding |
| **Workflow orchestration** | n8n | All cron + webhook + Claude calls + writebacks | Self-hosted on existing infra |
| **LLM** | Claude Max API + Claude Code | All extraction, scoring, drafting, summarization | Haiku for batch (95%); Opus for synthesis (5%) |
| **Productivity** | Gsuite | Calendar API for booking visibility, Gmail for AE drafts, Drive for collateral context, Sheets for dashboards | Calendar API drives the north-star metric |
| **Call intelligence (free)** | **Google Meet + Drive AI transcription (Gemini)** | Auto-records + transcribes every AE/CSM/exec call; transcripts stored in Drive folder; Claude reads via Drive API | **Replaces Gong/Fathom in v1 — saves $30K/yr.** Coaching analytics deferred to v2 if Drive quality insufficient |
| **Inbound capture** | **Google Forms** | Demo requests · NPS · churn-exit · webinar reg · content downloads · partner signups · merchant feedback | All routed via Sheets → n8n webhook → Claude parser → SF Lead/Activity. Replaces Typeform/Hubspot Forms |
| **Reporting (operational)** | Google Sheets | Per-rep operational sheets · DIN registry · agent overrides · Form intake · weekly digest summary | AE/SDR/CSM-facing |
| **Reporting (analytical)** | Metabase | Marketing/PMM/Demand Gen dashboards · channel performance · DIN-leaderboard · segment-level cohort views · ad-hoc SQL exploration | Marketing + RevOps-facing; reads Postgres + SF Connect + Snowflake (if added later) |
| **Reporting (executive)** | AWS QuickSight | Board-grade roll-ups · revenue attribution · forecast vs actual · multi-quarter trends · anomaly alerts via QuickSight ML insights | Leadership/Founders-facing; reads from data warehouse (Snowflake / RDS / Athena) |

**Tools deferred to v2 (only if v1 KPIs justify):** Gong/Fathom (deferred indefinitely if Drive transcription quality holds), Bombora (intent network), Common Room (community signals), PostHog (product analytics), Hightouch/Multiwoven (reverse ETL).

**Google-stack force multiplier — the "use what you pay for" stack:**
| Workspace asset | GTM use case |
|---|---|
| **Calendar API** | Trigger meeting-prep agent 2h before; track AE calendar fill-rate (north-star metric) |
| **Drive (transcription)** | Auto-transcribed call layer for Stage-Mover + Churn-Saver signal extraction |
| **Drive (collateral)** | Reference library for Outreach-Writer (case studies, decks, pricing) — Claude reads via Drive API |
| **Gmail API** | Draft creation for AE follow-ups (HITL approval before send) |
| **Forms** | All inbound capture (demo · NPS · churn-exit · webinar · content download) |
| **Sheets** | The lightweight UI for everything that doesn't deserve a real app: Form responses landing zone · weekly dashboard primary surface · AE/CSM operational sheets (my-pipeline, my-calendar, my-outreach-queue) · ABM target-list management · suppression lists · agent override inputs · inter-team sharing without SF access · ad-hoc pivots — see §4.3 |
| **Docs API** | Auto-generated meeting briefs + deal reviews + post-launch retros (DIN templates) |
| **Apps Script** | Lightweight glue for Forms → Sheets → n8n webhook flow |
| **Admin SDK** | Org chart for territory mapping + champion-tracking |

This gives you a 7-tool data + collaboration stack at $0 incremental spend (already paying Gsuite premium).

### 4.3 Skills repository — Google Shared Drive for team-wide access

> **Stop hoarding skills in Mothi's local `.claude/skills/`. Move them to a mothi-internal Shared Drive so the entire GTM team uses, edits, and contributes.**

#### 4.3.1 Structure

```
Shared Drive: "mothi GTM AI"  (Drive ID: TBD)
├── Skills/
│   ├── 00-INDEX.md              ← master catalog (auto-generated weekly)
│   ├── README.md                ← how to use, contribute, version
│   │
│   ├── product/                 ← per-product skills (payments, payouts, secure-id, etc.)
│   ├── persona/                 ← per-persona skills (cfo, cto, founder, etc.)
│   ├── lifecycle-state/         ← state-* skills (new-trial, dormant, power-user, etc.)
│   ├── function/                ← function skills (meeting-prep, win-loss, churn-save, etc.)
│   ├── compliance/              ← dpdp-compliance, trai-dlt, pci-dss, etc.
│   ├── voice/                   ← content-strategist, psy-trigs, follow-up-email, etc.
│   ├── framework/               ← meddpicc, spiced, scqa-pyramid, etc.
│   └── agents/                  ← icp-scout, outreach-writer, stage-mover, etc.
│
├── Templates/
│   ├── brief-template.gdoc      ← DIN brief template
│   ├── retro-template.gdoc      ← post-launch retro template
│   ├── playbook-template.gdoc   ← vertical/persona playbook template
│   └── skill-template.md        ← canonical skill format (frontmatter + body)
│
├── Briefs/                      ← all DIN briefs (per §11)
│   ├── Drafts/{DIN_ID}/
│   ├── In-Review/{DIN_ID}/
│   ├── Approved/{DIN_ID}/
│   └── Archived/{DIN_ID}/
│
├── Collateral/                  ← decks, case studies, one-pagers (input to Outreach-Writer)
│   ├── BFSI/
│   ├── D2C/
│   ├── SaaS/
│   └── Marketplace/
│
└── Transcripts/                 ← Drive AI auto-recorded meeting transcripts
    ├── {YYYY-MM-DD}-{account_name}-{meeting_type}/
    └── ... (auto-organized by Drive Workspace AI)
```

#### 4.3.2 Permissions model

| Folder | Reader | Editor | Admin |
|---|---|---|---|
| `Skills/` | Entire GTM team (read) | PMM leads + RevOps (edit) | Mothi (admin) |
| `Templates/` | Entire GTM team | PMM leads | Mothi |
| `Briefs/Drafts/` | Brief owner + co-owners | Brief owner | PMM leads |
| `Briefs/Approved/` | Entire GTM team (read-only) | None (locked) | Mothi (rare unlocks) |
| `Collateral/` | Entire GTM team | Vertical PMM owner | PMM lead |
| `Transcripts/` | Account-AE, CSM, PMM | Auto (Drive AI writes) | Admin |

#### 4.3.3 How agents load skills at runtime

**Pattern 1 — n8n agents (Postgres-cached for speed):**
```
1. On agent run: query Postgres `skill_cache` table
2. If skill not in cache OR last_synced > 1h: fetch from Drive API by file_id
3. Inject skill .md content into Claude system prompt
4. Cache for 1h (TTL configurable per skill)
```

**Pattern 2 — Claude Code (local mount via Drive Desktop):**
```
1. Each team member installs Drive Desktop + syncs "mothi GTM AI/Skills/" folder locally
2. Symlink the synced folder into ~/.claude/skills/ (or use a project-level skill loader)
3. Edit skill in Drive (web or Docs) → syncs to local within seconds → Claude Code picks it up
```

**Pattern 3 — direct Docs API for marketing-team-edited skills:**
- Some skills (voice guides, brand rules) live as Google Docs (not .md) for non-engineer editing
- n8n fetches via Docs API → converts to plaintext → injects into Claude prompt
- Marketing team edits in Docs UI (familiar) — no markdown training needed

#### 4.3.4 Contribution workflow

| Role | Can do |
|---|---|
| **GTM team member** | Read all skills · suggest edits via Doc comment · file new skill request via `gtm.skill-requests` Sheet |
| **PMM lead** | Edit skills in their domain · approve new-skill PRs · promote draft to stable |
| **Mothi (or RevOps lead)** | Admin folder structure · enforce frontmatter schema · run weekly skill-eval batch via Promptfoo |

#### 4.3.5 Skill governance — the Promptfoo gate

Every skill change runs through eval before merge:

1. PMM/team member proposes edit (in Drive or via local sync + commit)
2. n8n cron runs Promptfoo against the changed skill (test cases stored in `Skills/.evals/{skill_name}/`)
3. If pass rate ≥ 90% on baseline cases: auto-merge + notify in #gtm-skills-changes
4. If fail: revert + Slack DM to author with diff + failed cases

This makes the skill library safe to give the team — bad edits get caught.

#### 4.3.6 Skill index — auto-maintained

`00-INDEX.md` regenerated weekly by `skills-indexer` agent:
- Crawls all `Skills/*/` directories
- Extracts frontmatter (title, tags, version, owner, last_updated, status)
- Generates a single browsable catalog with cross-links
- Posts changelog of new/updated/deprecated skills to #gtm-skills-changes

**Net effect:** the entire team can answer "what skills do we have for X?" by opening one Doc. Skill-discovery friction → near zero.

---

### 4.4 Operational sheets — the lightweight UI layer

> **Pattern:** every workflow that needs human eyes (review, override, quick-glance) gets a Sheet. n8n reads/writes via Sheets API. Apps Script handles the cron + webhook glue. No custom UI built in v1.

**Sheets to create on Day 1:**

| Sheet | Purpose | Read/write | Owner | Refresh |
|---|---|---|---|---|
| **`gtm.weekly-dashboard`** | The canonical weekly report (auto-generated by `weekly-report` agent) | Agent writes; humans read | PMM | Mon 9am |
| **`gtm.din-registry`** | Live view of all DINs with status, owner, approver chain, days-in-stage | n8n writes from Postgres `campaigns` table; PMM/RevOps read | PMM | Real-time |
| **`gtm.ae-pipeline-{ae_email}`** | Per-AE personal dashboard: my opportunities, my next actions, my agent-suggested moves, my calendar fill | Agent writes; AE reads | Each AE | Hourly |
| **`gtm.outreach-queue`** | Daily outbound lineup per BDR — accounts, templates, sequences, expected-send-time | ICP-Scout + Outreach-Writer write; BDR reviews | BDR + RevOps | Daily 6am |
| **`gtm.suppression-list`** | Master list of accounts/emails to never send to (compliance, legal hold, do-not-contact, recent unsubscribes) | Append-only via webhook from Smartlead/MoEngage; n8n reads before every send | RevOps + Compliance | Real-time |
| **`gtm.abm-tier-A`** + **`gtm.abm-tier-B`** | Lighthouse + strategic account lists with owners, signals, last-touch, next-step | PMM + AE write; agents read for tier-aware targeting | PMM + Sales | Weekly |
| **`gtm.cross-sell-candidates`** | Output of Cross-Sell-Detector — merchants flagged this week + recommended pitch | Agent writes; CSM reviews | CSM + PMM | Weekly Mon |
| **`gtm.churn-watchlist`** | Output of Churn-Saver — at-risk merchants + save-brief link | Agent writes; CSM owns | CSM | Daily 6am |
| **`gtm.form-responses.{form_name}`** | Auto-landing zone for every Google Form. n8n watches via Sheets API webhook | Form auto-writes; agent + RevOps read | RevOps | Real-time |
| **`gtm.agent-overrides`** | The "manual veto" sheet — humans add account_id + reason to skip an agent's recommendation | PMM/RevOps write; agents read before action | PMM + RevOps | Real-time |
| **`gtm.deliverability-monitor`** | Per-domain reply rate, bounce, spam-complaint, sender reputation | n8n writes hourly; Marketing Ops reads | Marketing Ops | Hourly |
| **`gtm.din-anomalies`** | Output of `din-watchdog` — unauthorized launches detected | Watchdog writes; PMM acts | PMM | Real-time |

**Why this pattern works:**
- **Zero UI build cost** — Sheets is the UI
- **AE-friendly** — sales reps already live in Sheets
- **Auditable** — Sheets revision history is built-in
- **Shareable** — granular permissions per row/range
- **Override-capable** — humans can edit, agents respect (e.g., `gtm.agent-overrides`)
- **Apps Script extensibility** — for any sheet that needs a custom on-edit trigger, button, or schedule, Apps Script handles it without leaving Workspace

**Apps Script glue patterns to know:**
- Form submission → Apps Script `onFormSubmit` trigger → fires webhook to n8n with parsed payload
- Sheet edit → Apps Script `onEdit` trigger → writes to Postgres via webhook (e.g., when AE updates `gtm.ae-pipeline` next-step field)
- Time-driven trigger → Apps Script reads Postgres → updates Sheet (alternative to n8n cron for simple reads)
- Sheets-to-Slack notifications via Apps Script + Slack webhook (e.g., when a row is added to `gtm.din-anomalies`)

**Hard rule:** no operational data lives ONLY in a Sheet. Sheets are the **read surface** + **lightweight write capture**; Postgres + Salesforce remain the source of truth. Sheets data flushes to / from those at minimum hourly.

---

## 5. Where Claude Code earns its slot

> Claude Code (skills + agents in `.claude/`) is the build environment for everything. Specific reuse:

| Existing Mothi skill | Reused as |
|---|---|
| `cold-campaigns` | Outreach-Writer's first-touch generator |
| `follow-up-nurture` | Outreach-Writer's touch-2 and touch-3 generator |
| `lead-scraper` | ICP-Scout's Sales Nav + LinkedIn ingestion |
| `mothi-outreach-agent` | Outreach-Writer's brand-aligned variant for mothi-domain sends |
| `psy-trigs` | Outreach-Writer + Stage-Mover persuasion layer |
| `content-strategist` | Voice consistency across all generated copy |
| `secure-id-comms` | Outreach + nurture for BFSI vertical |
| `secure-id-deal` | Stage-Mover for BFSI tier B/A opportunities |
| `tweet-harvest` / `reddit-scraper` / `review-scrape` | ICP-Scout signal-source feeds for vertical-specific intent |
| `discord-engage` / `discord-grow` (community pattern) | Reusable for WTFraud-led inbound to BFSI lighthouse |
| `ideavalidator` | New product-fit scoring for cross-sell-detector |

**Build new (Claude Code skills) for the agents themselves:**
- `icp-scout` (the agent prompt + scoring rubric)
- `outreach-writer` (per-tier templates + persona-aware body generation)
- `reply-classifier` (intent taxonomy + SF mapping)
- `stage-mover` (stage-by-stage playbook + meeting-prep variant)
- `cross-sell-detector` (product-pair logic + pitch templates)
- `dormant-detector` (re-engagement reasons + tier rules)
- `churn-saver` (signal composite + CSM playbook)
- `weekly-report` (the reporting agent — see §7)
- `drive-transcript-extractor` (utility: reads new Drive transcripts → extracts typed properties: objections, competitors, next-steps, sentiment, decision-makers-named → writes to Postgres + SF account)
- `forms-router` (utility: parses Google Forms webhooks → classifies intent → routes to ICP-Scout for demos, MoEngage for nurture, Churn-Saver for low-NPS, product team for churn-exit)
- `din-watchdog` (utility: 15-min anomaly scan across send channels — see §11.6.2)

---

## 6. Reliability — the 7 essentials (stripped from 12)

| # | Rule |
|---|---|
| **1** | **Idempotency.** Every n8n workflow handles re-runs without dupes. Use SF external ID + Smartlead lead ID as natural keys. |
| **2** | **Pydantic schema** at every Claude call boundary. Output validation before any writeback. |
| **3** | **HITL approval** on (a) first 100 sends per new template, (b) all Tier A/B outbound, (c) any message to a CXO regardless of tier. |
| **4** | **Frequency caps** baked into Smartlead config + MoEngage settings. Max 4 touches per merchant per quarter across all channels combined. |
| **5** | **Audit log** to Postgres `agent_decisions` table: input · output · skills_loaded · cost · latency · timestamp. ClickHouse upgrade path noted but not required for v1. |
| **6** | **Kill switch** per agent — n8n env var. One toggle, 30 seconds to disable any agent. |
| **7** | **Weekly health check** auto-generated: deliverability per domain, reply rate per template, MoEngage delivery rate per channel, agent cost per run, agent latency, % HITL approval. Posted to Slack #gtm-ops every Monday 9am. |
| **8** | **DIN gate.** No campaign launches without an approved DIN brief in Postgres `campaigns` table (status = `live`). n8n agents check before every send and HALT if absent. See §11. |
| **9** | **UTM tagging mandatory.** Every link, every send, every touch carries `utm_campaign = DIN_ID` + the full scheme per §11.3. Untagged sends are blocked at the n8n layer. |
| **10** | **Mandatory artifact uploads per DIN.** 9 required assets uploaded + validated before status can flip to `approved`. See §11.6.1. |
| **11** | **Three-layer skip-detection.** Pre-launch n8n gate + real-time anomaly watchdog (15-min scan across Smartlead/MoEngage/LinkedIn/Gmail/SF) + daily 9am reconciliation report. Any unauthorized launch is flagged within 15 min. See §11.6.2. |
| **12** | **Bypass governance.** Only VP Marketing / CRO / Compliance / Founder can authorize emergency sends, and only with 48h retro-DIN + post-mortem requirement. No silent bypasses. See §11.6.3. |
| **13** | **eSignature finality.** Approval is not "approved" until every approver has eSigned the Gdoc brief via Workspace native eSignature (or DocuSign fallback). Slack ✅ reactions are discussion only — they don't unlock launch. n8n polls Drive API for signature completion before flipping status. See §11.2. |

---

## 7. Channel attribution — the simple version

> No multi-touch model in v1. Use Salesforce Campaign Influence + a touch log.

### 7.1 Touch logging (always-on)

Every touch is logged as a Salesforce Activity with custom fields:
- `channel` (cold_email · linkedin_inmail · ad · webinar · content · referral · ae_email · ae_call · csm_outreach · in_app · whatsapp · sms)
- `touch_type` (impression · open · click · reply · meeting · demo · proposal · close)
- `source_agent` (which of the 7 agents generated it; or `human` for manual rep work)
- `recorded_at`

### 7.2 Attribution model (simple)

For every Closed-Won opportunity:
- **First-touch:** earliest activity logged
- **Last-touch:** activity logged immediately before stage = Closed-Won
- **Influencing touches:** count by channel between first and last
- **Sourced-by:** the channel that generated the original lead (from SF Lead Source field)

That's it. Three columns per closed deal. Roll up weekly.

### 7.3 Channel rollup table (auto-generated)

| Channel | Touches | MQLs | SQLs | Demos booked | Closed-won | Pipeline ₹ | Win rate | Avg cycle |
|---|---|---|---|---|---|---|---|---|
| Cold email (Smartlead) | … | … | … | … | … | … | … | … |
| LinkedIn (Sales Nav + InMail) | … | … | … | … | … | … | … | … |
| MoEngage lifecycle | … | … | … | … | … | … | … | … |
| WhatsApp (via MoEngage) | … | … | … | … | … | … | … | … |
| Inbound (web form / content) | … | … | … | … | … | … | … | … |
| Partner / co-sell | … | … | … | … | … | … | … | … |
| WTFraud / community | … | … | … | … | … | … | … | … |
| Paid ads (LinkedIn / Meta / Google) | … | … | … | … | … | … | … | … |
| AE outbound (manual) | … | … | … | … | … | … | … | … |

---

## 8. Reporting — single weekly digest

### 8.1 Structure (auto-generated by `weekly-report` agent every Monday 9am)

**Section A — North-star + KPI snapshot**
- AE calendar fill rate (target 80%)
- Demos booked vs. target (vs. last week, vs. 4-week avg)
- Pipeline created ₹ (vs. last week, vs. quarter target)
- MQL → SQL conversion %
- SQL → Closed-Won %
- Median cycle days

**Section B — Channel performance table** (the 7.3 rollup)

**Section C — Lifecycle benchmarks vs. Razorpay public floor**
| Motion | This week | 4-week avg | Razorpay public # | Gap to close |
|---|---|---|---|---|
| Onboarding completion | … | … | 29% | … |
| Re-engagement | … | … | 19% | … |
| Retention | … | … | 25% | … |
| Adoption | … | … | 16% | … |

**Section D — Observations (Claude generates 5-7 bullets)**
- E.g., "BFSI vertical's reply rate dropped from 4.2% to 2.1% — investigate template fatigue"
- E.g., "Cross-sell-detector flagged 47 Payments-only merchants this week, up from 22 last week — usage signals strengthening"
- E.g., "Domain `mothiteam.io` spam-complaint rate hit 0.08% — quarantine if it crosses 0.1%"

**Section E — Key actions for the week (Claude proposes 3-5)**
- E.g., "Refresh BFSI cold-email template (rotate hook from 'fraud cost' to 'NTC coverage')"
- E.g., "Pilot cross-sell-detector outputs with CSM team for 10 highest-value flagged accounts"
- E.g., "Add Sprinto + Hiver to ICP-Scout watch list — both showing traffic spikes on Ahrefs"

**Section F — Risks flagged**
- Compliance · deliverability · brand safety · cost overruns

### 8.2 Distribution — three-surface rule (no dashboard sprawl)

> **One surface per audience. Same source of truth (Postgres + SF). Different presentations.**

| Audience | Surface | What they see | Refresh |
|---|---|---|---|
| **AE / SDR / CSM** | **Google Sheets** (per-rep `gtm.ae-pipeline-{email}`, `gtm.outreach-queue`, `gtm.churn-watchlist`) | My pipeline · my queue · my next-actions · my agent recommendations | Hourly |
| **PMM / Demand Gen / RevOps** | **Metabase** (single workspace `mothi GTM`) | Channel performance · DIN-leaderboard · funnel cohorts · MoEngage flow stats · deliverability trends · cross-sell candidate volumes | Real-time (live SQL on Postgres + SF Connect) |
| **VP Sales / VP Marketing / CRO / Founders** | **AWS QuickSight** (single dashboard `mothi GTM Exec`) | Pipeline:revenue ratio · forecast vs actual · vertical mix · QoQ trends · win-rate by segment · QuickSight ML anomaly callouts | Daily 6am refresh from warehouse (RDS/Snowflake/Athena) |
| **All teams (passive)** | **Slack #gtm-weekly** (auto-post Mon 9am) | The weekly digest summary (Section A-G of §8.1) | Weekly Mon 9am |
| **Historical archive** | **Google Drive `/GTM/Reports/Archive/`** | All past weeklies + monthlies + quarterlies | On generation |

**Anti-sprawl rules:**
1. **No metric is defined twice.** Every metric has ONE definition in `gtm.metric-definitions` (a Sheet) → SQL view in Postgres → consumed by all 3 BI surfaces.
2. **No new dashboard without a metric-definition entry.** RevOps-enforced.
3. **No surface adds custom calculations** — if a chart needs a new metric, it goes back to the definitions Sheet first.
4. **Monthly review of dashboard usage.** Any chart not viewed in 30 days → archived. Prevents zombie charts.

### 8.3 The Unified GTM Buyer Journey Record — the spine of all reporting

> **Pattern from CS2's GTM Operations Framework: every closed-won (or closed-lost) opportunity resolves to ONE row capturing every milestone, source, and amount. This is the single canonical record from which all 9 analytics dimensions roll up.**

#### Schema (Postgres view `mart_buyer_journey`)

| Column | Type | Source | Notes |
|---|---|---|---|
| `journey_id` | uuid | generated | One per opportunity (or per qualified lead that died) |
| `account_name` | text | SF Account | |
| `contact_name` | text | SF Contact (primary) | |
| `gtm_motion` | enum | Inferred from first-touch source | demand_gen · outbound · abm · plg · partner · customer_expansion |
| `source` | text | First-touch channel | paid_ad · cold_email · linkedin_inmail · webinar · referral · partner · whatsapp · organic · etc. |
| `campaign` | text | DIN of first-touch campaign | resolves to `campaigns.din_id` |
| `lead_created_date` | timestamptz | SF Lead.created_date | |
| `mql_date` | timestamptz | SF Lead.MQL_at | when ICP-Scout flagged ready-for-sales |
| `sql_date` | timestamptz | SF Lead.SQL_at | when AE accepted |
| `sales_ready_date` | timestamptz | SF (= SQL_date typically) | per CS2 framing |
| `working_date` | timestamptz | SF Opportunity.created_date | when AE began active outreach |
| `meeting_booked_date` | timestamptz | First Calendar event linked to Opp | |
| `pipeline_opportunity_date` | timestamptz | SF Opp.stage = Pipeline | |
| `opportunity_type` | enum | SF Opp.type | new_business · expansion · renewal · cross_sell |
| `opportunity_amount` | numeric | SF Opp.amount | ₹ |
| `closed_won_date` | timestamptz | SF Opp.close_date if Won | |
| `closed_lost_date` | timestamptz | SF Opp.close_date if Lost | |
| `closed_lost_reason` | text | SF Opp.lost_reason + Claude extraction from final transcript | |
| `recycled_to_nurture_at` | timestamptz | when SF Opp moved back to Lead nurture | per Recycled/Disqualified loop |
| `tier` | enum | A · B · C · plg · long_tail | |
| `vertical` | enum | bfsi · d2c · saas · marketplace · other | |
| `owner_email` | text | SF Opp.owner | |
| `influencing_touches` | jsonb | aggregated from `interactions` table | array of {channel, campaign_din, timestamp} for ALL touches between first and last |
| `touch_count` | int | derived | |
| `cycle_days` | int | derived (closed_won_date − lead_created_date) | |
| `first_touch_attribution` | text | derived | for first-touch attribution model |
| `last_touch_attribution` | text | derived | for last-touch attribution model |
| `multi_touch_weights` | jsonb | derived (decay-weighted) | for multi-touch attribution model |

#### Why this row matters

It collapses the entire 1300-line operational sprawl into **one queryable record per buyer.** Every dashboard, every BI surface, every leadership question rolls up from here:

- "What's our cost-per-closed-won by source?" → `GROUP BY source` on this view
- "What's our median cycle days by tier × vertical?" → `GROUP BY tier, vertical` 
- "Which DINs influenced the most pipeline?" → unnest `influencing_touches`, count by `campaign_din`
- "What's our recycled-to-recovered conversion rate?" → filter `recycled_to_nurture_at IS NOT NULL`, then check downstream MQL flag
- "What's the funnel velocity per stage?" → date diffs between consecutive milestone columns

#### Build trigger

This view is **non-negotiable for v1** even if you defer everything else. Without it, every reporting question becomes a custom SQL query and the weekly digest is a manual exercise.

**Add to Week 1 build sequence:** ship `mart_buyer_journey` materialized view + nightly refresh job, even if the agents that populate the columns aren't all live yet.

### 8.4 The dbt-lite SQL layer (between Postgres and BI surfaces)

> Even without dbt-Cloud, run a lightweight modeling layer.

**Pattern:**
- Raw tables: SF mirror in Postgres + n8n agent writes
- **Staging models** (`stg_*`): cleanup, type-cast, dedupe — manually-maintained SQL views
- **Mart models** (`mart_*`): metric-ready aggregations consumed by Metabase + QuickSight + Sheets

Example marts to build Day 1:
- **`mart_buyer_journey`** — ⭐ the unified record per opportunity (see §8.3). Spine of all other marts.
- `mart_din_performance` — DIN-level pipeline + spend + win-rate (joins to `mart_buyer_journey` via campaign_din)
- `mart_channel_attribution` — channel-level touches → opportunities → revenue (rolls up `influencing_touches`)
- `mart_account_health` — composite ICP-fit + intent + engagement + churn-risk per account
- `mart_lifecycle_metrics` — onboarding/retention/re-engagement/adoption rates (vs Razorpay benchmarks)
- `mart_ae_performance` — per-AE pipeline, calendar-fill, conversion rates
- `mart_outbound_health` — deliverability + reply rate + cost-per-demo per domain
- `mart_recycled_recovery` — recycled-to-revived conversion rate by tier/vertical/recycle_reason

When PostgreSQL + manual views get unwieldy (> ~30 marts) → migrate to **dbt-core** (free, self-hosted) for proper version control + testing. Trigger: when v1 stabilizes, likely month 4-6.

---

## 9. Build sequence — 4 weeks to MVP, 12 weeks to full

### Week 1 — Foundation
- n8n on existing infra (or Hetzner $50/mo droplet if needed)
- Postgres mirror of SF (schema: account, contact, opp, signal, interaction, extracted_property, agent_decisions)
- Claude Max API integrated to n8n
- Audit log table live
- Build agents 1 (ICP-Scout) and 3 (Reply-Classifier)
- Test on 100 SF leads end-to-end

### Week 2 — Outbound activated
- Build agent 2 (Outreach-Writer)
- Smartlead campaigns configured per tier with frequency caps + domain pool routing
- HITL approval queue for first 100 sends per template
- Deliverability monitoring (warmup status + bounce + reply rates per domain)
- Reply-classifier wired to AE Slack alerts

### Week 3 — Nurture activated
- Build agents 4 (Stage-Mover) and 5 (Cross-Sell-Detector)
- MoEngage integration via webhook + API
- Stage-stagnation thresholds calibrated with VP Sales
- Cross-sell logic validated against 1 vertical first (suggest D2C — Payments → Payouts is highest attach)

### Week 4 — Re-engagement + reporting live
- Build agents 6 (Dormant-Detector) and 7 (Churn-Saver)
- MoEngage win-back journeys built per merchant tier
- Reporting agent + Gsheets dashboard live
- First weekly digest posted to Slack #gtm-weekly Monday morning

### Weeks 5–12 — Stabilize + expand
- Wks 5-6: Add Bombora intent layer if budget approved
- Wks 7-8: Add Gong or Fathom for transcript-based extraction → Stage-Mover + Churn-Saver get richer signal
- Wks 9-10: Add 2nd vertical to Cross-Sell-Detector
- Wks 11-12: Add Metabase for AE-facing dashboards (replaces Gsheets where needed)

---

## 10. Risks + open decisions

| Risk | Mitigation | Decision needed by |
|---|---|---|
| Reply triage capacity | Reply-Classifier MUST ship in Week 1; without it, SDRs drown | RevOps, Wk 1 |
| Domain reputation collapse | DMARC strict + Mailwarm + GlockApps + per-domain reply-rate alerts | Marketing Ops, Wk 2 |
| MoEngage frequency-cap conflicts | Single source of truth for cap rules in n8n; MoEngage configs derived | RevOps + PMM, Wk 3 |
| Salesforce API rate limits | Batch writes; cache reads in Postgres mirror | RevOps, Wk 1 |
| Claude cost overrun | Cost guardian agent on Langfuse (or simple n8n daily total alert) | Mothi, Wk 1 |
| AE adoption (will they trust agent-generated briefs?) | Pilot with 2 AEs Wks 1-2 before scale; weekly feedback session | VP Sales, Wk 2 |
| Brand safety on mothi-domain sends | PMM review on every Tier A/B send for first 30 days | Mothi, ongoing |

---

## 11. Campaign brief + DIN approval — mandatory pre-launch gate

> **No agent fires a campaign without a DIN-approved brief on file.** This is the hard gate that keeps the system stable + brand-safe + compliant.

### 11.1 The campaign brief template (single Gdoc per campaign)

Every campaign — outbound sequence, MoEngage journey, LinkedIn ad set, paid retargeting, lifecycle flow, cross-sell push — gets a brief before any agent or human touches send.

| Field | Required | Notes |
|---|---|---|
| **DIN ID** | ✅ | Auto-generated `AGS-GTM-YYYYMMDD-NNN` on brief creation |
| **Campaign name** | ✅ | Human-readable, ≤ 60 chars |
| **Owner (PMM lead)** | ✅ | One named person |
| **Co-owners** | optional | Demand Gen, AE pod, CSM |
| **Motion type** | ✅ | acquisition · nurture · cross-sell · re-engagement · churn-save |
| **Tier + segment** | ✅ | A · B · C × vertical × persona |
| **Audience size** | ✅ | Target account count + contact count |
| **Channels** | ✅ | One or more: cold_email · linkedin · whatsapp · email · in_app · push · sms · ad |
| **Frequency cap impact** | ✅ | How many touches per merchant this adds; running total within quarter |
| **Goal + KPI** | ✅ | E.g., "30 demos booked, 5% reply rate, 4-week duration" |
| **Hypothesis** | ✅ | "We believe X audience will respond to Y because Z" — testable |
| **Creative + copy** | ✅ | Links to draft assets (subject lines, body, ad creative, lead form) |
| **UTM scheme** | ✅ | Per §11.3 below |
| **Compliance check** | ✅ | DPDP consent source · TRAI DLT (if SMS) · PCI (if payment data) · brand guidelines pass |
| **Risk + mitigation** | ✅ | Deliverability risk, brand risk, legal risk |
| **Linked SF Campaign** | ✅ | SF Campaign ID created with same DIN ID |
| **Start date / end date** | ✅ | |
| **Approver chain** | ✅ | PMM lead → Brand (if creative) → Compliance (if regulated channel) → VP Marketing (final) |
| **Approval status** | ✅ | draft · in_review · approved · live · paused · archived |
| **Approved on** | autofill | timestamp + approver names |
| **Post-launch retro** | required at end | Linked back to brief; what worked, what didn't, what to keep |

### 11.2 DIN approval workflow — Slack-first, eSignature-final

> **Two-stage approval: Slack reactions for fast review, Google Doc eSignature for legally-binding finality. The eSignature IS the approval; Slack is the discussion layer.**

```
PMM owner drafts brief in Gdoc (template) → assigns DIN ID + adds eSignature
fields for each approver in the chain at the bottom of the doc
         │
         ▼
Slack #gtm-din-review channel: brief link posted with @mentions
         │
         ▼ [Stage 1 — Discussion]
Each approver reviews + reacts in Slack:
  ✅ approve-in-principle · 🛑 block (with reason) · 💬 inline comments
         │
         ▼
PMM resolves all blocks/comments → updates Doc → re-posts in Slack
         │
         ▼ [Stage 2 — eSignature]
Once all approvers signal ✅ in Slack:
  PMM activates eSignature requests in the Gdoc (via Workspace native eSignature)
  Each approver receives Drive notification → signs digitally in the Doc itself
  Workspace records timestamp, identity (verified Google account), audit log
         │
         ▼
n8n `din-watcher` polls Drive API every 5 min for signature-completion
  When all required signatures present → flip Postgres `campaigns.approval_status` = 'approved'
  + auto-create Salesforce Campaign with DIN ID
  + move brief Gdoc to /Drive/GTM/Campaigns/Approved/{DIN_ID}/
  + post confirmation to #gtm-din-review with link to signed Doc
         │
         ▼
Only THEN can n8n agent or human launch the campaign
         │
         ▼
On launch, n8n writes `launched_at`, `launched_by` to Postgres + SF;
The signed Doc is permanent legal evidence of the approval
```

**Why eSignature instead of just Slack:**
- Slack reactions can be removed/changed; eSignature on a Doc is permanent + identity-verified
- Compliance audits (DPDP, RBI, internal) require traceable approval — Slack thread isn't sufficient
- Approver accountability — they signed, they own
- Workspace native eSignature is FREE in Business Standard+ (no DocuSign spend)
- Drive API exposes signature status for n8n to poll programmatically

**Tooling:**
- Primary: **Google Workspace native eSignature** (built into Docs, no add-on)
- Fallback if version doesn't support: **DocuSign for Google Workspace** add-on (free tier covers low volume)
- API: Drive API v3 + Docs API for signature-field detection

### 11.3 UTM + tag scheme — unique per campaign + variant

Naming convention (lowercase, underscore-separated):

```
utm_source    = {channel_tool}        # smartlead | moengage | linkedin_ads | sales_nav | meta_ads | whatsapp | google_ads | organic | referral | partner
utm_medium    = {channel_type}        # email | push | whatsapp | sms | in_app | paid | social | inmail
utm_campaign  = {DIN_ID}              # AGS-GTM-20260424-001
utm_content   = {variant_id}          # v1 | v2 | v3 (creative variant)
utm_term      = {audience_segment}    # bfsi_tierA | d2c_midmkt | saas_tierB
```

**Example URL:**
`https://mothi.com/payouts?utm_source=smartlead&utm_medium=email&utm_campaign=AGS-GTM-20260424-001&utm_content=v2&utm_term=bfsi_tierA`

**Custom mothi query params (also required):**
- `cf_din=AGS-GTM-20260424-001` — duplicates DIN as a non-UTM param for legacy systems
- `cf_owner_email={pmm_owner_email}` — for accountability

**Per-channel tagging:**

| Channel | Where tag goes |
|---|---|
| **Cold email (Smartlead)** | Every link in body; Smartlead tracking domain forwards via UTM-preserving redirect |
| **MoEngage email** | All template links + CTA buttons |
| **MoEngage push** | Deep link param |
| **MoEngage WhatsApp** | Tracking link wrapper; UTM in click-through |
| **MoEngage in-app** | Custom event property + click-through URL |
| **LinkedIn ads** | Click URL; LinkedIn Conversion API event also fires with DIN |
| **Sales Nav InMail** | Manual UTM in sent links (PMM provides AE the pre-tagged link) |
| **Meta / Google ads** | Click URL + offline conversion event with DIN payload |
| **Organic content** | UTM in CTAs; SF web-to-lead form auto-captures |
| **Webinars** | Registration page UTM; post-webinar nurture inherits |

### 11.4 Reporting roll-up by DIN

Every closed-won opportunity, every demo booked, every reply, every click — joins back to its DIN via UTM. The weekly dashboard (§8) gains one new section:

**Section G — DIN performance leaderboard**

| DIN | Campaign name | Channels | Spend | Touches | MQLs | SQLs | Demos | Closed-won | Pipeline ₹ | Win rate | Cost per demo | Cost per ₹ pipeline |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| AGS-GTM-20260424-001 | … | … | … | … | … | … | … | … | … | … | … | … |
| AGS-GTM-20260418-007 | … | … | … | … | … | … | … | … | … | … | … | … |

This is what tells you which campaigns to repeat, kill, or scale.

### 11.5 Implementation — n8n + Postgres `campaigns` table

```sql
CREATE TABLE campaigns (
  din_id            TEXT PRIMARY KEY,
  name              TEXT NOT NULL,
  motion_type       TEXT NOT NULL,
  tier              TEXT NOT NULL,
  segment           TEXT NOT NULL,
  channels          TEXT[] NOT NULL,
  brief_gdoc_url    TEXT NOT NULL,
  pmm_owner_email   TEXT NOT NULL,
  approver_chain    TEXT[] NOT NULL,
  approval_status   TEXT NOT NULL CHECK (approval_status IN ('draft','in_review','approved','live','paused','archived')),
  approved_at       TIMESTAMPTZ,
  approved_by       TEXT[],
  launched_at       TIMESTAMPTZ,
  ended_at          TIMESTAMPTZ,
  utm_source        TEXT NOT NULL,
  utm_medium        TEXT NOT NULL,
  sf_campaign_id    TEXT,
  goal_kpi          JSONB,
  hypothesis        TEXT,
  retro_gdoc_url    TEXT,
  created_at        TIMESTAMPTZ DEFAULT now(),
  updated_at        TIMESTAMPTZ DEFAULT now()
);
```

**Hard gate in every n8n workflow:**
```
Before any send action:
  → query Postgres `campaigns` WHERE din_id = $din AND approval_status = 'live'
  → if 0 rows: HALT, log to audit, alert PMM owner in Slack
  → if 1+ rows: proceed with send + log touch with utm_campaign = din_id
```

This means the agents themselves enforce DIN approval. No backdoor.

### 11.6 Hard enforcement — mandatory uploads + skip-detection

> **Every artifact required by the brief must be uploaded into the system. Skip-attempts must be flagged in real-time. The brief Gdoc alone is not enough — assets live IN the system, not as Gdoc links.**

#### 11.6.1 Mandatory uploads per DIN (all required, validated by n8n before status flips to `approved`)

| Asset | Storage location | Validation rule |
|---|---|---|
| **Brief Gdoc** | `/Drive/GTM/Campaigns/Drafts/{DIN_ID}/brief.gdoc` | URL resolvable + 17 required fields populated (parsed via Gdoc API) |
| **Creative assets** | `/Drive/GTM/Campaigns/Drafts/{DIN_ID}/creative/` (subdir) | Subject lines (≥3) · body copy (≥3 variants) · ad creative (if paid) · lead form layout |
| **Audience list** | Upload to `/Drive/GTM/Campaigns/Drafts/{DIN_ID}/audience.csv` OR provide SF segment ID | Row count matches brief target ± 5%; consent source column required per row |
| **Compliance checklist** | `/Drive/GTM/Campaigns/Drafts/{DIN_ID}/compliance.md` | DPDP ✅ · TRAI DLT ✅ (if SMS) · PCI ✅ (if payment data) · brand-guidelines pass ✅ — all four signed by Compliance approver |
| **Approval audit trail** | Auto-captured from Slack #gtm-din-review thread | All approver chain reactions present + timestamps logged |
| **Test send results** | n8n auto-runs deliverability test before approval | GlockApps inbox-placement score ≥ 80% · spam-complaint risk score green |
| **UTM verification** | n8n auto-validates every link in creative | All links contain required UTM params + match DIN |
| **Frequency-cap impact analysis** | Auto-computed by n8n, attached to brief | Sum of touches in next 30d per merchant ≤ 4; if exceeds, flag for VP Marketing |
| **Post-launch retro template** | Pre-populated Gdoc auto-created | Empty until campaign ends; required to be filled within 7 days of `ended_at` |

**No row in `campaigns` can have `approval_status = 'approved'` until ALL nine validations pass.**

#### 11.6.2 Skip-detection — three-layer defense

**Layer 1: Pre-launch n8n gate (the "no" layer)**

Every n8n workflow that touches a send channel runs this check first:

```python
def can_launch(din_id: str) -> tuple[bool, str | None]:
    campaign = postgres.fetch_campaign(din_id)
    if not campaign:
        return False, "DIN_NOT_FOUND"
    if campaign.approval_status != "live":
        return False, f"STATUS_{campaign.approval_status.upper()}"
    if not all([campaign.brief_gdoc_url, campaign.creative_uploaded,
                campaign.audience_uploaded, campaign.compliance_signed,
                campaign.test_send_passed, campaign.utm_verified]):
        return False, "ARTIFACTS_INCOMPLETE"
    return True, None
```

Failure = HALT + audit-log entry + Slack DM to PMM owner with the specific reason.

**Layer 2: Real-time anomaly detection (the "you tried to bypass" layer)**

A continuous-monitor agent (`din-watchdog`, runs every 15 min) cross-references:
- All Smartlead campaigns active → must have a `cf_din` tag in custom field
- All MoEngage active flows → must have a `din_id` user-property filter or campaign tag
- All LinkedIn ad campaigns → must have `utm_campaign={DIN_ID}` in destination URL
- All SF Campaigns → must have a matching DIN in Postgres `campaigns` table
- All Gmail/Gsuite mass-send (via Gmail API audit log) → must originate from an n8n workflow tied to a DIN

**Any anomaly fires this Slack alert to #gtm-ops:**

```
🚨 DIN-ANOMALY DETECTED
Channel: {smartlead|moengage|linkedin_ads|gmail|sf_campaign}
Asset: {campaign_name + ID}
Issue: {NO_DIN | DIN_NOT_APPROVED | DIN_DOES_NOT_EXIST | DIN_ARCHIVED}
Detected at: {timestamp}
Owner (per channel-tool): {email}
Action required: Halt the asset within 24h OR file emergency DIN with retroactive approval

cc: @{pmm_lead}, @{vp_marketing}, @{revops_lead}
```

**Layer 3: Daily reconciliation report (the "what got past us" layer)**

Auto-generated 9am every morning, posted to #gtm-ops:

```
DIN Reconciliation — {date}

Active campaigns across tools: {N}
With approved DIN: {N - X}  ✅
Without DIN or with anomaly: {X}  ⚠️
  → {list each with link to halt action}

DINs in 'in_review' >48h: {Y}  ⏰
  → {list each with approver chain status}

Briefs missing required uploads: {Z}  📎
  → {list each with missing asset name}

Yesterday's blocked launches: {N}
  → {list each with reason}
```

#### 11.6.3 Bypass governance (for emergencies only)

There IS a controlled bypass — fintech reality means urgent compliance/PR/incident comms can't wait for full approval:

| Bypass type | Who can authorize | What it allows | Audit consequence |
|---|---|---|---|
| **Emergency send** | VP Marketing OR CRO | One-time send within 4h, max 5K recipients | Mandatory retro DIN within 48h + post-mortem in #gtm-ops |
| **Compliance correction** | Compliance lead | Pause active campaign, suppress affected list | Audit log auto-attaches to original DIN |
| **Brand crisis comms** | Founder OR VP Comms | Override frequency caps for one campaign | Full bypass log + retro within 24h |

**No other bypasses exist.** A PMM cannot self-approve. An AE cannot manually create a Smartlead campaign without DIN. A Demand Gen lead cannot duplicate an old campaign without re-running approval. **The system enforces.**

#### 11.6.4 Onboarding new team members

Every new PMM/Demand Gen/RevOps member joining the team:
- Day 1: Read this doc + watch 30-min Loom on DIN flow
- Day 1: Required to file a "training DIN" (marked `status='training'`) before they can file a real one
- Week 1: First real DIN must be co-signed by their manager AS the brief author
- After Week 4: Full DIN-filing rights granted

This prevents the "I didn't know I had to do that" excuse from ever being valid.

#### 11.6.5 The cultural reframe

Internal positioning — write this in the team handbook + put on Slack channel topic:

> **"If you launched it without a DIN, you didn't launch it — you leaked it. The system will tell on you within 15 minutes. No hard feelings, just a halt and a retro."**

This is not bureaucracy. This is what makes the agent layer trustworthy enough to hand the keys to. Without enforcement, the agents become a liability — they'll send 30K emails per month without anyone able to answer "who approved this?"

With enforcement, every send is auditable, every campaign has a hypothesis, every result has an owner, and the weekly report becomes signal — not noise.

---

## 12. What this DOESN'T include (deliberate scope cuts)

- ❌ 41-agent virtual GTM org chart (use only when v1 stabilizes)
- ❌ Multi-touch attribution model (SF Campaign Influence is sufficient for v1)
- ❌ Custom CDP / Postgres-as-warehouse / dbt transforms (SF + n8n mirror is enough)
- ❌ ClickHouse / BigQuery (defer until data volume justifies)
- ❌ Vertex AI / custom embeddings / pgvector (Claude can do retrieval directly from llm-wiki for v1)
- ❌ ML churn prediction (rules + Claude composite scoring is enough; ML in v2 if needed)
- ❌ Reverse ETL tools (n8n is the reverse ETL for v1)
- ❌ Looker / Looker Studio / advanced BI (Gsheets + SF reports for v1)
- ❌ Building or replacing Sales Nav / Smartlead / MoEngage themselves (use as-is)

---

## 13. Daily / weekly cadence

| When | Event |
|---|---|
| **6am daily** | ICP-Scout, Stage-Mover, Churn-Saver run |
| **6am Mon** | Cross-Sell-Detector + Dormant-Detector run |
| **9am Mon** | Weekly report agent runs + posts to Slack #gtm-weekly |
| **9am Wed** | Mid-week deliverability check + frequency-cap review |
| **5pm Fri** | Weekly health check + agent cost roll-up to Mothi DM |
| **Real-time** | Reply-Classifier + Google Forms inbound + Calendar meeting-prep trigger + ad-hoc HITL approvals via Slack |
| **Continuous** | Drive transcript watcher — every new transcript auto-extracted within 5 min of meeting end |

---

## 14. Success criteria for v1 (90 days)

| Metric | Target |
|---|---|
| AE calendar fill rate | 80%+ |
| Net-new pipeline / week | 2× current baseline |
| Demos booked / week (agent-sourced) | 30+ |
| MQL → SQL conversion | +15% vs baseline |
| Reply rate on cold outbound | ≥3% (current Smartlead baseline TBD) |
| MoEngage onboarding uplift | +25% (vs Razorpay's 29% target) |
| Churn save rate (merchants saved / merchants flagged) | 30%+ |
| Cross-sell deals closed (Payments → Payouts pilot) | 5+ |
| Agent operating cost / month | <$500 (LLM) + $50 (infra) = under $7K/yr |
| AE adoption (% AEs using agent briefs daily) | 75%+ |
| 100% campaigns DIN-approved before launch | Hard gate enforced at n8n layer |
| 100% touches UTM-tagged with DIN | Roll-up validation in weekly report |

If all 10 hit, v2 scope kicks off (more agents, deeper signal layer, richer attribution). If <7 hit, retro + simplify further before scaling.

---

## Cross-references

- [llm-wiki/wiki/concepts/modern-gtm-stack-blueprint.md](../../../llm-wiki/wiki/concepts/modern-gtm-stack-blueprint.md) — the 41-agent reference
- [llm-wiki/wiki/concepts/virtual-gtm-org-chart.md](../../../llm-wiki/wiki/concepts/virtual-gtm-org-chart.md) — full role mapping
- [llm-wiki/wiki/concepts/gtm-ai-stack.md](../../../llm-wiki/wiki/concepts/gtm-ai-stack.md) — tool catalog
- [llm-wiki/wiki/concepts/skills-master-map.md](../../../llm-wiki/wiki/concepts/skills-master-map.md) — 180+ existing skills cross-reference
- [llm-wiki/wiki/concepts/dpdp-act.md](../../../llm-wiki/wiki/concepts/dpdp-act.md) — compliance layer
- [github.com/mothivenkatesh/gtm-ops](https://github.com/mothivenkatesh/gtm-ops) — code scaffold (private)

---

## Sharp questions to answer before Wk 1 starts

1. **Calendar fill baseline:** What's the current AE calendar fill rate today? (Without this, "+80%" is meaningless.)
2. **Reply rate baseline:** What's the current Smartlead reply rate across the 20 domains? (Determines whether to fix targeting or scale volume first.)
3. **Cross-sell pair priority:** Which two mothi products have the highest historical attach rate? (Determines Cross-Sell-Detector v1 scope.)
4. **HITL approver SLA:** Who reviews the first 100 sends per template? Mothi or a dedicated Demand Gen Manager? (Determines whether HITL is a bottleneck.)
5. **n8n hosting decision:** Existing mothi infra or a separate Hetzner box? (Affects security review + IT involvement.)

**Until these 5 are answered, Wk 1 build is paused.** Each is a 1-message Slack/email away. Get them this week.
