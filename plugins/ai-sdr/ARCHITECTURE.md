# Architecture

Why this agent is structured the way it is, and what each piece does.

---

## Design Goals

1. **Autonomy over supervision** — The agent runs on a schedule without manual intervention.
2. **Safety over speed** — Hardcoded NEVER rules, score gates, and init checks prevent embarrassing mistakes.
3. **Maintainability over cleverness** — Modular mode files are easy to read, test, and update.
4. **Update-safety** — System files can be updated via `git pull` without touching user config.
5. **Crash resilience** — TSV staging means a mid-run crash doesn't lose prospect data.

---

## The Router + Mode Injection Pattern

Inspired by [santifer/career-ops](https://github.com/santifer/career-ops).

### What it is
Scheduled tasks are thin routers. They do:
1. Init check
2. Load context files (`_shared.md`, `_config.md`, relevant mode files)
3. Execute the fixed pipeline

All domain logic lives in `modes/`. The router knows the sequence; the modes know the details.

### Why it works
- **Modes are independently testable.** You can invoke `validate.md` on a single account without running the full pipeline.
- **Modes are independently updatable.** Changing scoring logic means editing `validate.md`, not the scheduler.
- **Context loading is deterministic.** The router always loads the same files in the same order.
- **Debugging is easier.** If outreach is off, you know the bug is in `outreach.md`.

### Comparison to career-ops

| Aspect | career-ops | AI SDR Agent |
|---|---|---|
| Router file | `SKILL.md` with intent detection | Scheduled task prompts |
| Mode trigger | User input (`oferta`, `scan`, etc.) | Pipeline step |
| Context loading | Conditional per mode | All modes pre-loaded for the pipeline |
| Mode count | 14 | 7 |

The SDR agent has fewer modes because it's a single pipeline (not a multi-intent system like career-ops). The router pattern still applies — each mode is a self-contained prompt file.

---

## Layered Context: System vs User

### The Two Layers

| File | Layer | Ownership | Update Policy |
|------|-------|-----------|---------------|
| `modes/_shared.md` | System | Repo maintainer | Auto-updatable via `git pull` |
| `modes/_config.md` | User | You | Never overwritten (gitignored) |

### Why This Matters

**Without separation:** Every user must customize the entire skill file. When the repo updates its scoring logic, users must manually merge changes against their customizations.

**With separation:**
- Repo updates improve `_shared.md` (new pain points, scoring tweaks, NEVER rules)
- Users customize `_config.md` (your product, voice, priorities)
- `git pull` safely updates system logic without touching your config
- Your customizations always win at runtime

### Override Semantics

When the agent loads context, it reads `_shared.md` first, then `_config.md`. Values in `_config.md` override defaults in `_shared.md`. This is stated explicitly at the top of `_shared.md`:

> User customizations go in `_config.md` (never overwritten).
> Read `_config.md` AFTER this file. User values override defaults here.

Example:
```yaml
# In _shared.md:
min_score_full_pipeline: 4.0

# In _config.md:
min_score_full_pipeline: 3.5   # User lowered the threshold
```

At runtime, the agent uses `3.5`.

---

## TSV-First State Management

### The Problem
Writing directly to Notion or a shared log during processing creates race conditions:
- Two prospects fail mid-write → Notion has partial data
- Agent crashes after pushing to Smartlead but before updating Notion → state diverges
- Parallel workers both try to write the same run history row → conflict

### The Solution
All writes go through a 2-phase commit:

1. **Phase 1 (during processing):** Write to `data/staging/prospects/{email-slug}.tsv` or `data/staging/accounts/{domain}.tsv`.
2. **Phase 2 (end of run):** Merge staging files → push to Notion → append to `run-history.tsv`.

### Benefits
- **Crash safety**: If the agent crashes in Phase 1, staging files are preserved. Next run can retry.
- **Atomic run history**: `run-history.tsv` is appended once at the end with the final tally.
- **Parallelism**: Multiple workers write to distinct staging files (no collisions).
- **Debugging**: Staging files are human-readable — you can inspect what the agent was about to write.
- **Retry logic**: Failed Notion pushes leave data in staging for next run to recover.

### Inspired By
career-ops uses the same pattern: batch workers write to `batch/tracker-additions/{ID}.tsv`, and `merge-tracker.mjs` handles the canonical write to `data/applications.md`. We use the same approach for Notion writes.

---

## Score Gates

### The Problem
Without gates, the agent wastes effort on low-quality leads:
- Researching prospects at companies that don't fit the ICP
- Generating 3 email variants for leads that will never convert
- Pushing low-quality emails to Smartlead and hurting sender reputation

### The Solution
Three-tier score gates:

| Score | Action | Rationale |
|-------|--------|-----------|
| >= 4.0 | Full pipeline | Strong ICP fit, worth the compute cost |
| 3.0 – 3.9 | Research only | Flagged for manual review, no outreach yet |
| < 3.0 | Skip | Not worth processing further |

### Score Dimensions

Each account gets scored 1-5 across 4 dimensions, weighted:

| Dimension | Weight | What It Measures |
|-----------|--------|-----------------|
| Firmographic fit | 30% | Employee count, revenue, growth stage |
| Technographic fit | 25% | Current tech stack alignment |
| Pain signal strength | 25% | Evidence of CX/EX initiatives |
| Vertical match | 20% | Clean fit to one of 8 verticals |

### Customization
Thresholds are overridable in `modes/_config.md`:
```yaml
min_score_full_pipeline: 3.5   # Override default 4.0
min_score_research_only: 2.5   # Override default 3.0
```

---

## Three-Tier Tool Fallback

### The Problem
Web scraping is unreliable:
- Modern job sites are SPAs that need JavaScript rendering
- Some pages require authentication
- Others are static HTML that's fast to fetch
- Sometimes data is only findable through search, not direct URLs

### The Solution
Always try tools in this order:

| Priority | Tool | Best For | Failure Mode |
|----------|------|----------|--------------|
| 1 | Chrome/Playwright | SPAs, auth'd pages, Google Sheets | Session collision, rate limit |
| 2 | WebFetch | Static HTML, company websites | Returns empty for JS-heavy pages |
| 3 | WebSearch | Broad discovery, cached content | Results may be stale (weeks) |

### Implementation
Each mode file explicitly calls out the fallback chain. For example, `validate.md`:

> Use the three-tier fallback (Chrome → WebFetch → WebSearch) to research the company:
> 1. Navigate to the company's website
> 2. Search for employee/revenue data
> 3. Check LinkedIn company page if accessible

If Tier 1 fails, try Tier 2. If Tier 2 fails, try Tier 3. If all fail, log the error and ask user for manual input. **Never silently skip.**

### Why Not Always Start with WebSearch?
Google caches results for weeks or months. For time-sensitive data (recent LinkedIn posts, current company status), cached data can be wrong. Chrome/WebFetch gets fresh data.

### Chrome Concurrency Constraint
career-ops has a hard rule: "NEVER 2+ agents with Playwright in parallel." Chrome sessions collide. We inherit this rule. In batch mode, the conductor handles all Chrome work upfront (reading the Google Sheet), then spawns workers that use WebFetch/WebSearch only.

---

## NEVER / ALWAYS Rules

### Why Explicit Rules
Models drift. Without explicit rules, each run might:
- Invent company data that sounds plausible but is fabricated
- Include "Dear [Name]" because it's trained on generic email templates
- Use banned corporate-speak like "leveraged" and "synergies"
- Skip the init check because it "knows the config is fine"

### How They Work
`modes/_shared.md` has 10 NEVER rules and 10 ALWAYS rules. Every scheduled task prompt references them. The router loads `_shared.md` into context, so the rules are always present in the agent's working memory.

### Example Enforcement
```
NEVER invent company data. If web research doesn't confirm employee count,
revenue, or tech stack — state "Not publicly available." Do not guess.
```

This gets violated if the rule is buried. Keeping it in `_shared.md` — which is loaded at the top of every run — ensures the rule is top-of-mind.

### Inspired By
career-ops has the same pattern in its `_shared.md`. The banned phrase list (leveraged, spearheaded, synergies) is copied from their CV-writing rules because they're equally bad in cold emails.

---

## Session Initialization Check

### What It Does
`scripts/init-check.sh` runs before every agent execution. It:
1. Verifies `.env` has all required keys
2. Confirms `_config.md` exists (warns if not)
3. Creates staging directories if missing
4. Creates `run-history.tsv` with headers if missing
5. Pings ZeroBounce API for a credit check
6. Pings Smartlead API for connectivity

### Why
- Catches configuration errors before they become Notion writes
- Saves runs from failing midway due to missing keys
- Makes "why did the agent not run?" debugging trivial (check init-check output)

### Failure Modes
- **0 errors, 0 warnings** → proceed
- **0 errors, N warnings** → proceed with caution (API may be flaky)
- **N errors** → abort run with error message

### Inspired By
career-ops has `cv-sync-check.mjs` that runs on the first evaluation of each session. Same principle: validate config before processing.

---

## Analytics Mode

### What It Does
`ai-sdr-analytics` runs weekly. It reads the Notion databases, calculates conversion rates at each pipeline stage, compares verticals, and generates 5 ranked recommendations.

### The Minimum Data Gate
Analytics skips analysis if there's insufficient data:
- Funnel analysis needs 20+ prospects
- Vertical comparison needs 5+ prospects per vertical
- Outreach variant comparison needs 15+ emails per variant

If the gate isn't met, the agent outputs "Insufficient data" and exits gracefully. No fake insights from tiny samples.

### What It Recommends
- ICP threshold adjustments ("Lower Technology to 3.5 — 80% of 3.5+ Tech accounts convert")
- Vertical reprioritization ("Move Banking to #1 — 2x response rate")
- Outreach tweaks ("Activity Hook underperforms for HR — use Industry Hook instead")
- Exclusions ("Fitness under $50M never responds — raise revenue floor")
- Volume adjustments ("Error rate 2% — safe to increase from 5 to 8 prospects/run")

### Self-Modification Boundary
Analytics can SUGGEST changes to `_config.md`. It can NEVER modify `_shared.md`. The user must manually apply suggestions. This prevents runaway self-modification.

### Inspired By
career-ops has `patterns.md` mode that does rejection pattern analysis on job applications. Same structure: minimum data gate, ranked recommendations, user approval before applying.

---

## Batch Mode

### When to Use
- 1-4 prospects → sequential (default)
- 5-10 prospects → batch with 2-3 workers
- 10+ prospects → batch with 3 workers, multiple rounds

### Architecture
```
Conductor (main agent)
  ├── Reads Google Sheet (Chrome — only the conductor uses Chrome)
  ├── Reserves sequential IDs for each prospect
  ├── Spawns workers (max 3) using run_in_background
  │     ├── Worker 1: process prospect A
  │     ├── Worker 2: process prospect B
  │     └── Worker 3: process prospect C
  ├── Each worker writes to data/staging/prospects/{email}.tsv
  ├── Conductor collects results
  ├── Merges staging files
  └── Pushes to Notion + Smartlead sequentially (respects rate limits)
```

### Worker Isolation
- Each worker has its own context (no memory sharing)
- Workers use WebFetch/WebSearch only (no Chrome to prevent session collision)
- A crash in Worker 2 doesn't affect Workers 1 or 3
- Failed workers are logged with error reasons for retry

### Inspired By
career-ops batch mode uses `claude -p` child processes for the same isolation. We use Claude Code's `run_in_background` which is the native equivalent.

---

## Why Not Multi-Agent?

Could this be N specialized agents coordinating? Possibly. But for this use case, single-conductor + modes is simpler:

| Approach | Pros | Cons |
|----------|------|------|
| Single conductor + modes | Simple context loading, deterministic flow, easy debugging | Context grows with prospect count |
| Multi-agent (orchestrator + specialists) | Better parallelism, isolated contexts per specialist | Coordination overhead, harder to debug, more failure modes |

The SDR pipeline is linear (validate → research → outreach → push). There's no branching that benefits from specialized agents. Modes give us the context isolation we need without the coordination complexity.

**The exception**: batch mode uses workers for parallelism when processing 5+ prospects. Each worker is a "specialist" in the sense that it owns one prospect end-to-end. The conductor orchestrates. This is multi-agent-lite — just enough parallelism, no more.

---

## Future Improvements

Things we haven't built yet but could:

1. **Persistent state for interrupted runs.** Currently staging files are our crash-recovery mechanism, but a dedicated `data/pending-runs.tsv` could track half-finished work explicitly.
2. **Adaptive score thresholds.** Analytics already recommends threshold changes — could auto-apply them with a cooldown period and rollback on regression.
3. **Multi-language outreach.** Detect the prospect's LinkedIn language and generate outreach in that language (career-ops does this with i18n mode files).
4. **Feedback loop from Smartlead replies.** When a prospect replies, analyze the reply to tune future messaging.
5. **Account-based orchestration.** Group prospects by company and send coordinated outreach to multiple contacts in the same account.
