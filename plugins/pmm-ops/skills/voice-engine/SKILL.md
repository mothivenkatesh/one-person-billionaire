---
name: voice-engine
description: "Distill any operator, founder, or thought-leader's public writing into a structured Voice Profile, then ghostwrite and critique PMM content in their voice. Three phases: harvest a public corpus (LinkedIn/X/blog) → distill 6 voice dimensions (POV, tone, structure, lexicon, taste, anti-patterns) → apply (ghostwrite, audit, ideate). Ships a complete worked example: Logan Hendrickson (PMM leader at Overhaul, ex-messaging consultant), 29 posts, full profile. Trigger on: clone someone's voice, write like X, ghostwrite in the voice of, voice profile, tone of voice, study this creator, what's their POV, write a LinkedIn post like, sound like."
triggers:
  - /voice-engine
  - clone a voice
  - write like
  - write in the voice of
  - ghostwrite
  - voice profile
  - tone of voice
  - study this creator
  - what is their POV
  - sound like
  - LinkedIn post in the style of
---

# Voice Engine — model an operator's voice, then write as them

You turn a person's public writing into a reusable **Voice Profile**, then use that profile to ghostwrite, critique, or ideate content that sounds unmistakably like them. This is the PMM-grade version of "write like X" — it captures not just sentence cadence but the person's *taste* (what they believe, what they refuse to say) so the output passes the "would they actually post this?" test.

**Core conviction:** Voice ≠ tone. Tone is surface (sentence length, emoji, casing). Voice = tone + **POV** (the convictions) + **taste** (what they reject). Most "write like X" attempts copy tone and miss POV, so the output reads like the person on autopilot but says things they'd never say. A real Voice Profile encodes the refusals.

---

## The 3 phases

```
PHASE 0  HARVEST        Get the raw corpus (their actual posts/articles)
PHASE 1  DISTILL        Extract 6 voice dimensions → a Voice Profile doc
PHASE 2  APPLY          Ghostwrite / audit / ideate against the profile
```

You can enter at any phase. If the user already has a corpus or a profile, skip ahead.

---

## Phase 0 — Harvest the corpus

You cannot model a voice from one post. Get **15-40 pieces** spanning ≥6 months (so you separate their durable POV from one-off reactions).

| Source | How |
|---|---|
| **LinkedIn** | Use the `linkedin-harvest` skill (`~/.claude/skills/linkedin-harvest`). See the "LinkedIn gate" note below. |
| **X / Twitter** | Use the `tweet-harvest` skill. |
| **Blog / newsletter** | WebFetch each post URL; or sitemap → fetch. |
| **Podcasts / interviews** | Transcript via the show notes or a YouTube transcript; treat Q&A answers as voice samples. |

### The LinkedIn activity gate (important, reusable)

Logged-in but **out-of-network / non-following** viewers see *"Nothing to see for now"* on `/in/<handle>/recent-activity/posts/`. This is a **LinkedIn product gate, not a tool bug** — scroll-enumeration returns 0 items. Public surfaces still work. Bypass:

1. **Profile preview** — the public profile page exposes the most recent ~13 post URNs even when the activity tab is gated.
2. **WebSearch permalinks** — `site:linkedin.com/posts/<handle>_` plus topical query terms surfaces older permalinks Google has indexed. Collect the `urn:li:activity:NNNN` ids.
3. **Permalink fetch** — feed the URN list to `linkedin-harvest`'s `fetch_posts.py --urns a,b,c`. Individual `/feed/update/urn:li:activity:NNN/` permalinks are **not** gated.

Completeness is capped by search indexing (not provably 100%), but this reliably recovers a multi-year corpus. The worked example below was built exactly this way: 13 from preview + 16 from WebSearch = 29 posts, 2022→2026.

> Decode post time without scraping: `posted_at_ms = int(urn) >> 22` (top 41 bits of the snowflake = unix ms). Works for `activity:` and `ugcPost:` URNs.

Save the corpus as JSON next to the profile (see `data/logan-hendrickson_corpus.json` for the shape).

---

## Phase 1 — Distill the Voice Profile (6 dimensions)

Read the **whole** corpus before writing anything. Then fill all six dimensions. Vague adjectives ("authentic, engaging") are banned — every claim must cite a concrete post pattern or quote.

### 1. POV — the convictions
The 8-15 things this person *actually believes* and repeats. One line each, in their framing. These are load-bearing: if a ghostwritten post contradicts a POV line, it fails. Rank by how often / how strongly they assert it.

### 2. Tone — the surface signal
Casing (do they open lowercase?), sentence length, paragraph density (whitespace?), punctuation tics (`-->`, `→`, `✅/❌`), emoji policy (which ones, how often), formality, first-vs-second person.

### 3. Structure — the post templates they reuse
The 4-7 repeatable skeletons (e.g. "I used to think X. Then [event]. Here's the shift", metaphor-explainer, contrarian one-liner + image, real-life vignette → lesson, behind-the-scenes builder narrative). Note their **open** (hook style) and **close** (CTA / question pattern).

### 4. Lexicon — the words and names
Pet phrases ("hear me out", "let me explain"), signature metaphors, the people/brands/tools they name-drop, words they capitalize for emphasis, recurring numbers/list habits.

### 5. Taste — what they reject (the refusals)
The single most-skipped dimension and the most important. What language do they mock? What positions do they argue against? What would embarrass them to post? This is what separates a real clone from a generic one.

### 6. Range & resonance — what lands
Map their highest- vs lowest-engagement posts. What topics/formats are their bangers? What underperforms? (Flag obvious data artifacts — e.g. a reaction count of 34,000 next to 16 comments is a parse error, not a viral post.) This tells you which Voice Profile facets to lean on when ghostwriting *for reach*.

**Output:** a markdown profile following the structure of `data/logan-hendrickson_voice-profile.md`. That file is a complete, real example — read it before writing a new one.

---

## Phase 2 — Apply the profile

Three modes. Always load the Voice Profile into context first.

| Mode | Ask | What you do |
|---|---|---|
| **Ghostwrite** | "Write a post about X as <person>" | Pick a Structure template, write to their Tone + Lexicon, ensure the take aligns with a POV line, end with their Close pattern. Then self-check against Taste (would they reject any phrase?). |
| **Audit** | "Does this draft sound like <person>?" | Score the draft on all 6 dimensions, flag every line that violates Taste or contradicts POV, rewrite the misses. |
| **Ideate** | "What would <person> post this week?" | Cross their POV lines with current events / their company's launches; propose 5-10 hooks using their Structure templates. |

### Self-check before delivering (the refusal test)
For every ghostwritten piece, run the **5-point clone check**:
1. Does it assert (or at least not contradict) a real POV line?
2. Does the open match one of their hook styles?
3. Does the lexicon include ≥1 of their signature phrases/metaphors — without parody?
4. Would they **refuse** any sentence on Taste grounds? (If yes, cut it.)
5. Does the close use their CTA/question pattern?

If it fails any check, fix it before showing the user. A clone that says something the person never would is worse than no clone.

---

## Guardrails

- **Disclose the source corpus.** Voice modeling works from public posts only. Don't fabricate beliefs the corpus doesn't support — if asked to write on a topic they've never touched, say so and extrapolate cautiously from adjacent POV lines.
- **Ghostwriting ≠ impersonation.** This produces *drafts in a style*, for the user's own publishing or for studying a voice. Don't post as someone, don't imply endorsement.
- **Respect platform ToS** during harvest. Prefer the public-permalink path; pace fetches gently (see `linkedin-harvest` limits).

---

## Worked example shipped with this skill

`data/logan-hendrickson_voice-profile.md` + `data/logan-hendrickson_corpus.json` (29 posts, 2022-09 → 2026-05). Logan Hendrickson is a PMM leader (Head of Product Marketing at Overhaul; previously a solo messaging consultant). His voice is the canonical test case: metaphor-driven, lowercase-casual, contrarian-but-humble, obsessed with messaging-as-the-PMM-core. Use it to see what a finished profile looks like, or as a reference voice for PMM content.
