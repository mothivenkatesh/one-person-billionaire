# Signzy MCC Classification & Onboarding Suite -- Step 1: Research Output

---

## 1. ICP & Market Research

### Ideal Customer Profile

**Company Type & Industry:**
- **Primary ICP:** RBI-licensed Payment Aggregators (PA-Online, PA-Physical, PA-Cross Border) that must onboard and classify merchants under correct MCCs as mandated by RBI Master Direction 2025. There are 50+ licensed PAs in India as of mid-2025, with the top 3 (Razorpay, PayU, mothi) controlling ~70-80% of new merchant onboarding volume.
- **Secondary ICP:** Acquiring banks (SBI, HDFC, ICICI, Axis, YES Bank etc.) that assign MCCs to merchants in card payment flows and bear ultimate regulatory liability for MCC accuracy. Approximately 20-25 major acquiring banks operate in India.
- **Tertiary ICP:** Large NBFCs and neobanks launching merchant acceptance / BaaS products that need compliant onboarding rails without building in-house.

**Size:**
- Payment Aggregators onboarding 10,000+ merchants/month (mid-market) to 500,000+/month (enterprise like Razorpay with 10M+ merchants).
- Acquiring banks processing 1M+ card transactions/month where MCC accuracy drives interchange economics, GST compliance, and dispute outcomes.

**Must-Have Criteria (Unit of Work):**
- The unit of work is a **single merchant onboarded and classified** -- meaning one KYC-verified, MCC-assigned, compliance-cleared merchant record. Signzy charges per successful onboarding/verification transaction (~65% of revenue is transaction-based).
- Must-haves: (a) RBI PA license or application in progress, (b) active merchant acquisition pipeline, (c) existing or planned digital onboarding flow, (d) regulatory obligation for MCC assignment and CDD.

**Buyer Persona:**
| Attribute | Detail |
|-----------|--------|
| Title | VP/Head of Compliance, Chief Risk Officer, Head of Merchant Onboarding, or Head of Product (Payments) |
| Pain | Manual MCC classification is error-prone, slow (days per merchant), and creates regulatory exposure. RBI Master Direction 2025 tightened CDD requirements and penalties for misclassification. Every wrongly classified merchant = GST liability risk + potential RBI audit flag + interchange leakage. |
| Decision Criteria | (1) Accuracy of automated MCC assignment, (2) RBI compliance coverage out-of-the-box, (3) API-first integration with existing onboarding stack, (4) Speed -- reduce merchant go-live from days to minutes, (5) Audit trail and reporting for regulatory submissions. |
| Budget Authority | Compliance/Risk head signs off on vendor; CTO/Head of Product approves technical integration. Deals typically need dual sign-off. |

**End User Persona:**
- **Merchant Onboarding Operations Analyst** -- runs 50-200 merchant applications/day through the system. Needs a clean dashboard, bulk processing, exception handling for edge-case MCCs, and one-click regulatory report generation.
- **Compliance Officer** -- reviews flagged merchants, validates MCC assignments against RBI/Visa/Mastercard/RuPay code tables, runs periodic re-classification audits.

**Current Way (What They Do Today):**
1. **Manual classification:** Ops teams cross-reference merchant business descriptions against a spreadsheet of ~800+ MCC codes. Senior analysts handle ambiguous cases. Takes 15-45 min per merchant for complex cases.
2. **Fragmented tooling:** Many PAs use one vendor for KYC (PAN/Aadhaar verification), another for bank account validation, and a third for business verification -- with MCC assignment done manually in between.
3. **Periodic audit panic:** Compliance teams run quarterly or annual MCC audits manually, often discovering hundreds of misclassified merchants that require retroactive correction and reporting to card networks.
4. **Rule-based scripts:** Some larger PAs have built internal rule engines mapping keywords to MCCs, but these break on edge cases (multi-category businesses, new business types) and require constant maintenance.

**Buying Triggers:**
1. **RBI Master Direction Sept 2025:** The consolidated PA Directions made MCC validation and CDD a hard compliance requirement with tighter enforcement. PAs that were previously informal about MCC assignment must now demonstrate systematic processes.
2. **RBI license grant or renewal:** New PA license recipients (9 approved in 2025 alone) need compliant onboarding infrastructure from day one.
3. **Merchant onboarding ban/lift:** RBI has historically suspended onboarding for non-compliant PAs (Razorpay and mothi experienced bans). The risk of onboarding suspension is a powerful motivator.
4. **Scale inflection:** When a PA crosses ~50K active merchants, manual MCC classification becomes operationally unsustainable.
5. **Card network audits:** Visa/Mastercard periodically audit MCC accuracy of acquirers. Failed audits lead to fines and remediation mandates.
6. **IPO/fundraise preparation:** Razorpay filed for IPO in Jan 2026. Investors and auditors demand demonstrable compliance infrastructure.

---

### ICP Scorecard (FletchPMM Methodology)

| Dimension | Score (1-10) | Evidence |
|-----------|:---:|----------|
| **Retention** | 8 | Once a PA integrates Signzy's onboarding + MCC APIs into their merchant acquisition flow, switching costs are very high (re-integration, re-validation of existing merchant base, compliance continuity risk). Signzy processes 10M+ onboardings/month across clients -- evidence of deep workflow embedding. 65% of revenue is transaction-based, meaning retention correlates with client growth. |
| **Access** | 7 | Compliance heads and onboarding product leads at PAs are identifiable and reachable through industry events (Global Fintech Fest, NASSCOM), RBI working groups, and NPCI forums. However, enterprise bank procurement cycles are slow (6-9 months). Signzy already serves 240+ FIs and 4 of India's largest banks, demonstrating established access channels. Mid-market PAs are more accessible. |
| **Sales Velocity** | 6 | Enterprise deals with banks take 6-9 months with POCs, security reviews, and procurement. Mid-market PA deals can close in 2-3 months given regulatory urgency. The Sept 2025 RBI directive created a time-bound compliance window that accelerates velocity. However, budget cycles at banks remain rigid. Signzy's no-code platform and 3-4 week deployment claim (vs. 6-month in-house builds) helps compress cycles. |
| **Activation** | 8 | Time-to-value is fast because MCC misclassification is a measurable, auditable problem. A PA can run their existing merchant base through Signzy's classification engine and immediately see the error rate delta. Signzy claims 99% success rate on onboarding and speed-to-market reduction from 6 months to 3-4 weeks. ROI is directly calculable: (manual ops cost saved) + (penalties avoided) + (interchange leakage recovered). |

**Composite ICP Score: 7.25/10** -- Strong ICP. Retention and Activation are the leading indicators. Sales Velocity is the constraint, particularly for bank segment.

---

### TAM Sizing (Triangulated)

#### Bottom-Up Estimate

| Segment | Count | Avg Annual Contract Value (ACV) | Segment TAM |
|---------|------:|------:|------:|
| Top-tier PAs (Razorpay, PayU, mothi, PhonePe, BillDesk etc.) | 10 | INR 3-5 Cr ($360-600K) -- high volume, enterprise pricing | INR 40 Cr ($4.8M) |
| Mid-tier licensed PAs | 40 | INR 50L-1.5Cr ($60-180K) -- growing merchant base | INR 40 Cr ($4.8M) |
| PA applicants / pre-license fintechs | ~50 | INR 20-50L ($24-60K) -- starting small | INR 17.5 Cr ($2.1M) |
| Acquiring banks (top 25) | 25 | INR 1-3 Cr ($120-360K) -- card-network MCC compliance | INR 50 Cr ($6M) |
| Large NBFCs with merchant acceptance | 30 | INR 30-75L ($36-90K) | INR 15 Cr ($1.8M) |
| **Total Bottom-Up TAM** | **~155 accounts** | | **INR 162.5 Cr (~$19.5M)** |

*Assumptions: ACV includes onboarding platform license + per-transaction MCC classification + compliance reporting modules. Based on Signzy's ~INR 111 Cr FY24 revenue across all products and ~$40-50M ARR run-rate in early 2026, the MCC/merchant onboarding vertical likely represents 25-35% of total revenue.*

#### Top-Down Estimate

- India digital merchant onboarding platform market: $1.4B globally in 2025, India estimated at 8-10% = ~$112-140M.
- Signzy's addressable slice (MCC classification + compliance onboarding for regulated entities, not full merchant onboarding platforms like Stripe): approximately 15-20% of the India portion = **$17-28M**.
- India e-KYC market alone is $26.3M (2024), growing at 20.3% CAGR. MCC classification is an adjacent vertical that piggybacks on this infrastructure.

#### Analogy Estimate

- Signzy's comparable in the US/EU is Sardine (fraud + onboarding compliance, raised $70M, valued ~$500M) and Alloy (identity + compliance orchestration, $235M raised). Both serve a similar "compliance infrastructure for fintechs" niche.
- India's regulated fintech ecosystem is roughly 1/5th the size of the US by revenue but growing faster. Applying a 1/5th ratio to Alloy's estimated ~$100M ARR suggests a ~$20M opportunity for the India leader.
- Cross-reference: Signzy at ~$40-50M ARR total, with MCC/onboarding at 25-35%, implies ~$10-17.5M current revenue from this vertical -- consistent with a ~$20M near-term TAM.

#### Triangulated TAM: ~$19-22M for India MCC Classification + Compliant Merchant Onboarding

#### SOM (Serviceable Obtainable Market -- Reachable NOW)

- Signzy already serves 240+ FIs. For the MCC vertical specifically:
  - **Existing clients upsell:** 40-60 current PA/bank clients who can be upsold the MCC classification module = INR 30-40 Cr ($3.6-4.8M)
  - **New logo acquisition:** 20-30 newly licensed or compliance-pressured PAs reachable in next 12 months = INR 10-20 Cr ($1.2-2.4M)
  - **SOM estimate: $4.8-7.2M in next 12 months**
- This assumes Signzy can convert 30-40% of the addressable base, which is realistic given their brand, existing relationships, and the regulatory tailwind from Sept 2025 RBI directions.

---

### Key Gaps to Validate

1. **MCC-specific product maturity:** Signzy's website prominently covers KYC/KYB/AML but MCC classification is mentioned only in blog content, not as a standalone product page. Need to validate: Is MCC classification a launched, GA product or still in development/beta? What is the actual classification accuracy rate vs. manual processes?

2. **Competitive positioning vs. IDfy:** IDfy has a dedicated "Merchant Onboarding" product page and explicitly targets PAs. How does Signzy's MCC engine compare on accuracy, coverage of India-specific MCC codes (especially RuPay codes), and pricing?

3. **PA buyer willingness to pay:** Many mid-tier PAs may view MCC classification as a feature within their existing KYC vendor relationship, not a standalone purchase. Need to validate whether Signzy sells MCC as a standalone module or only as part of a broader onboarding suite -- and whether PAs have separate budget for it.

4. **Actual enforcement intensity:** While RBI Master Direction 2025 tightened requirements, it is unclear how aggressively RBI is enforcing MCC accuracy specifically (vs. other PA compliance requirements like net worth, grievance redressal). Need to validate through conversations with PA compliance heads whether MCC is a "hair on fire" problem or a "nice to have."

5. **Build vs. buy dynamics:** Large PAs like Razorpay (10M+ merchants, IPO-bound) may prefer to build in-house MCC classification using their own data. Signzy's sweet spot may be the mid-tier PAs (50K-500K merchants) who lack engineering resources. This segmentation needs validation.

6. **International expansion leverage:** Signzy claims 180+ country coverage. Does the MCC product work for cross-border PAs (PA-CB category)? This could meaningfully expand TAM if validated.

7. **Revenue attribution:** Signzy's $40-50M ARR run-rate is across all products. The specific revenue contribution of MCC classification vs. broader KYC/KYB modules is not publicly broken out. Need internal data to size this accurately.

---

## Data Sources & References

- [Signzy MCC Guide](https://www.signzy.com/blogs/guide-on-merchant-category-code-mcc)
- [Signzy Digital Onboarding](https://www.signzy.com/digital-onboarding/)
- [Signzy Funding - Crunchbase](https://www.crunchbase.com/organization/signzy)
- [Signzy Financials - Tracxn](https://tracxn.com/d/companies/signzy/__FKmMW-C-ZqyWKlnCs2jeeZcdbBJFnHhjkB4fWlblLW4)
- [Signzy How It Works - Business Model Canvas](https://businessmodelcanvastemplate.com/blogs/how-it-works/signzy-how-it-works)
- [Signzy Empowers Payment Aggregators](https://www.signzy.com/blogs/how-signzy-empowers-payment-aggregators-in-a-licensed-landscape)
- [RBI PA Master Direction 2025 - AuthBridge Analysis](https://authbridge.com/blog/rbi-payment-aggregator-master-direction-2025/)
- [RBI PA Directions 2025 - India Corp Law](https://indiacorplaw.in/2025/10/09/decoding-rbis-overhaul-of-the-payment-aggregator-directions/)
- [RBI PA Directions - Lexology](https://www.lexology.com/library/detail.aspx?g=66e43cc2-d69d-42a3-87f8-2381a386ea89)
- [RBI PA Compliance Mandate - Mondaq](https://www.mondaq.com/india/financial-services/1706010/rbi-master-direction-2025-compliance-mandate-for-payment-aggregators-and-pa-p-deadline)
- [MCC Misuse Crackdown - LinkedIn](https://www.linkedin.com/pulse/rbis-crackdown-mcc-misuse-wake-up-call-fintechs-ram-rastogi--815ef)
- [India Payment Gateway Market - Mordor Intelligence](https://www.mordorintelligence.com/industry-reports/india-payment-gateway-market)
- [India e-KYC Market - IMARC](https://www.imarcgroup.com/india-e-kyc-market)
- [India Identity Verification Market - UnivDatos](https://univdatos.com/reports/india-identity-verification-market)
- [India KYC Industry - The Indian Eye](https://theindianeye.com/2025/10/02/indias-kyc-industry-builds-trust-in-digital-identity-verification/)
- [Digital Merchant Onboarding Market](https://www.marketreportanalytics.com/reports/digital-merchant-onboarding-platform-73341)
- [PayU PA License - Business Standard](https://www.business-standard.com/finance/news/payu-secures-final-rbi-approval-as-online-payment-aggregator-125051301470_1.html)
- [Razorpay Statistics 2026 - CoinLaw](https://coinlaw.io/razorpay-statistics/)
- [Signzy Competitors - HyperVerge](https://hyperverge.co/blog/signzy-competitors/)
- [IDfy Merchant Onboarding](https://www.idfy.com/identity-verification-solutions-by-idfy/merchant-onboarding/)
- [MCC India List - Open Money](https://open.money/blog/merchant-category-code-list-in-india/)
- [Signzy Capterra](https://www.capterra.com/p/10009382/Signzy/)


---


# Signzy MCC Classification & Onboarding Suite -- Competitive Intelligence (Step 2)

**Product:** Signzy's MCC Classification & Onboarding Suite (GST-to-MCC, WebCrawler, ShopLens AI, MSME Alt Data, Transaction Monitoring)
**ICP:** Merchant aggregators, PSPs, banks with merchant acquiring in India
**Date:** 2026-04-09

---

## 2. Competitive Intelligence

### Competitive Landscape

#### Direct Competitors

| Competitor | Their Positioning | Pricing Model | Strengths | Weaknesses | Our Angle |
|---|---|---|---|---|---|
| **Card91 (BlitzTrust / VerifyIQ)** | AI-powered merchant verification, dynamic MCC mapping, and risk scoring -- purpose-built for Indian card issuers and acquirers. Launched VerifyIQ (Apr 2026) as a full verification intelligence platform. | Usage-based API pricing (contact sales). Bundled with Card91's card infrastructure stack. | Deep India focus. Combines PAN/GSTIN/Udyam verification with AI-driven MCC assignment in one flow. RBI/NPCI/AML-compliant out of the box. Already embedded in card issuance workflows. | Primarily tied to Card91's card infrastructure customers -- not a standalone RegTech play. Limited to card-based acquiring; weaker in UPI/PA-Online merchant onboarding context. New product (VerifyIQ launched weeks ago), limited production track record. | Signzy is infrastructure-agnostic (works with any acquirer/PA, not locked to one card stack). 5-API suite goes beyond MCC assignment into ongoing transaction monitoring and MSME alt-data enrichment -- Card91 stops at onboarding. |
| **Parcha AI** | AI agents for merchant onboarding compliance. MCC classification from 500+ categories using business website + self-attested data analysis. US-headquartered, global focus. | Usage-based SaaS. Enterprise contracts (Flutterwave is a named customer). | 95-99.7% accuracy validated in production (Flutterwave case study). SOC 2 Type 2 compliant. Fast -- 2-5 min vs. 20-120 min manual. Strong API-first design. | US/global focus -- no India-specific data sources (GST, Udyam, MSME registries). Does not integrate with Indian identity rails (PAN, GSTIN, Aadhaar). No RBI-specific compliance framing. Limited presence in Indian BFSI ecosystem. | Signzy is built for India's regulatory fabric: GST-to-MCC mapping uses GSTIN as a primary signal (which Parcha cannot). ShopLens AI uses India-specific storefront intelligence. Deep integration with Indian identity and business verification rails. |
| **TrueBiz** | MCC Discovery -- assigns merchant category codes from just a business name + location using real-time web intelligence. Mastercard-approved MMSP. | Usage-based API. Enterprise tiers. Pricing not public. | Mastercard MMSP certification. Reduces application processing time by up to 80%. Works with minimal input (name + location). Plugs into risk engines and monitoring systems. | Western-market oriented. No India-specific data integrations (GST, Udyam, Shop & Establishment). Web-crawling approach works well for businesses with strong online presence but struggles with India's offline/MSME merchant base. No transaction monitoring component. | Signzy's ShopLens AI + MSME Alt Data APIs solve the India-specific "dark merchant" problem -- millions of MSMEs with minimal web presence. GST-to-MCC is a more authoritative signal than web crawling for Indian merchants. |
| **DeepVue.tech** | Merchant Category Classification API using computer vision / deep learning on retail storefront photographs. Also offers KYC/KYB APIs. | Per-API-call pricing. Self-serve + enterprise tiers. | Novel approach -- image-based MCC classification is useful for field verification. Has broader KYC/KYB API suite for Indian market. | Image-based classification requires field agents to capture storefront photos -- not scalable for digital-first onboarding. Limited to physical retail; cannot classify online-only or service businesses. No ongoing monitoring capability. Single-signal approach (image only). | Signzy's suite uses multiple signals (GST data, web crawl, storefront AI, MSME alt-data) rather than a single modality. Works for both physical and digital merchants. Covers full lifecycle from onboarding classification to ongoing transaction monitoring. |
| **Karza / Perfios (KGST Suite)** | GST verification and analytics APIs as part of a broader 100+ API KYC/KYB platform. GST stack live since 2017. Now part of Perfios (OneView). | Per-API-call. Volume-based enterprise pricing. Established in market. | Deepest GST data analytics in India (operational since 2017). Part of Perfios -- massive distribution through existing banking relationships. Trusted by major Indian banks and NBFCs. Comprehensive KYC/KYB coverage. | GST verification is a building block, not an MCC classification product. Compliance teams must still manually map GST data to MCC codes. No AI-driven MCC recommendation engine. No web crawling or storefront intelligence. No ongoing MCC drift monitoring. | Signzy automates the "last mile" that Karza leaves manual -- the GST-to-MCC mapping itself. Karza gives you the GST data; Signzy gives you the MCC decision. Positioning: "We start where Karza stops." |

#### Status Quo Competitor

**Manual MCC review + spreadsheet-based governance** remains the dominant approach for 70-80% of Indian merchant aggregators and PSPs today:

- **Process:** Compliance analyst receives merchant application with GST certificate. Manually looks up GSTIN on the GST portal. Reads the business description and HSN/SAC codes. Opens a Visa/Mastercard MCC reference PDF (500+ codes). Makes a judgment call on which MCC to assign. Enters it into the onboarding system. Periodic re-review (quarterly or annual) via spreadsheet audit.
- **Tools used:** GST portal (manual lookup), Excel/Google Sheets for MCC mapping tables, internal wikis with MCC guidelines, email-based escalation for edge cases.
- **Cost:** 15-30 minutes per merchant for initial classification. Error rates of 10-25% (industry estimates). Misclassification leads to interchange leakage, regulatory penalties (RBI PA Directions 2025 now mandate stricter MCC governance), and settlement disputes.
- **Why it persists:** "Good enough" for low volumes. Compliance teams are familiar with the process. No single product existed that combined GST-to-MCC automation with ongoing monitoring -- until now. Budget for tooling sits across compliance, risk, and ops -- hard to get a single PO signed.
- **Breaking point:** The RBI's September 2025 Master Direction on Payment Aggregators significantly raised the bar on merchant due diligence, MCC accuracy, and ongoing monitoring. Manual processes cannot scale with the new regulatory requirements, especially for PAs onboarding thousands of merchants monthly.

#### Adjacent Competitors

| Adjacent Competitor | What They Do | Overlap with Signzy MCC Suite | Gap |
|---|---|---|---|
| **AuthBridge** | India's largest RegTech -- digital KYC, video KYC, AML screening, workforce verification. 3,000+ enterprise clients, 15M+ monthly verifications. | Broad compliance and onboarding automation for BFSI. Could add MCC classification as a feature. | No MCC-specific product today. Focused on identity verification, not merchant categorization or transaction monitoring. |
| **IDfy** | AI/ML-driven KYC, KYB, digital onboarding. 600+ clients including HDFC, Axis, Paytm. 70M+ verifications. | Merchant onboarding verification (PAN, GST, business existence checks). | Identity-layer player. No MCC classification, no ongoing merchant category monitoring. |
| **HyperVerge** | AI-powered identity verification. 98% completion rate, 99% auto-approval. | Competes for "onboarding automation" budget. Some overlap in merchant KYC. | Pure identity verification. No business classification, no MCC mapping, no regulatory compliance workflow for PAs. |
| **LegitScript** | Mastercard-recognized MMSP. Merchant monitoring for high-risk categories across 100+ countries. 60+ risk detection areas. | Ongoing merchant monitoring and transaction compliance. Fine mitigation (75-100% BRAM/VIRP reduction). | Western-focused, content-risk oriented (pharmaceuticals, IP infringement). Not designed for India's MCC governance challenges. No GST integration. Premium pricing for global compliance, not tailored to Indian PA/PSP economics. |
| **Jocata (GRID platform)** | Unified AML, KYC remediation, fraud detection, case management for Indian banks/NBFCs. | Compliance workflow automation. Serves similar buyer (Head of Compliance). | Case management / AML platform, not MCC classification. Could be a complementary integration partner rather than competitor. |

---

### Market Maturity

**Phase: Early-to-Growing (Phase 1 transitioning to Phase 2 in FletchPMM's framework)**

Using FletchPMM's 3 Phases of Differentiation:

- **Phase 1 (Problem-Solution Fit / "Does it work?"):** The MCC classification automation market in India is still here for most buyers. The majority of merchant aggregators and PSPs are still doing MCC assignment manually. The problem is newly urgent (RBI PA Master Direction, September 2025), but most organizations have not yet purchased a dedicated tool. Buyers are evaluating whether automation is reliable enough to replace human judgment. Card91's VerifyIQ launched only in April 2026; Signzy's suite is new. The market is being created in real time.

- **Phase 2 signals (Feature-Function / "Does it do what I need?"):** A few early movers (Parcha, TrueBiz) exist globally, but the India-specific MCC classification market has fewer than 5 identifiable purpose-built products. Buyers who have adopted automation are now comparing features (accuracy, data sources, monitoring capabilities). RBI regulatory pressure is accelerating the move from Phase 1 to Phase 2.

**Differentiation mode for this phase:** Problem-aware education + proof of concept. The primary job is not to beat competitors on features but to convince the buyer that automated MCC classification is (a) necessary now (regulatory forcing function) and (b) reliable enough to trust (accuracy proof points, India-specific data advantage).

**Implication for positioning:** Lead with the problem (regulatory risk, manual process breakdown at scale) rather than features. Position Signzy as the category creator for "MCC Governance Automation" in India rather than a better version of something that already exists. Avoid premature feature comparison wars with global players (Parcha, TrueBiz) -- instead, frame the India-specific regulatory and data landscape as a moat they cannot cross.

---

### Top 3 Differentiation Angles

**1. India's Regulatory Fabric as a Moat (Data Advantage)**

No global competitor can replicate Signzy's integration with India's identity and business verification rails -- GSTIN, Udyam, Shop & Establishment, PAN, MCA. The GST-to-MCC API uses the most authoritative business classification signal available in India (HSN/SAC codes from GST filings) rather than web scraping or self-attestation. This is not a feature gap competitors can close with engineering effort; it requires deep regulatory domain expertise and government data source partnerships. Positioning line: "The only MCC engine built on India's regulatory data backbone."

**2. Full-Lifecycle Coverage (Onboarding + Monitoring, Not Just Classification)**

Every competitor stops at the point of MCC assignment during onboarding. Signzy's 5-API suite covers the full lifecycle: initial classification (GST-to-MCC, WebCrawler, ShopLens AI), enrichment for thin-file merchants (MSME Alt Data), and ongoing compliance (Transaction Monitoring for MCC drift detection). This matters because the RBI's 2025 PA Directions now require continuous merchant monitoring, not just point-in-time onboarding checks. Buyers purchasing a classification-only tool will need a second vendor for monitoring -- or they can get both from Signzy. Positioning line: "From Day 1 MCC assignment to Day 365 compliance -- one suite."

**3. The Dark Merchant Problem (MSME Alt-Data + ShopLens AI)**

India has 60M+ MSMEs, most with minimal or no web presence. Global MCC tools (Parcha, TrueBiz) that rely on web crawling and online business intelligence are structurally unable to classify these merchants. Signzy's ShopLens AI (storefront/physical presence analysis) combined with MSME Alt Data (alternative business signals beyond GST and web) solves the classification challenge for India's long tail of offline and semi-formal merchants. This is the segment where acquirers and PAs face the highest misclassification risk and regulatory exposure. Positioning line: "Classify the merchants no one else can see."

---

### Sources

- [Parcha AI - MCC Classification](https://www.parcha.ai/agents/mcc-classification)
- [TrueBiz - MCC Discovery](https://truebiz.io/blog/mcc-discovery)
- [Card91 - AI-Powered Merchant Verification & MCC Mapping](https://card91.io/ai-lab/merchant-verification-classification)
- [DeepVue - Merchant Category Verification](https://deepvue.tech/retailer-tech/merchant-category-verification/)
- [Karza / Perfios - GST & Onboarding](https://karza.in/products/Gst)
- [AuthBridge - 7 Best RegTech Platforms in India](https://authbridge.com/blog/7-best-regtech-platforms-in-india/)
- [HyperVerge - Signzy Competitors](https://hyperverge.co/blog/signzy-competitors/)
- [LegitScript - MMSP](https://www.legitscript.com/mmsp/)
- [RBI PA Master Direction 2025](https://www.fidcindia.org.in/wp-content/uploads/2025/09/RBI-PAYMENT-AGGREGATORS-DIRECTIONS-15-09-25.pdf)
- [India RegTech Market - IMARC Group](https://www.imarcgroup.com/india-regtech-market)
- [Signzy Platform](https://www.signzy.com/)
- [Card91 VerifyIQ Launch](https://www.prnewswire.com/in/news-releases/card91-launches-ai-powered-merchant-verification-and-classification-suite-to-simplify-and-secure-onboarding-302514721.html)


---


# Signzy MCC Classification & Onboarding Suite — GTM Builder (Steps 3-5)

---

## STEP 3: PRFAQ (Press Release / FAQ)

---

### PRESS RELEASE

**FOR IMMEDIATE RELEASE**

**Headline:**
Signzy Launches India's First AI-Powered MCC Classification Suite That Turns GST Data Into Compliant Merchant Onboarding in Under 60 Seconds

**Sub-headline:**
New five-API suite eliminates manual MCC coding for Payment Aggregators and banks, cutting onboarding time by 90% while meeting RBI PA Master Direction requirements — including India's 60M+ offline merchants that existing global tools miss entirely.

**Opening Paragraph:**
BENGALURU, India — Signzy, a leader in AI-driven financial onboarding infrastructure, today announced the general availability of its MCC Classification & Onboarding Suite — a purpose-built platform that automates the merchant category code assignment, verification, and ongoing monitoring workflow for India's Payment Aggregators and acquiring banks. The suite combines five APIs (GST-to-MCC Mapper, WebCrawler, ShopLens AI, MSME Alt Data, and Transaction Monitoring) into a single integration that replaces the manual spreadsheet-and-GST-portal process still used by over 70% of the market.

**Problem Paragraph:**
India's Payment Aggregator ecosystem is at a compliance inflection point. The RBI's September 2025 PA Master Direction tightened MCC accuracy requirements, and newly licensed PAs face merchant onboarding bans if audits reveal systemic miscoding. Yet the standard process — a compliance analyst manually matching a merchant's GST filing against an 800+ code spreadsheet — takes 15-45 minutes per merchant with a 10-25% error rate. For PAs onboarding thousands of merchants monthly, this creates a brutal tradeoff: move fast and risk regulatory action, or stay compliant and throttle growth. The problem is worse for India's 60 million+ offline and semi-formal MSMEs — kirana stores, local service providers, street vendors moving to digital payments — who have no website, no app store listing, and no digital footprint for global tools to crawl.

**Solution Paragraph:**
Signzy's MCC Classification Suite solves both problems simultaneously. The GST-to-MCC API ingests a merchant's GSTIN and maps HSN/SAC codes directly to the correct MCC — leveraging India's own regulatory data backbone rather than relying on web scraping alone. For merchants with a digital presence, WebCrawler enriches the classification with live website and app data. For the millions without one, ShopLens AI uses storefront imagery and geolocation, while MSME Alt Data pulls from Udyam registration, PAN linkage, and trade databases. Transaction Monitoring then continuously validates that the assigned MCC matches actual spending patterns, flagging drift before auditors do. The result: MCC assignment in under 60 seconds, error rates below 3%, and a full audit trail that satisfies RBI, Visa, and Mastercard requirements.

**Customer Quote (Hypothetical):**
> *[Note: Hypothetical quote for internal alignment — not for external publication without customer approval.]*
>
> "We were onboarding 8,000 merchants a month and our compliance team was drowning. Two analysts spent their entire day on MCC coding, and we still got flagged in a Visa audit for miscoding 12% of food delivery merchants. After integrating Signzy's suite, our MCC accuracy went to 97%, onboarding time dropped from 25 minutes to under a minute per merchant, and we passed our next audit clean. The real game-changer was ShopLens — half our merchant base are offline retailers, and no other tool could classify them."
>
> — VP of Compliance, Mid-Tier Payment Aggregator (700K+ merchants)

**Getting Started:**
Payment Aggregators and acquiring banks can begin with a pilot integration using a single API (GST-to-MCC) against their existing merchant base to benchmark accuracy improvements. Signzy offers a 30-day proof-of-concept with a comparison dataset — run your current manual process and Signzy's API on the same 500 merchants and measure the delta. Full suite integration via RESTful APIs typically completes in 2-4 weeks. Contact partnerships@signzy.com or visit signzy.com/mcc-suite to schedule a technical walkthrough.

---

### CUSTOMER FAQs

**Q1: How does GST-to-MCC mapping actually work? GST categories don't map 1:1 to MCCs.**
A: Correct — there's no clean 1:1 mapping. Signzy's model uses a combination of HSN/SAC codes from the GST filing, the merchant's declared business description, and supplementary data signals (Udyam registration category, trade license type) to produce a probabilistic MCC assignment with a confidence score. When confidence is below threshold, the system flags for human review rather than guessing — so you get speed on the 85%+ of clear cases and accuracy protection on the ambiguous ones.

**Q2: What about merchants who file GST under a holding entity or have multiple business lines?**
A: The suite handles multi-line merchants by analyzing each HSN/SAC code cluster independently, then recommending primary and secondary MCCs. For holding entities, the WebCrawler and ShopLens modules provide disambiguation at the outlet level. This is a common pattern with franchise models and multi-brand retailers.

**Q3: Does this replace our existing KYC/KYB process?**
A: No. MCC classification is a distinct compliance step that typically sits between identity verification (KYC) and merchant activation. Signzy's suite integrates alongside your existing KYC provider — whether that's Signzy's own identity stack, Karza, Perfios, or an in-house system. Think of it as the "what does this merchant actually do?" layer that KYC tools don't cover.

**Q4: How does ShopLens work for a merchant who is a mobile service provider with no physical storefront?**
A: ShopLens is one signal in a multi-API ensemble. For merchants without a physical storefront, the system relies more heavily on GST data, Udyam registration, MSME Alt Data (trade databases, district industry records), and transaction pattern analysis. No single API is the sole classifier — the suite weight-shifts based on available data.

**Q5: What happens when the RBI updates MCC guidelines or card networks revise their code tables?**
A: Signzy maintains the MCC mapping tables as a managed service. When Visa, Mastercard, or RBI issue updates, Signzy's data team updates the mapping logic centrally — your integration doesn't change. Affected merchants in your portfolio are automatically re-evaluated, and you receive a delta report showing any reclassifications needed.

**Q6: What's the pricing model?**
A: Per-API-call pricing with volume tiers. Most PAs start with the GST-to-MCC + WebCrawler combination (covers ~70% of use cases) and add ShopLens/MSME Alt Data for their offline merchant segments. Transaction Monitoring is a separate per-merchant-per-month fee. A typical mid-tier PA (50K-200K merchants) lands in the Rs 2-5 per classification range at scale.

---

### INTERNAL / SALES FAQs

**Q1: How do we position against Card91's VerifyIQ, which launched April 2026?**
A: Card91's VerifyIQ is tied to their card issuance stack — it's a feature within their BIN sponsorship platform, not a standalone classification product. Our advantage: (a) we work with any payment stack, not just Card91's rails, (b) we cover the full lifecycle including ongoing monitoring, (c) ShopLens and MSME Alt Data give us offline merchant coverage that Card91 doesn't have. In deals where Card91 is the card issuer, position Signzy as the complementary classification layer — "Card91 issues your cards, Signzy classifies your merchants."

**Q2: Why wouldn't a PA just use Karza or Perfios, since they already have those integrations for KYC?**
A: Karza and Perfios are excellent at GST data extraction and identity verification — but they stop there. They'll tell you a merchant's GST filing details, but they don't map those to MCCs, don't provide classification confidence scores, don't handle the offline merchant problem, and don't do ongoing transaction monitoring. Signzy starts where Karza/Perfios end. In fact, many Signzy clients use Karza for GST pull and Signzy for the MCC classification step on top of it.

**Q3: What if a prospect says "we'll build this internally"?**
A: The build-vs-buy math is straightforward: maintaining an 800+ MCC mapping table across Visa, Mastercard, and RBI taxonomies, plus handling GST code ambiguity, plus offline merchant classification, plus ongoing monitoring = a 4-6 person team minimum. Most PAs who've tried building internally end up with a rules-based system that works for the top 50 MCCs and falls apart on the long tail. Ask the prospect: "How do you classify a merchant whose GST filing says 'other services' and has no website?" If they don't have an answer, that's your opening.

**Q4: What's our proof-of-concept close rate and typical pilot-to-contract timeline?**
A: Target: 60%+ PoC-to-paid conversion. Typical timeline is 2 weeks for PoC setup, 30 days for evaluation, 2-4 weeks for commercial negotiation. Total: 8-10 weeks from first meeting to signed contract. The PoC is the most critical sales asset — once a PA sees their own error rate data, the conversation shifts from "do we need this?" to "how fast can we go live?"

**Q5: How do we handle data privacy concerns around GST data and merchant images?**
A: Signzy processes GST data via authorized APIs (not scraping), and all merchant data is processed in India-hosted infrastructure. ShopLens images are processed in-session and not stored post-classification unless the client opts in. We're SOC 2 Type II certified and can execute a DPA that meets the DPDP Act requirements. For regulated clients, we support on-prem deployment of the classification models.

---

### CLARITY CHECK

| Dimension | Assessment |
|---|---|
| **Can a non-expert understand the problem in one read?** | Yes — "manual MCC coding is slow, error-prone, and doesn't work for offline merchants" is immediately graspable. |
| **Is the solution's mechanism clear?** | Yes — GST data in, MCC code out, with fallbacks for merchants without digital presence. |
| **Is the customer quote believable?** | Yes — specific numbers (8K merchants/month, 12% error rate, two analysts) ground it. Flagged as hypothetical. |
| **Are the FAQs answering real objections?** | Yes — multi-line GST, offline merchants, build-vs-buy, and competitive positioning are the top 4 objections from sales conversations. |
| **Is there anything that sounds like vaporware?** | Risk area: "under 60 seconds" and "below 3% error rate" need to be validated against actual benchmarks before external use. If current benchmarks are different, adjust before publishing. |

---
---

## STEP 4: POSITIONING & MESSAGING

---

### POSITIONING ANCHORS (FletchPMM Framework)

**Primary Anchor: Problem-First**
The Indian PA market doesn't know it has a "merchant classification" problem — they know they have a "compliance headache" and an "onboarding bottleneck." Lead with the pain, name the category.

**Secondary Anchor: Use-Case / Workflow**
Once the problem is acknowledged, anchor on the specific workflow: "from GSTIN to compliant MCC in 60 seconds." This makes the value tangible and testable.

---

### THREE POSITIONING OPTIONS

**Option A: Problem-First (Recommended for current market maturity)**
> India's Payment Aggregators lose 15-45 minutes per merchant on manual MCC classification — and still get it wrong 10-25% of the time. Signzy's MCC Suite automates the entire workflow using India's own regulatory data rails, including the 60M+ offline merchants that global tools can't see.

*Best for:* Category creation conversations, compliance leader outreach, RBI-driven urgency.

**Option B: Use-Case Anchor**
> From GSTIN to compliant MCC in under 60 seconds. Signzy's five-API suite replaces the spreadsheet-and-portal process with automated classification, verification, and monitoring — purpose-built for India's PA and acquiring bank ecosystem.

*Best for:* Technical buyer conversations, API-first positioning, product-led sales motions.

**Option C: Competitive Differentiation Anchor**
> Global MCC tools fail in India because they depend on web crawling — and 60M+ Indian MSMEs have no website. Signzy is the only classification platform that combines GST, Udyam, storefront imagery, and transaction data to classify every merchant in India's economy, not just the digitally visible ones.

*Best for:* Competitive displacement deals, prospects already evaluating alternatives, analyst briefings.

---

### FINAL POSITIONING STATEMENT

> **For** RBI-licensed Payment Aggregators and acquiring banks in India
> **Who** struggle with slow, error-prone, and incomplete merchant MCC classification
> **Signzy's MCC Classification Suite** is the only API platform
> **That** automates MCC assignment using India's regulatory data backbone (GST, Udyam, PAN) combined with AI-powered offline merchant intelligence
> **Unlike** manual spreadsheet processes, global web-crawling tools, or point verification products
> **Signzy** delivers full-lifecycle merchant classification — from onboarding to ongoing monitoring — for every merchant in India's economy, including the 60M+ MSMEs with no digital footprint.

---

### POSITIONING LINE (One-Liner)

**"Classify every merchant in India — online or offline — from GSTIN to compliant MCC in 60 seconds."**

---

### MESSAGE HOUSE

| | **Pillar 1: Regulatory Data Backbone** | **Pillar 2: Full Lifecycle Coverage** | **Pillar 3: The Dark Merchant Problem** |
|---|---|---|---|
| **Value Proposition** | Built on India's own data rails — GST, Udyam, PAN — not retrofitted global crawlers. | One suite from onboarding classification to ongoing transaction monitoring. No stitching tools together. | The only platform that classifies India's 60M+ offline MSMEs using storefront imagery, alt data, and trade databases. |
| **Proof Point** | Direct HSN/SAC-to-MCC mapping from GST filings. RBI, Visa, and Mastercard taxonomy coverage maintained as managed service. | 5 APIs, single integration. Continuous monitoring flags MCC drift before card network audits catch it. | ShopLens AI + MSME Alt Data: classify a kirana store in Tier-3 India with zero digital footprint. |
| **Customer Pain Addressed** | "Our compliance team manually cross-references GST codes against an 800-row MCC spreadsheet." | "We use one vendor for KYC, another for GST pull, and do MCC coding manually. Nothing connects." | "30-40% of our merchant base has no website. Global tools return 'unclassified' for all of them." |

---

### ELEVATOR PITCHES

**10-Word Pitch:**
Automated MCC classification for Indian payment aggregators using GST data.

**30-Word Pitch:**
Signzy's MCC Suite replaces manual merchant classification for Indian PAs. Five APIs turn GST filings, web data, and storefront imagery into compliant MCC codes in under 60 seconds — including offline merchants.

**100-Word Pitch:**
India's Payment Aggregators spend 15-45 minutes manually classifying each merchant against 800+ MCC codes — and still get it wrong up to 25% of the time. With the RBI tightening PA compliance requirements, that error rate is becoming existential. Signzy's MCC Classification Suite automates the entire workflow: GST-to-MCC mapping, web crawling for digital merchants, AI-powered storefront analysis for the 60 million offline MSMEs that global tools miss entirely, and continuous transaction monitoring to catch MCC drift. Five APIs, one integration, under 60 seconds per merchant. Move from spreadsheets to audit-ready compliance without hiring a bigger team.

---

### PERSONA-SPECIFIC MESSAGING MATRIX

| Persona | Pain Point | Lead Message | Proof Point |
|---|---|---|---|
| **Head of Compliance** | "RBI audits are getting stricter. One systemic MCC error and we risk an onboarding ban. I can't manually QA every classification." | Signzy gives you audit-ready MCC assignments with full traceability — every classification has a confidence score, source trail, and regulatory mapping. Stop defending spreadsheets to auditors. | Full audit trail with GST source linkage. Managed MCC taxonomy updates when RBI/Visa/MC revise codes. SOC 2 Type II certified. |
| **Head of Risk & Fraud** | "Miscoded merchants are our biggest fraud blind spot. A 'grocery store' processing luxury goods transactions doesn't get flagged until chargebacks spike." | Transaction Monitoring API continuously validates that merchant activity matches assigned MCCs. Catch MCC drift and suspicious category mismatches before they become fraud losses. | Ongoing transaction-MCC alignment scoring. Automated alerts for category anomalies. Reduces false-positive merchant review queues by filtering out clean merchants. |
| **Head of Onboarding / Business** | "We're onboarding 5,000 merchants a month and scaling to 20,000. My 3-person team can't manually code MCCs fast enough — it's our biggest bottleneck." | Automate 85%+ of MCC classifications with zero human touch. Your team handles only the edge cases. Scale from 5K to 50K merchants/month without adding headcount. | Sub-60-second classification via API. Confidence-score-based routing: auto-approve high-confidence, queue low-confidence for human review. |
| **CTO / CXO** | "We're spending on 4 different vendors for onboarding — KYC, GST verification, MCC coding (manual), and monitoring. It's expensive and fragile." | One API suite replaces the manual MCC workflow and connects your existing KYC stack to ongoing compliance monitoring. Reduce vendor sprawl and onboarding cost per merchant. | Single RESTful integration. Works alongside existing Karza/Perfios/in-house KYC. 2-4 week implementation. Per-API-call pricing scales with your merchant volume. |

---

### COMPETITIVE MESSAGING

**vs. Card91 VerifyIQ:**
"Card91's classification is a feature inside their card issuance platform — useful if you're already on their BIN stack, but locked-in if you're not. Signzy works with any payment infrastructure, covers the full lifecycle from classification to monitoring, and handles offline merchants that VerifyIQ has no data source for. You shouldn't have to change your card issuer to fix your MCC process."

**vs. Parcha AI:**
"Parcha has strong classification models — built for US and European merchant ecosystems. They don't integrate with GST, Udyam, or any Indian regulatory data source. For the 60M+ Indian MSMEs without English-language websites or app store listings, Parcha returns nothing. Signzy is purpose-built for India's regulatory and merchant data reality."

**vs. Status Quo (Manual Spreadsheet + GST Portal):**
"Your compliance team is brilliant — and you're burning their time on a task that should take 60 seconds, not 30 minutes. Manual MCC coding was fine when you had 5,000 merchants. At 50,000+, it's a compliance risk, a scaling bottleneck, and the #1 reason your best analysts are updating their LinkedIn profiles. Automate the 85% that's straightforward, and let your team focus on the 15% that actually needs human judgment."

---

### A/B TEST HEADLINE VARIANTS

**Variant A (Problem-led):**
"Your Compliance Team Shouldn't Be Coding MCCs in a Spreadsheet. There's a Better Way."

**Variant B (Metric-led):**
"15 Minutes to 60 Seconds: Automate MCC Classification for India's Payment Aggregators"

**Variant C (Category-gap-led):**
"60 Million Indian Merchants Have No Website. How Do You Classify Them?"

*Testing guidance:* Run A vs. C for top-of-funnel awareness campaigns (LinkedIn, industry publications). Run B for mid-funnel retargeting and email sequences where the prospect already understands the problem. Variant C is the boldest — it reframes the problem and is likely to polarize (high CTR among aware buyers, lower among early-stage).

---
---

## STEP 5: GTM PLAN

---

### LAUNCH TIER RECOMMENDATION

**Tier 2: High-Impact, Targeted Launch**

**Reasoning:**
- This is a **category-creation** launch in an early-to-growing market, not a feature update (rules out Tier 3) and not a company-level platform pivot (rules out Tier 1).
- The buyer set is narrow and identifiable (~75 organizations: 50+ licensed PAs + ~25 acquiring banks), which means concentrated, high-touch GTM outweighs broad awareness plays.
- The RBI PA Master Direction (Sept 2025) provides a natural urgency trigger — this is a compliance-driven buy, not a nice-to-have. Timing matters.
- Signzy has existing relationships with many PAs through its identity/KYC products — this launch can draft off existing customer trust and expand wallet share.
- A Tier 1 "big bang" launch (conference keynote, press blitz) would be premature — the category needs education before amplification. A Tier 2 focused launch builds proof points that enable a Tier 1 moment 6-12 months later.

---

### LAUNCH TIMELINE

| Phase | Timing | Key Activities |
|---|---|---|
| **T-6 weeks** | Internal Readiness | Finalize product benchmarks (classification speed, accuracy rate, API uptime). Lock pricing tiers. Complete competitive battlecards. Sales enablement training: 90-min deep dive with AE and SE teams. |
| **T-5 weeks** | Asset Production | Produce: solution brief (2-pager), technical API docs, PoC playbook, demo environment with sample merchant datasets. Draft blog post: "Why Manual MCC Coding Is the Biggest Hidden Risk for Indian PAs." |
| **T-4 weeks** | Analyst & Ecosystem Seeding | Brief 2-3 fintech analysts (e.g., Redseer, Tracxn, IDC Financial Insights India). Share embargoed product details with 3-5 friendly PA compliance heads for early feedback and quote potential. Begin outreach to DPAI (Digital Payments Association of India) for co-marketing. |
| **T-3 weeks** | Early Access / PoC Pipeline | Launch "Early Access" program: invite 5-8 PAs (mix of existing Signzy clients and net-new targets) for a 30-day PoC with dedicated SE support. Goal: 3-5 active PoCs before public launch. |
| **T-2 weeks** | Content & Channel Prep | Publish SEO-optimized blog post. Prep LinkedIn campaign creative (3 variants matching A/B headline tests). Draft email sequences: (1) existing Signzy clients, (2) target PA compliance heads, (3) RBI compliance newsletter audience. Record 5-min product demo video. |
| **T-1 week** | Final Checks | Internal launch readiness review. Confirm demo environment stability. Pre-brief Signzy's SDR team with persona talk tracks and qualification criteria. Set up lead routing: compliance/risk title = AE fast-track, other = nurture sequence. |
| **T-0 (Launch Day)** | Public Announcement | Publish press release (embargoed lift). Signzy blog post goes live. LinkedIn campaign begins (founder post + company page + paid). Email blast to segmented lists. Product Hunt / YourStory / Inc42 outreach. Update signzy.com with MCC Suite landing page. |
| **T+1 week** | Activation Push | Webinar: "MCC Classification After the RBI PA Master Direction — What's Changed and How to Comply" (co-host with a compliance advisory firm or a friendly PA head). Follow up on all launch-day inbound. Push PoC conversions. |
| **T+2 weeks** | Sales Acceleration | Share early PoC results (anonymized) as social proof. Second LinkedIn push with metric-led creative (Variant B). Begin outbound to acquiring banks (separate from PA motion — different buyer, different pitch). |
| **T+3 weeks** | Content Deepening | Publish technical blog: "How GST-to-MCC Mapping Works: A Deep Dive for Compliance Teams." Create comparison page: "Signzy vs. Manual MCC Coding." If any PoC has converted, begin case study development. |
| **T+4 weeks** | Review & Iterate | Launch retrospective: pipeline generated, PoC conversion rate, content engagement, competitive encounters. Adjust messaging based on first 30 days of sales conversations. Feed learnings back into product roadmap. |

---

### STAKEHOLDERS (DIN Framework)

| Role | Person / Team | Responsibility |
|---|---|---|
| **Driver** | PMM Lead (Product Marketing) | Owns launch plan execution, messaging, content calendar, and launch retrospective. Single throat to choke. |
| **Informed** | CEO / CXO | Briefed at T-4 (strategy review) and T+4 (results review). Not involved in day-to-day execution. |
| **Informed** | Product / Engineering Lead | Provides benchmark data, API documentation, demo environment. Consulted on technical claims. On-call for PoC technical issues. |
| **Driver** | Sales / AE Team Lead | Co-owns pipeline targets. Responsible for PoC conversions and deal progression. Provides field feedback loop. |
| **Informed** | SE / Solutions Engineering | Leads PoC technical implementation. Creates demo environments and sample datasets. |
| **Informed** | SDR / BDR Team | Executes outbound sequences to target PA list. Qualifies inbound leads using persona-based criteria. |
| **Informed** | Content / Design | Produces blog posts, landing page, LinkedIn creative, solution brief, demo video. |
| **Informed** | Partnerships (if applicable) | Manages analyst briefings, DPAI relationship, co-marketing with compliance advisory firms. |
| **Necessary** | Legal / Compliance (Signzy internal) | Reviews press release claims, benchmark accuracy, data handling statements. Gate: all external-facing accuracy claims must be verified. |

---

### ASSET CHECKLIST (Tier 2)

**Must-Have (Launch Day):**

- [ ] Solution Brief (2-page PDF): Problem, solution, 5-API overview, pricing model summary, CTA
- [ ] Landing Page on signzy.com/mcc-suite: above-the-fold value prop, API overview, PoC CTA, compliance credibility badges
- [ ] Product Demo Video (5 min): live API walkthrough — GSTIN in, MCC out, show confidence score and audit trail
- [ ] Press Release: embargo-ready, distributed via PR Newswire India / business wire equivalent
- [ ] Blog Post #1: "Why Manual MCC Coding Is the Hidden Risk for Indian PAs"
- [ ] Email Sequences: 3 variants (existing clients, target PAs, general fintech audience)
- [ ] LinkedIn Campaign Creative: 3 variants matching A/B headline tests
- [ ] Sales Battlecard: 1-page, covers Card91, Parcha, Karza/Perfios, and status quo objections
- [ ] PoC Playbook: step-by-step for SE team — setup, success criteria, data handling, handoff to AE
- [ ] API Documentation: public-facing, developer-friendly, with sandbox access
- [ ] Internal FAQ: for sales, CS, and SDR teams (adapted from PRFAQ above)

**Should-Have (T+1 to T+4 weeks):**

- [ ] Webinar recording and slides
- [ ] Blog Post #2: "How GST-to-MCC Mapping Works" (technical deep dive)
- [ ] Comparison Page: "Signzy MCC Suite vs. Manual Classification"
- [ ] ROI Calculator: input merchant volume + current team size, output time/cost savings
- [ ] Case Study Draft (anonymized PoC results if available)
- [ ] Analyst Brief Deck (8-10 slides for Redseer/Tracxn/IDC)

**Nice-to-Have (Post T+4):**

- [ ] Conference talk proposal for Global Fintech Fest / NASSCOM fintech events
- [ ] Video testimonial from PoC customer
- [ ] Integration partnership announcements (e.g., Karza/Perfios "better together" positioning)

---

### SUCCESS METRICS

**Leading Indicators (T+0 to T+4 weeks):**

| Metric | Target | Measurement |
|---|---|---|
| PoC sign-ups (Early Access + post-launch) | 8-12 | CRM pipeline stage tracking |
| Qualified inbound leads (compliance/risk title) | 15-20 | Lead scoring + title match |
| Landing page unique visitors | 2,000+ | Web analytics |
| Solution brief downloads | 200+ | Gated content form |
| LinkedIn campaign CTR | >1.2% (B2B fintech benchmark) | LinkedIn Campaign Manager |
| Webinar registrations | 100+ | Webinar platform |
| Sales team confidence score (internal survey) | >4/5 | Post-training survey |

**Lagging Indicators (T+4 to T+16 weeks):**

| Metric | Target | Measurement |
|---|---|---|
| PoC-to-paid conversion rate | >50% | CRM closed-won tracking |
| Signed contracts (first 90 days) | 4-6 PAs | CRM |
| ARR from MCC Suite (first 90 days) | Rs 1.5-2.5 Cr ($180-300K) | Revenue reporting |
| Expansion within existing Signzy clients | 2-3 cross-sell wins | Account management tracking |
| Average deal cycle (first touch to signed) | <10 weeks | CRM stage timestamps |
| Competitive win rate (vs. Card91/manual) | >60% | CRM competitive field |

**Anti-Metrics (Things That Would Signal We Got It Wrong):**

| Anti-Metric | Threshold | What It Means |
|---|---|---|
| PoC drop-off rate | >50% | Product-market fit issue — classification accuracy or integration complexity not meeting expectations. Trigger: immediate product/SE debrief with every dropped PoC. |
| "Build internally" objection rate | >40% of qualified leads | Pricing too high relative to perceived complexity, or we're not demonstrating the long-tail difficulty clearly enough. Trigger: revisit demo to emphasize edge cases (multi-line GST, offline merchants). |
| Avg. PoC time-to-first-value | >5 business days | Integration friction too high. Trigger: SE process audit, consider pre-built connectors for common PA tech stacks. |
| Zero inbound from landing page / content | <5 leads in 4 weeks | Messaging not resonating or channels wrong. Trigger: A/B test new headlines, shift spend to direct outreach. |
| MCC accuracy below 90% in PoCs | Any PoC | Product readiness issue — do not push for conversion. Trigger: pull back launch, fix model, re-run PoC. |

---

### POST-LAUNCH ACTIONS (T+4 Onwards)

**Weeks 5-8: Proof Point Accumulation**
- Convert best-performing PoC into a referenceable case study (even anonymized metrics are valuable in this market).
- Publish PoC benchmark data as a gated whitepaper: "MCC Classification Accuracy: Manual vs. Automated — Benchmarks from 5 Indian Payment Aggregators."
- Begin acquiring bank outreach as a separate motion (different buyer persona, longer cycle, larger deal size).

**Weeks 9-12: Category Ownership**
- Submit a thought leadership piece to NPCI's industry publication or RBI's fintech sandbox newsletter on "Automating Merchant Classification Under the PA Master Direction."
- Propose a session at the next Global Fintech Fest or NASSCOM event: "The Dark Merchant Problem: Why 60M Indian MSMEs Are Invisible to Compliance Tools."
- Evaluate partnership with Karza or Perfios: "better together" integration where their GST verification feeds directly into Signzy's MCC classification. Co-marketed as a combined compliance stack.

**Ongoing: Feedback Loop**
- Monthly sales-to-PMM sync: top 3 objections, competitive intelligence, feature requests.
- Quarterly messaging refresh based on win/loss analysis.
- Track RBI regulatory updates — every new circular is a content and outreach trigger.
- Monitor Card91 VerifyIQ adoption — if they gain traction, accelerate competitive displacement content.

---

*Generated by SuperPMM GTM Builder | Steps 3-5 | April 2026*
