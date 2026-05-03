/**
 * gtm.din-registry.gs — Live view of all DINs (campaigns table) from Postgres.
 *
 * Trigger: hourly time-driven (PostgresREST endpoint pulled via UrlFetch)
 * Receives: SELECT * FROM campaigns ORDER BY created_at DESC payload from n8n.
 */

const POSTGRES_DIN_ENDPOINT = PropertiesService.getScriptProperties().getProperty('POSTGRES_DIN_ENDPOINT');

function doPost(e) {
  try {
    const payload = JSON.parse(e.postData.contents);
    writeDinTable_(payload.campaigns || []);
    return ContentService.createTextOutput(
      JSON.stringify({ status: 'ok', count: (payload.campaigns || []).length })
    ).setMimeType(ContentService.MimeType.JSON);
  } catch (err) {
    return ContentService.createTextOutput(
      JSON.stringify({ status: 'error', message: err.message })
    ).setMimeType(ContentService.MimeType.JSON);
  }
}

function pullHourly() {
  if (!POSTGRES_DIN_ENDPOINT) { Logger.log('No endpoint configured'); return; }
  const resp = UrlFetchApp.fetch(POSTGRES_DIN_ENDPOINT);
  const payload = JSON.parse(resp.getContentText());
  writeDinTable_(payload.campaigns || []);
}

function installHourlyTrigger() {
  ScriptApp.newTrigger('pullHourly').timeBased().everyHours(1).create();
}

function writeDinTable_(campaigns) {
  const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('DINs')
                || SpreadsheetApp.getActiveSpreadsheet().insertSheet('DINs');
  sheet.clear();
  const headers = ['DIN', 'Name', 'Motion', 'Tier', 'Segment', 'Status', 'Owner',
                   'Approved At', 'Launched At', 'Spend ₹', 'Budget ₹', 'Channels',
                   'Brief', 'Days In Stage'];
  sheet.getRange(1, 1, 1, headers.length).setValues([headers]).setFontWeight('bold').setBackground('#1a73e8').setFontColor('#ffffff');
  if (!campaigns.length) return;

  const rows = campaigns.map(c => [
    c.din_id, c.name, c.motion_type, c.tier, c.segment, c.approval_status,
    c.pmm_owner_email, c.approved_at || '', c.launched_at || '',
    c.spend_inr || 0, c.planned_budget_inr || 0,
    (c.channels || []).join(', '),
    c.brief_gdoc_url ? '=HYPERLINK("' + c.brief_gdoc_url + '","brief")' : '',
    c.days_in_stage || ''
  ]);
  sheet.getRange(2, 1, rows.length, headers.length).setValues(rows);

  // Conditional formatting: red for in_review >48h, yellow for draft
  const statusCol = 6;
  const range = sheet.getRange(2, statusCol, rows.length, 1);
  const rules = [
    SpreadsheetApp.newConditionalFormatRule().whenTextEqualTo('in_review').setBackground('#fbbc04').setRanges([range]).build(),
    SpreadsheetApp.newConditionalFormatRule().whenTextEqualTo('draft').setBackground('#e8eaed').setRanges([range]).build(),
    SpreadsheetApp.newConditionalFormatRule().whenTextEqualTo('live').setBackground('#34a853').setFontColor('#ffffff').setRanges([range]).build(),
    SpreadsheetApp.newConditionalFormatRule().whenTextEqualTo('paused').setBackground('#ea4335').setFontColor('#ffffff').setRanges([range]).build(),
    SpreadsheetApp.newConditionalFormatRule().whenTextEqualTo('archived').setBackground('#9aa0a6').setRanges([range]).build()
  ];
  sheet.setConditionalFormatRules(rules);
}
