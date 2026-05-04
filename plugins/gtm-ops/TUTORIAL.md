# Tutorial — Your first 7 days with gtm-ops

> **You've cloned the repo. Now what?** This is the hands-on companion to [`OPERATOR-QUICKSTART.md`](OPERATOR-QUICKSTART.md). Step-by-step commands, real queries, concrete checkpoints. Get from zero to one shipped workflow in 7 days.

---

## Prerequisites

Before you start, you'll need:

| Tool | Version | Why | Where to get |
|---|---|---|---|
| **Docker Desktop** | 4.x+ | Runs Postgres + Metabase + Redis | [docker.com](https://docker.com) |
| **Python** | 3.11+ | Runs the LangGraph reference flows | [python.org](https://python.org) or `uv` |
| **uv** (recommended) | latest | Faster Python env management | `pip install uv` |
| **Node.js** | 20+ | Runs Promptfoo evals | [nodejs.org](https://nodejs.org) |
| **gh CLI** | latest | Pull/push to GitHub | [cli.github.com](https://cli.github.com) |
| **Anthropic API key** | — | Powers all Claude calls | Use your existing Claude Max key |
| **n8n** (optional, day 3+) | self-hosted | Production agent runtime | [n8n.io](https://n8n.io) — or skip for now |
| **Salesforce sandbox** (optional) | — | Real CRM target | mothi internal |
| **Smartlead account** (optional) | — | Outbound sender | mothi internal |

**The repo runs end-to-end on just Docker + Python + Anthropic API.** Everything else is for production. Day 1-2 of this tutorial uses only seed data — no SF, no Smartlead, no real outbound.

---

## Day 1 — Local setup (45 min)

### Step 1: Clone + enter the repo

```bash
gh repo clone mothivenkatesh/gtm-ops
cd gtm-ops
```

If you've already cloned, `git pull` to get the latest.

### Step 2: Copy environment template

```bash
cp .env.example .env
```

Open `.env` in your editor. Fill in **only** these for Day 1:

```bash
ANTHROPIC_API_KEY=sk-ant-...        # required
OPENROUTER_API_KEY=                  # leave blank for Day 1; flows will fall back to ANTHROPIC
DATABASE_URL=postgresql://gtm:gtm@localhost:5432/gtm_ops    # default — leave as-is
LLM_WIKI_PATH=C:/Users/mothi/llm-wiki/wiki    # only if you have llm-wiki cloned locally
LOG_LEVEL=INFO
DEMO_MODE=true
```

Leave the rest blank for now. They get filled when you go to production.

### Step 3: Spin up Postgres + Metabase + Redis

```bash
docker compose up -d
```

Wait ~30 seconds. Verify all 3 containers are running:

```bash
docker ps
```

Should show `gtm-ops-postgres`, `gtm-ops-metabase`, `gtm-ops-redis`. If any are missing, run:

```bash
docker compose logs gtm-ops-postgres
```

and look for errors (most common: port 5432 already in use — kill the conflicting process or change port in `docker-compose.yml`).

### Step 4: Run the 3 schemas + seed data

```bash
docker exec -i gtm-ops-postgres psql -U gtm -d gtm_ops < sql/001_schema.sql
docker exec -i gtm-ops-postgres psql -U gtm -d gtm_ops < sql/002_schema_extensions.sql
docker exec -i gtm-ops-postgres psql -U gtm -d gtm_ops < sql/003_schema_extensions.sql
docker exec -i gtm-ops-postgres psql -U gtm -d gtm_ops < sql/seed_mock_data.sql
```

Each command should show `CREATE TABLE`, `INSERT`, `ALTER TABLE` etc. without errors. If you see "relation already exists" — that's fine, the schemas use `IF NOT EXISTS`.

### Step 5: Build the marts

The marts are materialized views that compute reporting on top of the seed data:

```bash
docker exec -i gtm-ops-postgres psql -U gtm -d gtm_ops < sql/marts/mart_buyer_journey.sql
docker exec -i gtm-ops-postgres psql -U gtm -d gtm_ops < sql/marts/mart_account_health.sql
docker exec -i gtm-ops-postgres psql -U gtm -d gtm_ops < sql/marts/mart_din_performance.sql
docker exec -i gtm-ops-postgres psql -U gtm -d gtm_ops < sql/marts/mart_channel_attribution.sql
docker exec -i gtm-ops-postgres psql -U gtm -d gtm_ops < sql/marts/mart_lifecycle_metrics.sql
docker exec -i gtm-ops-postgres psql -U gtm -d gtm_ops < sql/marts/mart_ae_performance.sql
docker exec -i gtm-ops-postgres psql -U gtm -d gtm_ops < sql/marts/mart_outbound_health.sql
docker exec -i gtm-ops-postgres psql -U gtm -d gtm_ops < sql/marts/mart_recycled_recovery.sql
```

Each should show `SELECT N` (where N > 0). If you see `SELECT 0`, the seed didn't fully load — re-run `seed_mock_data.sql`.

### Step 6: Install Python dependencies

```bash
uv sync
```

Or if you don't have `uv`:

```bash
python -m venv .venv
source .venv/bin/activate   # Mac/Linux
# OR: .venv\Scripts\activate   # Windows
pip install -e .
```

### Step 7: Verify it all works

```bash
uv run python -c "from gtm_ops.config import settings; print('✅ config loaded:', settings.database_url)"
```

Should print: `✅ config loaded: postgresql://gtm:gtm@localhost:5432/gtm_ops`

**Day 1 done.** You have a Postgres database with realistic mothi-shaped data, marts populated, Python env ready. Next: explore the data.

---

## Day 2 — Explore the data + run a flow (1 hour)

### Step 1: Query the spine — mart_buyer_journey

This is the canonical record per opportunity. Open a Postgres shell:

```bash
docker exec -it gtm-ops-postgres psql -U gtm -d gtm_ops
```

Now run:

```sql
-- All closed-won deals with their attribution
SELECT account_name, vertical, tier, gtm_motion, source,
       opportunity_amount, cycle_days, first_touch_attribution
FROM mart_buyer_journey
WHERE outcome = 'won'
ORDER BY closed_won_date DESC;
```

You should see 8 closed-won deals from the seed (HDFC, MamaEarth, Plum, Hiver, Meesho, etc.).

```sql
-- Cost-per-closed-won by source channel
SELECT source, COUNT(*) AS won_deals,
       AVG(opportunity_amount)::INT AS avg_acv_inr,
       AVG(cycle_days)::INT AS avg_cycle
FROM mart_buyer_journey
WHERE outcome = 'won'
GROUP BY source
ORDER BY won_deals DESC;
```

```sql
-- Median cycle by tier × vertical
SELECT tier, vertical,
       PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY cycle_days) AS median_cycle
FROM mart_buyer_journey
WHERE outcome IN ('won','lost')
GROUP BY tier, vertical;
```

### Step 2: Query account health

```sql
-- Top 5 churn-risk accounts (these would fire churn-saver in production)
SELECT account_name, vertical, tier, churn_risk_score,
       churn_risk_signals_30d, competitor_mentions_30d
FROM mart_account_health
WHERE churn_risk_score >= 3.0
ORDER BY churn_risk_score DESC
LIMIT 5;
```

```sql
-- Cross-sell candidates (Payments-heavy + no Payouts)
SELECT account_name, vertical, intent_score, expansion_signals_30d
FROM mart_account_health
WHERE expansion_signals_30d > 0
ORDER BY intent_score DESC
LIMIT 10;
```

Exit psql with `\q`.

### Step 3: Open Metabase

Browser → http://localhost:3000

First-time setup: create admin account → connect to Postgres:

- Display name: `gtm-ops`
- Database type: Postgres
- Host: `host.docker.internal` (Mac/Windows) or `172.17.0.1` (Linux)
- Port: `5432`
- Database name: `gtm_ops`
- Username: `gtm`
- Password: `gtm`

Once connected, browse → Models → you'll see all 8 marts. Click any to explore.

### Step 4: Run the canonical Python flow

```bash
uv run gtm-ops meeting-prep --deal-id=deal_013
```

This runs the Meeting-Prep agent against `deal_013` (HDFC Mobile360 POC). Watch the LangGraph nodes execute:
- fetch_deal → fetch_stakeholders → fetch_competitive → fetch_past_touchpoints → synthesize_brief → [HITL pause]

The flow pauses before posting to Slack (HITL checkpoint). For now, you'll see the brief printed in your terminal.

### Step 5: Run the Promptfoo eval suite

This validates that all 11 skills behave correctly:

```bash
cd evals
npm install promptfoo
npx promptfoo eval
```

You'll see ~45 test cases run across the 11 skills. Open the results:

```bash
npx promptfoo view
```

Browser opens with a table showing pass/fail per case + assertion details.

**Expected baseline:** ≥85% pass rate. If you see lower, check that `OPENROUTER_API_KEY` is set or `ANTHROPIC_API_KEY` fallback is configured.

**Day 2 done.** You've queried the data layer, explored Metabase, run a flow end-to-end, and validated the skills work. Next: ship one workflow live.

---

## Day 3 — Ship your first DIN-approved campaign (3 hours)

> **Goal:** create a campaign brief, push it through DIN approval, send 10 cold outbound emails, watch Reply-Classifier handle the response.

### Step 1: Configure Smartlead (or skip with a mock)

If you don't have Smartlead access yet, you can mock by configuring a test SMTP (e.g., [Mailtrap](https://mailtrap.io)). Add to `.env`:

```bash
SMARTLEAD_API_KEY=your_key_here
```

If skipping, just observe the flow — no actual email sends.

### Step 2: Create your first DIN brief

Create a Google Doc with this template (or use any markdown file for now):

```
DIN: AGS-GTM-20260427-TEST-001
Campaign: My first test campaign
Owner: <your email>
Motion: acquisition
Tier: C
Segment: d2c
Channels: cold_email
Audience size: 10 accounts
Goal: 1 reply minimum
Hypothesis: D2C founders respond to international PG hook
Compliance: ✅ DPDP (legitimate interest), ✅ no SMS so no DLT
UTM: utm_source=smartlead utm_medium=email utm_campaign=AGS-GTM-20260427-TEST-001
```

### Step 3: Insert the DIN into Postgres

```sql
INSERT INTO campaigns (din_id, name, motion_type, tier, segment, channels,
                        brief_gdoc_url, pmm_owner_email, approver_chain,
                        approval_status, utm_source, utm_medium,
                        creative_uploaded, audience_uploaded, compliance_signed,
                        test_send_passed, utm_verified, freq_cap_impact_analyzed,
                        spend_inr, planned_budget_inr)
VALUES ('AGS-GTM-20260427-TEST-001', 'My first test campaign', 'acquisition', 'C', 'd2c',
        '{cold_email}', 'https://docs.google.com/d/example-test',
        '<your_email>', '{<your_email>}', 'live',
        'smartlead', 'email',
        true, true, true, true, true, true,
        500, 1000)
ON CONFLICT (din_id) DO NOTHING;
```

DIN is now `live`. Any agent can send under it.

### Step 4: Build a 10-account target list

```sql
-- Pull 10 D2C Tier C accounts that haven't been touched recently
SELECT a.id, a.name, a.domain, c.email, c.first_name
FROM accounts a
LEFT JOIN contacts c ON c.account_id = a.id
WHERE a.vertical = 'd2c'
  AND a.tier = 'C'
  AND (a.last_meaningful_touch IS NULL OR a.last_meaningful_touch < now() - interval '14 days')
LIMIT 10;
```

Save the result to a CSV (you'll feed this to Smartlead or your mock).

### Step 5: Generate personalized outreach for ONE account

Run the Outreach-Writer flow manually for one of the 10:

```bash
uv run python -c "
from gtm_ops.flows.outreach_writer import build_outreach_writer_graph
import asyncio

graph = build_outreach_writer_graph()
result = asyncio.run(graph.ainvoke({
    'sf_lead_id': 'test_lead_001',
    'din_id': 'AGS-GTM-20260427-TEST-001',
    'tier': 'C',
    'vertical': 'd2c',
    'spear_product': 'international-pg',
    'frequency_cap_remaining': 4,
}))
print(result.get('sequence', {}))
"
```

This calls Claude with the outreach-writer skill loaded; you'll see the 3-touch sequence printed. **HITL is built in for Tier A/B but Tier C bypasses, so this would auto-send in production.**

### Step 6: Push the sends to Smartlead (or mock)

If you have real Smartlead, the agent's `push_to_smartlead` node creates the campaign automatically. Otherwise, copy-paste the generated touches into Mailtrap or a test inbox to verify formatting.

### Step 7: Wait for replies + watch Reply-Classifier

When a reply lands, the reply-classifier agent fires (in production via Smartlead webhook). Test it manually:

```bash
uv run python -c "
from gtm_ops.flows.reply_classifier import build_reply_classifier_graph
import asyncio

graph = build_reply_classifier_graph()
result = asyncio.run(graph.ainvoke({
    'smartlead_payload': {
        'from_email': 'test@d2cbrand.com',
        'body_text': 'Sounds interesting, can we set up a call next Tuesday at 4pm IST?',
    },
    'thread_context': {'lead_tier': 'C', 'lead_vertical': 'd2c'}
}))
print('Intent:', result.get('intent'))
print('Routing:', result.get('routing_action'))
"
```

You'll see `intent: positive`, `routing_action: alert_ae`. In production, this auto-pings the AE in Slack.

**Day 3 done.** You've created a DIN, generated personalized outreach, and watched intent classification work. Next: operationalize across the team.

---

## Day 4–7 — Operationalize (4 weeks of work, condensed)

### Day 4 — Wire the 4 critical Sheets

Create a new Google Spreadsheet for each:

1. `gtm.weekly-dashboard` — paste source from `dashboards/sheets/gtm.weekly-dashboard.gs` into Extensions → Apps Script
2. `gtm.din-registry` — same with `gtm.din-registry.gs`
3. `gtm.outreach-queue` — same with `gtm.outreach-queue.gs`
4. `gtm.churn-watchlist` — same with `gtm.churn-watchlist.gs`

For each, set Script Properties (Project Settings → Script Properties):
- `SLACK_WEBHOOK_URL` (incoming-webhook URL for #gtm-weekly)
- `POSTGRES_DIN_ENDPOINT` (your n8n endpoint that returns the DINs JSON)
- `N8N_OUTREACH_SENT_WEBHOOK` (callback URL for outreach-queue Sent checks)
- `SLACK_CS_WEBHOOK` (alert channel for churn-watchlist P0)

Run `installWeeklyTrigger()` from the Apps Script editor to install the Monday 9am cron.

### Day 5 — Set up n8n + first workflow

```bash
# Self-hosted n8n on the same machine
docker run -d --name n8n -p 5678:5678 -v ~/.n8n:/home/node/.n8n n8nio/n8n
```

Open http://localhost:5678 → create workflow "icp-scout" → schedule daily 6am cron → add nodes:

1. Cron trigger
2. Postgres query (pull leads where icp_score is null)
3. HTTP request to Anthropic API (load skill from local file or Drive, send Claude Haiku prompt)
4. Postgres write (update icp_score, intent_score, tier)
5. HTTP request to Slack webhook (alert on tier A/B)

Reference the Python flow at `src/gtm_ops/flows/icp_scout.py` for the exact node sequence + prompt structure.

### Day 6 — Connect Forms intake

Create a Google Form titled "mothi Demo Request" with fields per `forms-router.SKILL.md` spec:
- Company, Name, Email, Phone, Monthly Volume, Vertical, Urgency, Consent

In Apps Script, paste `dashboards/sheets/gtm.form-responses.demo-request.gs`. Set property `N8N_FORMS_ROUTER_WEBHOOK` to your forms-router endpoint. Run `installFormTrigger()`.

Test: submit a fake form → verify it lands in n8n → verify it routes to ICP-Scout with `high_intent_explicit=true`.

### Day 7 — First weekly digest

Wait until Monday 9am IST. The `weekly-report` agent should fire, push the digest to your Sheet, and post to Slack #gtm-weekly.

If it doesn't:
- Check the Apps Script execution log
- Check n8n workflow status
- Check Postgres for the materialized view refresh: `REFRESH MATERIALIZED VIEW CONCURRENTLY mart_din_performance;`

**End of Week 1.** You have:
- Live Postgres + 8 marts populated daily
- 1 Tier C campaign with DIN approval
- Reply-Classifier + ICP-Scout running on n8n
- Weekly digest Sheet auto-refreshed Monday 9am
- Slack alerts wired for high-priority events

---

## Troubleshooting

### Postgres connection refused

```bash
docker compose down -v
docker compose up -d
sleep 10
docker exec -i gtm-ops-postgres psql -U gtm -d gtm_ops -c 'SELECT 1'
```

If still failing, port 5432 is taken on host. Change in `docker-compose.yml`:
```yaml
ports:
  - "5433:5432"   # host port 5433
```
Then update `DATABASE_URL=postgresql://gtm:gtm@localhost:5433/gtm_ops`.

### Mart returns empty

Always re-run the seed first, then the mart:
```bash
docker exec -i gtm-ops-postgres psql -U gtm -d gtm_ops < sql/seed_mock_data.sql
docker exec -i gtm-ops-postgres psql -U gtm -d gtm_ops -c "REFRESH MATERIALIZED VIEW mart_buyer_journey;"
```

### Promptfoo failures > 15%

Most common cause: model API key issues. Verify:
```bash
echo $OPENROUTER_API_KEY
echo $ANTHROPIC_API_KEY
```

Or rate-limited — Promptfoo retries; let it complete then re-check.

### Skill loading errors in Python flows

The flows reference skill bodies as `<{skill-name} skill body from Shared Drive>` placeholders. In production you wire Drive API to fetch them. For local dev, you can shortcut by reading the skill file directly:

```python
with open(f"skills/{skill_name}/SKILL.md") as f:
    skill_body = f.read()
```

### n8n workflow won't trigger

Common causes: webhook URL mismatch (check Apps Script Script Properties), credentials not configured (n8n Credentials → re-add Anthropic API), or cron timezone (set n8n to Asia/Kolkata).

### Slack alerts not firing

Test the webhook directly:
```bash
curl -X POST -H 'Content-type: application/json' \
  --data '{"text":"test from gtm-ops"}' \
  $SLACK_WEBHOOK_URL
```

If 200 OK but no message, check the channel name in your webhook config.

---

## Going to production

The local setup is for learning. To deploy at mothi:

| Layer | Local (this tutorial) | Production |
|---|---|---|
| Postgres | Docker on laptop | Managed RDS or mothi's existing Postgres |
| n8n | Docker on laptop | n8n self-hosted on mothi infra OR n8n Cloud |
| Skills | Local `skills/` folder | Google Shared Drive (`mothi GTM AI/Skills/`) |
| Sheets | Personal Google account | mothi Workspace shared sheets |
| Smartlead | Personal/test account | mothi's existing Smartlead with 20 warmed domains |
| Salesforce | Skipped (mock data) | mothi's SF instance via API |
| MoEngage | Skipped | mothi's MoEngage with WhatsApp BSP |
| Drive AI transcription | Skipped | mothi Workspace + Drive API |
| LLM | Anthropic API direct | OpenRouter or Anthropic Enterprise tier |
| Observability | Print statements | Langfuse self-hosted + Sentry + Slack alerts |

The 4-week production rollout is documented in [`docs/gtm-context.md`](docs/gtm-context.md) §9.

---

## Glossary

| Term | Meaning |
|---|---|
| **DIN** | Document Identification Number — every campaign gets one (`AGS-GTM-YYYYMMDD-NNN`). No DIN = no send. |
| **mart_buyer_journey** | The single canonical row per opportunity. Spine of all reporting. |
| **HITL** | Human-In-The-Loop. Required on every CRM write, every outbound message, every ad audience change. |
| **NTC** | New-to-Credit. 190M+ Indian adults with no credit-bureau history. mothi's Mobile360 covers them. |
| **V-CIP** | Video-based Customer Identification Process. RBI-mandated for KYC. |
| **Razorpay floor** | The public 29/25/19/16% benchmarks Razorpay shared in their MoEngage case study. mothi's lifecycle motions must beat these. |
| **Tier A/B/C/plg** | Account tiering. A = lighthouse (50 accounts max, exec-led). B = strategic (200, AE-led). C = mid-market (1500, automated). plg = self-serve. |
| **Recycled** | A closed-lost opportunity moved back into nurture. The recycled-recovery mart tracks how many of these revive. |

---

## Next steps

- Read [`docs/gtm-context.md`](docs/gtm-context.md) end-to-end (~25 min) — the canonical operating manual
- Read [`CONTRIBUTING.md`](CONTRIBUTING.md) — how to add skills, agents, marts, dashboards
- Read [`ROADMAP.md`](ROADMAP.md) — what's planned for v1.5 / v2 / v3
- Pick ONE thing to ship in your first 2 weeks — don't try to launch everything at once

Questions: mothi@mothi.com.
