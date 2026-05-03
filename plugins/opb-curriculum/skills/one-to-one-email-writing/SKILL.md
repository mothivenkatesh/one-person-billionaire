---
name: one-to-one-email-writing
description: >
  Use this skill whenever the user wants to write a 1:1 personalised cold email from
  a seller (Company X) to a target contact at a prospect company (Company Y), based on
  a buying trigger or signal. Trigger this skill when the user provides a contact list
  with names, LinkedIn profiles, titles, and/or triggers and asks for "personalised
  emails", "cold emails", "1:1 emails", "ABM emails", "outreach emails", "trigger-based
  emails", or shares a signal (job change, funding round, product launch, etc.) and asks
  Claude to draft outreach. Also trigger when the user mentions "hook", "value prop",
  "social proof", "Soft CTA", "Hard CTA", or asks for an email under a strict word count.
  Always use this skill before writing trigger-based 1:1 emails from scratch — it
  enforces the structure, word limits, and CTA logic.
---

# 1:1 Personalised Email Writing Skill

This skill defines the end-to-end workflow for writing **1:1 personalised cold emails** from a seller (Company X) to a target contact at a prospect company (Company Y), using a buying trigger or signal as the hook.

The skill enforces:
- A **100-word total cap** per email
- A **20-word cap** on the hook
- A **30-word cap** on the value prop
- Explicit structure: Hook → Value Prop → Social Proof → CTA
- User-confirmed CTA style (Soft or Hard) applied consistently across the batch

---

## Required Inputs

Before writing, confirm the user has provided:
- **Company X** (the seller — whose product/service is being pitched)
- **Contact list** with at minimum: first name, title, LinkedIn URL, Company Y (the prospect company / website)
- **Persona cohort** (optional but helpful — e.g., "VP Marketing at mid-market SaaS")
- **Triggers/signals** per contact (strongly preferred — the hook quality depends on this)
- **Any attached documents** (case studies, customer lists, win stories) — prioritise these as sources

If Company X is not clear or no contacts are provided, ask the user for the missing piece before drafting.

---

## Workflow Overview

```
Step 1: Confirm inputs and ask for CTA style (once per batch)
Step 2: For each contact, research the trigger and build the 4 email components
Step 3: Assemble the email under the 100-word cap
Step 4: Proof-read for flow and constraint compliance
Step 5: Present all emails in a structured format
```

---

## Step 1 — Ask for CTA Style (Once Per Batch)

Before drafting any email, ask the user:

> "Before I draft, should the CTA be **Soft** or **Hard**?
> • **Soft CTA** — low-friction ask, e.g., 'Mind if I share how we delivered [outcome] for [industry]?'
> • **Hard CTA** — direct meeting ask, e.g., 'What time next [weekday] works for a quick chat on [outcome]?'"

Apply the same CTA style to all emails in the batch unless the user asks otherwise.

---

## Step 2 — Build Each Email (4 Components)

For each contact, construct the email in this exact order.

### Component A — The Hook (≤ 20 words)

The hook opens the email and must be tied to a buying trigger. Use the following category framework to identify the best hook for each contact:

**1. People** — Job change, new hire in relevant role, promotion, departure of a champion, new leadership joining the target account, skill/certification additions on LinkedIn.

**2. Company** — Funding round, headcount growth, M&A activity, new office/geo expansion, tech stack change, product launch, layoffs/restructuring, earnings/revenue growth.

**3. Industry** — Regulatory change, new compliance mandate, industry-wide tech shift, major industry event/conference, standards body update, sector-wide disruption.

**4. Strategic** — Lookalike of an existing Company X customer in the same industry/geo; adjacent vertical where Company X already wins; geographic expansion opportunity.

**5. Competitor** — Company Y uses a direct competitor of Company X; recent migration away from a competitor; negative reviews of competitor on G2; renewal-window timing.

**6. Engagement** — Website visits to high-intent pages, LinkedIn likes/comments on Company X's posts, G2/Capterra page views, webinar attendance, content downloads, repeated pricing page visits.

**7. Technographic** — Company Y just adopted a complementary tech (e.g., Snowflake → now needs reverse-ETL).

**8. Hiring** — Open job reqs that signal platform evaluation (e.g., hiring "Head of Commerce Transformation").

**9. Event-based** — Contact is attending/speaking at an industry event relevant to Company X's category.

**10. Financial** — Earnings call mentions, public strategic priorities, budget cycle timing (especially Q4).

**Hook construction rules:**
- The hook must **accentuate the need** — i.e., connect the trigger to a latent reason Company Y would benefit from Company X.
- Example: If the trigger is "Jane just moved to VP Growth at Company Y," the hook should nod to her new role and the typical 90-day tool evaluation window.
- **If no real trigger is found**, write an **acknowledgement hook** instead — call out a specific, verified positive achievement of the person or Company Y (award, product launch, milestone, press mention).
- Avoid generic openers like "Hope you're well" or "Saw you on LinkedIn."
- Never invent a trigger. If nothing public exists, use the acknowledgement path.

### Component B — The Value Prop (≤ 30 words)

Align directly with the pain point implied by the hook, and craft a 1:1 value prop for Company Y.

**If the hook was trigger-based**: The value prop should directly address the pain that the trigger creates (e.g., new VP → scaling challenge → Company X helps scale ops in 90 days).

**If the hook was only an acknowledgement**: Find a **specific pain point** Company X can solve for Company Y — derived from Company Y's public signals (industry, size, tech stack, recent news). Then write the value prop to address that pain.

**Rules:**
- Must reference Company Y by name or by a specific attribute of Company Y.
- Must name a specific outcome, not a feature list.
- No buzzwords: avoid "synergy," "leverage," "best-in-class," "world-class," "cutting-edge," "revolutionary."

### Component C — The Social Proof (1 sentence)

Find the **closest competitor of Company Y that is an existing customer of Company X**. Use that competitor's name as social proof.

**Where to find this:**
1. Check **attached documents** first (case studies, customer lists, win stories) — these are authoritative.
2. If not in documents, use **public research** — Company X's website customer logos, case study pages, G2 reviews, press releases.
3. If no direct competitor is found, fall back to naming a well-known customer of Company X in the same industry as Company Y.

**Rules:**
- Never fabricate a customer name. If no verifiable customer exists, skip social proof and use a quantified outcome instead (e.g., "We've helped 40+ retailers cut fulfilment cost by 18%").
- Keep the social proof to one sentence.
- Connect it to the value prop (e.g., "We did exactly this for [Competitor of Company Y]").

### Component D — The CTA (1 sentence)

Use the CTA style the user picked in Step 1.

**Soft CTA template:**
> "Mind if I share how we delivered [specific outcome] for [target industry of Company X]?"

**Hard CTA template:**
> "What time next [random weekday — Tuesday/Wednesday/Thursday] works for a quick chat on how we delivered [specific outcome] for [target industry of Company X]?"

**Rules:**
- For Hard CTAs, always specify "next [weekday]" — pick Tuesday, Wednesday, or Thursday at random. Avoid Monday and Friday.
- The outcome referenced in the CTA should match the value prop's outcome.
- One question mark maximum. No double asks.

---

## Step 3 — Assemble the Email (≤ 100 words total)

Assemble in this exact order:

```
[Greeting: Hi [First Name],]

[Hook — ≤ 20 words]

[Value Prop — ≤ 30 words, references Company Y]

[Social Proof — 1 sentence with competitor/customer name]

[CTA — 1 sentence, Soft or Hard]

[Sign-off: Best, / Thanks, / [blank for signature]]
```

**Critical word count check**: The body (hook + value prop + social proof + CTA) must total **≤ 100 words**. Greetings and sign-offs don't count toward the limit, but keep them one line each.

---

## Step 4 — Proof-read

Before presenting each email, self-check:

- [ ] Total body word count ≤ 100
- [ ] Hook ≤ 20 words and tied to a real trigger (or a verified acknowledgement)
- [ ] Value prop ≤ 30 words and names Company Y or a specific attribute
- [ ] Social proof names a real, verifiable company
- [ ] CTA matches the user-selected style (Soft or Hard)
- [ ] No fabricated facts, customer names, or triggers
- [ ] No buzzwords
- [ ] Reads naturally — hook flows to value prop flows to social proof flows to CTA
- [ ] One question mark maximum
- [ ] Sounds like a real human wrote it, not a template

---

## Step 5 — Present the Output

Present all emails in this format — one block per contact:

---

### 📧 Email for [First Name Last Name] — [Title] at [Company Y]

**Trigger used:** [Category / Sub-category — brief description]
**CTA style:** [Soft / Hard]
**Word count:** [X / 100]

```
Hi [First Name],

[Hook]

[Value Prop]

[Social Proof]

[CTA]

Best,
```

---

After all emails, provide a one-line summary:
> "Drafted [N] emails — all under the 100-word cap, [N] using trigger-based hooks, [N] using acknowledgement hooks."

---

## Example Email (for reference)

**Context:** Company X = Gong (revenue intelligence). Company Y = Ramp. Contact = Maya Patel, VP Sales. Trigger = Job change (just promoted from Director to VP, 2 weeks ago).

> Hi Maya,
>
> Congrats on the VP Sales move at Ramp — the first 90 days usually decide whether the forecast actually holds.
>
> Gong gives new VPs real-time visibility into which deals are slipping and why, without chasing reps for updates.
>
> Brex's sales leader saw forecast accuracy jump 22% in their first quarter using Gong.
>
> What time next Wednesday works for a 15-min look at how we did it?
>
> Best,

**Word count (body):** 73. Hook: 18. Value prop: 23. Social proof: 15. CTA: 17. All within limits.

---

## Common Mistakes to Avoid

- **Do not exceed 100 words in the body.** If the draft is over, cut from the value prop first, then social proof.
- **Do not invent triggers.** If no public trigger exists, use the acknowledgement path — never fabricate.
- **Do not invent customer names for social proof.** If none is verifiable, use a quantified outcome instead.
- **Do not mix CTA styles in the same batch.** Pick one (based on user input) and apply consistently.
- **Do not use generic openers.** "Hope you're doing well" / "Saw your profile" / "Reaching out because..." all fail the hook test.
- **Do not reference features — only outcomes.** The value prop describes what changes for Company Y, not what the product does.
- **Do not skip the user's CTA confirmation** (Step 1) — defaulting silently causes rework.
- **Do not forget to name Company Y** in the value prop. The 1:1 feel comes from specificity.
- **Do not double-ask** in the CTA. One clean question mark only.

---

## Notes on Research Sources

When researching triggers or social proof for a given contact, prioritise in this order:
1. **Attached documents** — case studies, customer lists, win stories shared by the user
2. **LinkedIn** — for job changes, promotions, certifications, engagement signals
3. **Company Y's website and newsroom** — for funding, launches, leadership changes
4. **G2 / Capterra** — for competitor usage signals
5. **Crunchbase / public press** — for funding, M&A, financial signals
6. **Company X's website** — for customer logos and case studies (for social proof)

If no trigger can be verified from any of these sources, fall back to the acknowledgement hook path.
