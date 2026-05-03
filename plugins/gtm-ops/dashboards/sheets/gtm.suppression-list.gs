/**
 * gtm.suppression-list.gs — Master do-not-contact list.
 *
 * Trigger: append-only via webhook from cf-reply-classifier (when intent=unsubscribe)
 *          AND from manual edits (compliance team can add entries directly).
 *
 * Reads: every n8n outbound workflow checks this sheet BEFORE send (via cached pull).
 *
 * Critical: this sheet is the legal record of consent withdrawal under DPDP. Never delete rows.
 */

function doPost(e) {
  try {
    const payload = JSON.parse(e.postData.contents);
    // payload = { email, account_id, reason, source_agent, source_evidence, suppressed_at }
    appendSuppression_(payload);
    return ContentService.createTextOutput(JSON.stringify({ status: 'ok' })).setMimeType(ContentService.MimeType.JSON);
  } catch (err) {
    return ContentService.createTextOutput(JSON.stringify({ status: 'error', message: err.message })).setMimeType(ContentService.MimeType.JSON);
  }
}

function appendSuppression_(p) {
  const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('Suppression')
                || ensureSuppressionSheet_();
  // Dedupe — don't append if email already suppressed
  const existing = sheet.getRange(2, 1, Math.max(sheet.getLastRow() - 1, 0), 1).getValues().flat();
  if (existing.indexOf(p.email) > -1) return;
  sheet.appendRow([
    p.email,
    p.account_id || '',
    p.reason || 'unsubscribe',
    p.source_agent || 'manual',
    p.source_evidence || '',
    p.suppressed_at || new Date().toISOString(),
    p.suppressed_by || 'system'
  ]);
}

function ensureSuppressionSheet_() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const sheet = ss.insertSheet('Suppression');
  const headers = ['Email', 'Account ID', 'Reason', 'Source Agent', 'Source Evidence', 'Suppressed At', 'Suppressed By'];
  sheet.getRange(1, 1, 1, headers.length).setValues([headers]).setFontWeight('bold').setBackground('#ea4335').setFontColor('#ffffff');
  sheet.setFrozenRows(1);
  return sheet;
}

/** onEdit trigger: log manual additions to Postgres for audit. */
function onEdit(e) {
  if (!e || e.range.getSheet().getName() !== 'Suppression') return;
  if (e.range.getRow() === 1) return;
  const webhook = PropertiesService.getScriptProperties().getProperty('N8N_SUPPRESSION_WEBHOOK');
  if (webhook) {
    const row = e.range.getRow();
    const sheet = e.range.getSheet();
    const data = sheet.getRange(row, 1, 1, 7).getValues()[0];
    UrlFetchApp.fetch(webhook, { method: 'post', contentType: 'application/json',
      payload: JSON.stringify({ source: 'manual_edit', edited_by: Session.getActiveUser().getEmail(), data }) });
  }
}
