/**
 * gtm.abm-tier-A.gs — Lighthouse account list (50 named accounts max).
 *
 * Trigger: weekly Monday cron from n8n (pulls from Postgres + extracted_property + signals).
 *          PMM/AE can also manually edit; on-edit syncs back to Postgres.
 *
 * Format: rows are Tier-A accounts with current state, owner, signals, next-step.
 */

function doPost(e) {
  try {
    const payload = JSON.parse(e.postData.contents);
    writeTierATable_(payload.accounts || []);
    return ContentService.createTextOutput(JSON.stringify({ status: 'ok', count: (payload.accounts || []).length })).setMimeType(ContentService.MimeType.JSON);
  } catch (err) {
    return ContentService.createTextOutput(JSON.stringify({ status: 'error', message: err.message })).setMimeType(ContentService.MimeType.JSON);
  }
}

function writeTierATable_(accounts) {
  const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('Tier A')
                || SpreadsheetApp.getActiveSpreadsheet().insertSheet('Tier A');
  sheet.clear();
  const headers = ['Account', 'Vertical', 'AE Owner', 'Stage', 'Open Pipeline ₹',
                   'Days Since Last Touch', 'Recent Signals', 'Champion?', 'Next Step',
                   'PMM Notes', 'Last Updated'];
  sheet.getRange(1, 1, 1, headers.length).setValues([headers]).setFontWeight('bold').setBackground('#1a73e8').setFontColor('#ffffff');
  sheet.setFrozenRows(1);
  if (!accounts.length) return;

  const rows = accounts.map(a => [
    a.name, a.vertical, a.ae_owner, a.stage || 'no_open_deal',
    a.open_pipeline_inr || 0,
    a.days_since_last_touch || '',
    (a.recent_signals || []).join(' · '),
    a.has_champion ? '✅' : '—',
    a.next_step || '',
    a.pmm_notes || '',
    new Date().toISOString().slice(0, 10)
  ]);
  sheet.getRange(2, 1, rows.length, headers.length).setValues(rows);

  // Highlight stale accounts (>30d since last touch) in yellow
  const range = sheet.getRange(2, 6, rows.length, 1);
  const rules = [
    SpreadsheetApp.newConditionalFormatRule().whenNumberGreaterThan(60).setBackground('#ea4335').setFontColor('#ffffff').setRanges([range]).build(),
    SpreadsheetApp.newConditionalFormatRule().whenNumberGreaterThan(30).setBackground('#fbbc04').setRanges([range]).build()
  ];
  sheet.setConditionalFormatRules(rules);
}

/** onEdit: sync PMM Notes + Next Step changes back to Postgres. */
function onEdit(e) {
  if (!e || e.range.getSheet().getName() !== 'Tier A') return;
  if (e.range.getRow() === 1) return;
  if (![9, 10].indexOf(e.range.getColumn()) > -1) return;  // only Next Step + PMM Notes
  const webhook = PropertiesService.getScriptProperties().getProperty('N8N_ABM_TIER_A_EDIT_WEBHOOK');
  if (webhook) {
    const sheet = e.range.getSheet();
    const accountName = sheet.getRange(e.range.getRow(), 1).getValue();
    const nextStep = sheet.getRange(e.range.getRow(), 9).getValue();
    const pmmNotes = sheet.getRange(e.range.getRow(), 10).getValue();
    UrlFetchApp.fetch(webhook, { method: 'post', contentType: 'application/json',
      payload: JSON.stringify({ account: accountName, next_step: nextStep, pmm_notes: pmmNotes,
                                edited_by: Session.getActiveUser().getEmail() }) });
  }
}
