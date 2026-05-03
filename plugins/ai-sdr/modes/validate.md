# Mode: Account ICP Validation

> Triggered by the main SDR agent. Processes accounts from Google Sheets.
> Requires: `_shared.md` + `_config.md` loaded in context.

---

## Inputs
- Company Name (string)
- Domain (string)

## Process

### Step 1: Web Research (mandatory)

Use the three-tier fallback (Chrome → WebFetch → WebSearch) to research the company:

1. Navigate to the company's website (`https://{domain}`)
2. Search for: `"{company_name}" employees revenue funding`
3. Search for: `"{company_name}" technology stack CRM`
4. Check LinkedIn company page if accessible

**Extract and verify from public sources:**
- Industry/sector
- Employee count (range is acceptable)
- Revenue (range is acceptable)
- Funding stage / growth stage
- Core business model and primary target market
- Technology stack (CRM, HRIS, LMS, PMS, analytics, etc.)
- Signals of survey, feedback, or experience management needs

**Do NOT infer from domain or company name alone.** All data must come from web research.

### Step 2: Score Calculation

Score each dimension 1–5 based on evidence found:

| Dimension | 5 (Strong match) | 3 (Partial) | 1 (No match) |
|-----------|------------------|-------------|---------------|
| Firmographic | Exact range match for a vertical | Close to thresholds | Way outside all ranges |
| Technographic | Uses 2+ tools from a vertical's required list | Uses 1 tool or adjacent tools | No relevant tech found |
| Pain signal | Active CX/EX initiative, recent hire for feedback role | Industry-typical needs | No evidence of feedback needs |
| Vertical match | Clean fit to exactly 1 vertical | Could fit 2+ verticals | Doesn't fit any |

**Global score** = weighted average per `_shared.md` weights.

### Step 3: Decision

- **Score >= 4.0**: `Yes – {vertical} – {key qualifying factors}`
- **Score 3.0–3.9**: `Maybe – {vertical} – {qualifying factors} – {gaps}`
- **Score < 3.0**: `No – {specific disqualifying reason}`

### Step 4: Output

Write TSV row to `data/staging/accounts/{domain}.tsv`:

```
company_name	domain	icp_status	icp_score	icp_reason	vertical_match	processed_date
```

Push to Notion SDR Accounts database with all fields.

---

## Failure Handling

| Failure | Action |
|---------|--------|
| Company website unreachable | Try WebSearch only. If no data: score 1, status "No – Insufficient data" |
| Ambiguous industry | Score the best-fit vertical, note ambiguity in reason |
| Revenue/employee data unavailable | Use industry benchmarks from web research. Note "estimated" |
| Multiple vertical matches | Score the highest-priority vertical per `_config.md` |
