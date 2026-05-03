# Mode: Batch Processing

> Processes multiple prospects in parallel using background agents.
> Use when 5+ prospects are queued and you want faster throughput.

---

## Architecture

```
Conductor (main agent)
  ├── reads Google Sheet → extracts prospect list
  ├── reserves Notion placeholder entries (prevents ID collisions)
  ├── spawns worker agents (run_in_background)
  │     ├── Worker 1: prospect A (validate → research → outreach)
  │     ├── Worker 2: prospect B (validate → research → outreach)
  │     └── Worker 3: prospect C (validate → research → outreach)
  ├── collects results from workers
  ├── merges staging TSVs
  ├── pushes to Notion + Smartlead (sequentially, to respect rate limits)
  └── logs run summary
```

## Conductor Rules

1. **Max parallel workers: 3.** More causes context/API saturation.
2. **Never 2+ workers with Chrome in parallel.** Chrome sessions collide. Workers use WebFetch/WebSearch only. Conductor handles all Chrome work upfront (reading Google Sheets).
3. **Pre-reserve sequential IDs** before spawning workers. Each worker gets: prospect data + reserved ID + staging file path.
4. **Workers are self-contained.** Each worker prompt includes the full `_shared.md` context, `_config.md` values, and the prospect's data. No dependency on SKILL.md or the conductor's context.
5. **Workers write to staging only.** `data/staging/prospects/{email-slug}.tsv`. Never to Notion directly.
6. **Conductor merges + pushes.** After all workers complete, conductor reads staging files, validates, pushes to Notion, pushes valid emails to Smartlead.

## Worker Output Format

Each worker writes a JSON result to its staging file:

```json
{
  "status": "completed",
  "prospect_name": "Sarah Chen",
  "company": "Acme Hotels",
  "email": "sarah.chen@acmehotels.com",
  "icp_score": 4.2,
  "vertical": "Hospitality",
  "classification": "Decision Maker",
  "research_quality": "High",
  "email_validated": true,
  "email_status": "valid",
  "outreach_generated": true,
  "error": null
}
```

On failure:
```json
{
  "status": "failed",
  "prospect_name": "Sarah Chen",
  "error": "LinkedIn profile inaccessible, WebSearch returned no results"
}
```

## Failure Isolation

- A crash in Worker 2 does NOT affect Workers 1 or 3.
- Each worker logs independently to `data/batch-logs/{email-slug}.log`.
- Conductor collects all results, reports failures, and only pushes successful ones.
- Failed prospects are logged with error reason for retry in next run.

## When to Use Batch vs Sequential

| Scenario | Mode |
|----------|------|
| 1-4 prospects | Sequential (default `ai-sdr-agent` run) |
| 5-10 prospects | Batch with 2-3 workers |
| 10+ prospects | Batch with 3 workers, multiple rounds |
| API rate limit errors | Switch to sequential |
