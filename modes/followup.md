# Mode: Non-Responder Follow-up

> Runs daily at 10 AM. Checks Smartlead for non-responders, pushes to HeyReach.
> Requires: `_shared.md` loaded in context.

---

## Process

### Step 1: Find Candidates

Search Notion SDR Prospects database for:
- Smartlead Status = "Pushed"
- HeyReach Status = "Not Sent"
- Processed Date is 2+ days ago

### Step 2: Check Smartlead Stats

```bash
source ~/Documents/sdr-agent/.env
curl -s "https://server.smartlead.ai/api/v1/campaigns/${SMARTLEAD_CAMPAIGN_ID}/statistics?api_key=${SMARTLEAD_API_KEY}"
```

Parse response. Categorize each lead:
- **Responded** (opened + replied, or clicked): Update Notion → `Smartlead Status = "Responded"`
- **Opened but no reply** (opened, no click/reply, 2+ days): Keep monitoring, don't escalate yet
- **No response** (no opens after 2+ days): Escalate to HeyReach

### Step 3: Push Non-Responders to HeyReach

For each non-responder, read their LinkedIn messages from Notion, then:

```bash
source ~/Documents/sdr-agent/.env
curl -s -X POST "https://api.heyreach.io/api/public/list/AddLeadsToListV2" \
  -H "X-API-KEY: ${HEYREACH_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "listId": '"${HEYREACH_LIST_ID}"',
    "leads": [{
      "firstName": "FIRST",
      "lastName": "LAST",
      "emailAddress": "EMAIL",
      "position": "JOB_TITLE",
      "profileUrl": "LINKEDIN_URL",
      "customUserFields": [
        {"name": "LinkedIn Connection Request", "value": "CONNECTION_TEXT"},
        {"name": "LinkedIn Follow-Up Message", "value": "FOLLOWUP_TEXT"}
      ]
    }]
  }'
```

**Retry policy:** If HeyReach returns 429, wait 5 seconds and retry once. If still failing, log error and continue.

### Step 4: Update Notion

For each processed prospect:
- Responded → `Smartlead Status = "Responded"`
- Pushed to HeyReach → `Smartlead Status = "No Response"`, `HeyReach Status = "Pushed"`

### Step 5: Log & Summary

Append to `data/run-history.tsv`:
```
timestamp	run_type	accounts_processed	prospects_processed	emails_pushed	heyreach_pushed	responded	errors
```

Output summary: X checked, Y responded, Z pushed to HeyReach, W errors.
