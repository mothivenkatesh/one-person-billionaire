# Offer Workshop — Workflow Spec

A workflow that automates the Grand Slam offer iteration loop. Built as an Inngest-style spec — implement in your stack of choice.

This is the practical companion to [Lesson 08A](../../08A-the-grand-slam-offer/README.md) and the [grand-slam-offer skill](../../skills/grand-slam-offer/SKILL.md).

---

## What it does

Every Friday at 4pm, the workflow:
1. Pulls last week's prospect data (cold outbound replies, sales call notes, lost deals, won deals)
2. Aggregates objections, common questions, requested features
3. Re-scores your current offer's Value Equation
4. Identifies the lowest-scoring lever and proposes 1-3 specific changes
5. Drafts a Friday journal entry using the [value-equation worksheet](../../templates/value-equation-worksheet.md)
6. Queues it for your review

---

## Why a workflow (not an agent)

Per [Lesson 04A](../../04A-the-boring-stack-first/README.md), this is mostly **structured data + 1-2 LLM steps**. The aggregation is plain SQL/code; the LLM is used only for:
- Clustering objections from free-text notes
- Drafting the journal entry

A pure agent loop would be 10× more expensive and less reliable. Workflow + 2 LLM steps wins.

---

## Architecture

```
[Cron: every Friday 4pm]
        ↓
[Workflow: weekly_offer_review]
        ↓
[Step 1: pull data]                       ← plain SQL
   - Cold outbound: replies in past 7 days
   - Sales calls: notes from CRM
   - Stripe: new subs, churns, refunds
   - Support: tickets tagged "objection" or "question"
        ↓
[Step 2: cluster objections]              ← LLM call (Haiku, cheap)
   Input: ~50 free-text snippets
   Output: 3-7 named clusters with frequency
        ↓
[Step 3: compute Value Equation deltas]   ← plain code
   - Compare close rate to last week
   - Compute average sale price delta
   - Refund count delta
        ↓
[Step 4: identify weakest lever]          ← decision rules
   IF testimonial count not increased AND likelihood low → Likelihood
   IF time-to-first-result > 7 days       → Time Delay
   IF onboarding completion < 80%         → Effort
   IF dream outcome unclear in feedback    → Dream Outcome
        ↓
[Step 5: draft journal entry]             ← LLM call (Sonnet)
   Inputs: clusters from step 2, deltas from step 3, weakest lever from step 4
   Output: filled-in value-equation-worksheet.md
        ↓
[Step 6: queue for human review]          ← Slack / email / Notion
   - Send to your inbox
   - Pause workflow until you mark it reviewed
        ↓
[Step 7: log decision]                    ← append to log file / DB
   - What you decided
   - What you'll change next week
        ↓
[End]
```

---

## Implementation (Inngest example)

```typescript
// inngest/functions/offer-workshop.ts
import { inngest } from "../client";
import Anthropic from "@anthropic-ai/sdk";

const anthropic = new Anthropic();

export const weeklyOfferReview = inngest.createFunction(
  { id: "weekly-offer-review", name: "Weekly Grand Slam Offer Review" },
  { cron: "0 16 * * 5" },  // every Friday 4pm
  async ({ event, step }) => {
    // Step 1: pull data (plain code, retried automatically by Inngest)
    const data = await step.run("pull-data", async () => {
      return {
        cold_replies: await db.coldReplies.last7Days(),
        sales_notes: await crm.callNotes.last7Days(),
        stripe: await stripe.subscriptionDeltas(),
        support: await support.objections(),
      };
    });

    // Step 2: cluster objections (LLM, Haiku)
    const clusters = await step.run("cluster-objections", async () => {
      const allText = [
        ...data.cold_replies.map(r => r.body),
        ...data.sales_notes.map(n => n.text),
        ...data.support.map(t => t.body),
      ].join("\n---\n");

      const resp = await anthropic.messages.create({
        model: "claude-haiku-4-5",
        max_tokens: 2000,
        messages: [{
          role: "user",
          content: `Cluster these objections/questions into 3-7 named groups with frequency. Output JSON.\n\n${allText}`,
        }],
      });
      return JSON.parse(extractJson(resp.content[0].text));
    });

    // Step 3: compute deltas (plain code)
    const deltas = await step.run("compute-deltas", async () => ({
      closeRateDelta: data.stripe.closeRate - data.stripe.priorWeekCloseRate,
      asp: data.stripe.averageSalePrice,
      refundCount: data.stripe.refundsThisWeek,
    }));

    // Step 4: identify weakest lever (decision rules)
    const weakLever = await step.run("identify-lever", () => {
      if (testimonialsNotIncreased() && deltas.closeRateDelta < 0) return "Likelihood";
      if (timeToFirstResult() > 7) return "Time Delay";
      if (onboardingCompletion() < 0.8) return "Effort";
      return "Dream Outcome";
    });

    // Step 5: draft journal entry (LLM, Sonnet)
    const journalEntry = await step.run("draft-journal", async () => {
      const resp = await anthropic.messages.create({
        model: "claude-sonnet-4-6",
        max_tokens: 3000,
        messages: [{
          role: "user",
          content: `Fill in the value-equation-worksheet.md template using:
            Clusters: ${JSON.stringify(clusters)}
            Deltas: ${JSON.stringify(deltas)}
            Weakest lever this week: ${weakLever}

            Be specific and operational. Propose 1-3 actions to lift the weakest lever.`,
        }],
      });
      return resp.content[0].text;
    });

    // Step 6: queue for human review
    await step.run("notify", async () => {
      await slack.postToChannel("#offer-review", {
        text: `📊 Friday offer review ready. Weakest lever: *${weakLever}*`,
        attachment: { content: journalEntry, filename: `offer-review-${today()}.md` },
      });
    });

    // Step 7: wait for human approval
    const decision = await step.waitForEvent("offer.decision", {
      timeout: "7d",
      match: "data.weekId",
    });

    // Step 8: log decision
    await step.run("log", async () => {
      await db.offerDecisions.insert({
        weekId: today(),
        weakLever,
        clusters,
        decision: decision?.data,
      });
    });
  }
);
```

---

## Reliability primitives in use

(see [Lesson 04A](../../04A-the-boring-stack-first/README.md))

- ✅ **Idempotency** — Inngest handles via step IDs
- ✅ **Retries with backoff** — automatic per step
- ✅ **Timeouts** — `waitForEvent` has 7-day timeout
- ✅ **DLQ** — failed runs route to Inngest's failed-runs view
- ✅ **Observability** — every step traced in Inngest dashboard
- ✅ **Human-in-loop checkpoint** — `waitForEvent` pauses for your approval

---

## Cost

Per weekly run:
- Step 2 (cluster) — Haiku, ~5K input tokens, ~500 output → ~$0.005
- Step 5 (draft) — Sonnet, ~10K input, ~3K output → ~$0.05
- Total per week: **~$0.06**
- Per year: **~$3**

vs hiring a part-time growth ops person: ~$2,000/mo. ROI: ~99%+ if it surfaces even one offer change that lifts close rate by 5%.

---

## What this gets you

After 12 weeks:
- 12 written records of what changed in your offer
- Pattern recognition on which levers move close rate
- Guarantee data that you can stress-test
- A documented operator's instinct for offer iteration

After 52 weeks: you're in the 1% of operators who actually iterate the offer with data instead of vibes.

---

## Next steps to implement

1. ☐ Install Inngest (`npm i inngest`) or your workflow engine of choice
2. ☐ Wire up the data pulls (CRM, Stripe, support tool, cold outbound)
3. ☐ Set the cron
4. ☐ Run it manually first to verify outputs
5. ☐ Schedule a recurring 30-min slot every Friday to review the journal entry
6. ☐ After 4 weeks, evaluate: is the workflow surfacing useful insights?
7. ☐ Iterate: refine the clustering prompt; tune the decision rules

---

## Variations

- **Daily** instead of weekly during a launch
- **Multi-product** — fork per product, aggregated dashboard
- **Auto-A/B** — when the weak lever is "Dream Outcome," automatically generate 3 A/B variants for testing

---

[← Lesson 08A](../../08A-the-grand-slam-offer/README.md) | [Skill: Grand Slam Offer](../../skills/grand-slam-offer/SKILL.md) | [Template: Value Equation Worksheet](../../templates/value-equation-worksheet.md)
