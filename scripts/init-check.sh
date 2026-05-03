#!/bin/bash
# AI SDR Agent — Pre-run Initialization Check
# Run before every agent execution. Exits non-zero on critical failure.

set -euo pipefail

ENV_FILE="${HOME}/Documents/sdr-agent/.env"
CONFIG_FILE="${HOME}/Documents/sdr-agent/modes/_config.md"
STAGING_DIR="${HOME}/Documents/sdr-agent/data/staging"
HISTORY_FILE="${HOME}/Documents/sdr-agent/data/run-history.tsv"

errors=0
warnings=0

echo "=== AI SDR Agent Init Check ==="
echo "Timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo ""

# 1. Check .env exists and has required keys
echo "[1/6] Checking .env..."
if [[ ! -f "$ENV_FILE" ]]; then
    echo "  FAIL: .env not found at $ENV_FILE"
    ((errors++))
else
    required_keys=("ZEROBOUNCE_API_KEY" "SMARTLEAD_API_KEY" "SMARTLEAD_CAMPAIGN_ID" "HEYREACH_API_KEY" "HEYREACH_LIST_ID" "GOOGLE_SHEET_URL" "NOTION_ACCOUNTS_DATASOURCE" "NOTION_PROSPECTS_DATASOURCE")
    source "$ENV_FILE"
    for key in "${required_keys[@]}"; do
        if [[ -z "${!key:-}" ]]; then
            echo "  FAIL: $key is empty or missing in .env"
            ((errors++))
        fi
    done
    if [[ $errors -eq 0 ]]; then
        echo "  OK: All required keys present"
    fi
fi

# 2. Check _config.md exists
echo "[2/6] Checking _config.md..."
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "  WARN: _config.md not found — using defaults from _shared.md"
    ((warnings++))
else
    echo "  OK: _config.md found"
fi

# 3. Check staging directories exist
echo "[3/6] Checking staging directories..."
mkdir -p "$STAGING_DIR/accounts" "$STAGING_DIR/prospects"
echo "  OK: Staging directories ready"

# 4. Check run history file
echo "[4/6] Checking run history..."
if [[ ! -f "$HISTORY_FILE" ]]; then
    echo "timestamp	run_type	accounts_processed	prospects_processed	emails_pushed	heyreach_pushed	responded	errors" > "$HISTORY_FILE"
    echo "  OK: Created run-history.tsv with headers"
else
    line_count=$(wc -l < "$HISTORY_FILE" | tr -d ' ')
    echo "  OK: run-history.tsv exists ($((line_count - 1)) previous runs)"
fi

# 5. Test ZeroBounce API connectivity
echo "[5/6] Testing ZeroBounce API..."
if [[ -n "${ZEROBOUNCE_API_KEY:-}" ]]; then
    zb_response=$(curl -s -o /dev/null -w "%{http_code}" "https://api.zerobounce.net/v2/getcredits?api_key=${ZEROBOUNCE_API_KEY}" 2>/dev/null || echo "000")
    if [[ "$zb_response" == "200" ]]; then
        echo "  OK: ZeroBounce API reachable"
    else
        echo "  WARN: ZeroBounce API returned $zb_response (may be rate-limited)"
        ((warnings++))
    fi
else
    echo "  SKIP: No API key"
fi

# 6. Test Smartlead API connectivity
echo "[6/6] Testing Smartlead API..."
if [[ -n "${SMARTLEAD_API_KEY:-}" ]]; then
    sl_response=$(curl -s -o /dev/null -w "%{http_code}" "https://server.smartlead.ai/api/v1/campaigns/${SMARTLEAD_CAMPAIGN_ID}/statistics?api_key=${SMARTLEAD_API_KEY}" 2>/dev/null || echo "000")
    if [[ "$sl_response" == "200" ]]; then
        echo "  OK: Smartlead API reachable"
    else
        echo "  WARN: Smartlead API returned $sl_response"
        ((warnings++))
    fi
else
    echo "  SKIP: No API key"
fi

# Summary
echo ""
echo "=== Result: $errors errors, $warnings warnings ==="

if [[ $errors -gt 0 ]]; then
    echo "ABORT: Fix errors above before running the agent."
    exit 1
fi

if [[ $warnings -gt 0 ]]; then
    echo "PROCEED WITH CAUTION: Warnings detected but non-blocking."
fi

exit 0
