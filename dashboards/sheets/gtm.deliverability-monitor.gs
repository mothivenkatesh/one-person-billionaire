/**
 * gtm.deliverability-monitor.gs — Per-domain reputation dashboard.
 *
 * Trigger: hourly cron via webhook (n8n queries mart_outbound_health and pushes here).
 * Auto-fires Slack alert if any domain crosses spam_complaint_rate threshold (>0.10%).
 */

const SLACK_OPS_WEBHOOK = PropertiesService.getScriptProperties().getProperty('SLACK_OPS_WEBHOOK');

function doPost(e) {
  try {
    const payload = JSON.parse(e.postData.contents);
    // payload = { snapshot_at, domains: [...] }
    writeDomainsTable_(payload.snapshot_at, payload.domains || []);
    checkAlertThresholds_(payload.domains || []);
    return ContentService.createTextOutput(JSON.stringify({ status: 'ok', count: (payload.domains || []).length })).setMimeType(ContentService.MimeType.JSON);
  } catch (err) {
    return ContentService.createTextOutput(JSON.stringify({ status: 'error', message: err.message })).setMimeType(ContentService.MimeType.JSON);
  }
}

function writeDomainsTable_(snapshotAt, domains) {
  const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('Domains')
                || SpreadsheetApp.getActiveSpreadsheet().insertSheet('Domains');
  sheet.clear();
  sheet.getRange(1, 1, 1, 2).setValues([['Deliverability Monitor', `Snapshot ${snapshotAt}`]]).setFontWeight('bold');
  const headers = ['Domain', 'Pool', 'Status', 'Days Since Warmed', 'Sends 7d', 'Sends 30d',
                   'Reply Rate 7d', 'Reply Rate 30d', 'Bounce Rate 30d', 'Spam Complaint 7d',
                   'Inbox Score 30d', 'Demos Credited 30d', 'Cost/Demo ₹', 'Action'];
  sheet.getRange(3, 1, 1, headers.length).setValues([headers]).setFontWeight('bold').setBackground('#1a73e8').setFontColor('#ffffff');
  sheet.setFrozenRows(3);
  if (!domains.length) return;
  const rows = domains.map(d => [
    d.domain, d.pool, d.status, d.days_since_warmed || '',
    d.sends_7d, d.sends_30d, d.reply_rate_pct_7d, d.reply_rate_pct_30d,
    d.bounce_rate_pct_30d, d.spam_complaint_rate_pct_7d, d.avg_inbox_placement_score_30d,
    d.demos_credited_30d, d.cost_per_demo_inr_30d || '',
    actionForFlag_(d.computed_health_flag)
  ]);
  sheet.getRange(4, 1, rows.length, headers.length).setValues(rows);

  // Highlight quarantine candidates in red
  const statusRange = sheet.getRange(4, 14, rows.length, 1);
  const rules = [
    SpreadsheetApp.newConditionalFormatRule().whenTextStartsWith('QUARANTINE').setBackground('#ea4335').setFontColor('#ffffff').setRanges([statusRange]).build(),
    SpreadsheetApp.newConditionalFormatRule().whenTextStartsWith('WARNING').setBackground('#fbbc04').setRanges([statusRange]).build(),
    SpreadsheetApp.newConditionalFormatRule().whenTextEqualTo('healthy').setBackground('#34a853').setFontColor('#ffffff').setRanges([statusRange]).build()
  ];
  sheet.setConditionalFormatRules(rules);
}

function actionForFlag_(flag) {
  if (!flag) return 'healthy';
  if (flag.startsWith('quarantine')) return 'QUARANTINE NOW: ' + flag;
  if (flag.startsWith('warning')) return 'WARNING: ' + flag;
  return 'healthy';
}

function checkAlertThresholds_(domains) {
  const critical = domains.filter(d => d.computed_health_flag && d.computed_health_flag.startsWith('quarantine'));
  if (critical.length && SLACK_OPS_WEBHOOK) {
    UrlFetchApp.fetch(SLACK_OPS_WEBHOOK, { method: 'post', contentType: 'application/json',
      payload: JSON.stringify({
        text: `🚨 *${critical.length} domain(s) recommended for quarantine:* ${critical.map(d => d.domain).join(', ')}`
      })
    });
  }
}
