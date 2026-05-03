/**
 * gtm.form-responses.demo-request.gs — Apps Script for the gtm.demo-request Google Form.
 *
 * Two roles:
 * 1. onFormSubmit trigger: when a new demo request lands, fire webhook to n8n forms-router agent
 *    (which routes to ICP-Scout in real-time path with high_intent_explicit=true).
 * 2. doPost: receive any back-channel webhook updates from n8n (e.g., AE alerted, qualified, disqualified).
 */

const N8N_FORMS_ROUTER_WEBHOOK = PropertiesService.getScriptProperties().getProperty('N8N_FORMS_ROUTER_WEBHOOK');

/** Form submission trigger — fires immediately on each form response. */
function onFormSubmit(e) {
  try {
    const responses = e.namedValues || {};
    const payload = {
      form_name: 'gtm.demo-request',
      respondent_email: (responses['Email'] || [''])[0],
      submitted_at: new Date().toISOString(),
      form_response_id: e.range ? `row_${e.range.getRow()}` : 'unknown',
      fields: {
        company: (responses['Company'] || [''])[0],
        name: (responses['Name'] || [''])[0],
        email: (responses['Email'] || [''])[0],
        phone: (responses['Phone'] || [''])[0],
        monthly_payments_volume_inr: (responses['Monthly Volume'] || [''])[0],
        vertical: (responses['Vertical'] || [''])[0],
        urgency: (responses['Urgency'] || [''])[0],
        consent_to_contact: (responses['I consent to be contacted'] || ['No'])[0] === 'Yes'
      }
    };
    if (N8N_FORMS_ROUTER_WEBHOOK) {
      UrlFetchApp.fetch(N8N_FORMS_ROUTER_WEBHOOK, { method: 'post', contentType: 'application/json',
        payload: JSON.stringify({ raw_payload: payload }) });
    }
    appendFormRow_(payload);
  } catch (err) {
    Logger.log('onFormSubmit error: ' + err.message);
  }
}

/** Back-channel updates from n8n (e.g., qualified/disqualified status). */
function doPost(e) {
  try {
    const update = JSON.parse(e.postData.contents);
    appendStatusUpdate_(update);
    return ContentService.createTextOutput(JSON.stringify({ status: 'ok' })).setMimeType(ContentService.MimeType.JSON);
  } catch (err) {
    return ContentService.createTextOutput(JSON.stringify({ status: 'error', message: err.message })).setMimeType(ContentService.MimeType.JSON);
  }
}

function appendFormRow_(p) {
  const sheet = ensureLogSheet_();
  sheet.appendRow([
    p.submitted_at, p.fields.name, p.fields.company, p.fields.email,
    p.fields.phone, p.fields.monthly_payments_volume_inr, p.fields.vertical,
    p.fields.urgency, p.fields.consent_to_contact, 'submitted', '', ''
  ]);
}

function appendStatusUpdate_(update) {
  const sheet = ensureLogSheet_();
  const data = sheet.getDataRange().getValues();
  for (let i = 1; i < data.length; i++) {
    if (data[i][3] === update.email) {
      sheet.getRange(i + 1, 10).setValue(update.status);
      sheet.getRange(i + 1, 11).setValue(update.tier || '');
      sheet.getRange(i + 1, 12).setValue(update.ae_assigned || '');
      return;
    }
  }
}

function ensureLogSheet_() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  let sheet = ss.getSheetByName('Demo Requests Log');
  if (!sheet) {
    sheet = ss.insertSheet('Demo Requests Log');
    sheet.getRange(1, 1, 1, 12).setValues([['Submitted', 'Name', 'Company', 'Email',
      'Phone', 'Monthly Volume', 'Vertical', 'Urgency', 'Consent', 'Status', 'Tier', 'AE Assigned']])
      .setFontWeight('bold').setBackground('#1a73e8').setFontColor('#ffffff');
    sheet.setFrozenRows(1);
  }
  return sheet;
}

/** Setup: install the form-submit trigger. */
function installFormTrigger() {
  const form = FormApp.getActiveForm();
  ScriptApp.newTrigger('onFormSubmit').forForm(form).onFormSubmit().create();
}
