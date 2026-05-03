# sql/

> dbt-lite SQL marts that feed the three BI surfaces. **`mart_buyer_journey` is the spine.**

---

## Schema convention

- **`stg_*` views** = staging (cleanup, type-cast, dedupe)
- **`mart_*` views** = metric-ready aggregations consumed by Metabase + QuickSight + Sheets
- All marts are **materialized views** with nightly refresh: `REFRESH MATERIALIZED VIEW CONCURRENTLY mart_*`
- **Migrate to dbt-core** when mart count exceeds ~30 (estimated month 4-6)

---

## Files

### Schema

- **[`001_schema.sql`](001_schema.sql)** — Postgres mirror of Salesforce + ClickHouse-style audit log + agent state. Run once on a fresh Postgres 16 instance with pgvector extension.

### Marts (to build)

| Mart | Priority | Purpose |
|---|---|---|
| **`mart_buyer_journey`** ⭐ | **P0 (build first)** | The spine — one canonical row per opportunity with every milestone date + source + amount. All other marts join to this. |
| `mart_din_performance` | P1 | Per-DIN pipeline + spend + win-rate (joins via `campaign_din`) |
| `mart_channel_attribution` | P1 | Channel-level touches → opportunities → revenue |
| `mart_account_health` | P1 | Composite ICP-fit + intent + engagement + churn-risk per account |
| `mart_lifecycle_metrics` | P2 | Onboarding/retention/re-engagement/adoption (vs Razorpay benchmarks 29/25/19/16%) |
| `mart_ae_performance` | P2 | Per-AE pipeline · calendar-fill · conversion rates |
| `mart_outbound_health` | P2 | Deliverability + reply rate + cost-per-demo per domain |
| `mart_recycled_recovery` | P3 | Recycled-to-revived conversion by tier/vertical/recycle_reason |

---

## The spine — `mart_buyer_journey`

Per CS2's Go-To-Market Operations Framework: **every closed-won (or closed-lost) opportunity resolves to ONE row** capturing every milestone, source, and amount. This is the single canonical record from which all 9 analytics dimensions roll up.

See spec §8.3 for the full schema (24 columns including `journey_id`, `account_name`, `gtm_motion`, `source`, `campaign`, all milestone dates, `opportunity_amount`, `cycle_days`, `first/last/multi-touch attribution`, etc.).

**Critical:** this view is **non-negotiable for v1** even if you defer everything else. Without it, every reporting question becomes a custom SQL query.

---

## Adding a new mart

See top-level [`CONTRIBUTING.md`](../CONTRIBUTING.md) §"Adding a new SQL mart".

Required steps:
1. Add to `cf-gtm-context.md` §8.4 with purpose + columns + source tables
2. If introducing a new metric, add to `gtm.metric-definitions` Sheet first
3. Write SQL with `stg_*` → `mart_*` chain
4. Add nightly `REFRESH MATERIALIZED VIEW CONCURRENTLY` to cron
5. Test query latency (<3s for AE-facing marts)
6. Update the table above with status

---

## Future: dbt-core migration

When mart count exceeds ~30 (estimated month 4-6 of build), migrate to dbt-core for:

- Proper version control + testing
- DAG visualization
- Refresh dependency management
- Snapshot/SCD2 patterns
- Documentation generation

dbt-core is free + self-hosted. dbt-Cloud paid version deferred indefinitely.
