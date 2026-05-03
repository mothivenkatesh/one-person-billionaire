# AI SDR Agent

> **Install via the agentic-gtm-stack marketplace:**
> ```bash
> claude plugin marketplace add mothivenkatesh/agentic-gtm-stack
> claude plugin install ai-sdr@agentic-gtm-stack
> ```
> The legacy standalone-repo install instructions further down still work for development. User data (`.env`, `data/`, `_config.md`) lives at `~/Documents/sdr-agent/` by convention — set this up before first run; see [SETUP.md](./SETUP.md).

An autonomous AI Sales Development Representative that runs inside [Claude Code](https://docs.anthropic.com/en/docs/claude-code). It replaces a 25-node n8n workflow with a modular mode-based architecture that researches prospects, qualifies accounts, writes hyper-personalized outreach, and pushes leads into email and LinkedIn campaigns on a scheduled cadence.

**Inspired by the architecture of [santifer/career-ops](https://github.com/santifer/career-ops)** — specifically the router + mode injection pattern, shared/user config separation, score-gated pipelines, and TSV-first state management.

---

## Why

Traditional SDR workflows are brittle chains of API calls stitched together in tools like n8n or Zapier. They break when a schema changes, can't reason about edge cases, and produce generic outreach that prospects ignore. Worse, they require constant babysitting.

**This agent fixes that.** Claude acts as the reasoning engine — it reads prospect data, does live web research, makes ICP qualification judgments, writes genuinely personalized emails, and orchestrates the entire pipeline end-to-end. It runs on a cron schedule, logs structured output to Notion, self-analyzes its own performance, and only escalates when something truly goes wrong.

---

## What's New (v2)

| v1 (monolithic) | v2 (modular, career-ops inspired) |
|---|---|
| Single 200-line skill file | Router + 7 composable mode files |
| All rules inlined per task | `_shared.md` system layer + `_config.md` user layer |
| No score gates | 3-tier score gates (4.0 / 3.0-3.9 / <3.0) |
| Direct Notion writes | TSV staging → merge → Notion (crash-safe) |
| No dedup | `run-history.tsv` + Notion dedup |
| No init check | `init-check.sh` validates env, config, API connectivity |
| No analytics | Weekly pipeline analytics with recommendations |
| No batch mode | Parallel worker support with failure isolation |
| Basic error handling | Three-tier fallback (Chrome → WebFetch → WebSearch), retry policies, graceful degradation |
| No NEVER/ALWAYS rules | 10 NEVER + 10 ALWAYS hardcoded safety rails |

---

## Architecture

```
                              +------------------+
                              |   SKILL.md       |
                              |   (Router)       |
                              +--------+---------+
                                       |
                         +-------------+-------------+
                         |                           |
                  +------v------+            +-------v------+
                  | _shared.md  |            | _config.md   |
                  | (system)    |            | (user)       |
                  | auto-update |            | never touch  |
                  +------+------+            +-------+------+
                         |                           |
                         +-------------+-------------+
                                       |
                                       v
                +----------------------+------------------+
                |                                         |
                v                                         v
     +------------------+              +------------------------+
     | SCHEDULED TASKS  |              | MODES                  |
     +------------------+              +------------------------+
     | ai-sdr-agent     |              | validate.md            |
     | (9am + 3pm)      |              | research.md            |
     |                  | loads modes  | outreach.md            |
     | ai-sdr-followup  | on demand    | followup.md            |
     | (10am daily)     +------------->+ analytics.md           |
     |                  |              | batch.md               |
     | ai-sdr-analytics |              +------------------------+
     | (Mon 8am)        |                        |
     +---------+--------+                        |
               |                                 v
               v                    +------------+---------+
     +---------+---------+          | data/                |
     | Google Sheets     +--Chrome->| staging/             |
     | (accounts/        |          | run-history.tsv      |
     |  prospects)       |          | analytics/           |
     +-------------------+          +----------+-----------+
                                               |
                                               v
                                    +----------+-----------+
                                    | External APIs        |
                                    | ZeroBounce           |
                                    | Smartlead            |
                                    | HeyReach             |
                                    | Notion (via MCP)     |
                                    +----------------------+
```

### Router + Mode Injection Pattern
The scheduled tasks (`ai-sdr-agent`, `ai-sdr-followup`, `ai-sdr-analytics`) are thin routers. They execute a fixed sequence: init check → load context → execute modes. All domain logic lives in `modes/`. This makes modes independently testable and updatable without touching the schedulers.

### Layered Context with Override Semantics
- **`modes/_shared.md`** — system layer: ICP criteria, scoring, NEVER/ALWAYS rules, tool policies. Auto-updatable via `git pull`.
- **`modes/_config.md`** — user layer: your company identity, outreach voice, vertical priorities, exclusions. Never overwritten. Always wins over `_shared.md` defaults.

### TSV-First State Management
Agents never write directly to Notion or the main run history during processing. They write to `data/staging/accounts/{domain}.tsv` and `data/staging/prospects/{email}.tsv`. The final Notion push and `run-history.tsv` append happen at the end of the run. This prevents partial writes and data loss on crash.

### Three-Tier Tool Fallback
For any web content extraction:
1. **Chrome/Playwright** (primary) — SPAs, authenticated pages, Google Sheets
2. **WebFetch** (fallback) — static pages, company websites
3. **WebSearch** (last resort) — broad discovery, cached data

Rule: If Tier 1 fails, try Tier 2. If Tier 2 fails, try Tier 3. Never silently skip.

### Score Gates

| Account Score | Action |
|---------------|--------|
| >= 4.0 | Full pipeline: research + outreach + email validation + Smartlead push |
| 3.0 – 3.9 | Research only: log findings to Notion with "Maybe" status |
| < 3.0 | Skip: log as "No" with reason |

---

## How It Works — End-to-End Example

### Input (Google Sheet row)

| Company Name | Domain | First Name | Last Name | Job Title | Email | LinkedIn |
|---|---|---|---|---|---|---|
| Acme Hotels Group | acmehotels.com | Sarah | Chen | VP of Guest Experience | sarah.chen@acmehotels.com | linkedin.com/in/sarahchen |

### Phase 1: Account ICP Validation

The agent loads `modes/validate.md` and researches `acmehotels.com`:
- 1,200 employees across 15 properties
- ~$180M annual revenue
- Uses Oracle Hospitality PMS + Salesforce CRM
- Recently launched a guest satisfaction initiative

**Score calculation:**
- Firmographic: 5 (clean Hospitality fit: 1,200 emp, $180M rev)
- Technographic: 5 (Oracle Hospitality + Salesforce = full match)
- Pain signal: 4 (active CX initiative found)
- Vertical match: 5 (unambiguous Hospitality)
- **Global: 4.75** → `Yes – Hospitality – multi-property chain, 1.2K employees, $180M revenue, Oracle Hospitality + Salesforce`

Written to `data/staging/accounts/acmehotels.com.tsv`, then pushed to Notion SDR Accounts.

### Phase 2: Prospect Research (modes/research.md)

The agent researches Sarah Chen:
- Promoted to VP of Guest Experience 8 months ago
- Spoke at HospitalityTech Conference on "Measuring What Matters in Guest Feedback"
- Company recently expanded to 3 new locations
- Industry trend: 72% of hospitality brands plan to increase CX tech spend

**Pain points identified (Hospitality vertical, referencing her specific situation):**
1. Tracking guest satisfaction across 15+ properties using Oracle Hospitality, with independent post-stay surveys per property causing a 4-6 week lag in identifying service quality trends
2. Post-stay survey response rates below industry benchmarks (hospitality avg 12-18%)
3. Lack of real-time guest sentiment data for operational decisions at property level

**Classification:** Decision Maker (VP title + guest experience budget authority)
**Research quality:** High (3/3: career + activity + company news)

### Phase 3: Outreach Generation (modes/outreach.md)

**Email 1 — Recent Activity Hook**

> **Subject:** Following up on your HospitalityTech talk
>
> The panel on measuring guest feedback at HospitalityTech raised a point that resonated — standardizing satisfaction metrics across properties with different guest profiles is one of the hardest problems in multi-property hospitality.
>
> At Sogolytics, we've helped hotel groups similar to Acme consolidate guest feedback from post-stay surveys, in-app ratings, and frontline staff inputs into a single real-time dashboard. Properties see a 40% lift in survey response rates when feedback is embedded naturally into the guest journey rather than sent as a standalone email days later.
>
> Would it make sense to do a 15-minute walkthrough of how this looks for a 15-property group? Happy to tailor it to the specific challenges you raised at the conference.

**Email 2 — Company/Industry Hook**

> **Subject:** Guest experience at scale — the 15-property challenge
>
> Acme Hotels' expansion to 18 properties is impressive, especially maintaining brand consistency across that footprint. The industry data backs up the challenge: properties added in the last 12 months typically score 15-20% lower on guest satisfaction until feedback systems catch up.
>
> Sogolytics gives multi-property hospitality brands a unified experience management layer — real-time NPS tracking by property, automated post-stay surveys that adapt based on guest segment, and compliance reporting that rolls up across the entire portfolio in minutes, not days.
>
> I'd love to show you how other hotel groups at your scale have closed the gap between new and established properties. Open for a quick call this week?

**Email 3 — Peer/Competitive Hook**

> **Subject:** How mid-market hotel groups are closing the CX gap
>
> Hotel groups between 10-25 properties are at an inflection point — too large for manual guest feedback tracking, but not yet at the scale where enterprise CX platforms make financial sense. The ones pulling ahead are using purpose-built experience management tools that deliver the depth without the overhead.
>
> Sogolytics sits in that sweet spot for hospitality. Multi-property dashboards, guest journey mapping, and satisfaction benchmarking that works out of the box with Oracle Hospitality and Salesforce — no 6-month implementation.
>
> Would you be open to seeing how this compares to what Acme is using today? I can put together a 15-minute demo tailored to your setup.

**LinkedIn Connection Request** (294 chars):
> Enjoyed your panel at HospitalityTech on measuring guest feedback across multi-property groups — the point about standardizing metrics while respecting each property's unique guest profile was spot on. Would love to connect and exchange notes on CX measurement in hospitality.

**LinkedIn Follow-up** (487 chars):
> Thanks for connecting. Given Acme's recent expansion, thought you might find this relevant — we've been helping hotel groups similar to yours unify guest feedback across properties into real-time dashboards that work with Oracle Hospitality and Salesforce. Happy to share how it looks if useful.

### Phase 4: Email Validation + Smartlead Push

```
ZeroBounce: sarah.chen@acmehotels.com → status: "valid"
Smartlead POST: 200 OK
```

### Phase 5: Notion Log

New row in SDR Prospects database with all 21 fields populated.

### Phase 6 (2 days later): Follow-up

The `ai-sdr-followup` agent checks Smartlead stats. Sarah hasn't opened any emails. She gets pushed to HeyReach with the pre-generated LinkedIn messages. Notion updates: `Smartlead Status = No Response`, `HeyReach Status = Pushed`.

### Phase 7 (weekly): Analytics

The `ai-sdr-analytics` agent runs every Monday. After 20+ prospects, it generates a pipeline report showing: funnel conversion, vertical performance comparison, blocker analysis, and 5 ranked recommendations.

---

## Setup

### Prerequisites
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed
- Chrome with [Claude in Chrome](https://chromewebstore.google.com/detail/claude-in-chrome) extension
- Notion MCP connector configured in Claude Code
- API keys for ZeroBounce, Smartlead, HeyReach

### 1. Clone

```bash
git clone https://github.com/mothivenkatesh/ai-sdr-agent.git ~/Documents/sdr-agent
cd ~/Documents/sdr-agent
```

### 2. Configure environment

```bash
cp .env.example .env
```

Edit `.env` with your keys:

```bash
# Google Sheets
GOOGLE_SHEET_ID=your_sheet_id
GOOGLE_SHEET_URL=https://docs.google.com/spreadsheets/d/YOUR_ID/edit

# ZeroBounce
ZEROBOUNCE_API_KEY=your_key

# Smartlead
SMARTLEAD_API_KEY=your_key
SMARTLEAD_CAMPAIGN_ID=your_campaign_id

# HeyReach
HEYREACH_API_KEY=your_key
HEYREACH_LIST_ID=your_list_id

# Notion
NOTION_ACCOUNTS_DB_ID=your_db_id
NOTION_ACCOUNTS_DATASOURCE=your_datasource_id
NOTION_PROSPECTS_DB_ID=your_db_id
NOTION_PROSPECTS_DATASOURCE=your_datasource_id
NOTION_PARENT_PAGE=your_parent_page_id
```

### 3. Customize your config (optional but recommended)

```bash
cp modes/_config.template.md modes/_config.md
```

Edit `modes/_config.md` with your:
- Company identity and product names
- Outreach voice (tone, formality, word limits)
- Vertical priorities
- Exclusions (competitors, active deals)
- Custom proof points per vertical
- Score threshold overrides

This file is gitignored — it's yours, never overwritten by `git pull`.

### 4. Run the init check

```bash
./scripts/init-check.sh
```

Expected output:
```
=== AI SDR Agent Init Check ===
[1/6] Checking .env... OK
[2/6] Checking _config.md... OK
[3/6] Checking staging directories... OK
[4/6] Checking run history... OK
[5/6] Testing ZeroBounce API... OK
[6/6] Testing Smartlead API... OK
=== Result: 0 errors, 0 warnings ===
```

Fix any errors before proceeding.

### 5. Install scheduled tasks

Copy the skill files to your Claude Code scheduled tasks directory:

```bash
mkdir -p ~/.claude/scheduled-tasks/ai-sdr-agent
mkdir -p ~/.claude/scheduled-tasks/ai-sdr-followup
mkdir -p ~/.claude/scheduled-tasks/ai-sdr-analytics

cp skills/ai-sdr-agent.md ~/.claude/scheduled-tasks/ai-sdr-agent/SKILL.md
cp skills/ai-sdr-followup.md ~/.claude/scheduled-tasks/ai-sdr-followup/SKILL.md
cp skills/ai-sdr-analytics.md ~/.claude/scheduled-tasks/ai-sdr-analytics/SKILL.md
```

Or create them through Claude Code using the `mcp__scheduled-tasks__create_scheduled_task` tool with the prompts from the skill files.

### 6. Create Notion databases

In Claude Code, ask:
> Create two Notion databases for the AI SDR agent: SDR Accounts (Company Name, Domain, ICP Status, ICP Reason, Vertical Match, Processed Date) and SDR Prospects (all fields for prospect tracking with email variants, LinkedIn messages, Smartlead/HeyReach status).

Then update your `.env` with the new database IDs.

### 7. First run (important)

Run the agent manually once to pre-approve tool permissions:

1. Open Claude Code
2. Go to **Scheduled** section in the sidebar
3. Click **Run now** on `ai-sdr-agent`
4. Approve Chrome, Bash, WebSearch, and Notion tool permissions when prompted

This stores the permissions on the task so future automated runs don't pause waiting for approval.

---

## Usage

### Scheduled runs (automatic)

| Task | Cron | When | What It Does |
|---|---|---|---|
| `ai-sdr-agent` | `0 9,15 * * *` | 9 AM + 3 PM daily | Full pipeline: read sheets → validate → research → outreach → push |
| `ai-sdr-followup` | `0 10 * * *` | 10 AM daily | Check Smartlead non-responders → push to HeyReach |
| `ai-sdr-analytics` | `0 8 * * 1` | Monday 8 AM | Weekly pipeline report + recommendations |

### Manual runs

From Claude Code:

```
Run the ai-sdr-agent task now
```

Or click "Run now" in the Scheduled section of the sidebar.

### On-demand analytics

```
Run the ai-sdr-analytics task now to see this week's pipeline report
```

### Processing a specific prospect

```
Run the ai-sdr-agent but only process this prospect: Sarah Chen, VP Guest Experience, Acme Hotels, sarah.chen@acmehotels.com
```

Claude will load `modes/validate.md`, `modes/research.md`, and `modes/outreach.md`, skip the sheet read, and process just that prospect.

### Batch mode (for 5+ prospects)

```
Run the ai-sdr-agent in batch mode with 3 parallel workers
```

Claude will load `modes/batch.md` and spawn workers using `run_in_background`.

---

## File Structure

```
ai-sdr-agent/
  .env.example              # API key template
  .env                      # Your keys (gitignored)
  .gitignore
  README.md                 # This file
  SETUP.md                  # Detailed setup walkthrough
  ARCHITECTURE.md           # Deep dive into the router + mode design
  CUSTOMIZATION.md          # How to adapt to your company/product

  modes/
    _shared.md              # System: ICP criteria, scoring, NEVER/ALWAYS rules
    _config.template.md     # User config template
    _config.md              # Your user config (gitignored)
    validate.md             # Mode: account ICP validation
    research.md             # Mode: prospect deep research
    outreach.md             # Mode: email + LinkedIn generation
    followup.md             # Mode: non-responder follow-up
    analytics.md            # Mode: pipeline performance analysis
    batch.md                # Mode: parallel worker batch processing

  skills/
    ai-sdr-agent.md         # Main scheduled task: full pipeline
    ai-sdr-followup.md      # Daily: check non-responders
    ai-sdr-analytics.md     # Weekly: pipeline analytics

  scripts/
    init-check.sh           # Pre-run validation (env, config, APIs)

  data/
    run-history.tsv         # Append-only run log
    staging/
      accounts/             # Pre-Notion staging for accounts
      prospects/            # Pre-Notion staging for prospects
    batch-logs/             # Per-worker logs from batch mode
    analytics/              # Weekly report markdown files
```

---

## ICP Verticals

The agent validates accounts against 8 target verticals. All criteria must match for a "Yes" verdict (score >= 4.0).

| # | Vertical | Employees | Revenue | Required Tech Signals | Product Fit |
|---|----------|-----------|---------|----------------------|-------------|
| 1 | HR / Employee Experience | 500–5K | $50M–$1B+ | HRIS (Workday, SAP, BambooHR, ADP) OR engagement (Qualtrics, Glint, CultureAmp, Peakon) | SogoEX + SogoCore |
| 2 | K-12 & Universities | 500–3K staff | $50M–$500M | LMS (Blackboard, Canvas, Moodle), CRM (Salesforce Ed Cloud, Ellucian) | SogoCore + SogoEX |
| 3 | Technology / Cloud | 200–2.5K | $30M–$500M | CRM (Salesforce, HubSpot), CS (Gainsight, Totango), analytics | SogoCX + SogoCore |
| 4 | Travel & Aviation | 1K–10K+ | $500M–$5B+ | CRM (Salesforce, Sabre, Amadeus), loyalty (Oracle CX) | SogoCX + SogoEX |
| 5 | Hospitality | 500–3K | $50M–$500M | PMS (Oracle Hospitality, Cloudbeds), CRM (Salesforce, Zoho) | SogoCX + SogoEX |
| 6 | Fitness Chains | 200–2K | $20M–$200M | CRM (Mindbody, Zen Planner), survey tools | SogoCX + SogoEX |
| 7 | Hotels & Restaurants | 500–3K | $50M–$500M | POS/PMS (Toast, Oracle), CRM (Salesforce, HubSpot) | SogoCX + SogoEX |
| 8 | Banking & Finance | 1K–10K | $500M–$5B+ | Core banking (FIS, Fiserv, Temenos), CRM (Salesforce, nCino) | SogoCX + SogoEX + SogoCore |

---

## NEVER / ALWAYS Rules

Hardcoded safety rails in `modes/_shared.md`.

### NEVER
1. Invent company data (state "Not publicly available" instead)
2. Fabricate prospect activity (state "No recent activity found")
3. Use "Dear" or "Hi [Name]" in email openings
4. Include closing signatures
5. Push invalid emails to Smartlead
6. Process more than 10 accounts or 5 prospects per run
7. Skip the init check
8. Send outreach without ZeroBounce validation
9. Edit `run-history.tsv` mid-run (append once at end)
10. Use corporate-speak: leveraged, spearheaded, synergies, robust, seamless, cutting-edge, passionate about, excited to

### ALWAYS
1. Run init check at start of every run
2. Read `_config.md` before generating any outreach
3. Use WebSearch for company research (don't infer from domain)
4. Write prospect data to staging TSV first, then push to Notion
5. Log every run to `run-history.tsv`
6. Check run history + Notion for dedup before processing
7. Continue on single-item failures (don't abort the whole run)
8. Output a run summary at the end
9. Use the three-tier fallback for web content
10. Generate content in English unless prospect's LinkedIn is in another language

---

## Customization

See [CUSTOMIZATION.md](CUSTOMIZATION.md) for details.

**Quick customization via `_config.md`:**
- Change company identity and product names
- Adjust outreach voice (tone, formality, word limits)
- Reorder vertical priorities
- Add exclusion lists (competitors, active deals)
- Override score thresholds
- Add custom proof points per vertical

**Deep customization (edit `modes/_shared.md`):**
- Change ICP verticals
- Modify scoring weights
- Add/remove pain point definitions
- Change tool fallback order

**Add a new outreach channel:**
- Add a new mode file (e.g., `modes/twitter.md`)
- Reference it in the main scheduled task prompt
- Agents can make any REST API call via `curl`

---

## Analytics Example

After 20+ prospects, the weekly analytics report looks like:

```
# AI SDR Pipeline Report — 2026-04-13

## Summary
- Accounts evaluated: 127
- ICP Yes rate: 34% (Yes: 43, Maybe: 18, No: 66)
- Prospects researched: 65
- Emails validated: 58 (valid: 47, catch-all: 6, invalid: 5)
- Smartlead pushed: 53
- Response rate: 11% (6 replies)
- LinkedIn connect rate: 23% (12 connections of 52 sent)

## Vertical Performance
| Vertical | Accts | ICP% | Prospects | Email Valid% | Response% |
|----------|-------|------|-----------|--------------|-----------|
| Technology | 34 | 44% | 18 | 94% | 17% |
| Banking | 21 | 52% | 14 | 100% | 14% |
| Hospitality | 19 | 37% | 11 | 82% | 9% |
| HR | 25 | 28% | 9 | 89% | 11% |
| Others | 28 | 18% | 13 | 77% | 0% |

## Top 3 Recommendations
1. [HIGH IMPACT] Lower Technology ICP threshold to 3.5
   Evidence: 80% of 3.5-3.9 Tech accounts converted in trial run.
   Action: Update `min_score_full_pipeline: 3.5` for Technology in _config.md

2. [HIGH IMPACT] Reprioritize Banking to #1
   Evidence: 2x response rate vs average, 100% email validity.
   Action: Move Banking to top of priority_verticals in _config.md

3. [MEDIUM IMPACT] Drop Fitness vertical
   Evidence: 0% response rate across 8 prospects, all below revenue floor.
   Action: Remove Fitness from priority_verticals, add to excluded_verticals
```

---

## Origin

Converted from a 25-node n8n workflow (`AI SDR Workflow`) that used OpenAI GPT-4.1-mini for ICP validation and prospect research, with Google Sheets as storage, ZeroBounce/Smartlead/HeyReach for outreach.

**v1** (first conversion): Straight port of the workflow into a single Claude Code skill.

**v2** (current): Refactored using patterns from [santifer/career-ops](https://github.com/santifer/career-ops):
- Router + mode injection architecture
- Shared system layer (`_shared.md`) vs user config layer (`_config.md`)
- TSV-first state management for crash safety
- Score-gated pipeline (don't waste effort on low-quality leads)
- Three-tier tool fallback (Chrome → WebFetch → WebSearch)
- Session initialization check
- Weekly self-analyzing analytics mode
- Explicit NEVER/ALWAYS rules
- Parallel batch processing with worker isolation

---

## Further Reading

- [SETUP.md](SETUP.md) — Detailed setup walkthrough with Notion database schemas
- [ARCHITECTURE.md](ARCHITECTURE.md) — Deep dive into the router + mode design and why it works
- [CUSTOMIZATION.md](CUSTOMIZATION.md) — How to adapt the agent to your company, product, and ICP

---

## License

MIT
