"""LangGraph flows for gtm-ops.

Spec-aligned agents (per cf-gtm-context.md §3):

Acquisition loop:
    - icp_scout — daily prospect ingest + ICP scoring + tier routing
    - outreach_writer — per-tier 3-touch personalized sequence with HITL on Tier A/B
    - reply_classifier — 6-class intent classifier on Smartlead reply webhook

Nurture loop:
    - stage_mover — branching trigger (stagnation cron OR meeting-prep calendar)
    - cross_sell_detector — weekly product-pair gap scan with personalized pitch

Re-engagement loop:
    - dormant_detector — 30/60/90d windows with change-signal-driven re-engagement
    - churn_saver — composite churn signal with CSM brief or auto MoEngage save journey

Utility agents:
    - drive_transcript_extractor — Drive watcher → typed property extraction
    - forms_router — Google Forms webhook → downstream-agent dispatch
    - din_watchdog — 15-min anomaly scan + daily 9am reconciliation report

Legacy flows (from JD-aligned scaffold; partial overlap with spec agents — kept
for historical reference and cross-validation):
    - meeting_prep — original Flow 1 (functionality folded into stage_mover.meeting_prep_branch)
    - crm_enrichment — original Flow 3 (functionality folded into icp_scout)
    - cold_deal_flagger — original Flow 5 (utility; complements stage_mover)
    - followup_drafter — Flow 4; used by stage_mover and outreach_writer
    - win_loss_analyzer — original Flow 7 (monthly synthesis)
    - multichannel_outbound — original Flow 8 (orchestration of outreach + reply + dripify)
"""
