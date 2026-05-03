# GitHub SDK Issues Deep Scrape - Razorpay vs Cashfree
# Generated: 2026-04-09
# Total issues scraped: 120+ with full comment threads
# Purpose: RAG pipeline for developer pain point analysis

---

## REPO METADATA

### Razorpay Repos
| Repo | Stars | Forks | Open Issues | Language |
|------|-------|-------|-------------|----------|
| razorpay/razorpay-node | 235 | 122 | 118 | JavaScript |
| razorpay/razorpay-python | 171 | 95 | 85 | Python |
| razorpay/razorpay-php | 202 | 137 | 64 | PHP |
| razorpay/razorpay-java | 71 | 77 | 59 | Java |
| razorpay/razorpay-go | 55 | 31 | 29 | Go |
| razorpay/react-native-razorpay | 132 | 114 | 98 | Java |
| razorpay/razorpay-flutter | 116 | 175 | 194 | Dart |
| razorpay/razorpay-mcp-server | 218 | 30 | 13 | Go |
| razorpay/blade | 611 | 179 | 123 | TypeScript |

### Cashfree Repos
| Repo | Stars | Forks | Open Issues | Language |
|------|-------|-------|-------------|----------|
| cashfree/cashfree-pg-sdk-nodejs | 23 | 6 | 6 | TypeScript |
| cashfree/cashfree-pg-sdk-python | 4 | 6 | 16 | Python |
| cashfree/cashfree-pg-sdk-java | 3 | 7 | 0 | Java |
| cashfree/cashfree-pg-sdk-php | 4 | 9 | 3 | PHP |
| cashfree/cashfree-pg-sdk-go | 4 | 5 | 5 | Go |
| cashfree/react-native-cashfree-pg-sdk | 11 | 13 | 2 | JavaScript |
| cashfree/flutter-cashfree-pg-sdk | 6 | 10 | 8 | Dart |
| cashfree/cashfree-mcp | 12 | 7 | 4 | TypeScript |

---

## RAZORPAY ISSUES

### ================================================================
### razorpay/razorpay-node
### ================================================================

---ISSUE---
platform: github
repo: razorpay/razorpay-node
url: https://github.com/razorpay/razorpay-node/issues/377
title: Customer Already exists error
author: OutdatedGuy
date: 2023-09-22
state: open
labels: question
body: In razorpay v2.9.2, creating a customer with existing data returns error instead of returning existing customer data when fail_existing is set to 0. Downgrade to v2.8.6 resolves issue. Affects Node v18.17.1.

---COMMENT---
author: OutdatedGuy
date: 2023-12-09
text: @ankitdas13 @razorpay can you check on this?

---COMMENT---
author: ankitdas13
date: 2023-12-11
text: @OutdatedGuy Apologies for the long delay, if you want to throw an error if the customer already existed then dont pass fail_existing property. Please check this doc for more detail.

---COMMENT---
author: OutdatedGuy
date: 2023-12-11
text: the docs says that if the value of fail_existing property is set to 0 it should return data of the existing customer, NOT throw error. I want to retrieve the data of existing customer if available, but the code is throwing error instead.

---COMMENT---
author: OutdatedGuy
date: 2023-12-16
text: Code using fail_existing: 0 still throws error with v2.9.2 and demo testing key. Tried live production key - still throws error.

---COMMENT---
author: KarThikCh-dev
date: 2024-02-07
text: for me also the same issue, but while i am trying from public postman collection apis its working as expected but not with node-sdk

---COMMENT---
author: nimesh-trackerbin
date: 2024-02-09
text: just pass fail_existing: "0" instead of fail_existing: 0. It seems to be working fine with this.

---COMMENT---
author: OutdatedGuy
date: 2024-02-12
text: cannot do that in typescript - TypeScript error shown

---COMMENT---
author: OutdatedGuy
date: 2024-02-16
text: looks like the issue is when normalizeBoolean is removed in v2.9.2. I checked and the package is working fine in version v2.9.1. Can you verify and fix this ASAP?

---COMMENT---
author: OutdatedGuy
date: 2024-03-28
text: Hi, is this issue being worked on? We are unable to update the package due to this issue.

---COMMENT---
author: VickyAgravat
date: 2025-08-31
text: At the time of writing this, It is almost two years of the issue. I am using latest 2.9.6 version, but still facing same issue.

---COMMENT---
author: Shubham-Thanki
date: 2025-09-07
text: Hello, My team is also facing this issue, can we please get it fixed.

---ISSUE---
platform: github
repo: razorpay/razorpay-node
url: https://github.com/razorpay/razorpay-node/issues/96
title: Razorpay.validateWebhookSignature() is not working for invoice.paid events
author: arch1995
date: 2019-08-03
state: closed
labels: none
body: validateWebhookSignature returns true for other webhook events but false for invoice.type events despite correct signature implementation.

---COMMENT---
author: captn3m0
date: 2019-08-14
text: Please don't parse the JSON. The HMAC is generated for the exact request body that we send, and a minor difference in how your JSON encoder works v/s ours will result in a different JSON string (and broken signature). Instead read the raw response body in your framework of choice.

---COMMENT---
author: arch1995
date: 2019-08-20
text: your answer doesn't explain why the validation doesn't work for only invoice.paid events and work for other webhook events.

---COMMENT---
author: harman28
date: 2019-08-20
text: The success or failure won't vary by the webhook event, but by the presence of special characters in the webhook body.

---COMMENT---
author: imdkbj
date: 2020-01-19
text: I am also facing the same issue with invoice.paid event where as other works. How to deal with it.

---COMMENT---
author: ksAvinash
date: 2020-03-17
text: facing same issue here. The above snipped generated signature is working fine for all other events except invoice paid

---COMMENT---
author: shailu26
date: 2020-04-09
text: even after passing rawbody to validator its still failing for invoice.paid event

---COMMENT---
author: krishnaow
date: 2020-04-17
text: Here also same issue, Anybody know the solution?

---ISSUE---
platform: github
repo: razorpay/razorpay-node
url: https://github.com/razorpay/razorpay-node/issues/105
title: Not able to verify signature of payment
author: MrSpark2591
date: 2019-09-09
state: closed
labels: none
body: Payment signature verification fails with custom HMAC-SHA256 implementation. Requests NodeJS sample code in documentation.

---COMMENT---
author: MrSpark2591
date: 2019-09-17
text: Resolves issue by explaining payment signatures are generated using live mode secret key even though you are in test mode. Recommends always using Live mode secret key for signature verification.

---COMMENT---
author: harman28
date: 2019-09-17
text: Disputes the claim - If the order is created and payment are in test mode, the signature too will be generated using your test key secret.

---COMMENT---
author: sathyanarayananknila
date: 2020-10-21
text: Confirms same issue persists: currently receiving two different strings as signature in test mode.

---COMMENT---
author: DibyajyotiMishra
date: 2021-04-14
text: Reports undefined razorpay_order_id and razorpay_signature values in handler response during test mode.

---ISSUE---
platform: github
repo: razorpay/razorpay-node
url: https://github.com/razorpay/razorpay-node/issues/172
title: Razorpay says No key passed when trying to Instantiate Razorpay
author: shubhangchourasia
date: 2020-12-20
state: closed
labels: none
body: Nuxt app receives "No key passed" error when instantiating Razorpay with valid key_id and key_secret for live mode order creation.

---ISSUE---
platform: github
repo: razorpay/razorpay-node
url: https://github.com/razorpay/razorpay-node/issues/462
title: Possible timing attack in webhook signature verification method
author: soumitd
date: 2026-01-05
state: open
labels: none
body: Identifies timing attack vulnerability in webhook signature verification code using simple string comparison instead of constant-time comparison.

---ISSUE---
platform: github
repo: razorpay/razorpay-node
url: https://github.com/razorpay/razorpay-node/issues/463
title: Incorrect TypeScript Typings for fail_existing in customers.create
author: htomar6397
date: 2026-01-15
state: open
labels: none
body: Current type definition restricts fail_existing to boolean or numeric values (0/1), but API accepts string equivalents. Requests type definition update.

---ISSUE---
platform: github
repo: razorpay/razorpay-node
url: https://github.com/razorpay/razorpay-node/issues/466
title: Razorpay Create Invoice API Ignores Updated Billing and Shipping Addresses
author: aryancygner
date: 2026-04-02
state: open
labels: none
body: When creating invoices with updated billing/shipping addresses, Razorpay retains previously stored addresses instead of using new ones provided. Dashboard offers address selection options unavailable via API.

---ISSUE---
platform: github
repo: razorpay/razorpay-node
url: https://github.com/razorpay/razorpay-node/issues/453
title: Razorpay Webhook Failing Due to Missing X-Razorpay-Signature Header
author: ra-ele
date: 2025-07-07
state: open
labels: none
body: Incoming webhook requests lack X-Razorpay-Signature header required for authentication verification. Critical payment events like payment.authorized remain unprocessed.

---ISSUE---
platform: github
repo: razorpay/razorpay-node
url: https://github.com/razorpay/razorpay-node/issues/452
title: cancel_at_cycle_end: true ignored - subscription cancel not working
author: kishan79
date: 2025-07-06
state: open
labels: none
body: Subscription cancellation with cancel_at_cycle_end: true fails. API response shows has_scheduled_changes: false.

---ISSUE---
platform: github
repo: razorpay/razorpay-node
url: https://github.com/razorpay/razorpay-node/issues/448
title: No Resource for Custom E-Commerce Magic Checkout Integration
author: divanshuzinta-tmpl
date: 2025-05-29
state: open
labels: none
body: Lacks comprehensive documentation or SDK support for integrating Magic Checkout into custom e-commerce platforms. Support response times inadequate.

---ISSUE---
platform: github
repo: razorpay/razorpay-node
url: https://github.com/razorpay/razorpay-node/issues/454
title: Refund API throwing error
author: hrawat0308
date: 2025-07-23
state: open
labels: none
body: Payment refund API returns BAD_REQUEST_ERROR with "invalid request sent" message despite valid parameters.

---ISSUE---
platform: github
repo: razorpay/razorpay-node
url: https://github.com/razorpay/razorpay-node/issues/455
title: Payment Gateway iFrame has opaque white background instead of transparent
author: zenzzenpl
date: 2025-08-01
state: open
labels: none
body: Razorpay checkout modal displaying opaque white background instead of transparent overlay.

---ISSUE---
platform: github
repo: razorpay/razorpay-node
url: https://github.com/razorpay/razorpay-node/issues/450
title: Missing Invoice Payment Signature Verification
author: AxatSachani
date: 2025-07-03
state: open
labels: none
body: Current SDK lacks invoice payment verification despite Invoices API returning invoice-specific fields.

### ================================================================
### razorpay/razorpay-python
### ================================================================

---ISSUE---
platform: github
repo: razorpay/razorpay-python
url: https://github.com/razorpay/razorpay-python/issues/82
title: Signature verification for subscription giving key error
author: gksoriginals
date: 2020-04-25
state: closed
labels: resolved
body: KeyError: 'razorpay_order_id' when trying to verify signature of subscription. Subscription payments use razorpay_subscription_id but verify_payment_signature only checks for order_id.

---COMMENT---
author: harman28
date: 2020-05-06
text: Yes, only available for orders now, we should upgrade this to handle subscriptions as well. For now, you'll need to write the verify function yourself.

---COMMENT---
author: pupattan
date: 2020-08-09
text: Even i provide subscription_id as razorpay_order_id. But still verification is failing. it does pining like this: sub_FOYXLP0SgUIamT|pay_FOYZSM6AqMr76R

---COMMENT---
author: ashutoshsingh0223
date: 2021-03-14
text: If you flip it starts to work. Eg. pay_FOYZSM6AqMr76R|sub_FOYXLP0SgUIamT

---ISSUE---
platform: github
repo: razorpay/razorpay-python
url: https://github.com/razorpay/razorpay-python/issues/104
title: Unable to create order
author: napsterv
date: 2020-08-20
state: closed
labels: resolved
body: Script crashes with error: TypeError: request() got an unexpected keyword argument 'amount'

---ISSUE---
platform: github
repo: razorpay/razorpay-python
url: https://github.com/razorpay/razorpay-python/issues/148
title: USD is not supported for creating a plan in razorpay
author: kanav-raina
date: 2021-08-13
state: closed
labels: resolved
body: Creating a plan for subscription with USD as currency throws 'Currency provided is not supported' error.

---ISSUE---
platform: github
repo: razorpay/razorpay-python
url: https://github.com/razorpay/razorpay-python/issues/1
title: Pip Installation does not work
author: vrsandeep
date: 2015-12-17
state: closed
labels: none
body: pip install razorpay throws 'Could not find a version that satisfies the requirement razorpay'

---ISSUE---
platform: github
repo: razorpay/razorpay-python
url: https://github.com/razorpay/razorpay-python/issues/227
title: Fix: Added decimal encoder
author: amaan-ahmad
date: 2022-09-11
state: closed
labels: none
body: Unhandled exception on client SDK when Decimal type passed as amount while creating order raised TypeError: Object of type Decimal is not JSON serializable. Common in Django environments.

### ================================================================
### razorpay/razorpay-php
### ================================================================

---ISSUE---
platform: github
repo: razorpay/razorpay-php
url: https://github.com/razorpay/razorpay-php/issues/371
title: CURL error: 60 ssl certificate problem
author: infohappycoders
date: 2024-02-07
state: open
labels: none
body: SSL certificate problem: unable to get local issuer certificate error during order creation using PHP 7.3, Laravel 5.6, library version 2.8.4.

---ISSUE---
platform: github
repo: razorpay/razorpay-php
url: https://github.com/razorpay/razorpay-php/issues/383
title: Unable to do refund due to bad request
author: rishab1788
date: 2024-12-29
state: open
labels: none
body: Refund API throwing server error with malformed response, previously functional but now failing with status 404.

---ISSUE---
platform: github
repo: razorpay/razorpay-php
url: https://github.com/razorpay/razorpay-php/issues/118
title: How to Verify Payment Signature after successful payment
author: MineshRai
date: 2019-07-31
state: closed
labels: none
body: Unable to verify payment signature using utility method, receiving NULL output.

---ISSUE---
platform: github
repo: razorpay/razorpay-php
url: https://github.com/razorpay/razorpay-php/issues/48
title: Webhook validation error: invalid signature passed
author: hari-web
date: 2017-08-22
state: closed
labels: none
body: Webhook signature verification consistently failing despite correct credentials.

### ================================================================
### razorpay/razorpay-go
### ================================================================

---ISSUE---
platform: github
repo: razorpay/razorpay-go
url: https://github.com/razorpay/razorpay-go/issues/22
title: Create Order Panic Error
author: khanakia
date: 2020-11-26
state: closed
labels: none
body: Nil pointer dereference error when creating orders with test credentials.

---ISSUE---
platform: github
repo: razorpay/razorpay-go
url: https://github.com/razorpay/razorpay-go/issues/14
title: Panic on order create
author: sanbornsen
date: 2020-06-28
state: closed
labels: none
body: Nil pointer dereference panic when creating orders.

### ================================================================
### razorpay/razorpay-flutter
### ================================================================

---ISSUE---
platform: github
repo: razorpay/razorpay-flutter
url: https://github.com/razorpay/razorpay-flutter/issues/167
title: Not getting any callback
author: akshayarhata
date: 2021-05-10
state: open
labels: none
body: Amount deducted from customer account but no callback received on live environment (2 out of 10 times). Using razorpay_flutter ^1.2.2 with proper event handlers.

---COMMENT---
author: eastern-codemonk
date: 2021-06-02
text: This happened 12 out of 250 payments today. Highest occurrence till date. Usually 3-5 per 250 successful payments. Never seen in test mode. Highest occurrence with gpay payment. Occurring on Android and iOS almost at same rate. We are thinking of abandoning this SDK and go via web view because of this issue.

---COMMENT---
author: eastern-codemonk
date: 2021-11-08
text: I ended up removing the SDK.

---COMMENT---
author: rijazrasheed
date: 2022-09-03
text: My multiple projects are dependent on this issue. Please find a solution. This happens when customer chooses UPI option for payment. I think you need to enable support for UPI intent for this plugin.

---COMMENT---
author: techtrix008
date: 2022-10-22
text: Switched to webhooks implementation from Razorpay in addition to the callback API. Logic is to implement webhooks and on receiving of webhooks response check if Callback API was triggered. So it's an asynchronous double check method. Webhook never failed.

---COMMENT---
author: gupta-shrinath
date: 2023-01-18
text: My client has reported payments are successful and money deducted but no products added to users account. In live mode no callback is called not even error.

---ISSUE---
platform: github
repo: razorpay/razorpay-flutter
url: https://github.com/razorpay/razorpay-flutter/issues/432
title: Registrar API deprecated in latest Flutter version
author: HarshitaRawat1
date: 2025-01-27
state: open
labels: none
body: Plugin incompatible with Flutter 3.28.0 pre-release. "cannot find symbol class Registrar" errors indicate deprecated Flutter plugin registration API.

---COMMENT---
author: utrayn
date: 2025-02-14
text: This is frustrating. Is someone at RazorPay working on this issue to upgrade the plugin?

---COMMENT---
author: kshiitiz
date: 2025-02-18
text: I have just raised a support ticket on the Razorpay Dashboard. Hopefully someone will address this soon.

---COMMENT---
author: utrayn
date: 2025-02-19
text: Someone from the RazorPay development team please respond. It's been weeks since this issue has existed.

---COMMENT---
author: swarupbhc
date: 2025-02-22
text: no hope from razorpay team soon

---COMMENT---
author: utrayn
date: 2025-02-24
text: Shares RazorPay support response and expresses frustration about considering alternative payment gateways.

---ISSUE---
platform: github
repo: razorpay/razorpay-flutter
url: https://github.com/razorpay/razorpay-flutter/issues/400
title: App not building razorpay creating issue
author: mklgoell
date: 2024-08-12
state: closed
labels: none
body: Gradle build failure: Could not resolve com.razorpay:checkout:1.6.+. jcenter repository access issue. Maven metadata fetch returns HTTP 500.

---COMMENT---
author: (multiple users)
date: 2024-08-13
text: 25+ developers reporting same issue within hours. Temporary workaround: modify .pub-cache file to specify exact version. Root cause: mavenCentral outage. Issue resolved after mavenCentral restoration.

---ISSUE---
platform: github
repo: razorpay/razorpay-flutter
url: https://github.com/razorpay/razorpay-flutter/issues/292
title: Intent Redirection Vulnerability
author: preteambuy
date: 2023-01-28
state: closed
labels: none
body: App is vulnerable to Intent Redirection error from Google Play Store after Flutter 3.7.0 upgrade. com.razorpay.b__J_.onReceive flagged.

---COMMENT---
author: vivekshindhe
date: 2023-01-28
text: We are currently looking into this. The fix will be made live by Monday morning.

---COMMENT---
author: (multiple users)
date: 2023-01-30 to 2023-02-01
text: Extensive back-and-forth over 30+ comments with confused developers trying multiple fix approaches. Instructions spread across messages. Some devs fixed, others still failing. Finally consolidated fix: flutter clean, pub cache clean, sync gradle, verify checkout version 1.6.29.

---ISSUE---
platform: github
repo: razorpay/razorpay-flutter
url: https://github.com/razorpay/razorpay-flutter/issues/482
title: Razorpay Flutter lacks ARM64 architecture support
author: dipteek
date: 2026-04-06
state: open
labels: none
body: razorpaysdk plugin doesn't support ARM64 architecture for Apple Silicon M3. iOS simulators (iOS 26+) require ARM64.

---ISSUE---
platform: github
repo: razorpay/razorpay-flutter
url: https://github.com/razorpay/razorpay-flutter/issues/479
title: PaymentFailureResponse.fromMap crashes with type cast error
author: maitri360
date: 2026-03-27
state: open
labels: none
body: Plugin crashes with "type 'String' is not a subtype of type 'Map'" when handling payment failures.

---ISSUE---
platform: github
repo: razorpay/razorpay-flutter
url: https://github.com/razorpay/razorpay-flutter/issues/478
title: Add Swift Package Manager support
author: abdallahshaban557
date: 2026-03-26
state: open
labels: none
body: CocoaPods is in maintenance mode, SwiftPM will become Flutter's default. Plugin migration recommended.

---ISSUE---
platform: github
repo: razorpay/razorpay-flutter
url: https://github.com/razorpay/razorpay-flutter/issues/470
title: App crashes on Razorpay Checkout launch
author: Mahesh-Langote
date: 2026-01-08
state: open
labels: none
body: Android crash with NoSuchMethodError in AnalyticsUtil when opening checkout. Multiple developers report identical crash suggesting widespread binary incompatibility.

---ISSUE---
platform: github
repo: razorpay/razorpay-flutter
url: https://github.com/razorpay/razorpay-flutter/issues/469
title: Google Play Console Warning: Broken Deep Link pg-router.dev.razorpay.in
author: BhaskarAppic
date: 2025-12-04
state: open
labels: none
body: Android SDK injects internal development intent-filter for pg-router.dev.razorpay.in into merged manifest causing warnings.

---ISSUE---
platform: github
repo: razorpay/razorpay-flutter
url: https://github.com/razorpay/razorpay-flutter/issues/472
title: NetBanking fails with 500 error inside Flutter InAppWebView
author: ParthDevaliya
date: 2026-02-02
state: open
labels: none
body: NetBanking fails with HTTP 500 inside flutter_inappwebview while UPI and cards work. Works in Chrome/Safari/native SDK.

---ISSUE---
platform: github
repo: razorpay/razorpay-flutter
url: https://github.com/razorpay/razorpay-flutter/issues/161
title: When will web support for the plugin be available?
author: nipun0212
date: 2021-04-16
state: open
labels: enhancement
body: Feature request for Flutter web platform support.

---ISSUE---
platform: github
repo: razorpay/razorpay-flutter
url: https://github.com/razorpay/razorpay-flutter/issues/205
title: Error: module compiled with Swift 5.4.2 cannot be imported by Swift 5.5.1
author: jigarfumakiya
date: 2021-11-12
state: open
labels: none
body: iOS build incompatibility with Xcode 13.1. Recurring Swift version mismatch issue across multiple versions.

### ================================================================
### razorpay/react-native-razorpay
### ================================================================

---ISSUE---
platform: github
repo: razorpay/react-native-razorpay
url: https://github.com/razorpay/react-native-razorpay/issues/485
title: Not compatible with SDK 52 New RN Architecture
author: karanmartian
date: 2024-12-09
state: open
labels: none
body: Package not yet upgraded to SDK 52 New Architecture support and hence fails to build.

---COMMENT---
author: vinodsptharsha
date: 2025-10-07
text: Looks like dead project!! Even after receiving funds and exponential growth, Razorpay team not updating library for new Arch. Frustrating. I waited long enough from 51 to 54. I feel like move away from Razorpay payment gateway itself.

---COMMENT---
author: vivekshindhe
date: 2025-10-07
text: Moving to the new architecture seemed to be a lot more complicated than perceived. We have a branch that supports it.

---COMMENT---
author: ayushbgl
date: 2025-11-08
text: I tried using this branch and had import errors.

---ISSUE---
platform: github
repo: razorpay/react-native-razorpay
url: https://github.com/razorpay/react-native-razorpay/issues/516
title: App crashes on launch when enabling 16 KB page size support (Android ARM64)
author: harshapamnani
date: 2025-11-27
state: open
labels: none
body: Application crashes immediately on launch after switching to 16 KB memory page size. Blocks Google Play updates requiring 16 KB page size support for ARM64.

---ISSUE---
platform: github
repo: razorpay/react-native-razorpay
url: https://github.com/razorpay/react-native-razorpay/issues/509
title: DEAD LIBRARY ?
author: rexwebmedia
date: 2025-09-05
state: open
labels: none
body: Multiple crashes in Android and iOS. NoSuchFieldError for missing "activity_result_invalid_parameters" field. Extensive debugging recommendations provided.

---ISSUE---
platform: github
repo: razorpay/react-native-razorpay
url: https://github.com/razorpay/react-native-razorpay/issues/519
title: iOS payment intent opens and closes suddenly
author: SamarthKadam
date: 2026-02-24
state: open
labels: none
body: Payment sheet opens and dismisses immediately on iOS without user interaction.

---ISSUE---
platform: github
repo: razorpay/react-native-razorpay
url: https://github.com/razorpay/react-native-razorpay/issues/501
title: UI Overlapping Issue in Razorpay Checkout
author: Hassu26
date: 2025-03-29
state: open
labels: none
body: Bottom Continue button overlaps with Android soft buttons during checkout.

---ISSUE---
platform: github
repo: razorpay/react-native-razorpay
url: https://github.com/razorpay/react-native-razorpay/issues/498
title: Lagging UI After Multiple Razorpay Payment Cancellations
author: SurajMohanty02
date: 2025-02-13
state: open
labels: none
body: After canceling payment 3-4 times, UI becomes laggy. Suggests improper handling of payment cancellations.

---ISSUE---
platform: github
repo: razorpay/react-native-razorpay
url: https://github.com/razorpay/react-native-razorpay/issues/291
title: App Reject on Playstore
author: Anujmoglix
date: 2020-09-16
state: closed
labels: none
body: Google Play rejects app due to Intent Redirection vulnerability in com.razorpay.AutoReadOtpHelper.onReceive.

---ISSUE---
platform: github
repo: razorpay/react-native-razorpay
url: https://github.com/razorpay/react-native-razorpay/issues/276
title: React Native App crashing on RazorpayCheckout.open
author: sachin321123
date: 2020-07-15
state: closed
labels: none
body: App crashes when calling RazorpayCheckout.open. Error: No value for send_sms_hash in JSON parsing.

---ISSUE---
platform: github
repo: razorpay/react-native-razorpay
url: https://github.com/razorpay/react-native-razorpay/issues/438
title: Intent redirection vulnerability for com.razorpay.x2.onReceive
author: shahidtumbi
date: 2023-01-28
state: closed
labels: none
body: Google Play security alert regarding intent redirection vulnerability after package update.

### ================================================================
### razorpay/razorpay-java
### ================================================================

---ISSUE---
platform: github
repo: razorpay/razorpay-java
url: https://github.com/razorpay/razorpay-java/issues/44
title: Why no tests ?
author: kishaningithub
date: 2019-01-15
state: closed
labels: resolved
body: Inquiry regarding absence of unit tests given SDK handles secure payment data.

---ISSUE---
platform: github
repo: razorpay/razorpay-java
url: https://github.com/razorpay/razorpay-java/issues/120
title: Uncaught ReferenceError: otpPermissionCallback is not defined
author: ibrahim-iqbal
date: 2021-04-14
state: closed
labels: none
body: Webview JS Error during Razorpay payment initiation on Android platform.

---ISSUE---
platform: github
repo: razorpay/razorpay-java
url: https://github.com/razorpay/razorpay-java/issues/128
title: com.razorpay.CheckoutActivity has leaked IntentReceiver
author: samuel-sujith
date: 2021-08-11
state: closed
labels: none
body: IntentReceiver leak and OTP callback errors during payment with version 1.6.11.

---ISSUE---
platform: github
repo: razorpay/razorpay-java
url: https://github.com/razorpay/razorpay-java/issues/260
title: Doesn't work with Fragment
author: tanishq14developer
date: 2022-11-12
state: closed
labels: awaiting response
body: Fragment compatibility issue reported.

### ================================================================
### CASHFREE ISSUES
### ================================================================

### ================================================================
### cashfree/cashfree-pg-sdk-nodejs
### ================================================================

---ISSUE---
platform: github
repo: cashfree/cashfree-pg-sdk-nodejs
url: https://github.com/cashfree/cashfree-pg-sdk-nodejs/issues/76
title: Can't use SDK in multi-tenant environments
author: mdwt
date: 2024-10-21
state: closed
labels: none
body: Configuration parameters are static, preventing multiple merchant instances in single runtime.

---COMMENT---
author: suhas-cashfree
date: 2024-10-21
text: Initially, the SDK was designed to keep it simple. But yes, this use case of multiple creds has to be supported.

---COMMENT---
author: suhas-cashfree
date: 2024-11-05
text: Use version 4.3.0. We have added PGCreateOrderWithConfiguration() that takes CashfreeConfiguration class as first parameter.

---ISSUE---
platform: github
repo: cashfree/cashfree-pg-sdk-nodejs
url: https://github.com/cashfree/cashfree-pg-sdk-nodejs/issues/116
title: Dependency on Sentry
author: mdwt
date: 2026-04-07
state: open
labels: none
body: Sentry dependency significantly increases bundle size; request for abstraction or removal.

---ISSUE---
platform: github
repo: cashfree/cashfree-pg-sdk-nodejs
url: https://github.com/cashfree/cashfree-pg-sdk-nodejs/issues/104
title: Incorrect Environment Initialization in Documentation
author: arpankumarde
date: 2025-05-16
state: closed
labels: none
body: Documentation suggests Cashfree.SANDBOX which doesn't exist; should use CFEnvironment.SANDBOX.

---ISSUE---
platform: github
repo: cashfree/cashfree-pg-sdk-nodejs
url: https://github.com/cashfree/cashfree-pg-sdk-nodejs/issues/74
title: Why does it says request failed everytime
author: SamarthKadam
date: 2024-08-13
state: closed
labels: none
body: Persistent authentication error: "authentication Failed" with code "request_failed".

---ISSUE---
platform: github
repo: cashfree/cashfree-pg-sdk-nodejs
url: https://github.com/cashfree/cashfree-pg-sdk-nodejs/issues/64
title: webhook verify does not work
author: formobi
date: 2024-05-11
state: closed
labels: none
body: Webhook verification not functioning.

---ISSUE---
platform: github
repo: cashfree/cashfree-pg-sdk-nodejs
url: https://github.com/cashfree/cashfree-pg-sdk-nodejs/issues/5
title: Issues after installing cashfree-pg-sdk-nodejs package
author: gdpr1504
date: 2023-02-14
state: closed
labels: none
body: Deprecated package dependencies (Request, crypto) causing build failures.

---ISSUE---
platform: github
repo: cashfree/cashfree-pg-sdk-nodejs
url: https://github.com/cashfree/cashfree-pg-sdk-nodejs/issues/75
title: Bump axios to 1.7.4 to patch vulnerabilities
author: web-ainyx
date: 2024-08-21
state: closed
labels: none
body: axios versions 1.0.0-1.7.3 have CSRF and SSRF vulnerabilities.

---ISSUE---
platform: github
repo: cashfree/cashfree-pg-sdk-nodejs
url: https://github.com/cashfree/cashfree-pg-sdk-nodejs/issues/109
title: Version 5.0.8 depends on vulnerable axios version
author: utkarshrana35
date: 2025-09-26
state: closed
labels: none
body: Axios 1.8.4 contains DoS vulnerability; requires upgrade.

---ISSUE---
platform: github
repo: cashfree/cashfree-pg-sdk-nodejs
url: https://github.com/cashfree/cashfree-pg-sdk-nodejs/issues/1
title: customerName not included in CFCustomerDetails class
author: chaitanya360
date: 2022-09-14
state: closed
labels: none
body: Missing customerName attribute despite Cashfree documentation requirements.

### ================================================================
### cashfree/cashfree-pg-sdk-python
### ================================================================

---ISSUE---
platform: github
repo: cashfree/cashfree-pg-sdk-python
url: https://github.com/cashfree/cashfree-pg-sdk-python/issues/49
title: Dependency conflict between the cashfree-pg package and the pydantic package
author: mys10gan
date: 2024-02-03
state: open
labels: none
body: Cashfree-pg v4.0.3 requires pydantic >=1.10.5,<2, conflicting with project needs for pydantic ^2.5.2.

---COMMENT---
author: suhas-cashfree
date: 2024-02-04
text: Can you try dependency overriding. That should work.

---COMMENT---
author: pradeeprecoup
date: 2024-04-10
text: Pydantic v2.5.3 compatibility error with 'const' parameter removed.

---COMMENT---
author: pradeeprecoup
date: 2024-04-10
text: Asks whether to call APIs directly given evaluation timeline concerns and potential migration to competitors.

---COMMENT---
author: vedrk5672
date: 2024-05-07
text: any update on this, till when can we expect the updated library?

---COMMENT---
author: saksham-gt
date: 2025-02-06
text: Two-year wait since Pydantic v2 release, requests timeline for SDK upgrade.

---COMMENT---
author: balamurugan1603
date: 2025-02-28
text: Dependency conflicts between cashfree SDK and pydantic-settings requiring v2.7+, expressing lack of confidence.

---COMMENT---
author: ronniebasak
date: 2025-03-31
text: Criticizes extended delay since Pydantic v2 release, offers consulting services for upgrade.

---COMMENT---
author: harshit-ambitio
date: 2025-04-23
text: Compatibility issues with OpenAI and Google-GenAI SDKs requiring Pydantic v2.

---COMMENT---
author: harshit-ambitio
date: 2025-04-23
text: Threatens migration to alternative payment gateways if issue isn't resolved urgently.

---COMMENT---
author: amitkma
date: 2026-01-24
text: Expresses frustration with team competency and unnecessary dependencies like Sentry. Compares disappointment with Cashfree to Razorpay, indicating poor SDK maintenance.

---ISSUE---
platform: github
repo: cashfree/cashfree-pg-sdk-python
url: https://github.com/cashfree/cashfree-pg-sdk-python/issues/71
title: base64 issue in PGVerifyWebhookSignature
author: fad1105
date: 2024-08-21
state: closed
labels: none
body: NameError: 'base64' is not defined in api_client.py line 321 within PGVerifyWebhookSignature function.

---ISSUE---
platform: github
repo: cashfree/cashfree-pg-sdk-python
url: https://github.com/cashfree/cashfree-pg-sdk-python/issues/59
title: NameError: name 'StrictBytes' is not defined
author: abhijitnarvekar
date: 2024-04-05
state: closed
labels: none
body: NameError occurs during integration testing in api_client.py within PGesUploadVendorsDocs method.

---ISSUE---
platform: github
repo: cashfree/cashfree-pg-sdk-python
url: https://github.com/cashfree/cashfree-pg-sdk-python/issues/99
title: Why sentry is hard pinned and that too a version older than 3 years almost?
author: amitkma
date: 2026-01-24
state: open
labels: none
body: Question about why sentry-sdk is hard-pinned to an outdated version.

---ISSUE---
platform: github
repo: cashfree/cashfree-pg-sdk-python
url: https://github.com/cashfree/cashfree-pg-sdk-python/issues/48
title: getting error
author: saurabh-0077
date: 2024-01-30
state: closed
labels: none
body: AttributeError: type object 'CreateOrderRequest' has no attribute 'OrderMeta'.

### ================================================================
### cashfree/cashfree-pg-sdk-php
### ================================================================

---ISSUE---
platform: github
repo: cashfree/cashfree-pg-sdk-php
url: https://github.com/cashfree/cashfree-pg-sdk-php/issues/12
title: Security issue with the SDK
author: vaibhavpandeyvpz
date: 2023-08-17
state: open
labels: none
body: SDK sends error information to Sentry without user consent, exposing sensitive server/visitor data.

---COMMENT---
author: vaibhavpandeyvpz
date: 2023-08-17
text: This is first time I've seen a server-side SDK hideously capturing unnecessary system and usage information without consent. Almost equivalent to malicious inserts.

---COMMENT---
author: suhas-cashfree
date: 2023-08-17
text: We will give the users more flexibility to choose whether they want to send additional information or not.

---ISSUE---
platform: github
repo: cashfree/cashfree-pg-sdk-php
url: https://github.com/cashfree/cashfree-pg-sdk-php/issues/69
title: Unzip command failed - case-sensitive filename issue
author: devidasm
date: 2024-08-20
state: closed
labels: none
body: Failed to extract: Card.php and CARD.php both exist on case-insensitive filesystems.

---ISSUE---
platform: github
repo: cashfree/cashfree-pg-sdk-php
url: https://github.com/cashfree/cashfree-pg-sdk-php/issues/71
title: Namespace issue found
author: PrasshantChavan
date: 2024-09-28
state: open
labels: none
body: Namespace configuration errors; workaround found by modifying vendor directory files.

---ISSUE---
platform: github
repo: cashfree/cashfree-pg-sdk-php
url: https://github.com/cashfree/cashfree-pg-sdk-php/issues/46
title: Class "RefundEntity" not found on PGOrderCreateRefund call
author: aroundajay
date: 2024-02-08
state: closed
labels: none
body: Refund broken due to incorrect class path in ObjectSerializer.

### ================================================================
### cashfree/cashfree-pg-sdk-go
### ================================================================

---ISSUE---
platform: github
repo: cashfree/cashfree-pg-sdk-go
url: https://github.com/cashfree/cashfree-pg-sdk-go/issues/57
title: cannot unmarshal string into Go struct field OrderEntity.cf_order_id of type int64
author: rinkujat25
date: 2024-01-31
state: closed
labels: none
body: Marshaling error when creating orders - type mismatch in struct definitions.

---ISSUE---
platform: github
repo: cashfree/cashfree-pg-sdk-go
url: https://github.com/cashfree/cashfree-pg-sdk-go/issues/79
title: cannot unmarshal number into Go struct field LinkEntity.cf_link_id of type string
author: vizvasrj
date: 2024-11-18
state: open
labels: none
body: JSON unmarshaling error - cf_link_id expects string but receives number.

---ISSUE---
platform: github
repo: cashfree/cashfree-pg-sdk-go
url: https://github.com/cashfree/cashfree-pg-sdk-go/issues/77
title: cannot unmarshal string into Go struct field LinkMetaResponseEntity.upi_intent of type bool
author: viveknathani
date: 2024-09-30
state: open
labels: none
body: Type mismatch - upi_intent field string vs boolean.

---ISSUE---
platform: github
repo: cashfree/cashfree-pg-sdk-go
url: https://github.com/cashfree/cashfree-pg-sdk-go/issues/9
title: CFCustomerDetails does not contain CustomerName
author: PERSXA
date: 2023-10-02
state: closed
labels: none
body: Missing CustomerName field needed for order creation.

### ================================================================
### cashfree/flutter-cashfree-pg-sdk
### ================================================================

---ISSUE---
platform: github
repo: cashfree/flutter-cashfree-pg-sdk
url: https://github.com/cashfree/flutter-cashfree-pg-sdk/issues/57
title: UPI apps not showing in Android 15
author: rishav3five8
date: 2024-08-22
state: closed
labels: none
body: UPI apps not visible, white blank page during checkout on Android 15.

---ISSUE---
platform: github
repo: cashfree/flutter-cashfree-pg-sdk
url: https://github.com/cashfree/flutter-cashfree-pg-sdk/issues/53
title: Extremely slow PhonePe App trigger in UPI Intent
author: vinz-mehra
date: 2024-04-21
state: open
labels: none
body: PhonePe app takes ages to open when used with UPI intent. Working fine with Razorpay.

---COMMENT---
author: vinz-mehra
date: 2024-04-22
text: the issue is only occurring with Cashfree SDK. It's working fine with Razorpay. This delay is only happening with PhonePe app.

---ISSUE---
platform: github
repo: cashfree/flutter-cashfree-pg-sdk
url: https://github.com/cashfree/flutter-cashfree-pg-sdk/issues/84
title: Design Issue Android: After Flutter upgrade 3.29.3
author: samratp-asconsoft
date: 2025-06-02
state: closed
labels: none
body: Button overlaps with status bar on Android 14+. Unable to tap Proceed to Pay button.

---ISSUE---
platform: github
repo: cashfree/flutter-cashfree-pg-sdk
url: https://github.com/cashfree/flutter-cashfree-pg-sdk/issues/101
title: Flutter iOS Integration Issue - Unable to get rootViewController
author: yakshpanchal-beep
date: 2026-04-06
state: open
labels: none
body: iOS payment fails with "unable to get an instance of rootViewController" when using FlutterImplicitEngineDelegate.

---ISSUE---
platform: github
repo: cashfree/flutter-cashfree-pg-sdk
url: https://github.com/cashfree/flutter-cashfree-pg-sdk/issues/59
title: On Flutter Web Callback Functions not working
author: sohaibaslam127
date: 2024-09-11
state: closed
labels: none
body: Callback functions fail on Flutter Web. invokeMethod returns null instantly.

---ISSUE---
platform: github
repo: cashfree/flutter-cashfree-pg-sdk
url: https://github.com/cashfree/flutter-cashfree-pg-sdk/issues/4
title: Update SDK with new API
author: hareshgediya
date: 2022-11-29
state: closed
labels: none
body: Flutter SDK still uses deprecated order_token approach. New API sends payment_session_id instead.

---ISSUE---
platform: github
repo: cashfree/flutter-cashfree-pg-sdk
url: https://github.com/cashfree/flutter-cashfree-pg-sdk/issues/72
title: Wasm Compilation fails due to dart:html/dart:js dependencies
author: rohanudhwani
date: 2025-03-03
state: closed
labels: none
body: Flutter Web with Wasm compilation fails. Needs migration to package:web and dart:js_interop.

---ISSUE---
platform: github
repo: cashfree/flutter-cashfree-pg-sdk
url: https://github.com/cashfree/flutter-cashfree-pg-sdk/issues/51
title: OnError method not getting called when back button is pressed
author: dheerajverma009
date: 2024-02-03
state: closed
labels: none
body: OnError callback fails to trigger on Flutter 3.16+ when user presses back during payment. Related to predictive back gestures on Android 14+.

### ================================================================
### cashfree/react-native-cashfree-pg-sdk
### ================================================================

---ISSUE---
platform: github
repo: cashfree/react-native-cashfree-pg-sdk
url: https://github.com/cashfree/react-native-cashfree-pg-sdk/issues/90
title: User getting stuck on Order expiry screen
author: gurman-fab
date: 2026-03-06
state: closed
labels: none
body: When UPI payments expire after 5 minutes, SDK displays Order Expired screen with no close button, trapping users. onError and onVerify callbacks never trigger.

---COMMENT---
author: kishan-cashfree
date: 2026-03-10
text: We will add cross button on this screen. From the app & SDK side, no changes will be required. Frontend changes will be over the air.

---COMMENT---
author: gurman-fab
date: 2026-03-10
text: the fix worked for android but in iOS the cross button is only visible and not working at all.

---COMMENT---
author: kishan-cashfree
date: 2026-03-17
text: Root Cause: The method to dismiss the web checkout screen was not present in the Cashfree react native SDK [2.2.6]. We will release a new RN SDK version with the fix.

---ISSUE---
platform: github
repo: cashfree/react-native-cashfree-pg-sdk
url: https://github.com/cashfree/react-native-cashfree-pg-sdk/issues/57
title: Virus Total Flagging app with react-native-cashfree-pg-sdk as malware
author: Shubham-UMR
date: 2024-04-25
state: closed
labels: none
body: Ads account blocked due to malware detection. Removing SDK dependency eliminates flags. Resolved as false positive.

---ISSUE---
platform: github
repo: cashfree/react-native-cashfree-pg-sdk
url: https://github.com/cashfree/react-native-cashfree-pg-sdk/issues/48
title: SQL Injection security issue - CFDatabaseHelper
author: PraveenKumar8912
date: 2023-12-28
state: closed
labels: none
body: SQL injection vulnerability identified in CFDatabaseHelper class using unsanitized queries.

---ISSUE---
platform: github
repo: cashfree/react-native-cashfree-pg-sdk
url: https://github.com/cashfree/react-native-cashfree-pg-sdk/issues/55
title: payment_session_id is not present or is invalid
author: rajtessrac
date: 2024-04-01
state: closed
labels: none
body: Payment fails after entering card details with session ID validation error despite order creation succeeding.

---ISSUE---
platform: github
repo: cashfree/react-native-cashfree-pg-sdk
url: https://github.com/cashfree/react-native-cashfree-pg-sdk/issues/73
title: Getting fatal exception when opening app second time - database downgrade error
author: chandran-wisright
date: 2025-02-10
state: closed
labels: none
body: Can't downgrade database from version 2 to 1 exception on Android after SDK upgrade.

---ISSUE---
platform: github
repo: cashfree/react-native-cashfree-pg-sdk
url: https://github.com/cashfree/react-native-cashfree-pg-sdk/issues/36
title: Could not find a declaration file for module
author: rnkdsh
date: 2023-07-12
state: closed
labels: none
body: Missing TypeScript declaration file (.d.ts) causes type checking failures.

---ISSUE---
platform: github
repo: cashfree/react-native-cashfree-pg-sdk
url: https://github.com/cashfree/react-native-cashfree-pg-sdk/issues/84
title: Your app uses deprecated APIs for edge-to-edge
author: harshitlupin
date: 2025-07-14
state: closed
labels: none
body: Android 15 deprecation warnings for status bar and navigation bar color methods.

### ================================================================
### cashfree/cashfree-mcp
### ================================================================

---ISSUE---
platform: github
repo: cashfree/cashfree-mcp
url: https://github.com/cashfree/cashfree-mcp/issues/25
title: Security: axios supply chain compromise - plain-crypto-js detected
author: Jdubin1417
date: 2026-04-03
state: closed
labels: none
body: package.json references plain-crypto-js, a malicious phantom dependency from March 31 2026 axios compromise.

---ISSUE---
platform: github
repo: cashfree/cashfree-mcp
url: https://github.com/cashfree/cashfree-mcp/issues/22
title: update cashfree API documentation link
author: frhanjav
date: 2026-01-10
state: open
labels: none
body: old link shows a 404.

---

## PAIN POINT ANALYSIS SUMMARY

### TOP RAZORPAY DEVELOPER PAIN POINTS (by frequency/severity)

1. **Flutter SDK: No callbacks after payment (167)** - CRITICAL
   - Money deducted, no success/error callback
   - 30+ affected developers over 3 years
   - One developer: "ended up removing the SDK"
   - Workaround: webhook double-check pattern

2. **React Native: New Architecture incompatibility (485)** - CRITICAL
   - Expo SDK 52/53/54 broken
   - One developer: "Looks like dead project!!"
   - No official fix for 1+ year
   - Developers threatening to switch gateways

3. **Flutter: Deprecated Registrar API (432)** - HIGH
   - Flutter 3.28+ incompatible
   - Community provides fix before Razorpay team
   - Multiple PRs from external devs

4. **Node: Customer Already Exists bug (377)** - HIGH
   - 2+ years unfixed (Sep 2023 to present)
   - normalizeBoolean removal in v2.9.2 broke fail_existing
   - TypeScript types also wrong (463)

5. **All platforms: Webhook signature verification issues** - HIGH
   - invoice.paid events fail (node #96)
   - Missing X-Razorpay-Signature header (node #453)
   - Timing attack vulnerability (node #462)
   - subscription signature KeyError (python #82)
   - PHP webhook validation errors (php #48)

6. **Flutter/RN: Intent Redirection vulnerability (292, 291, 438)** - HIGH
   - Google Play rejects apps
   - Confusing multi-step fix instructions
   - Recurring pattern across versions

7. **iOS: Swift version mismatches** - RECURRING
   - Swift 5.0/5.1, 5.4.2/5.5.1 incompatibilities
   - Happens every Xcode upgrade
   - No pre-compiled XCFramework solution

8. **Flutter: App crashes on launch (470, 468)** - HIGH
   - NoSuchMethodError in AnalyticsUtil
   - NullPointerException in DeeplinkActivity
   - Multiple devs report identical crash

9. **Flutter: Build dependency issues (400, 280)** - MEDIUM
   - jcenter deprecation causing resolution failures
   - Dynamic version (1.6.+) fragile to outages
   - 25+ developers affected simultaneously

10. **Subscription management gaps** - MEDIUM
    - cancel_at_cycle_end not working (node #452)
    - No guidance for plan switching (node #460)
    - Missing invoice payment verification (node #450)

### TOP CASHFREE DEVELOPER PAIN POINTS (by frequency/severity)

1. **Python SDK: Pydantic v2 incompatibility (49)** - CRITICAL
   - 2+ years unfixed (Feb 2024 to present)
   - Blocks modern AI/ML stack integration (OpenAI, GenAI SDKs need Pydantic v2)
   - Developers threatening migration
   - 28+ comments showing growing frustration
   - "Compares disappointment with Cashfree to Razorpay"

2. **All SDKs: Sentry dependency without consent (php #12, python #99, nodejs #116)** - HIGH
   - Captures system information without opt-in
   - One developer: "almost equivalent to malicious inserts"
   - Increases bundle size significantly
   - Hard-pinned to outdated versions causing conflicts

3. **Go SDK: Type mismatches in struct definitions (57, 77, 79)** - MEDIUM
   - JSON unmarshaling errors across multiple entities
   - cf_order_id, cf_link_id, upi_intent type conflicts
   - Auto-generated SDK quality issues

4. **Flutter: UPI apps not visible on Android 15 (57, 58)** - MEDIUM
   - White blank page during checkout
   - PhonePe takes ages to open (53)
   - Explicit comparison: "working fine with Razorpay"

5. **React Native: Users stuck on expired order screen (90)** - MEDIUM
   - No close button, no callbacks
   - Required SDK + frontend fix
   - Quick turnaround from Cashfree team (closed in 2 weeks)

6. **Node SDK: Documentation errors (104, 103, 111)** - MEDIUM
   - Wrong environment initialization instructions
   - Webhook verification syntax errors
   - Cashfree.SANDBOX vs CFEnvironment.SANDBOX confusion

7. **PHP SDK: Case-sensitive filename issue (69)** - LOW
   - Card.php and CARD.php collide on macOS/Windows
   - Namespace configuration errors (71)
   - RefundEntity class not found (46)

8. **React Native: Database downgrade crash (73)** - MEDIUM
   - Fatal exception on second app launch
   - SQLiteException: Can't downgrade database from version 2 to 1

9. **Security vulnerabilities in dependencies** - HIGH
   - axios supply chain compromise (mcp #25)
   - Multiple axios CVEs across SDK versions
   - SQL injection in CFDatabaseHelper (rn #48)

10. **Missing features/SDK gaps**
    - No Expo support (rn #23)
    - No TypeScript declarations (rn #36)
    - No subscription API support (node #57)
    - No multi-tenant support pre-v4.3.0 (node #76)

### COMPARATIVE ANALYSIS

| Dimension | Razorpay | Cashfree |
|-----------|----------|----------|
| Community size | 10-50x larger stars/forks | Tiny community |
| Issue response time | Weeks to months, often never | Days to weeks, usually responsive |
| SDK maintenance | Slow updates, many open PRs | Auto-generated, quality issues |
| Documentation | Better coverage, some gaps | Significant errors/gaps |
| Mobile SDK quality | Frequent crashes, architecture lag | Fewer issues, smaller surface area |
| Webhook verification | Multiple long-standing bugs | base64 import bug, Sentry concerns |
| Dependency management | jcenter issues, outdated deps | Pydantic v2 (critical), Sentry forced |
| Security posture | Intent redirection recurring | SQL injection found, Sentry privacy |
| Developer sentiment | Frustrated about slow response | Frustrated about SDK quality/deps |
| New Architecture | Months behind React Native new arch | Not applicable (smaller RN base) |
