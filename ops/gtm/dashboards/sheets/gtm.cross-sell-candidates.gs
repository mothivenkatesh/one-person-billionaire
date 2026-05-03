/**
 * gtm.cross-sell-candidates.gs — Cross-Sell-Detector output (weekly Monday refresh).
 *
 * Trigger: weekly Monday 6am cron via webhook from cf-cross-sell-detector agent.
 * Receives: scored cross-sell candidates with personalized pitch + recommended channel.
 *
 * Format: one tab per product-pair (Payments→Payouts, Secure ID→Mobile360, etc.).
 */

function doPost(e) {
  try {
    const payload = JSON.parse(e.postData.contents);
    // payload = { week_ending, by_product_pair: { 'payments_to_payouts': [...], ... } }
    Object.entries(payload.by_product_pair || {}).forEach(([pair, candidates]) => {
      writeCandidateTab_(pair, payload.week_ending, candidates);
    });
    return ContentService.createTextOutput(JSON.stringify({ status: 'ok', pairs: Object.keys(payload.by_product_pair).length })).setMimeType(ContentService.MimeType.JSON);
  } catch (err) {
    return ContentService.createTextOutput(JSON.stringify({ status: 'error', message: err.message })).setMimeType(ContentService.MimeType.JSON);
  }
}

function writeCandidateTab_(productPair, weekEnding, candidates) {
  const tabName = productPair.replace(/_/g, '→').slice(0, 30);
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const sheet = ss.getSheetByName(tabName) || ss.insertSheet(tabName);
  sheet.clear();
  sheet.getRange(1, 1, 1, 2).setValues([[`Cross-Sell: ${tabName}`, `Week ending ${weekEnding}`]]).setFontWeight('bold');
  const headers = ['Account', 'Vertical', 'Tenure (d)', 'Monthly Volume ₹', 'Readiness Score',
                   'Tier', 'Recommended Channel', 'Email Subject', 'Pitch Body', 'CSM Email',
                   'Status ☐', 'Outcome'];
  sheet.getRange(3, 1, 1, headers.length).setValues([headers]).setFontWeight('bold').setBackground('#1a73e8').setFontColor('#ffffff');
  sheet.setFrozenRows(3);
  if (!candidates.length) {
    sheet.getRange(4, 1).setValue('No cross-sell candidates this week.');
    return;
  }
  const rows = candidates.map(c => [
    c.account_name, c.vertical, c.tenure_days, c.monthly_volume_inr,
    c.readiness_score, c.readiness_tier, c.recommended_channel,
    c.pitch_email_subject || '', c.pitch_email_body || '',
    c.csm_email || '',
    false, ''
  ]);
  sheet.getRange(4, 1, rows.length, headers.length).setValues(rows);
  sheet.getRange(4, 11, rows.length, 1).insertCheckboxes();

  // Highlight hot tier
  const range = sheet.getRange(4, 6, rows.length, 1);
  const rules = [
    SpreadsheetApp.newConditionalFormatRule().whenTextEqualTo('hot').setBackground('#ea4335').setFontColor('#ffffff').setRanges([range]).build(),
    SpreadsheetApp.newConditionalFormatRule().whenTextEqualTo('warm').setBackground('#fbbc04').setRanges([range]).build(),
    SpreadsheetApp.newConditionalFormatRule().whenTextEqualTo('cold').setBackground('#e8eaed').setRanges([range]).build()
  ];
  sheet.setConditionalFormatRules(rules);
}
