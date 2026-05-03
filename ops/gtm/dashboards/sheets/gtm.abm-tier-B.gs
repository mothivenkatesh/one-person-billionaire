/**
 * gtm.abm-tier-B.gs — Strategic account list (200 accounts max).
 *
 * Same structure as gtm.abm-tier-A but for Tier B accounts. Less hands-on
 * editing expected; more agent-driven updates.
 *
 * Trigger: weekly Monday cron from n8n.
 */

function doPost(e) {
  try {
    const payload = JSON.parse(e.postData.contents);
    writeTierBTable_(payload.accounts || []);
    return ContentService.createTextOutput(JSON.stringify({ status: 'ok', count: (payload.accounts || []).length })).setMimeType(ContentService.MimeType.JSON);
  } catch (err) {
    return ContentService.createTextOutput(JSON.stringify({ status: 'error', message: err.message })).setMimeType(ContentService.MimeType.JSON);
  }
}

function writeTierBTable_(accounts) {
  const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('Tier B')
                || SpreadsheetApp.getActiveSpreadsheet().insertSheet('Tier B');
  sheet.clear();
  const headers = ['Account', 'Vertical', 'AE Owner', 'ICP Score', 'Intent Score',
                   'Stage', 'Open Pipeline ₹', 'Days Since Last Touch', 'Active DIN',
                   'Next Recommended Action'];
  sheet.getRange(1, 1, 1, headers.length).setValues([headers]).setFontWeight('bold').setBackground('#34a853').setFontColor('#ffffff');
  sheet.setFrozenRows(1);
  if (!accounts.length) return;
  const rows = accounts.map(a => [
    a.name, a.vertical, a.ae_owner, a.icp_score, a.intent_score,
    a.stage || 'lead', a.open_pipeline_inr || 0, a.days_since_last_touch || '',
    a.active_din || '',
    a.next_recommended_action || ''
  ]);
  sheet.getRange(2, 1, rows.length, headers.length).setValues(rows);

  // Conditional format on intent_score: green for ≥4, yellow 3-4, red <3
  const intentRange = sheet.getRange(2, 5, rows.length, 1);
  const rules = [
    SpreadsheetApp.newConditionalFormatRule().whenNumberGreaterThanOrEqualTo(4).setBackground('#34a853').setFontColor('#ffffff').setRanges([intentRange]).build(),
    SpreadsheetApp.newConditionalFormatRule().whenNumberGreaterThanOrEqualTo(3).setBackground('#fbbc04').setRanges([intentRange]).build(),
    SpreadsheetApp.newConditionalFormatRule().whenNumberLessThan(3).setBackground('#ea4335').setFontColor('#ffffff').setRanges([intentRange]).build()
  ];
  sheet.setConditionalFormatRules(rules);
}
