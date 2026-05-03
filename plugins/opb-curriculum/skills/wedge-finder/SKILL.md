---
name: wedge-finder
description: >
  Use this skill whenever the user wants to find or validate a profitable wedge
  for a solo / near-solo agent operator. Trigger when the user mentions phrases
  like "what should I build?", "is this a good market?", "find me a wedge",
  "validate this idea", "narrow my ICP", or shares 1-N candidate ideas and
  wants scoring. Also trigger when the user is at the start of a new project,
  has just finished a job, or is feeling stuck on what to build next. Always
  use this skill before drafting an offer ([`grand-slam-offer`](../grand-slam-offer/SKILL.md))
  or running ICP/TAM analysis ([`icp-tam-research`](../icp-tam-research/SKILL.md))
  — it filters out non-starters before any further GTM work is wasted.
---

# Wedge Finder Skill

This skill defines the workflow for identifying and scoring **profitable wedges** for a solo agent operator. A wedge is the *narrow specific painful workflow you can sell to a specific paying audience.* The skill enforces the dual-test scoring (7-attribute internal + Hormozi's 4-attribute Starving Crowd), anti-wedge filters, and the 100-customer reachability check.

The skill enforces:
- **Narrow specificity** — "X for everyone" gets rejected
- **Two-test scoring** — internal (7 attributes) + Hormozi's Starving Crowd (4 attributes)
- **Anti-wedge filters** — known dead-end categories blocked
- **100-customer sanity check** — the user must name a specific channel
- **One recommended wedge** — not 3, not 5; one to pursue

---

## Hard Constraints (Check First)

### Constraint 1 — Maximum 5 Candidate Wedges

If the user wants to score more than 5 wedges, stop and say:

> "⚠️ More than 5 candidates means none get serious scoring. Pick your top 5 by gut, share those, and we'll score each properly. We can repeat the cycle if none clear the bar."

### Constraint 2 — Required Inputs Per Wedge

Each candidate wedge must have:
- **Wedge name** (1 line — what it does)
- **Specific buyer** (industry + role + company size — NOT "B2B" or "founders")
- **Specific pain workflow** (the recurring task they hate)
- **Specific channel** (ONE place you can find 100 of them)
- **Why you** (unfair access — past job, network, community)

If any are missing per wedge, ask before scoring.

### Constraint 3 — Reject Veto-List Wedges Immediately

Before scoring, check against the anti-wedge list. If a candidate matches, kill it without scoring:

| Veto wedge | Why |
|------------|-----|
| "X for everyone" / "X for all [broad category]" | Reaches no one |
| "X for engineers / developers" | They build their own; don't pay |
| "GPT wrapper for [thing]" | Commoditizes when model improves |
| "AI assistant for content creators" | Low ARPU, zero retention |
| "Notion for X" / "Slack for Y" | Switching cost > benefit |
| "B2B SaaS" with no industry / role specified | Not a wedge yet |
| "Anything in regulated space without compliance expertise" | Dies in audit |
| "Anywhere a $100M-funded company is competing on the same wedge" | Outspent |

Tell the user which veto rule killed which candidate.

---

## Workflow Overview

```
Step 1: Confirm 1-5 candidates with required inputs
Step 2: Apply anti-wedge filters (kill non-starters)
Step 3: Score each survivor on the 7-attribute matrix (internal)
Step 4: Score each survivor on Hormozi's 4-attribute Starving Crowd test
Step 5: Apply the 100-customer sanity check
Step 6: Pick ONE recommended wedge
Step 7: Output the comparison table + next-step recommendation
```

---

## Step 1 — Confirm Candidates

Restate each candidate back to the user. Confirm:
- Specific buyer named (industry + role + size)
- Specific pain workflow named (recurring + measurable)
- Specific channel named (1 place to find 100)
- Unfair access named (why YOU not competitors)

If any element is vague, ask the user to refine before scoring.

---

## Step 2 — Apply Anti-Wedge Filters

For each candidate, check against the veto list (above). Kill any matches. Output:

```
KILLED CANDIDATES:
- [wedge] — Veto: [rule]
- [wedge] — Veto: [rule]

SURVIVORS TO SCORE:
- [wedge]
- [wedge]
```

If all candidates are killed, send the user back to Step 1 with new candidates. Don't proceed to scoring with zero survivors.

---

## Step 3 — Score the 7-Attribute Internal Matrix

For each survivor, score 1-5 on these 7 attributes:

| Attribute | 1 (bad) | 5 (great) |
|-----------|---------|-----------|
| **Pain frequency** | Once a year | Multiple times per week |
| **Pain intensity** | Mild irritation | "I'd pay $500 to never do this" |
| **Payer access** | Person feeling pain has no budget | Corporate card / business expense |
| **Channel reachability** | Scattered across the internet | Concentrated in 1-3 places |
| **Manual workaround cost** | $5/hr offshore VA | $80/hr licensed pro |
| **Workflow stability** | Changes every 6 months | Stable for 5+ years |
| **Defensibility** | Anyone copies in a weekend | Needs domain knowledge / data |

Total per wedge: **__ / 35**

Verdict:
- < 22 → drop
- 22-29 → workable; investigate further
- 30+ → strong candidate

---

## Step 4 — Hormozi's Starving Crowd Test

Score 1-10 on the 4 attributes (this is *additive* to the internal scoring above):

| Attribute | Score 1-10 | Why? |
|-----------|------------|------|
| **Massive pain** (bleeding, not annoying) | __ | |
| **Purchasing power** (corporate card / business expense) | __ | |
| **Easy to target** (1-3 channels you can reach) | __ | |
| **Growing market** (rising tide, not sinking ship) | __ | |
| **Total** | **__/40** | |

Verdict:
- < 25 → wrong crowd, no offer will save you
- 25-32 → workable; build the Grand Slam carefully
- 33+ → starving crowd; ship hard

---

## Step 5 — The 100-Customer Sanity Check

For each surviving candidate, ask the user to name:

> "On the public web today, where can you find 100 of these specific people in 90 days? Name the EXACT channel — subreddit, Slack, LinkedIn group, conference, paid list."

If the user can't name a specific channel, the wedge fails — even with great scores. Mark as "channel-unproven" and recommend they validate the channel before pursuing.

---

## Step 6 — Pick ONE Recommended Wedge

Combine scores:

```
Wedge        Internal /35    Starving Crowd /40    100-cust    Total Recommend
A            __              __                    [Y/N]       __/75 + cust check
B            __              __                    [Y/N]       __/75 + cust check
C            __              __                    [Y/N]       __/75 + cust check
```

Recommend the wedge with:
- Highest combined score
- AND 100-customer = YES
- AND no veto matches

If multiple wedges tie, recommend the one where the user has the most unfair access.

If NONE clear all 3 bars, refuse to recommend. Tell the user: "All your candidates are weak. Re-do Step 1 with new candidates." Don't recommend a weak wedge to be polite.

---

## Step 7 — Required Output Format

```
### 🎯 Wedge Finder Output — [Date]

**Candidates evaluated:** [N]
**Killed by veto:** [N]
**Survivors scored:** [N]

### 📊 Comparison Table

| Wedge | Internal /35 | Starving Crowd /40 | 100-cust | Channel | Combined |
|-------|--------------|-------------------|----------|---------|----------|
| A     | __           | __                | Y/N      | [name]  | __       |
| B     | __           | __                | Y/N      | [name]  | __       |
| C     | __           | __                | Y/N      | [name]  | __       |

### ✅ Recommended Wedge: [name]

**Why this one:**
1. [Specific reason rooted in scoring]
2. [Specific reason about user's unfair access]
3. [Specific reason about market timing or growth]

**Specific buyer:**
[Industry + role + company size]

**Specific pain workflow:**
[1-2 sentences]

**Specific channel:**
[Where to find 100 of them]

**Unfair access:**
[Why this user wins over a generic competitor]

### 🚀 Next Steps

1. **Validate willingness-to-pay** → Run [`riskiest-assumption-tester`](../riskiest-assumption-tester/SKILL.md)
2. **Map identification + sizing** → Run [`icp-tam-research`](../icp-tam-research/SKILL.md)
3. **Find buying signals** → Run [`buying-triggers-signals`](../buying-triggers-signals/SKILL.md)
4. **Build the offer** → Run [`grand-slam-offer`](../grand-slam-offer/SKILL.md)

### 🔍 Wedges to Revisit Later

[List wedges that scored 22-29 but didn't win — keep on the bench]
```

---

## Worked Example

**User input:** Solo AI engineer leaving FAANG, looking for a wedge. Provides 4 candidates:

1. "AI assistant for solo founders"
2. "AI lease analyzer for Florida real estate paralegals"
3. "AI cold outbound for early-stage SaaS"
4. "AI bookkeeping for $1M+ Shopify sellers"

**Step 2 — Anti-wedge filter:**
- Candidate 1 — KILLED (no specific buyer; "solo founders" too broad)
- Candidate 2 — survives
- Candidate 3 — flagged: 12+ funded competitors. Survives but with caveat.
- Candidate 4 — survives

**Step 3 — Internal scoring:**

| Attribute | Lease (FL paralegals) | Cold outbound | Shopify bookkeeping |
|-----------|----------------------|---------------|---------------------|
| Pain frequency | 5 (weekly) | 5 (daily) | 4 (weekly) |
| Pain intensity | 5 (audit risk) | 4 | 5 (tax / audit) |
| Payer access | 5 (firm card) | 3 (founder budget tight) | 5 (CFO / founder) |
| Channel reachability | 5 (FL state bar group) | 3 (scattered) | 4 (Shopify communities) |
| Workaround cost | 5 ($150/hr lawyer) | 4 ($50/hr VA) | 5 ($80/hr CPA) |
| Workflow stability | 5 (FL law stable) | 3 (changing fast) | 5 (tax law stable) |
| Defensibility | 5 (FL law expertise) | 2 (anyone copies) | 4 (CPA partnerships) |
| **Total** | **35/35** | **24/35** | **32/35** |

**Step 4 — Starving Crowd:**

| Attribute | Lease | Cold outbound | Bookkeeping |
|-----------|-------|---------------|-------------|
| Massive pain | 9 | 7 | 9 |
| Purchasing power | 9 | 6 | 9 |
| Easy to target | 9 | 5 | 8 |
| Growing market | 7 | 8 | 8 |
| **Total** | **34/40** | **26/40** | **34/40** |

**Step 5 — 100-customer check:**
- Lease: ✅ (FL state bar paralegal Slack + 3 paralegal subreddits)
- Cold outbound: ❌ (user can't name a specific channel; "Twitter" too vague)
- Bookkeeping: ✅ (Shopify Plus user community + Klaviyo customer base + private Slacks)

**Step 6 — Recommendation:**

Lease (35 + 34 = 69, channel ✅) and Bookkeeping (32 + 34 = 66, channel ✅) both qualify. Recommend **Lease analyzer** because user has unfair access (worked at FL real estate firm during summer internships, has 50+ paralegal LinkedIn connections). Bookkeeping kept on the bench.

**Output:**
> Recommended wedge: **Lease Risk Analyzer for Florida Real Estate Paralegals.** Specific buyer: paralegals at FL real estate firms (50-500 employees). Specific pain: 6 hours per lease checking 24 standard clauses for unusual terms. Channel: FL State Bar paralegal Slack (1,200 members), 3 paralegal subreddits, FL real estate paralegal LinkedIn group. Unfair access: prior summer internships + 50 connections.

---

## Common Mistakes to Avoid

- **Do not let the user score "AI for everyone".** Reject. Force narrowing.
- **Do not skip the anti-wedge filter.** Some wedges are dead before scoring.
- **Do not recommend a wedge without the 100-customer channel.** "TAM is huge" doesn't matter without channel proof.
- **Do not score more than 5 candidates at once.** None get serious analysis.
- **Do not recommend the highest-scoring wedge if the user has no unfair access.** The score might be right; the operator is wrong.
- **Do not let "I'll figure out the channel later" pass.** Channel is THE bottleneck for solo operators.
- **Do not validate-then-pivot endlessly.** If 3 cycles of wedge-finding produce no recommendation, the user has a deeper issue (possibly wrong industry, possibly wrong moment to start).
- **Do not score wedges in someone else's domain.** "I want to build for healthcare" — but the user has zero healthcare exposure — is a vetoed wedge.

---

## Notes on Research Sources

When researching whether a candidate wedge has a starving crowd, prioritise:

1. **Industry-specific subreddits** — read top 50 posts of last 6 months for recurring complaints
2. **G2 / Capterra** — 1-3 star reviews on tools in the adjacent space; specific gripes
3. **LinkedIn / Twitter** — what professionals in the role are actually venting about
4. **Job postings** — if 200 firms are hiring for "manual X processor", X is automatable
5. **Industry Slack / Discord groups** — where the role hangs out (e.g., RevOps Co-op, Demand Curve)
6. **Conference speaker lists** — what topics they're paying to attend
7. **Trade publications** — what the industry's own writers cover as pain
8. **The user's own past employer** — workflows you hated and saw others hate

Avoid as research source: HackerNews (engineers self-select for DIY), generic Reddit, AI-generated summaries.

---

## Notes on When to Re-Run This Skill

- After **any major market shift** (new regulation, model release that commoditizes a category)
- **Quarterly** during the first year (you'll learn faster than your initial wedge can keep up)
- After **3 months of failed wedge validation** — possibly the wedge isn't the issue but the operator's access is
- When **user is bored** of current wedge — usually a sign the wedge was wrong, not that the user should quit

---

## Quick Reference — Wedges That Have Worked

For inspiration (don't copy — find your own):

| Wedge archetype | Example operator |
|-----------------|------------------|
| Compliance / regulatory automation | Vanta (early), Drata |
| Workflow automation in regulated industry | Harvey (legal), Hippocratic (medical) |
| B2B sales tooling for niche vertical | Common Room, Default |
| Replacing $50/hr offshore role with $99/mo agent | Brex (early ops), Mercury |
| Industry-specific second brain | Granola (meeting notes), Glean |
| Migration / integration agents | Common Paper (legal docs migration) |

---

## Source

Lesson 05: [Find a Profitable Wedge](../../05-find-a-profitable-wedge/README.md)
