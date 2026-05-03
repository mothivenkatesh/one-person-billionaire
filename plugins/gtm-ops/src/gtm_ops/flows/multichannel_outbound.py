"""Flow 8 — Multi-channel outbound (Smartlead + Dripify) with reply-catch (stubbed).

Planned graph:
    qualified_list (Clay/Common Room) → parallel:
        (a) smartlead.create_campaign + add_leads
        (b) dripify.start_sequence  (webhook-only in portfolio demo)
      → reply_webhook fires on either channel
      → pause both sequences → create HubSpot deal → slack_alert to AE
"""
