/**
 * gtm.din-anomalies.gs — DIN-Watchdog output.
 *
 * Trigger: append-only via webhook from cf-din-watchdog agent (15-min anomaly scan +
 * daily 9am reconciliation).
 *
 * Slack alert fires immediately on any P0 row append.
 * Daily reconciliation digest also written here at 9am as a special row.
 */

const SLACK_OPS_WEBHOOK = PropertiesService.getScriptProperties().getProperty('SLACK_OPS_WEBHOOK');

function doPost(e) {
  try {
    const payload = JSON.parse(e.postData.contents);
    if (payload.mode === 'daily_recon') {
      writeReconciliationDigest_(payload);
    } else {
      // 15-min anomaly scan
      const newP0Count = appendAnomalies_(payload.anomalies || []);
      if (newP0Count > 0 && SLACK_OPS_WEBHOOK) postP0SlackAlert_(payload.anomalies.filter(a => a.severity === 'P0'));
    }
    return ContentService.createTextOutput(JSON.stringify({ status: 'ok' })).setMimeType(ContentService.MimeType.JSON);
  } catch (err) {
    return ContentService.createTextOutput(JSON.stringify({ status: 'error', message: err.message })).setMimeType(ContentService.MimeType.JSON);
  }
}

function appendAnomalies_(anomalies) {
  const sheet = ensureAnomalySheet_();
  let p0Count = 0;
  anomalies.forEach(a => {
    sheet.appendRow([
      a.detected_at, a.severity, a.channel, a.asset_id, a.asset_name,
      a.issue_type, a.owner_email, a.recommended_action, 'open', ''
    ]);
    if (a.severity === 'P0') p0Count++;
  });
  return p0Count;
}

function writeReconciliationDigest_(payload) {
  const sheet = ensureReconciliationSheet_();
  sheet.appendRow([
    payload.report_date,
    payload.active_campaigns_total,
    payload.with_approved_din,
    payload.without_din_count,
    payload.in_review_over_48h_count,
    payload.briefs_missing_uploads_count,
    payload.yesterday_blocked_launches_count,
    payload.report_markdown_url || ''
  ]);
}

function postP0SlackAlert_(p0Anomalies) {
  UrlFetchApp.fetch(SLACK_OPS_WEBHOOK, { method: 'post', contentType: 'application/json',
    payload: JSON.stringify({
      text: `🚨 *${p0Anomalies.length} P0 DIN anomalies detected*`,
      blocks: p0Anomalies.slice(0, 5).map(a => ({
        type: 'section',
        text: { type: 'mrkdwn', text: `*${a.severity}* — ${a.channel} \`${a.asset_id}\` (${a.asset_name})\nIssue: ${a.issue_type}\nOwner: ${a.owner_email}\nAction: ${a.recommended_action}` }
      }))
    })
  });
}

function ensureAnomalySheet_() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  let sheet = ss.getSheetByName('Anomalies Log');
  if (!sheet) {
    sheet = ss.insertSheet('Anomalies Log');
    sheet.getRange(1, 1, 1, 10).setValues([['Detected At', 'Severity', 'Channel', 'Asset ID',
      'Asset Name', 'Issue Type', 'Owner', 'Recommended Action', 'Status', 'Resolution Notes']])
      .setFontWeight('bold').setBackground('#ea4335').setFontColor('#ffffff');
    sheet.setFrozenRows(1);
  }
  return sheet;
}

function ensureReconciliationSheet_() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  let sheet = ss.getSheetByName('Daily Reconciliation');
  if (!sheet) {
    sheet = ss.insertSheet('Daily Reconciliation');
    sheet.getRange(1, 1, 1, 8).setValues([['Date', 'Active Campaigns', 'With Approved DIN',
      'Without DIN', 'In Review >48h', 'Briefs Missing Uploads', 'Yesterday Blocked Launches', 'Report Link']])
      .setFontWeight('bold').setBackground('#1a73e8').setFontColor('#ffffff');
    sheet.setFrozenRows(1);
  }
  return sheet;
}
