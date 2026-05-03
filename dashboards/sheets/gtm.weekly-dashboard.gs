/**
 * gtm.weekly-dashboard.gs — Apps Script source for the canonical weekly-dashboard sheet.
 *
 * Purpose: receives the weekly digest from `cf-weekly-report` agent and renders it
 * into a structured Sheet. Also handles Slack #gtm-weekly publication every Monday 9am.
 *
 * Triggers:
 *  - HTTP POST webhook from n8n (`doPost`) — agent pushes the digest payload
 *  - Time-driven trigger Monday 9am IST — fires Slack post if digest exists
 */

const SLACK_WEBHOOK_URL = PropertiesService.getScriptProperties().getProperty('SLACK_WEBHOOK_URL');
const SHEET_NAME_OVERVIEW = 'Overview';
const SHEET_NAME_CHANNEL = 'Channel Performance';
const SHEET_NAME_LIFECYCLE = 'Lifecycle vs Razorpay';
const SHEET_NAME_OBSERVATIONS = 'Observations';
const SHEET_NAME_ACTIONS = 'Key Actions';
const SHEET_NAME_DIN_LEADERBOARD = 'DIN Leaderboard';

/**
 * Webhook entry point — n8n POSTs the digest payload here.
 *
 * Expected payload shape:
 * {
 *   week_ending: "YYYY-MM-DD",
 *   north_star: { calendar_fill_pct, demos_booked, pipeline_created_inr, mql_to_sql_pct, sql_to_won_pct, median_cycle_days },
 *   channel_performance: [ { channel, touches, mqls, sqls, demos, won, pipeline_inr, win_rate_pct, avg_cycle_days } ],
 *   lifecycle_metrics: [ { motion, this_week_pct, four_week_avg_pct, razorpay_floor_pct } ],
 *   observations: [ "string" ],
 *   key_actions: [ "string" ],
 *   din_leaderboard: [ { din, name, channels, spend_inr, touches, mqls, sqls, demos, won, pipeline_inr, win_rate_pct, cost_per_demo_inr, cost_per_pipeline_rupee } ],
 *   risks: [ { type, description, severity } ]
 * }
 */
function doPost(e) {
  try {
    const payload = JSON.parse(e.postData.contents);
    const ss = SpreadsheetApp.getActiveSpreadsheet();

    writeOverview_(ss, payload);
    writeChannelPerformance_(ss, payload);
    writeLifecycleMetrics_(ss, payload);
    writeObservations_(ss, payload);
    writeKeyActions_(ss, payload);
    writeDinLeaderboard_(ss, payload);

    // Cache the latest digest for Monday 9am Slack post
    PropertiesService.getScriptProperties().setProperty(
      'LATEST_DIGEST',
      JSON.stringify(payload)
    );

    return ContentService.createTextOutput(
      JSON.stringify({ status: 'ok', week_ending: payload.week_ending })
    ).setMimeType(ContentService.MimeType.JSON);
  } catch (err) {
    return ContentService.createTextOutput(
      JSON.stringify({ status: 'error', message: err.message })
    ).setMimeType(ContentService.MimeType.JSON);
  }
}

/** Time-driven trigger: fire Slack digest Monday 9am IST. */
function postWeeklyToSlack() {
  const cached = PropertiesService.getScriptProperties().getProperty('LATEST_DIGEST');
  if (!cached) {
    Logger.log('No cached digest — skipping Slack post');
    return;
  }
  const payload = JSON.parse(cached);
  const slackBlocks = formatSlackBlocks_(payload);
  UrlFetchApp.fetch(SLACK_WEBHOOK_URL, {
    method: 'post',
    contentType: 'application/json',
    payload: JSON.stringify({ blocks: slackBlocks })
  });
}

/** Setup function — run once to install the time trigger. */
function installWeeklyTrigger() {
  ScriptApp.newTrigger('postWeeklyToSlack')
    .timeBased()
    .onWeekDay(ScriptApp.WeekDay.MONDAY)
    .atHour(9)
    .inTimezone('Asia/Kolkata')
    .create();
  Logger.log('Trigger installed: postWeeklyToSlack every Monday 9am IST');
}

// =============================================
// Sheet writers
// =============================================

function writeOverview_(ss, payload) {
  const sheet = ss.getSheetByName(SHEET_NAME_OVERVIEW) || ss.insertSheet(SHEET_NAME_OVERVIEW);
  sheet.clear();
  const ns = payload.north_star;
  sheet.getRange(1, 1, 8, 2).setValues([
    ['Week ending', payload.week_ending],
    ['Calendar fill %', ns.calendar_fill_pct],
    ['Demos booked', ns.demos_booked],
    ['Pipeline created (₹)', ns.pipeline_created_inr],
    ['MQL → SQL %', ns.mql_to_sql_pct],
    ['SQL → Won %', ns.sql_to_won_pct],
    ['Median cycle (days)', ns.median_cycle_days],
    ['', '']
  ]);
  sheet.getRange(1, 1, 7, 1).setFontWeight('bold');
}

function writeChannelPerformance_(ss, payload) {
  const sheet = ss.getSheetByName(SHEET_NAME_CHANNEL) || ss.insertSheet(SHEET_NAME_CHANNEL);
  sheet.clear();
  const headers = ['Channel', 'Touches', 'MQLs', 'SQLs', 'Demos', 'Won', 'Pipeline ₹', 'Win rate %', 'Avg cycle (d)'];
  sheet.getRange(1, 1, 1, headers.length).setValues([headers]).setFontWeight('bold');
  const rows = payload.channel_performance.map(c => [
    c.channel, c.touches, c.mqls, c.sqls, c.demos, c.won, c.pipeline_inr, c.win_rate_pct, c.avg_cycle_days
  ]);
  if (rows.length) sheet.getRange(2, 1, rows.length, headers.length).setValues(rows);
}

function writeLifecycleMetrics_(ss, payload) {
  const sheet = ss.getSheetByName(SHEET_NAME_LIFECYCLE) || ss.insertSheet(SHEET_NAME_LIFECYCLE);
  sheet.clear();
  const headers = ['Motion', 'This week %', '4-week avg %', 'Razorpay floor %', 'Gap'];
  sheet.getRange(1, 1, 1, headers.length).setValues([headers]).setFontWeight('bold');
  const rows = payload.lifecycle_metrics.map(m => [
    m.motion, m.this_week_pct, m.four_week_avg_pct, m.razorpay_floor_pct,
    (m.this_week_pct - m.razorpay_floor_pct).toFixed(1) + ' pts'
  ]);
  if (rows.length) sheet.getRange(2, 1, rows.length, headers.length).setValues(rows);
}

function writeObservations_(ss, payload) {
  const sheet = ss.getSheetByName(SHEET_NAME_OBSERVATIONS) || ss.insertSheet(SHEET_NAME_OBSERVATIONS);
  sheet.clear();
  sheet.getRange(1, 1).setValue('Observations (Claude-generated)').setFontWeight('bold');
  const rows = (payload.observations || []).map((o, i) => [`#${i + 1}`, o]);
  if (rows.length) sheet.getRange(2, 1, rows.length, 2).setValues(rows);
}

function writeKeyActions_(ss, payload) {
  const sheet = ss.getSheetByName(SHEET_NAME_ACTIONS) || ss.insertSheet(SHEET_NAME_ACTIONS);
  sheet.clear();
  sheet.getRange(1, 1).setValue('Key Actions for this Week').setFontWeight('bold');
  const rows = (payload.key_actions || []).map((a, i) => [`#${i + 1}`, a, '☐']);
  if (rows.length) sheet.getRange(2, 1, rows.length, 3).setValues(rows);
  sheet.getRange(2, 1, rows.length || 1, 1).setFontWeight('bold');
}

function writeDinLeaderboard_(ss, payload) {
  const sheet = ss.getSheetByName(SHEET_NAME_DIN_LEADERBOARD) || ss.insertSheet(SHEET_NAME_DIN_LEADERBOARD);
  sheet.clear();
  const headers = ['DIN', 'Name', 'Channels', 'Spend ₹', 'Touches', 'MQLs', 'SQLs', 'Demos', 'Won', 'Pipeline ₹', 'Win rate %', 'Cost/Demo ₹', 'Cost/₹Pipeline'];
  sheet.getRange(1, 1, 1, headers.length).setValues([headers]).setFontWeight('bold');
  const rows = (payload.din_leaderboard || []).map(d => [
    d.din, d.name, d.channels.join(', '), d.spend_inr,
    d.touches, d.mqls, d.sqls, d.demos, d.won, d.pipeline_inr,
    d.win_rate_pct, d.cost_per_demo_inr, d.cost_per_pipeline_rupee
  ]);
  if (rows.length) sheet.getRange(2, 1, rows.length, headers.length).setValues(rows);
}

// =============================================
// Slack formatting
// =============================================

function formatSlackBlocks_(payload) {
  const ns = payload.north_star;
  return [
    {
      type: 'header',
      text: { type: 'plain_text', text: `📊 GTM Weekly — ${payload.week_ending}` }
    },
    {
      type: 'section',
      fields: [
        { type: 'mrkdwn', text: `*Calendar fill:*\n${ns.calendar_fill_pct}%` },
        { type: 'mrkdwn', text: `*Demos booked:*\n${ns.demos_booked}` },
        { type: 'mrkdwn', text: `*Pipeline ₹:*\n${ns.pipeline_created_inr.toLocaleString('en-IN')}` },
        { type: 'mrkdwn', text: `*MQL→SQL:*\n${ns.mql_to_sql_pct}%` },
        { type: 'mrkdwn', text: `*SQL→Won:*\n${ns.sql_to_won_pct}%` },
        { type: 'mrkdwn', text: `*Median cycle:*\n${ns.median_cycle_days} days` }
      ]
    },
    { type: 'divider' },
    {
      type: 'section',
      text: {
        type: 'mrkdwn',
        text: '*🔍 Top 3 Observations*\n' + (payload.observations || []).slice(0, 3).map((o, i) => `${i + 1}. ${o}`).join('\n')
      }
    },
    {
      type: 'section',
      text: {
        type: 'mrkdwn',
        text: '*✅ Key Actions This Week*\n' + (payload.key_actions || []).slice(0, 3).map((a, i) => `${i + 1}. ${a}`).join('\n')
      }
    },
    {
      type: 'context',
      elements: [
        { type: 'mrkdwn', text: '<https://docs.google.com/spreadsheets/d/${SHEET_ID}|Open full dashboard →>' }
      ]
    }
  ];
}
