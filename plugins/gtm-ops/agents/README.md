# agents/

> n8n workflow JSON exports for the 7 + 3 utility agents specified in `gtm-context.md` §3.

---

## To build

Each agent = one n8n workflow JSON export, named `{agent-name}.json`.

| Agent | Trigger | Status | File |
|---|---|---|---|
| **icp-scout** | Daily 6am cron + Google Forms webhook | 🔲 | `icp-scout.json` |
| **outreach-writer** | New high-score lead | 🔲 | `outreach-writer.json` |
| **reply-classifier** | Smartlead reply webhook | 🔲 | `reply-classifier.json` |
| **stage-mover** | Daily 7am cron + Calendar webhook | 🔲 | `stage-mover.json` |
| **cross-sell-detector** | Weekly Monday 6am | 🔲 | `cross-sell-detector.json` |
| **dormant-detector** | Weekly Tuesday 6am | 🔲 | `dormant-detector.json` |
| **churn-saver** | Daily 6am + Forms NPS webhook | 🔲 | `churn-saver.json` |
| **weekly-report** | Monday 9am cron | 🔲 | `weekly-report.json` |
| **drive-transcript-extractor** | Drive watcher (5-min poll) | 🔲 | `drive-transcript-extractor.json` |
| **forms-router** | Google Forms webhook | 🔲 | `forms-router.json` |
| **din-watchdog** | 15-min cron | 🔲 | `din-watchdog.json` |

---

## Workflow pattern (every agent must follow)

```
1. Trigger (cron / webhook)
2. Pre-launch DIN gate                       ← reliability rule #8
3. Fetch context (SF + Postgres + Drive + LLM-extracted properties)
4. Load skill from Shared Drive              ← see skills/README.md
5. Claude API call                           ← via Claude Max
6. Pydantic schema validation on output      ← reliability rule #2
7. Frequency cap check                       ← reliability rule #4
8. HITL approval (where applicable)          ← reliability rule #9
9. Writeback (SF + MoEngage + Slack + Sheets)
10. Audit log entry → Postgres `agent_decisions`  ← reliability rule #11
11. UTM tagging on every link                ← reliability rule #9 / §11.3
```

---

## Reliability rules enforced per workflow

(All 13 from spec §6 + §11)

- ✅ Idempotent (rule #1)
- ✅ Pydantic schema validated (rule #2)
- ✅ LiteLLM/Claude Max proxy with cost cap (rule #3)
- ✅ Prompt caching enabled (rule #4)
- ✅ Batch API for non-realtime (rule #5)
- ✅ Circuit breakers on external calls (rule #6)
- ✅ Rate limits at MCP boundary (rule #7)
- ✅ Retries with exponential backoff (rule #8)
- ✅ HITL approval where required (rule #9)
- ✅ Unleash feature flag in place (rule #10)
- ✅ Audit log written (rule #11)
- ✅ Kill switch via env var (rule #12)
- ✅ DIN gate validated (rule #13)

---

## Hosting

n8n self-hosted on existing mothi infra OR a $50/mo Hetzner box. See spec §9 build sequence Week 1.

---

## How to export from n8n

```
n8n UI → Workflow → ⋮ menu → Download
```

Save the JSON to `agents/{agent-name}.json` and update the status table above.

---

## Adding a new agent

See top-level [`CONTRIBUTING.md`](../CONTRIBUTING.md) §"Adding a new n8n agent".
