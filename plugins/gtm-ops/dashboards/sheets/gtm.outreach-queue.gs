/**
 * gtm.outreach-queue.gs — Daily outbound lineup per BDR.
 *
 * Trigger: daily 6am IST cron (called from n8n after icp-scout + outreach-writer complete).
 * Receives: ranked list of accounts to outbound today, per BDR, with assigned templates + sender domains.
 *
 * Format: one tab per BDR; rows are the day's outreach queue with checkbox to mark Sent.
 */

function doPost(e) {
  try {
    const payload = JSON.parse(e.postData.contents);
    // payload = { date: 'YYYY-MM-DD', queues: { 'bdr1@mothi.com': [...], ... } }
    Object.entries(payload.queues || {}).forEach(([bdrEmail, queue]) => writeBdrQueue_(bdrEmail, payload.date, queue));
    return ContentService.createTextOutput(JSON.stringify({ status: 'ok', bdrs: Object.keys(payload.queues).length })).setMimeType(ContentService.MimeType.JSON);
  } catch (err) {
    return ContentService.createTextOutput(JSON.stringify({ status: 'error', message: err.message })).setMimeType(ContentService.MimeType.JSON);
  }
}

function writeBdrQueue_(bdrEmail, date, queue) {
  const tabName = bdrEmail.split('@')[0];
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const sheet = ss.getSheetByName(tabName) || ss.insertSheet(tabName);
  sheet.clear();
  sheet.getRange(1, 1, 1, 2).setValues([[`${bdrEmail} — Daily Queue`, date]]).setFontWeight('bold');
  const headers = ['Account', 'Tier', 'Vertical', 'Persona', 'ICP Score', 'Touch #', 'Template DIN', 'Sender Domain', 'Sequence', 'Sent ☐', 'Reply Notes'];
  sheet.getRange(3, 1, 1, headers.length).setValues([headers]).setFontWeight('bold').setBackground('#1a73e8').setFontColor('#ffffff');
  if (!queue.length) {
    sheet.getRange(4, 1).setValue('No queued outreach today. ✅');
    return;
  }
  const rows = queue.map(q => [
    q.account_name, q.tier, q.vertical, q.persona,
    q.icp_score, q.touch_number, q.template_din, q.sender_domain,
    q.sequence_name, false, ''
  ]);
  sheet.getRange(4, 1, rows.length, headers.length).setValues(rows);
  // Mark Sent column as checkbox
  sheet.getRange(4, 10, rows.length, 1).insertCheckboxes();
}

/** onEdit trigger: when BDR ticks Sent, write back to Postgres via webhook. */
function onEdit(e) {
  if (!e || e.range.getColumn() !== 10) return;
  if (!e.value) return;  // unchecked
  const sheet = e.range.getSheet();
  const row = e.range.getRow();
  const accountName = sheet.getRange(row, 1).getValue();
  const din = sheet.getRange(row, 7).getValue();
  const webhook = PropertiesService.getScriptProperties().getProperty('N8N_OUTREACH_SENT_WEBHOOK');
  if (webhook) {
    UrlFetchApp.fetch(webhook, { method: 'post', contentType: 'application/json',
      payload: JSON.stringify({ bdr: sheet.getName(), account: accountName, din, sent_at: new Date().toISOString() }) });
  }
}
