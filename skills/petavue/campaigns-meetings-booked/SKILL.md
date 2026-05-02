---
name: campaigns-meetings-booked
description: >
  Use this skill whenever the user wants to connect campaign touches to meeting
  bookings within 30 days to measure SDR-driven engagement and pipeline
  influence. Trigger when the user mentions phrases like "meetings booked from
  campaign", "campaign to meeting", "SDR follow-up", "marketing-sourced
  meetings", or shares campaign + meeting data. Use this skill to bridge the
  marketing-to-sales handoff measurement.
---

# Campaigns — Meetings Booked

This skill measures how marketing campaigns influence meeting bookings within 30 days post-touch — the cleanest proxy for marketing-to-sales handoff effectiveness.

The skill enforces:
- **30-day window** post-campaign-touch (longer = noise)
- **First-touch attribution** (the campaign that triggered the journey)
- **SDR vs self-booked split** — different intent levels
- **Per-campaign meeting yield** ranking

---

## Hard Constraints

### Required Inputs
- Campaign touches per contact (date, campaign name)
- Meeting bookings per contact (date, type: SDR-booked, self-serve)
- 30-day attribution rule confirmed with user

### Refuse if no Meeting Data
If meetings aren't tracked separately from "demos" or "calls," ask the user to define their meeting taxonomy first.

---

## Workflow

### Step 1: Match campaign touches to subsequent meetings within 30 days

For each contact: did they book a meeting within 30 days of a campaign touch? If yes, attribute the meeting to the most recent campaign before booking.

### Step 2: Aggregate meetings per campaign

Count: total meetings, SDR-booked, self-serve booked.

### Step 3: Compute meeting yield per campaign

`Meeting yield = Meetings / Touched contacts`

### Step 4: Rank + correlate

Rank campaigns by meeting yield. Cross-check with downstream Closed-Won (does high meeting yield = high revenue, or just busy work for SDRs?).

---

## Required Output Format

```
### 📅 Campaigns — Meetings Booked (30-day window)

| Campaign | Channel | Touched | Meetings | SDR-booked | Self-serve | Yield | Closed-Won |
|----------|---------|---------|----------|------------|------------|-------|------------|
| | | | | | | __% | $ |

### Highlights

- Top yield: [campaign] @ __% — scale
- High volume, low yield: [campaign] — re-target
- Self-serve heavy: [campaign] — reduces SDR burden, scale
```

---

## Common Mistakes to Avoid

- Using > 30-day window — too much noise
- Mixing SDR-booked + self-serve in one number
- Counting "discovery calls" + "demos" + "consultations" as one type
- Ignoring downstream Closed-Won (high meeting yield ≠ high revenue)

---

## Notes on Tooling

| Tool | Use |
|------|-----|
| Petavue MCP | Primary execution |
| Salesforce / HubSpot | Meetings + campaigns |
| Calendly / Chili Piper | Self-serve booking source |
| Outreach / Salesloft | SDR-booked attribution |

---

## Source

Adapted from [Petavue's GTM Prompt Library — Campaigns — Meetings Booked](https://www.petavue.com/resources/prompts).
Petavue category: Sales / Marketing
