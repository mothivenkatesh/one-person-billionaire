---
name: icp-tam-research
description: >
  Use this skill whenever the user provides a company description and wants to identify
  their Ideal Customer Profile (ICP) or calculate their Total Addressable Market (TAM).
  Trigger this skill when the user mentions phrases like "find my ICP", "who should I target",
  "what's my TAM", "how big is my market", "target industries", "addressable market size",
  or when they share a company description and ask about go-to-market strategy, sales targeting,
  or market sizing. Also trigger when the user asks to research Apollo for company counts
  or market data. Always use this skill before attempting ICP or TAM work from scratch —
  it contains the exact workflow, presentation format, confirmation gates, and Apollo
  credit-safe instructions.
---

# ICP & TAM Research Skill

This skill defines the end-to-end workflow for:
1. Building an **Ideal Customer Profile (ICP)** from a company description
2. Calculating the **Total Addressable Market (TAM)** using Apollo.io — without consuming Apollo export credits

---

## Overview of the Two-Phase Workflow

```
Phase 1: ICP → Present → Get user confirmation (YES/NO)
Phase 2: TAM → Research Apollo → Present market size breakdown
```

**Critical rule**: Never proceed to Phase 2 without explicit user confirmation after Phase 1.

---

## Phase 1: Building the ICP

### Step 1 — Parse the Company Description

Read the company description carefully and extract:
- What the product/service does
- Who it's currently built for (if mentioned)
- The pain points it solves
- Any existing customer signals or verticals mentioned

### Step 2 — Reason Through the ICP

Use first-principles reasoning to identify the best-fit customers. Think about:
- Who has the most acute pain that this product solves?
- What industries rely on this kind of problem being solved?
- What company size (employees/revenue) would have budget and need?
- Which geographies are most likely early adopters or natural buyers?

### Step 3 — Present the ICP in This Exact Format

Present the ICP as a clean, structured output with these three sections:

---

### 🎯 Ideal Customer Profile

**Target Industries & Sub-Industries**

| Industry | Sub-Industries |
|----------|---------------|
| [e.g. Financial Services] | [e.g. Wealth Management, Insurance, Neo-banks] |
| [e.g. Healthcare] | [e.g. Hospital Networks, Health-tech, Diagnostics] |
| *(Add 3–5 rows)* | |

**Company Size**

| Dimension | Range |
|-----------|-------|
| Employees | e.g. 50–500 |
| Annual Revenue | e.g. $5M–$100M |
| Stage | e.g. Series A–C, or SMB, or Mid-Market |

**Target Geographies**

List the top 3–5 countries or regions in order of priority. For each, briefly explain why (e.g., market maturity, regulatory environment, density of target companies).

1. [Country/Region] — [Reason]
2. ...

---

### Step 4 — Ask for Confirmation

After presenting the ICP, always say:

> "Does this ICP look right to you? Let me know if you'd like to adjust any industries, company sizes, or geographies — or confirm with **yes** and I'll move on to calculating your TAM using Apollo."

**Do NOT proceed to Phase 2 until the user explicitly says yes (or equivalent like "looks good", "go ahead", "confirm").**

---

## Phase 2: TAM Calculation via Apollo

### Step 5 — Announce TAM Research

Once the user confirms, say:

> "Great! I'll now research Apollo to estimate your TAM based on the ICP we defined. This uses Apollo's search filters (no credits consumed — read-only count data only)."

### Step 6 — Apollo Research Instructions (Credit-Safe)

**IMPORTANT: Do NOT use Apollo's export or contact reveal features. Only use search/filter counts.**

Use the Apollo MCP (connected at `https://mcp.apollo.io/mcp`) to query company counts. The goal is to use Apollo's **organization search** with filters to get *total result counts*, not to pull individual records.

For each ICP segment (industry + company size + geography combination), call Apollo's search with:
- `industry` or `keywords` filter matching the target sub-industry
- `num_employees_ranges` matching the ICP employee range
- `organization_locations` matching the target country/region

Extract only the **total_entries** or **pagination.total_entries** count from the response — this is the number of matching companies in Apollo's database. This does **not** consume credits.

Repeat this for each major ICP segment (top 3–5 industry + geo combinations).

### Step 7 — Aggregate TAM by Segment

Once you have company counts per segment from Apollo, sum them up. TAM here is defined purely as **the number of companies** that match the ICP — not a dollar value.

```
TAM = Σ (Company Count per Segment across all ICP filters)
```

Do not apply ACV or revenue multipliers. The output is a headcount of addressable companies.

### Step 8 — Present the TAM in This Exact Format

---

### 📊 Total Addressable Market (TAM)

**Assumptions**
- Apollo data represents companies with verified profiles in the database
- Counts reflect companies matching ICP filters (industry + size + geography)
- Segments may have minor overlap if a company fits multiple industries — treat total as approximate

**TAM by Segment**

| Segment | Industry | Sub-Industry | Geography | Employee Range | Company Count (Apollo) |
|---------|----------|--------------|-----------|----------------|----------------------|
| 1 | Financial Services | Wealth Management | USA | 50–500 | 4,200 |
| 2 | Healthcare | Hospital Networks | UK | 100–500 | 1,800 |
| ... | | | | | |
| **Total** | | | | | **~X,XXX companies** |

**Summary**

> Your estimated TAM is approximately **X,XXX companies** across [N] segments.
> This is a bottom-up count based on Apollo company data filtered to your ICP criteria.

---

## Common Mistakes to Avoid

- **Do not skip the confirmation gate.** Always wait for user approval of the ICP before starting TAM.
- **Do not consume Apollo credits.** Never call export, contact reveal, or email unlock endpoints. Only use search-with-filters to get counts.
- **Do not fabricate company counts.** If Apollo returns no results for a segment, say so and suggest broadening the filter.
- **Do not collapse all segments into one.** Break TAM into meaningful industry × geography segments — this makes it actionable for sales targeting.
- **Do not convert to dollar value.** TAM here is a company headcount, not a revenue figure. Do not multiply by ACV or pricing unless the user explicitly asks for a separate revenue estimate.

---

## Notes on Apollo MCP Usage

The Apollo MCP is connected at `https://mcp.apollo.io/mcp`. Use `tool_search` to discover available Apollo tools before calling them. Key tools to look for:
- Organization/company search with filter parameters
- People search (for contact density estimation, if needed)

Always check `total_entries` or equivalent pagination count field from Apollo responses — this is the TAM signal, not the individual records returned.
