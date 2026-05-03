# Mode: Pipeline Analytics

> Runs weekly (or on-demand). Analyzes pipeline performance and recommends adjustments.
> Minimum data gate: 20+ prospects processed before analysis runs.

---

## Process

### Step 1: Data Collection

Read from Notion SDR databases:

**Accounts:**
- Total accounts processed
- ICP Yes / No / Maybe breakdown
- Score distribution (1-5)
- Vertical distribution

**Prospects:**
- Total prospects processed
- Email validation rates (valid / invalid / catch-all)
- Smartlead statuses (Pushed / Responded / No Response)
- HeyReach statuses (Not Sent / Pushed / Connected)
- Vertical distribution
- Classification distribution (DM / Influencer / Manager)

### Step 2: Funnel Analysis

Calculate conversion rates at each stage:

```
Accounts Evaluated → ICP Yes → Prospects Researched → Emails Valid → Smartlead Pushed → Responded → HeyReach Pushed → Connected
```

For each transition, calculate:
- Conversion rate (%)
- Average time between stages
- Drop-off rate and top reasons

### Step 3: Vertical Performance

| Vertical | Accounts | ICP Yes % | Prospects | Email Valid % | Response Rate | LinkedIn Connect % |
|----------|----------|-----------|-----------|---------------|---------------|-------------------|

Identify:
- **Best vertical**: Highest end-to-end conversion
- **Worst vertical**: Lowest conversion — recommend dropping or adjusting criteria
- **Highest volume**: Most accounts processed
- **Best ROI**: Highest response rate per prospect processed

### Step 4: Outreach Performance

Compare email variant effectiveness (if Smartlead provides variant-level stats):
- Which hook type gets the most opens?
- Which hook type gets the most replies?
- Are certain verticals more responsive to certain hooks?

Compare channel effectiveness:
- Email-only response rate
- Email + LinkedIn response rate
- LinkedIn-only connection rate

### Step 5: Blocker Analysis

Identify common blockers:
- Top reasons for ICP "No" verdicts
- Top reasons for email validation failure
- Top reasons for no Smartlead response
- Common patterns in non-responders (title, vertical, company size)

### Step 6: Recommendations

Generate 5 actionable recommendations ranked by expected impact:

```
| # | Recommendation | Impact | Effort | Evidence |
|---|---------------|--------|--------|----------|
```

**Types of recommendations:**
- Adjust ICP score thresholds (e.g., "Lower Technology threshold to 3.5 — 80% of 3.5+ Tech accounts convert")
- Reprioritize verticals (e.g., "Move Banking to #1 priority — 2x response rate vs average")
- Adjust outreach (e.g., "Activity Hook underperforms for HR — switch to Industry Hook as Email 1")
- Exclude segments (e.g., "Fitness chains under $50M never respond — raise revenue floor")
- Process more per run (e.g., "Error rate is 2% — safe to increase from 5 to 8 prospects/run")

### Step 7: Output

Write report to `data/analytics/{YYYY-MM-DD}-pipeline-report.md`.

If recommendations include config changes, offer to update `_config.md`:
- Vertical priority reordering
- Score threshold adjustments
- Exclusion list additions

**NEVER modify `_shared.md` from analytics.** Only `_config.md` is user-modifiable.

---

## Minimum Data Gates

| Analysis | Minimum Data Required |
|----------|--------------------|
| Funnel analysis | 20 prospects processed |
| Vertical comparison | 5+ prospects per vertical being compared |
| Outreach variant comparison | 15+ emails sent per variant |
| Blocker analysis | 10+ blocked/failed entries |
| Recommendations | 20+ prospects + 5+ in post-email status |

If minimum data is not met, output: "Insufficient data for [analysis]. Need X more [items]. Current: Y."
