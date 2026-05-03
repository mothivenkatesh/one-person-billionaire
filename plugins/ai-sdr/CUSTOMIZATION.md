# Customization Guide

How to adapt the AI SDR agent to your company, product, and ICP.

---

## Two Layers of Customization

| Layer | File | When to Touch | Git Behavior |
|-------|------|---------------|--------------|
| User config | `modes/_config.md` | Always (your company info) | Gitignored — your file, your rules |
| System config | `modes/_shared.md` | Only for deep changes | Tracked — updatable via `git pull` |

**Start with `_config.md`.** 90% of customizations live here. Only edit `_shared.md` for structural changes (new verticals, different scoring weights).

---

## Quick Customization (`_config.md`)

Copy the template:
```bash
cp modes/_config.template.md modes/_config.md
```

### Company Identity

```yaml
company_name: Sogolytics
product_names:
  - SogoCX (Customer Experience)
  - SogoEX (Employee Experience)
  - SogoCore (Survey Platform)
website: https://www.sogolytics.com
one_liner: "Experience management platform for enterprises"
```

**Where this shows up:** Every generated email and LinkedIn message. The agent uses `company_name` and `product_names` to compose outreach, and falls back to `one_liner` when it needs a short description.

### Outreach Voice

```yaml
tone: conversational-professional
formality: medium
humor: none
max_email_words: 150
max_linkedin_words: 75
```

**Options:**
- `tone`: `conversational-professional` | `direct-executive` | `technical-peer`
- `formality`: `low` | `medium` | `high`
- `humor`: `none` | `light` | `moderate`

**Example:**
```yaml
# For a technical product selling to engineers
tone: technical-peer
formality: low
humor: light
max_email_words: 100  # Engineers prefer shorter
```

### Vertical Priorities

```yaml
priority_verticals:
  - Technology
  - Banking & Finance
  - HR
  - Education
  - Hospitality
  - Travel & Aviation
  - Restaurants
  - Fitness
```

**Effect:** When multiple accounts qualify in the same run, higher-priority verticals are processed first. When an account could fit 2+ verticals, the highest priority wins.

### Exclusions

```yaml
excluded_domains:
  - hubspot.com     # Direct competitor
  - qualtrics.com   # Direct competitor
  - microsoft.com   # Too large / enterprise sales team handles

excluded_titles:
  - Intern
  - Junior
  - Assistant
  - Trainee
  - Student

active_deal_domains:
  - acme-corp.com   # Already in negotiation, avoid SDR/AE conflict
  - beta-inc.com
```

**Effect:** The agent skips any account/prospect matching these lists before processing (saves research budget).

### Score Overrides

```yaml
min_score_full_pipeline: 3.5   # Default: 4.0
min_score_research_only: 2.5   # Default: 3.0
```

**When to lower:**
- You're in a high-funnel testing phase and want more volume
- Analytics shows 3.5+ accounts converting well
- Your product has broad horizontal applicability

**When to raise:**
- Email deliverability is suffering from low-quality leads
- You're at capacity and need to focus on best-fit only
- Analytics shows <4.0 accounts have 0% conversion

### Smartlead Campaign Mapping

```yaml
campaign_overrides:
  Technology: 2626058
  Banking & Finance: 2626059
```

**Effect:** Route different verticals to different Smartlead campaigns (useful if you have vertical-specific email copy or sending infrastructure).

### Custom Proof Points

```yaml
custom_proof_points:
  Technology:
    - "40% lift in survey response rates for SaaS companies"
    - "Integration with Salesforce and HubSpot in under 2 hours"
    - "Used by Stripe, Notion, and Figma"
  Banking & Finance:
    - "SOC 2 Type II certified, GDPR compliant"
    - "Used by 3 of the top 20 regional banks"
    - "Sub-second response time for 10K+ daily surveys"
  Hospitality:
    - "Deployed at 200+ hotel properties globally"
    - "Works out of the box with Oracle Hospitality and Cloudbeds"
    - "Average 3x lift in post-stay survey completion"
```

**Effect:** Generated emails inject these specific proof points for the matching vertical. Without this, the agent uses generic language.

**Tip:** Keep each proof point under 15 words and include a concrete number.

---

## Deep Customization (`_shared.md`)

Only touch this for structural changes.

### Adding a New Vertical

Example: Adding "Retail" as a 9th vertical.

1. **Edit the ICP Verticals table:**
```markdown
| 9 | Retail & eCommerce | 500–5K | $100M–$1B+ | CRM (Salesforce Commerce, Shopify Plus), CX (Medallia, Qualtrics), POS | SogoCX + SogoCore |
```

2. **Add pain points to the Pain Points table:**
```markdown
| Retail | Customer feedback fragmented across online/in-store channels | Store-level satisfaction hidden in aggregate data | Return rate drivers unclear without exit surveys |
```

3. **Update the Vertical-Adapted Framing table in `outreach.md`:**
```markdown
| Retail | Conversion rate → revenue impact | Omnichannel feedback unification | Store-level customer insight dashboards |
```

4. **Add Retail to Notion database options:**
   - In Notion, add "Retail & eCommerce" as a new option to the `Vertical Match` and `ICP Vertical` select properties
   - Use Claude Code: "Add 'Retail & eCommerce' as a new option to the ICP Vertical select property in the SDR Prospects database"

5. **Add to priority list in `_config.md`:**
```yaml
priority_verticals:
  - Retail & eCommerce   # New
  - Technology
  - # ... rest
```

### Changing Scoring Weights

In `_shared.md`:

```markdown
| Dimension | Weight | What It Measures |
|-----------|--------|-----------------|
| Firmographic fit | 40% |  # Was 30%
| Technographic fit | 20% | # Was 25%
| Pain signal strength | 30% | # Was 25%
| Vertical match | 10% | # Was 20%
```

**When to adjust:**
- **Increase Firmographic** if size is the biggest predictor of deal close
- **Increase Technographic** if integration complexity is a dealbreaker
- **Increase Pain signal** if you have strong market research on buying triggers
- **Decrease Vertical match** if your product is truly horizontal

### Changing NEVER/ALWAYS Rules

Generally, don't remove rules — add to them. If your product has compliance requirements, add:

```markdown
11. **NEVER send outreach to EU prospects without GDPR compliance language.**
12. **ALWAYS include unsubscribe link in email body** (required for CAN-SPAM).
```

---

## Adding a New Mode

Example: Adding Twitter DM outreach as a 4th channel (after email + LinkedIn).

### 1. Create the mode file

```bash
touch modes/twitter.md
```

```markdown
# Mode: Twitter DM Outreach

> Triggered as a fallback after email + LinkedIn don't get a response.

## Inputs
- Prospect name, company, Twitter handle (if available)
- LinkedIn connection status (for mutual context)

## Process

### Step 1: Verify Twitter account
Use WebSearch: `"{prospect name}" "{company}" site:twitter.com`

### Step 2: Generate DM
- Max 280 chars (Twitter limit)
- Reference their most recent tweet
- Bridge to value prop in 1 sentence
- No CTA — just start a conversation

### Step 3: Output
Write to `data/staging/twitter/{handle}.tsv`
```

### 2. Add a Twitter handle field to Notion

Add a new property to the SDR Prospects database: `Twitter Handle` (URL).

### 3. Extend the followup task

Edit `skills/ai-sdr-followup.md` or the `ai-sdr-followup` scheduled task prompt:

```
## Step 6: Twitter Fallback

For prospects with:
- HeyReach Status = "Pushed" 2+ days ago
- Still no LinkedIn connection

Load `modes/twitter.md` and process.
```

### 4. Add a Twitter status column

Add `Twitter Status` select property to SDR Prospects: `Not Sent / Sent / Replied`.

---

## Changing the Schedule

### Via Claude Code

```
Update the ai-sdr-agent scheduled task to run at 8 AM and 2 PM instead of 9 AM and 3 PM
```

Claude will update the cron expression.

### Manual edit

The cron format is standard 5-field:
```
minute hour day-of-month month day-of-week
```

| Schedule | Cron |
|---|---|
| Daily at 9 AM | `0 9 * * *` |
| Twice daily (9 AM, 3 PM) | `0 9,15 * * *` |
| Weekdays only at 10 AM | `0 10 * * 1-5` |
| Every 6 hours | `0 */6 * * *` |
| Mondays at 8 AM | `0 8 * * 1` |
| First of month at midnight | `0 0 1 * *` |

**Pro tip**: Avoid exactly `0 9 * * *` (everyone schedules at 9am sharp, creating API congestion). Use `7 9 * * *` or `13 9 * * *`.

---

## Adjusting Processing Limits

In `modes/_shared.md`, the NEVER rule:
> NEVER process more than 10 accounts or 5 prospects per run.

Change to:
> NEVER process more than 15 accounts or 8 prospects per run.

**Warning**: Don't go above 20 accounts or 10 prospects. Claude's context window can handle it, but:
- API rate limits become a concern
- Research quality degrades (less context per prospect)
- A single failure affects more items

If you need higher throughput, use batch mode (3 parallel workers × 5 prospects = 15/run).

---

## Adding a New Integration

Example: Replacing Smartlead with [Apollo.io](https://apollo.io) for email outreach.

### 1. Add API credentials to `.env`

```bash
APOLLO_API_KEY=your_key
APOLLO_SEQUENCE_ID=your_sequence_id
```

### 2. Add to `scripts/init-check.sh`

```bash
# Add to the list:
required_keys+=("APOLLO_API_KEY" "APOLLO_SEQUENCE_ID")

# Add connectivity test:
echo "[7/7] Testing Apollo API..."
if [[ -n "${APOLLO_API_KEY:-}" ]]; then
    apollo_response=$(curl -s -o /dev/null -w "%{http_code}" "https://api.apollo.io/v1/..." 2>/dev/null || echo "000")
    # ...
fi
```

### 3. Update the main task prompt

Replace the Smartlead push step with:
```bash
curl -s -X POST "https://api.apollo.io/v1/sequences/${APOLLO_SEQUENCE_ID}/contacts" \
  -H "X-Api-Key: ${APOLLO_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{...}'
```

### 4. Update the Notion select options

Change `Smartlead Status` to `Apollo Status` with the same select values (Pending, Pushed, Responded, No Response).

### 5. Update followup task

The followup task also references Smartlead — update it to query Apollo sequence stats instead.

---

## Testing Changes

### Dry run a single prospect

In Claude Code:

```
Load modes/_shared.md, modes/_config.md, modes/validate.md, modes/research.md, and modes/outreach.md.

Process this single test prospect:
- Name: Test User
- Company: Stripe
- Domain: stripe.com
- Job Title: VP of Customer Experience
- Email: test@stripe.com
- LinkedIn: linkedin.com/in/testuser

Run through ICP validation, research, and outreach generation. Show me the output but DO NOT push to Smartlead, Notion, or ZeroBounce.
```

### Validate the init check

```bash
./scripts/init-check.sh
```

All 6 checks should pass.

### Inspect staging files

After a run, check `data/staging/` to see what the agent produced:

```bash
ls -la data/staging/accounts/
ls -la data/staging/prospects/
cat data/staging/prospects/test-at-stripe.tsv
```

---

## Getting Help

- **Bug?** Open an issue on GitHub
- **Analytics showing poor performance?** Let the weekly analytics task run for 2-3 weeks, then read its recommendations
- **Agent behaving oddly?** Check `data/run-history.tsv` for error counts, then check the scheduled task logs in Claude Code
- **Want to contribute a new mode or integration?** PR welcome
