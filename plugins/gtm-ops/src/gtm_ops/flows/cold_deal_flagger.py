"""Flow 5 — Deal-cold flagging (stubbed).

The heavy lifting is SQL: see sql/001_schema.sql for the `cold_deal_flags` materialized view.
Metabase reads that view directly. A small refresh job keeps it current.

Planned graph:
    scheduled_trigger → REFRESH MATERIALIZED VIEW cold_deal_flags CONCURRENTLY
      → query top-N cold deals → slack_alert to deal owners
"""
