# dashboards/sheets/

> Google Sheets templates + Apps Script source for the AE/SDR/CSM-facing operational layer.

---

## Pattern

Every operational sheet:
1. **Has a canonical column structure** documented here in markdown
2. **May have an Apps Script source file** (`.gs`) for automation
3. **Is created via a one-time setup script** that any operator can run to replicate

---

## The 12 Day-1 Sheets (per spec §4.4)

| Sheet | Status | Apps Script | Purpose |
|---|---|---|---|
| `gtm.weekly-dashboard` | ✅ Apps Script committed | [`gtm.weekly-dashboard.gs`](gtm.weekly-dashboard.gs) | Auto-generated weekly digest from `cf-weekly-report` agent |
| `gtm.din-registry` | 🔲 | — | Live view of all DINs synced from Postgres `campaigns` table |
| `gtm.ae-pipeline-{ae_email}` | 🔲 | — | Per-AE personal dashboard (one sheet per AE) |
| `gtm.outreach-queue` | 🔲 | — | Daily outbound lineup per BDR |
| `gtm.suppression-list` | 🔲 | — | Master do-not-contact list, auto-appended via webhook |
| `gtm.abm-tier-A` + `gtm.abm-tier-B` | 🔲 | — | Lighthouse + strategic account lists |
| `gtm.cross-sell-candidates` | 🔲 | — | Cross-Sell-Detector output (weekly Mon refresh) |
| `gtm.churn-watchlist` | 🔲 | — | Churn-Saver output (daily 6am refresh) |
| `gtm.form-responses.{form_name}` | 🔲 | — | Auto-landing zones for Google Forms |
| `gtm.agent-overrides` | 🔲 | — | Manual veto sheet |
| `gtm.deliverability-monitor` | 🔲 | — | Per-domain reply/bounce/spam reputation |
| `gtm.din-anomalies` | 🔲 | — | DIN-watchdog output (15-min refresh) |

---

## Apps Script glue patterns

Each Sheet may have associated Apps Script for:

| Pattern | Use case |
|---|---|
| `onFormSubmit` trigger | Form submission → fires webhook to n8n with parsed payload |
| `onEdit` trigger | Sheet edit → writes to Postgres via webhook (e.g., AE updates next-step field) |
| Time-driven trigger | Read Postgres → update Sheet hourly/daily (alternative to n8n cron for simple reads) |
| Sheets-to-Slack | Row appended to anomaly sheet → Slack webhook alert |

---

## How to deploy a sheet

1. Create blank Sheet in Google Drive: `Cashfree GTM AI / Operational / {sheet-name}`
2. Set permissions per spec §4.3.2
3. Copy Apps Script source from this folder → Sheet's Extensions > Apps Script
4. Configure triggers via Apps Script editor
5. Set up n8n webhook endpoint
6. Test end-to-end with one synthetic row
7. Add Sheet URL to `gtm.din-registry` (the canonical sheet-of-sheets)

---

## Hard rule (anti-sprawl)

**No operational data lives ONLY in a Sheet.** Sheets are the **read surface** + **lightweight write capture**; Postgres + Salesforce remain the source of truth. Sheets data flushes to/from those at minimum hourly (more frequent for high-velocity ops sheets like outreach queue).
