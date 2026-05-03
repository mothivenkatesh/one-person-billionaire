---
name: buying-triggers-signals
description: >
  Use this skill whenever the user provides a company name, website, or description
  and wants to identify buying triggers, intent signals, or outreach opportunities
  for that company. Trigger this skill when the user mentions phrases like
  "find buying signals", "find triggers", "intent signals", "who's in-market",
  "outreach signals", "what should I watch for", "ABM signals",
  "how do I personalize outreach", or when they share a company and ask about
  prospecting, account targeting, or trigger-based selling. Also trigger when
  the user asks about job changes, funding rounds, product launches, regulatory
  shifts, or competitor moves as a buying signal. Always use this skill before
  attempting trigger/signal research from scratch — it contains the exact
  workflow, category framework, and customised output format.
---

# Buying Triggers & Signals Skill

This skill defines the end-to-end workflow for identifying **buying triggers and intent signals** for a given company so the user can:
1. Find top accounts likely to be in-market for the company's product/solution/service
2. Customise email and LinkedIn outreach based on those signals

The output is a structured, company-specific table — never generic.

---

## Workflow Overview

```
Step 1: Ingest company info → website + description + uploaded docs
Step 2: Run ICP skill (industries + countries only — skip TAM)
Step 3: Research signals across all categories in parallel
Step 4: Validate every signal is relevant to THIS company
Step 5: Present as a single structured table
```

---

## Step 1 — Ingest Company Context

Take the company name and/or website provided by the user. If a website is given:
- Fetch the homepage and 1–2 key product pages to understand what they sell
- Note the value proposition, key features, and target buyer persona

If documents are uploaded (pitch deck, sales playbook, ICP doc, etc.), read them and extract:
- Product capabilities and differentiators
- Existing customer logos and verticals (if mentioned)
- Use cases and buyer personas

If neither website nor description is sufficient, ask the user one clarifying question before proceeding.

---

## Step 2 — Run the ICP Skill (Industries + Countries Only)

Invoke the `icp-tam-research` skill to identify the company's Ideal Customer Profile.
**Important: only extract Target Industries/Sub-Industries and Target Countries. Skip the TAM calculation entirely.**

You will use these industries and countries as the basis for the **Strategic** and **Competitor** signal categories below.

---

## Step 3 — Research Signals Across All Categories

Research the internet (and any uploaded docs) in parallel for signals across all of the following categories. Customise each signal to the specific company — never use generic, template signals.

### Required Categories

**1. People**
Signals tied to individual movements and career changes.
- Sub-categories include: Job change, New hire in a relevant role, Promotion, Departure of a champion, New leadership joining a target account, Skill/certification additions on LinkedIn

**2. Company**
Signals tied to changes within the target company itself.
- Sub-categories include: Funding round, Headcount growth, M&A activity, New office/geographic expansion, Tech stack change, Product launch, Layoffs/restructuring, Earnings/revenue growth

**3. Industry**
Signals tied to the industry or vertical the target company operates in.
- Sub-categories include: Regulatory change, New compliance mandate, Industry-wide tech shift, Major industry event/conference, Standards body update, Sector-wide disruption

**4. Strategic**
Use the ICP output to identify the company's top 3–5 industries / sub-industries / countries. Then propose reaching out to the **closest competitors of the company's existing customers** within those segments.
- Example logic: If the company is *Salesforce Agentforce Commerce* and a known customer is L'Oréal, propose a sub-segment of large-scale cosmetic brands (Estée Lauder, Shiseido, Coty) — because the company likely has a deeper, proven solution for cosmetics.
- Sub-categories: Lookalike accounts of existing logos, Adjacent verticals where current solution maps cleanly, Geographic expansion opportunities

**5. Competitor**
Identify the top 2–3 direct competitors of the company. Propose reaching out to **prospects who currently use those competitor products**.
- Example: If the company is *Salesforce Agentforce Commerce*, then Adobe Commerce Cloud users (and Shopify Plus users at enterprise scale) are prime targets.
- Sub-categories: Active users of competitor X, Recent migrations away from competitor, Negative reviews of competitor on G2, Renewal-window timing

**6. Engagement**
Signals tied to digital behaviour suggesting active research.
- Sub-categories include: Website visits (specific high-intent pages), LinkedIn engagement (likes/comments on the company's posts), G2/Capterra page views or reviews, Webinar attendance, Content downloads, Email opens, Repeat visits to pricing page

### Additional Categories to Consider (add when relevant)

**7. Technographic**
Adoption or removal of a complementary or competing technology in the target's stack (e.g., they just bought Snowflake → now they need a reverse-ETL tool).

**8. Hiring**
Open job requisitions that reveal intent (e.g., a target company hiring a "Head of Commerce Transformation" signals platform evaluation).

**9. Event-based**
Attendance or speaking slot at an industry event relevant to the company's category.

**10. Financial**
Earnings call mentions, public statements about strategic priorities, or budget cycle timing (especially Q4 for annual planning).

You may add other categories specific to the company's space if research surfaces a clearly relevant signal type. State the rationale briefly.

---

## Step 4 — Validate Each Signal Against the Company

Before adding any signal to the output table, ask:
- "Would this signal genuinely indicate someone is in-market for **this specific company's** product?"
- "Can I write a one-liner explaining why it matters *for this company* — not for any company in this space?"

If either answer is no, drop the signal. Quality over quantity.

---

## Step 5 — Present the Output in This Exact Format

Always return one consolidated table. No prose preamble inside the table. Keep "What to Watch" and "Why it's relevant" each to **a single line**.

---

### 🎯 Buying Triggers & Signals for [Company Name]

| Category | Sub-Category | What to Watch (Signal / Trigger) | Why It's Relevant to [Company Name] |
|----------|--------------|----------------------------------|------------------------------------|
| People | Job change | New VP of [relevant function] joining a target account | New leaders bring new budget and tend to re-evaluate the [category] stack within 90 days |
| People | Champion departure | An existing customer's champion leaves for a new company | The champion is likely to bring [Company Name] into their new org |
| Company | Funding round | Series B+ raise in target ICP | Fresh capital usually triggers spend on [category] within 2 quarters |
| Company | Headcount growth | 30%+ YoY headcount growth at a target account | Scaling teams outgrow legacy [category] tools quickly |
| Industry | Regulatory change | New [specific regulation] in [target geography] | Forces compliance buyers to re-evaluate [category], where [Company Name] has a built-in advantage |
| Strategic | Lookalike of L'Oréal | Large cosmetic brands (Estée Lauder, Shiseido, Coty) | [Company Name] already proves ROI for L'Oréal — strong sub-vertical pattern match |
| Competitor | Adobe Commerce users | Enterprise retailers running Adobe Commerce Cloud | Direct displacement opportunity — [Company Name] competes head-on with Adobe Commerce |
| Competitor | G2 negative review | 1–3 star reviews of [competitor] on G2 | High intent to switch — reach out within 14 days of the review |
| Engagement | Pricing page visits | Repeat visits to the pricing page from a target account domain | Indicates active evaluation — prioritise for outbound the same week |
| Engagement | LinkedIn engagement | Decision-maker likes/comments on [Company Name]'s LinkedIn posts | Warm signal — easy opener for a personalised connection request |
| Hiring | Job req | Target account hires for "[specific role tied to category]" | Indicates internal investment and active stack evaluation |
| Technographic | Stack signal | Target adopts a complementary technology (e.g., [specific tool]) | [Company Name] integrates natively, making the case for adoption easier |

*(Include 10–15 rows, customised. Drop any row that doesn't pass the validation in Step 4.)*

---

## How to Use the Output

After presenting the table, briefly tell the user:
- The top 2–3 highest-priority signals to start tracking immediately
- Which tools (Clay, Apollo, LinkedIn Sales Navigator, G2, etc.) can be used to monitor each signal type
- A suggested next step: "Want me to draft a sample outreach email or LinkedIn message based on one of these triggers?"

---

## Common Mistakes to Avoid

- **Do not use generic signals.** "Funding round" alone is not enough — say what stage, what size, in what ICP.
- **Do not skip the ICP step.** The Strategic and Competitor categories depend on knowing the company's industries and customer base.
- **Do not pad the table with weak signals.** 10 strong rows beat 25 weak ones.
- **Do not forget to customise the "Why it's relevant" column.** This is what makes the output useful — it's the bridge between a signal and an outreach hook.
- **Do not include TAM or company counts.** This skill is about *qualitative* triggers, not market sizing.
- **Do not assume competitors without validation.** Check the company's positioning page or G2 category before naming competitors.

---

## Notes on Research Sources

When researching signals for a given company, prioritise these sources:
- **Company website** — for product positioning, customer logos, integrations
- **G2 / Capterra** — for category, competitors, and review-based intent signals
- **LinkedIn** — for hiring trends, leadership changes, and engagement signals
- **Crunchbase / PitchBook** — for funding signals
- **Industry publications** — for regulatory and macro shifts
- **Uploaded documents** — always prioritise these over generic web research, as they carry the company's own framing
