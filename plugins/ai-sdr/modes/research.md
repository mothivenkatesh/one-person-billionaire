# Mode: Prospect Deep Research

> Triggered after ICP validation passes (score >= 4.0) or for flagged prospects.
> Requires: `_shared.md` + `_config.md` loaded in context.

---

## Inputs
- First Name, Last Name
- Job Title
- Company Name
- Email Address
- LinkedIn Contact Profile URL
- LinkedIn Company Profile URL
- ICP Vertical (from validation)

## Process

### Step 1: Prospect Research (web search)

Research the prospect across multiple sources:

1. **LinkedIn profile** (via Chrome if accessible, else WebSearch `site:linkedin.com "{first} {last}" "{company}"`)
2. **Company website** team/about page
3. **Web search**: `"{first} {last}" "{company}" speaker OR interview OR podcast OR article`
4. **Industry events**: `"{first} {last}" conference OR summit OR panel 2025 2026`

**Extract:**

| Data Point | Source Priority | Fallback |
|-----------|----------------|----------|
| Career path | LinkedIn > company site | WebSearch |
| Recent activity (30 days) | LinkedIn posts > news | "No recent activity found" |
| Speaking engagements | Event sites > LinkedIn | "None found" |
| Published content | Google Scholar > Medium > company blog | "None found" |
| Company news (90 days) | Press releases > TechCrunch > industry pubs | WebSearch |
| Team size/reports | LinkedIn > company site | "Not available" |

### Step 2: Pain Point Identification

Using the vertical-specific pain point table from `_shared.md`, identify 3 pain points specific to THIS prospect:

**Pain Point Formula:**
```
[Specific challenge] + [evidence from their role/company] + [why it matters now]
```

**Example:**
- Generic: "Guest satisfaction tracking across properties"
- Specific: "Tracking guest satisfaction across 15 properties using Oracle Hospitality, where each property runs independent post-stay surveys with no unified dashboard — likely causing a 4-6 week lag in identifying service quality trends across the portfolio"

Each pain point must reference:
1. Something specific to their company (property count, employee size, recent expansion)
2. Something specific to their tech stack (if known)
3. A concrete business consequence

### Step 3: Classification

Classify using signals from `_shared.md`:

| Signal | Classification |
|--------|---------------|
| VP, SVP, C-suite, "Head of", reports to CEO/board | Decision Maker |
| Director, Sr. Director, evaluates vendors, manages team of managers | Influencer |
| Manager, Team Lead, individual contributor with title inflation | Manager |

**Confidence check:** If title is ambiguous (e.g., "Director" at a 50-person startup = Decision Maker; "Director" at a 10K-person enterprise = Influencer), use company size as tiebreaker.

### Step 4: Research Quality Score

Self-evaluate the research:

| Quality | Criteria | Next Step |
|---------|----------|-----------|
| High (3/3) | Found career data + recent activity + company news | Proceed to outreach |
| Medium (2/3) | Missing one category | Proceed with caveat: flag gaps in Notion |
| Low (1/3) | Only basic LinkedIn data | Flag for manual research, generate generic outreach |

### Step 5: Output

Write TSV to `data/staging/prospects/{email-slug}.tsv`:

```
prospect_name	company	email	job_title	linkedin_url	icp_vertical	classification	research_summary	pain_point_1	pain_point_2	pain_point_3	research_quality	processed_date
```

---

## Failure Handling

| Failure | Action |
|---------|--------|
| LinkedIn inaccessible | Use WebSearch + company website. Note "LinkedIn not scraped" |
| No recent activity found | State explicitly. Email 1 (Activity Hook) falls back to career milestone hook |
| Company news unavailable | Use industry trends instead. Note in research summary |
| Prospect appears to have left the company | Flag in Notion, skip outreach, log warning |
