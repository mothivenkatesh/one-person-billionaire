---
name: email-waterfall-enrichment
description: >
  Use this skill whenever the user provides a list of contacts (with names, companies,
  or LinkedIn URLs) and wants to find verified corporate/professional email IDs using
  Clay's email waterfall method. Trigger this skill when the user mentions phrases like
  "find emails for these contacts", "build an email waterfall", "verify these emails",
  "get me work emails", "enrich emails in Clay", "Apollo + Prospeo + Icypeas + Leadmagic",
  "Reoon validation", "catch-all check", or "Enrichley safe-to-send check". Always use
  this skill when the goal is the highest valid-email coverage at the lowest Clay credit
  cost. The skill enforces a hard cap of 10 contacts, the exact provider sequence, and
  the final output table format.
---

# Email Waterfall Enrichment Skill

This skill defines the exact workflow for finding the **maximum number of valid corporate email IDs** for a list of contacts using the **least Clay credits possible**, by sequencing email finders from cheapest/most-accurate to fallback in a true waterfall — exiting the moment a valid email is confirmed.

---

## Hard Constraints (Check First)

### Constraint 1 — Maximum 10 Contacts

Before doing anything else, count the contacts in the input list.

- If the list has **more than 10 contacts**, stop and flag this to the user with:

  > "⚠️ The list you've shared has [N] contacts. This skill is capped at 10 contacts to keep Clay credit usage controlled. Please share a list of 10 or fewer, or confirm you want to proceed with just the first 10."

- Wait for user confirmation before proceeding.

### Constraint 2 — Required Input Fields

Each contact must have at minimum:
- First name + Last name (or full name)
- Company name **or** company domain
- LinkedIn URL is optional but improves match rates

If any contact is missing the minimum, flag it and ask the user to provide the missing fields or skip those rows.

---

## The Waterfall Logic (Exact Sequence)

The waterfall runs **per contact**, in this exact order. The instant a step returns a **valid** email (per Reoon), exit the waterfall for that contact and move to the next one. This is what saves credits — every step skipped is credits saved.

```
┌──────────────────────────────────────────────────────────────────┐
│  STEP 1: Apollo (find email) → Reoon (validate)                  │
│    ✅ Valid → exit waterfall                                     │
│    ❌ Invalid / Catch-all → go to Step 2                         │
├──────────────────────────────────────────────────────────────────┤
│  STEP 2: Prospeo (find email) → Reoon (validate)                 │
│    ✅ Valid → exit waterfall                                     │
│    ❌ Invalid / Catch-all → go to Step 3                         │
├──────────────────────────────────────────────────────────────────┤
│  STEP 3: Icypeas (find email) → Reoon (validate)                 │
│    ✅ Valid → exit waterfall                                     │
│    ❌ Invalid / Catch-all → go to Step 4                         │
├──────────────────────────────────────────────────────────────────┤
│  STEP 4: Leadmagic (find email) → Reoon (validate)               │
│    ✅ Valid → exit waterfall                                     │
│    ❌ Invalid → mark "Not Found"                                 │
│    ⚠️ Catch-all → go to Step 5 (Enrichley safe-to-send check)    │
├──────────────────────────────────────────────────────────────────┤
│  STEP 5 (only if Leadmagic returns catch-all):                   │
│    Enrichley API → check if safe to send                         │
│    ✅ Safe → include in output (mark "Catch-all — Safe")         │
│    ❌ Not safe → mark "Not Found"                                │
└──────────────────────────────────────────────────────────────────┘
```

### Why this order saves credits

- Apollo first: highest free-tier coverage and often included in many Clay plans
- Prospeo second: high accuracy, good for fallback
- Icypeas third: strong European coverage, cheap per credit
- Leadmagic fourth: catches what others miss, with built-in catch-all flagging
- Enrichley last: only invoked for catch-alls — never wasted on outright invalid emails

### Reoon validation status mapping

When Reoon validates each candidate email, treat the statuses as:
- `valid` / `safe` → ✅ Exit waterfall
- `invalid` / `unknown` / `disposable` / `role-based` → ❌ Move to next provider
- `catch-all` / `accept-all` → ❌ Move to next provider (except after Leadmagic, where it triggers the Enrichley step)

---

## Step-by-Step Workflow in Clay

### Step A — Set Up the Table

1. Create a new Clay table (or use an existing one) and import the contact list (max 10 rows).
2. Ensure columns exist for: First Name, Last Name, Title, Company Name, Company Domain, LinkedIn URL.

### Step B — Add the Waterfall Enrichments

For each provider in sequence, add a Clay enrichment column with a **conditional run formula** that only runs if the previous step's Reoon validation didn't return a valid email. This is the Clay-native way to build a true waterfall and is what minimises credit spend.

Suggested column setup:

| # | Column Name | Action | Conditional Run |
|---|------------|--------|-----------------|
| 1 | Apollo Email | Apollo → Find Work Email | Always run |
| 2 | Apollo Reoon Status | Reoon → Validate Email | Run if Apollo Email is not empty |
| 3 | Prospeo Email | Prospeo → Find Work Email | Run if Apollo Reoon Status is not "valid" |
| 4 | Prospeo Reoon Status | Reoon → Validate Email | Run if Prospeo Email is not empty |
| 5 | Icypeas Email | Icypeas → Find Email | Run if Prospeo Reoon Status is not "valid" |
| 6 | Icypeas Reoon Status | Reoon → Validate Email | Run if Icypeas Email is not empty |
| 7 | Leadmagic Email | Leadmagic → Find Email | Run if Icypeas Reoon Status is not "valid" |
| 8 | Leadmagic Reoon Status | Reoon → Validate Email | Run if Leadmagic Email is not empty |
| 9 | Enrichley Safe Check | Enrichley → Safe-to-Send | Run only if Leadmagic Reoon Status is "catch-all" |
| 10 | Final Email | Formula | First valid email from columns 1, 3, 5, 7 — or Leadmagic email if Enrichley confirms safe |
| 11 | Email Status | Formula | "Valid (Apollo)" / "Valid (Prospeo)" / "Valid (Icypeas)" / "Valid (Leadmagic)" / "Catch-all — Safe (Enrichley)" / "Not Found" |

### Step C — Run the Waterfall

- Run the columns in order.
- Monitor that each conditional run is firing correctly (i.e., later steps should only run when earlier ones failed — verify this in the credit usage tab).

### Step D — Review and Validate

After the waterfall completes:
- Spot-check 2–3 rows manually to confirm the conditional logic worked
- Confirm no contact triggered all 4 finders unnecessarily (that would mean credits were wasted)
- If any contact still shows "Not Found", consider whether the input data (name spelling, company domain) was correct

---

## Final Output Format

Always present the result as a single table with **exactly these columns**:

| First Name | Last Name | Title | Company Name | LinkedIn URL | Final Email | Email Status |
|------------|-----------|-------|--------------|--------------|-------------|--------------|
| Jane | Doe | VP Marketing | Acme Inc | linkedin.com/in/janedoe | jane@acme.com | Valid (Apollo) |
| John | Smith | CTO | Globex | linkedin.com/in/johnsmith | john.smith@globex.com | Valid (Prospeo) |
| Maria | Garcia | Head of Sales | Initech | linkedin.com/in/mariagarcia | maria.garcia@initech.com | Valid (Icypeas) |
| Lee | Park | Director | Umbrella | linkedin.com/in/leepark | lee@umbrella.com | Catch-all — Safe (Enrichley) |
| Alex | Khan | CFO | Stark Co | linkedin.com/in/alexkhan | — | Not Found |

After the table, give a one-line summary:
> "Found valid emails for X out of Y contacts. Credit-saving waterfall exited early on Z contacts at the first or second step."

---

## Common Mistakes to Avoid

- **Do not run all four finders in parallel.** That defeats the entire purpose of a waterfall and burns credits. Always use conditional runs.
- **Do not skip Reoon validation.** A finder returning an email does not mean it's deliverable. Reoon is what gates the exit.
- **Do not invoke Enrichley unless the Leadmagic result was catch-all.** Enrichley is the final safety net, not a default validator.
- **Do not exceed 10 contacts** without explicit user confirmation.
- **Do not include role-based emails (info@, sales@, hello@)** in the final output — these are flagged by Reoon and should be treated as invalid for outreach.
- **Do not assume catch-all = bad.** Catch-all emails *can* be deliverable — that's the entire point of the Enrichley step.
- **Do not edit the provider sequence.** The order (Apollo → Prospeo → Icypeas → Leadmagic) is calibrated for credit efficiency. Changing it changes the cost profile.

---

## Notes on Credit Optimisation

The credit savings come from two things:
1. **Conditional runs** — later providers only fire when earlier ones fail
2. **Validation gating** — Reoon ensures we don't pay multiple finders for the same valid email

Approximate credit profile (per contact, Clay-managed accounts):
- Best case: 1 finder + 1 Reoon validation = ~3 credits
- Worst case (all 4 finders + 4 validations + Enrichley): ~15–18 credits
- Typical waterfall: ~5–7 credits per contact

For a list of 10 contacts, expect total spend of **50–80 credits** under typical conditions — significantly cheaper than running all providers in parallel (which would cost ~150+ credits).

---

## Quick Reference — Provider Roles

| Provider | Role in Waterfall |
|----------|-------------------|
| Apollo | First email finder — broad coverage |
| Prospeo | Second finder — high accuracy fallback |
| Icypeas | Third finder — strong international coverage |
| Leadmagic | Fourth finder — catches edge cases, flags catch-alls |
| Reoon | Email validator — runs after every finder to gate the exit |
| Enrichley | Safe-to-send checker — runs only on Leadmagic catch-alls |
