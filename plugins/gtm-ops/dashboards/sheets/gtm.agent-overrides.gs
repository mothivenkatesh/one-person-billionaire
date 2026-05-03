/**
 * gtm.agent-overrides.gs — Manual veto sheet.
 *
 * PMM/RevOps add rows here to tell agents "skip this account/deal/whatever for X reason."
 * Agents read this sheet (cached hourly) before taking any account-level action.
 *
 * On every edit, syncs to Postgres so agents pick up overrides within minutes.
 */

const N8N_OVERRIDES_WEBHOOK = PropertiesService.getScriptProperties().getProperty('N8N_OVERRIDES_WEBHOOK');

function setupSheet() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  let sheet = ss.getSheetByName('Overrides');
  if (!sheet) sheet = ss.insertSheet('Overrides');
  sheet.clear();
  const headers = ['Account ID OR Email', 'Override Type', 'Skip Until (date)', 'Reason',
                   'Added By', 'Added At', 'Active'];
  sheet.getRange(1, 1, 1, headers.length).setValues([headers]).setFontWeight('bold').setBackground('#9c27b0').setFontColor('#ffffff');
  // Row 2 = legend
  sheet.getRange(2, 1, 1, headers.length).setValues([[
    'e.g., acc_001 OR john@hdfc.com',
    'skip_outbound | skip_cross_sell | skip_dormant_re | skip_churn_save | skip_all',
    'YYYY-MM-DD or "permanent"',
    'Why',
    'auto-filled',
    'auto-filled',
    'TRUE / FALSE'
  ]]).setFontStyle('italic').setFontColor('#9aa0a6');
  sheet.setFrozenRows(2);

  // Validation on Override Type column
  const typeRule = SpreadsheetApp.newDataValidation()
    .requireValueInList(['skip_outbound', 'skip_cross_sell', 'skip_dormant_re', 'skip_churn_save', 'skip_all'], true)
    .build();
  sheet.getRange('B3:B').setDataValidation(typeRule);

  // Validation on Active column (boolean)
  sheet.getRange('G3:G').insertCheckboxes();
}

function onEdit(e) {
  if (!e || e.range.getSheet().getName() !== 'Overrides') return;
  if (e.range.getRow() < 3) return;
  const sheet = e.range.getSheet();
  const row = e.range.getRow();
  // Auto-fill Added By + Added At on first edit of each row
  if (sheet.getRange(row, 5).isBlank()) sheet.getRange(row, 5).setValue(Session.getActiveUser().getEmail());
  if (sheet.getRange(row, 6).isBlank()) sheet.getRange(row, 6).setValue(new Date().toISOString());
  // Sync to Postgres
  if (N8N_OVERRIDES_WEBHOOK) {
    const data = sheet.getRange(row, 1, 1, 7).getValues()[0];
    UrlFetchApp.fetch(N8N_OVERRIDES_WEBHOOK, { method: 'post', contentType: 'application/json',
      payload: JSON.stringify({
        target: data[0], override_type: data[1], skip_until: data[2],
        reason: data[3], added_by: data[4], added_at: data[5], active: data[6]
      })
    });
  }
}
