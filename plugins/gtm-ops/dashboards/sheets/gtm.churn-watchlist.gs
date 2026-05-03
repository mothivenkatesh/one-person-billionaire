/**
 * gtm.churn-watchlist.gs — Churn-Saver output (daily 6am refresh).
 *
 * Trigger: daily 6am cron via webhook from cf-churn-saver agent.
 * Receives: at-risk merchants with composite churn signal + save brief.
 *
 * Tabs: by severity (P0 / P1 / P2). CSMs work top-down by severity.
 * Slack alert fires for any P0 row added since last refresh.
 */

const SLACK_WEBHOOK = PropertiesService.getScriptProperties().getProperty('SLACK_CS_WEBHOOK');

function doPost(e) {
  try {
    const payload = JSON.parse(e.postData.contents);
    // payload = { date, by_severity: { 'P0': [...], 'P1': [...], 'P2': [...] } }
    let p0NewCount = 0;
    Object.entries(payload.by_severity || {}).forEach(([sev, accts]) => {
      const before = countRows_(sev);
      writeSeverityTab_(sev, payload.date, accts);
      if (sev === 'P0') p0NewCount = Math.max(0, accts.length - before);
    });
    if (p0NewCount > 0 && SLACK_WEBHOOK) postP0Alert_(p0NewCount, payload.date);
    return ContentService.createTextOutput(JSON.stringify({ status: 'ok', p0_new: p0NewCount })).setMimeType(ContentService.MimeType.JSON);
  } catch (err) {
    return ContentService.createTextOutput(JSON.stringify({ status: 'error', message: err.message })).setMimeType(ContentService.MimeType.JSON);
  }
}

function countRows_(sev) {
  const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName(sev);
  return sheet ? Math.max(sheet.getLastRow() - 3, 0) : 0;
}

function writeSeverityTab_(sev, date, accts) {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const sheet = ss.getSheetByName(sev) || ss.insertSheet(sev);
  sheet.clear();
  sheet.getRange(1, 1, 1, 2).setValues([[`Churn Watchlist — ${sev}`, `Date ${date}`]]).setFontWeight('bold');
  const headers = ['Account', 'Vertical', 'Monthly Revenue ₹', 'CSM Owner',
                   'Risk Score', 'Diagnosis', 'Top 3 Talking Points', 'Draft Check-in',
                   'Likely Objection', 'Escalation Criteria', 'Action Taken ☐', 'Outcome'];
  sheet.getRange(3, 1, 1, headers.length).setValues([headers]).setFontWeight('bold').setBackground(sev === 'P0' ? '#ea4335' : sev === 'P1' ? '#fbbc04' : '#9aa0a6').setFontColor('#ffffff');
  sheet.setFrozenRows(3);
  if (!accts.length) return;
  const rows = accts.map(a => [
    a.account_name, a.vertical, a.monthly_revenue_inr, a.csm_email,
    a.risk_score, a.diagnosis,
    (a.top_3_talking_points || []).map((t, i) => `${i + 1}. ${t}`).join('\n'),
    `[Email] ${a.email_body || ''}\n[WhatsApp] ${a.whatsapp || ''}`,
    a.likely_objection || '',
    a.escalation_criteria || '',
    false, ''
  ]);
  sheet.getRange(4, 1, rows.length, headers.length).setValues(rows);
  sheet.getRange(4, 11, rows.length, 1).insertCheckboxes();
}

function postP0Alert_(count, date) {
  UrlFetchApp.fetch(SLACK_WEBHOOK, { method: 'post', contentType: 'application/json',
    payload: JSON.stringify({
      text: `🚨 *${count} new P0 churn-risk accounts* added to gtm.churn-watchlist for ${date}. CSM team: review now.`
    })
  });
}
