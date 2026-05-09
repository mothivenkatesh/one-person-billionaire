# Setup Guide

Complete walkthrough for getting the AI SDR agent running end-to-end.

---

## Prerequisites

### Required
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed and working
- [Chrome](https://www.google.com/chrome/) with the [Claude in Chrome](https://chromewebstore.google.com/detail/claude-in-chrome) extension
- A Notion workspace where you can create databases
- Bash shell (macOS/Linux default, WSL on Windows)

### API Keys You'll Need
| Service | Sign up | What For |
|---------|---------|----------|
| [ZeroBounce](https://www.zerobounce.net/) | Free trial, then $16/mo | Email validation |
| [Smartlead](https://www.smartlead.ai/) | From $39/mo | Email outreach campaigns |
| [HeyReach](https://heyreach.io/) | From $79/mo | LinkedIn outreach automation |

---

## Step 1: Install the Plugin

**Recommended (marketplace):**

```bash
claude plugin marketplace add mothivenkatesh/MStack
claude plugin install ai-sdr@MStack
```

The plugin is installed read-only into Claude Code's plugin directory. Skill files reference `${CLAUDE_PLUGIN_ROOT}` so they resolve correctly at runtime.

**Then create the user-data dir** (this is where your `.env`, run history, and staging files live — separate from the read-only plugin install):

```bash
mkdir -p ~/Documents/sdr-agent/{data/staging,data/analytics,data/batch-logs,modes}
```

**Or, for development (standalone clone):**

```bash
git clone https://github.com/mothivenkatesh/MStack.git
cd MStack/plugins/ai-sdr
# Then symlink ~/Documents/sdr-agent to this dir, OR keep data dirs separate as above.
```

If you prefer a different location, update all paths in `scripts/init-check.sh` and the scheduled task prompts to match.

---

## Step 2: Create Notion Databases

### Option A: Ask Claude Code to do it

In Claude Code, paste:

> Create two Notion databases under a new page called "AI SDR Agent":
>
> **SDR Accounts** with properties:
> - Company Name (title)
> - Domain (URL)
> - ICP Status (select: Yes/green, No/red, Maybe/yellow)
> - ICP Reason (rich text)
> - Vertical Match (select: HR, Education, Technology, Travel & Aviation, Hospitality, Fitness, Restaurants, Banking & Finance)
> - Processed Date (date)
>
> **SDR Prospects** with properties:
> - Prospect Name (title)
> - Company (rich text)
> - Email (email)
> - Email Status (select: valid/green, invalid/red, catch-all/yellow, unknown/gray)
> - Job Title (rich text)
> - LinkedIn URL (url)
> - ICP Vertical (select: same 8 verticals as accounts)
> - Classification (select: Decision Maker, Influencer, Manager)
> - Research Summary (rich text)
> - Pain Points (rich text)
> - Email 1 Subject / Email 1 Body (rich text, rich text)
> - Email 2 Subject / Email 2 Body (rich text, rich text)
> - Email 3 Subject / Email 3 Body (rich text, rich text)
> - LinkedIn Connection Request (rich text)
> - LinkedIn Follow-up (rich text)
> - Smartlead Status (select: Pending, Pushed, Responded, No Response)
> - HeyReach Status (select: Not Sent, Pushed, Connected)
> - Processed Date (date)
>
> After creating, return the database IDs and data source IDs for both.

Claude will create them and give you the IDs.

### Option B: Manual creation

1. Create a new Notion page called "AI SDR Agent"
2. Inside, create two inline databases with the schemas above
3. Get their IDs from the URL (the UUID after the last `/`)

---

## Step 3: Configure `.env`

```bash
cp .env.example .env
```

Edit `.env` with your keys:

```bash
# Google Sheets — URL of your accounts + prospects sheet
GOOGLE_SHEET_ID=1luVwwXra6DGV5Dvupd0bNDexIesMoz74fhhTq6wzxcE
GOOGLE_SHEET_URL=https://docs.google.com/spreadsheets/d/YOUR_SHEET_ID/edit

# ZeroBounce — get from https://www.zerobounce.net/app/apikey
ZEROBOUNCE_API_KEY=your_zerobounce_key

# Smartlead — get from Settings → API
SMARTLEAD_API_KEY=your_smartlead_key
SMARTLEAD_CAMPAIGN_ID=your_campaign_id

# HeyReach — get from Settings → API
HEYREACH_API_KEY=your_heyreach_key
HEYREACH_LIST_ID=your_list_id

# Notion — from step 2
NOTION_ACCOUNTS_DB_ID=your_db_id
NOTION_ACCOUNTS_DATASOURCE=your_datasource_id
NOTION_PROSPECTS_DB_ID=your_db_id
NOTION_PROSPECTS_DATASOURCE=your_datasource_id
NOTION_PARENT_PAGE=your_parent_page_id
```

---

## Step 4: Create Your Google Sheet

Create a Google Sheet with two tabs:

### Tab 1: "Accounts" (gid=0)

| Company Name | Domain |
|---|---|
| Acme Hotels Group | acmehotels.com |
| TechCorp Inc | techcorp.com |

### Tab 2: "Prospects"

| First Name | Last Name | Email Address | Job Title | Company Name | LinkedIn Contact Profile URL | LinkedIn Company Profile URL |
|---|---|---|---|---|---|---|
| Sarah | Chen | sarah.chen@acmehotels.com | VP of Guest Experience | Acme Hotels Group | linkedin.com/in/sarahchen | linkedin.com/company/acmehotels |

Update `GOOGLE_SHEET_URL` in `.env` to your sheet's URL.

---

## Step 5: Customize Your Config

```bash
cp modes/_config.template.md modes/_config.md
```

Edit `modes/_config.md` to match your company:

```yaml
company_name: YourCompany
product_names:
  - YourProduct1
  - YourProduct2
website: https://yourcompany.com
one_liner: "One sentence about what you sell"

tone: conversational-professional
max_email_words: 150

priority_verticals:
  - Technology
  - Banking & Finance
  # ... reorder to match your ICP
```

This file is gitignored. Your customizations survive `git pull`.

---

## Step 6: Run Init Check

```bash
chmod +x scripts/init-check.sh
./scripts/init-check.sh
```

Expected output:

```
=== AI SDR Agent Init Check ===
Timestamp: 2026-04-10T14:30:00Z

[1/6] Checking .env... OK: All required keys present
[2/6] Checking _config.md... OK: _config.md found
[3/6] Checking staging directories... OK: Staging directories ready
[4/6] Checking run history... OK: Created run-history.tsv with headers
[5/6] Testing ZeroBounce API... OK: ZeroBounce API reachable
[6/6] Testing Smartlead API... OK: Smartlead API reachable

=== Result: 0 errors, 0 warnings ===
```

**If you get errors**, fix them before proceeding. Common issues:
- `FAIL: ZEROBOUNCE_API_KEY is empty or missing` → Check `.env`
- `WARN: ZeroBounce API returned 401` → Invalid API key
- `WARN: Smartlead API returned 404` → Wrong campaign ID

---

## Step 7: Install Scheduled Tasks

### Option A: Via Claude Code (recommended)

In Claude Code, paste:

> Create three scheduled tasks based on the skill files in ~/Documents/sdr-agent/skills/:
>
> 1. ai-sdr-agent — runs at 9am and 3pm daily (cron: `0 9,15 * * *`)
> 2. ai-sdr-followup — runs at 10am daily (cron: `0 10 * * *`)
> 3. ai-sdr-analytics — runs Mondays at 8am (cron: `0 8 * * 1`)
>
> Use the full prompt contents from each skill file.

### Option B: Manual file copy

```bash
mkdir -p ~/.claude/scheduled-tasks/ai-sdr-agent
mkdir -p ~/.claude/scheduled-tasks/ai-sdr-followup
mkdir -p ~/.claude/scheduled-tasks/ai-sdr-analytics

cp skills/ai-sdr-agent.md ~/.claude/scheduled-tasks/ai-sdr-agent/SKILL.md
cp skills/ai-sdr-followup.md ~/.claude/scheduled-tasks/ai-sdr-followup/SKILL.md
cp skills/ai-sdr-analytics.md ~/.claude/scheduled-tasks/ai-sdr-analytics/SKILL.md
```

Then add them to Claude Code's scheduler via the Scheduled sidebar or the `mcp__scheduled-tasks__create_scheduled_task` tool.

---

## Step 8: Pre-approve Tool Permissions

The first run needs manual approval for each tool. Pre-approve them now:

1. Open Claude Code
2. Click **Scheduled** in the sidebar
3. Find `ai-sdr-agent`
4. Click **Run now**
5. Approve permissions as they appear:
   - Bash (for `curl` and init check)
   - Chrome (for Google Sheets reading)
   - WebSearch (for company research)
   - Notion MCP (for database writes)

Approvals are stored on the task. Future automated runs won't pause.

Repeat for `ai-sdr-followup` and `ai-sdr-analytics`.

---

## Step 9: Verify

After the first run completes, check:

1. **Notion SDR Accounts database** — should have new rows for processed accounts
2. **Notion SDR Prospects database** — should have new rows with email variants and LinkedIn messages
3. **Smartlead campaign** — new leads should appear with custom fields populated
4. **`data/run-history.tsv`** — should have an entry for the run
5. **`data/staging/`** — should contain TSV files for each processed item

---

## Troubleshooting

### "init-check.sh: command not found"
```bash
chmod +x scripts/init-check.sh
```

### "Chrome tab not accessible"
- Make sure Chrome is running
- Make sure "Claude in Chrome" extension is installed and enabled
- Try clicking the extension icon to grant permissions

### "Notion MCP not available"
- Make sure the Notion MCP connector is installed in Claude Code
- Check Settings → Connectors → Notion

### "ZeroBounce 401"
- Double-check your API key in `.env`
- Verify you have credits remaining at https://www.zerobounce.net/app/dashboard

### "Smartlead 404 campaign not found"
- Log into Smartlead and get the correct campaign ID from the URL
- Update `SMARTLEAD_CAMPAIGN_ID` in `.env`

### "Scheduled task didn't run automatically"
- Make sure Claude Code is running (the scheduler only fires when Claude Code is active)
- Check the Scheduled section in the sidebar for next run time
- Check the task's logs for approval prompts that weren't responded to

### "Agent is inventing company data"
- This should not happen — check that `modes/_shared.md` is being loaded
- Verify the NEVER rules are present in the shared file
- If it persists, add stronger wording to the task prompt: "You MUST NOT invent any company data. If web research is inconclusive, state 'Not publicly available'"

---

## Next Steps

- Read [ARCHITECTURE.md](ARCHITECTURE.md) to understand how modes work
- Read [CUSTOMIZATION.md](CUSTOMIZATION.md) to adapt the agent to your product
- Let the agent run for a week, then check the analytics report to see how it's performing
- Tune `modes/_config.md` based on analytics recommendations
