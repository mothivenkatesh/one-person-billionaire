# dashboards/

> Dashboard templates for the three BI surfaces. **One audience per surface — no sprawl.**

---

## Three-surface rule (spec §8.2)

| Surface | Audience | What they see | Refresh |
|---|---|---|---|
| **Sheets** (`sheets/`) | AE / SDR / CSM | Per-rep operational sheets · DIN registry · agent overrides · Form intake · weekly digest | Hourly |
| **Metabase** (`metabase/`) | PMM / Demand Gen / RevOps | Channel performance · DIN-leaderboard · funnel cohorts · MoEngage flow stats · deliverability | Real-time (live SQL on Postgres) |
| **QuickSight** (`quicksight/`) | VP Sales / VP Marketing / CRO / Founders | Pipeline:revenue · forecast vs actual · vertical mix · QoQ trends · ML anomaly callouts | Daily 6am |

---

## Anti-sprawl rules (enforced)

1. **No metric defined twice.** Every metric lives in `gtm.metric-definitions` (canonical Sheet) → SQL view in Postgres → consumed by all 3 BI surfaces.
2. **No new dashboard without metric-definition entry.** RevOps-enforced.
3. **No surface adds custom calculations** — if a chart needs a new metric, it goes back to definitions Sheet first.
4. **Monthly review of dashboard usage.** Any chart not viewed in 30 days → archived. Prevents zombie charts.

---

## To build (per spec §4.4)

### Sheets templates (12 day-1 sheets)

| Sheet | Purpose | Status |
|---|---|---|
| `gtm.weekly-dashboard` | Auto-generated weekly digest | 🔲 |
| `gtm.din-registry` | Live view of all DINs with status | 🔲 |
| `gtm.ae-pipeline-{ae_email}` | Per-AE personal dashboard | 🔲 |
| `gtm.outreach-queue` | Daily outbound lineup per BDR | 🔲 |
| `gtm.suppression-list` | Master do-not-contact list | 🔲 |
| `gtm.abm-tier-A` + `gtm.abm-tier-B` | Lighthouse + strategic accounts | 🔲 |
| `gtm.cross-sell-candidates` | Cross-Sell-Detector output | 🔲 |
| `gtm.churn-watchlist` | Churn-Saver output | 🔲 |
| `gtm.form-responses.{form_name}` | Auto-landing zones for Forms | 🔲 |
| `gtm.agent-overrides` | Manual veto sheet | 🔲 |
| `gtm.deliverability-monitor` | Per-domain reply/bounce/spam | 🔲 |
| `gtm.din-anomalies` | DIN-watchdog output | 🔲 |

### Metabase dashboards

| Dashboard | Sections | Status |
|---|---|---|
| **mothi GTM** (master) | KPI snapshot · channel performance · lifecycle benchmarks · observations · key actions · DIN leaderboard | 🔲 |

### QuickSight analyses

| Analysis | Audience | Status |
|---|---|---|
| **mothi GTM Exec** | Founders / CRO / CMO | 🔲 |

---

## Apps Script glue (for Sheets workflows)

Each operational Sheet may have associated Apps Script for:
- Form submission `onFormSubmit` triggers → webhook to n8n
- Sheet edit `onEdit` triggers → write to Postgres via webhook
- Time-driven triggers → read Postgres → update Sheet
- Slack notifications via Apps Script + webhook

Save Apps Script source as `sheets/{sheet-name}.gs` alongside template URL.

---

## Adding a new dashboard

See top-level [`CONTRIBUTING.md`](../CONTRIBUTING.md) §"Adding a new dashboard".
