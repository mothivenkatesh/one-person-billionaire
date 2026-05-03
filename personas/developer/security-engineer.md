---
name: security-engineer
vertical: developer
seniority: senior | tech_lead | director
authority: gatekeeper | technical_evaluator
spear_products: [secure-id, payments-core]
common_titles:
  - "Security Engineer"
  - "Senior Security Engineer"
  - "Application Security Engineer"
  - "Head of Security"
  - "CISO"
  - "Chief Information Security Officer"
  - "VP Security"
  - "Director - Information Security"
common_companies: ["Indian fintech (BFSI-adjacent)", "Series B+ SaaS", "Lending platforms", "Insurance tech", "Healthcare tech", "Marketplaces handling PII"]
typical_focus: ["Vendor security review", "DPDP / GDPR compliance", "PCI / SOC2 / ISO27001", "Pen-testing"]
source: llm-wiki/wiki/concepts/dpdp-act.md
created: 2026-04-27
updated: 2026-04-27
status: stable
---

# Security Engineer — Indian Tech

## 1. Identity

The security-focused engineer at an Indian fintech / SaaS / insurance / lending platform who owns vendor-security review, application security, compliance certifications (PCI / SOC2 / ISO27001), and DPDP-compliance technical execution. 6-15 years experience, often ex-fintech-security OR ex-Big-4-cyber-consulting. Reports to CISO or Head of Security or VP Engineering. Owns the "can we let this vendor touch our data?" gate. Lives in security-scanning tools (Snyk / Veracode / Checkmarx) + SIEM (Splunk) + IaC scanners + penetration-test reports.

**Where you find them:** Nullcon India, BSides Mumbai/Bangalore/Delhi, DEFCON India, OWASP India chapters, India CISO Forum, FortyTwo Labs alumni, NULL community, secured-by-default communities, India InfoSec Slack.

**Where they don't hang:** sales-led events, marketing webinars, founder communities, generic SaaS conferences.

---

## 2. Top 3 pains (ranked by Mothi's security-engineer interviews)

1. **Vendor security review burden + vendor-supplied docs are weak.** Each new vendor = 40-80 hours of security review (SOC2 Type II, pen-test, threat-model, DPI, contracts). Most vendors send marketing PDFs instead of technical docs. **Cashfree wedge:** Cashfree security portal with: SOC2 Type II + pen-test summary + threat model + DPDP attestation + audit-log schemas — all in single trust-center URL.

2. **DPDP technical execution complexity.** DPDP Act enforcement requires consent-token rotation, data-residency proof, right-to-erasure workflows, breach-notification timing — most vendors haven't built these natively. **Cashfree wedge:** DPDP-native architecture from Day 1; consent-token API; right-to-erasure endpoint; breach-notification SLA.

3. **PCI scope expansion / contraction risk.** When a vendor handles card data poorly, PCI scope expands → annual PCI audit cost grows. **Cashfree wedge:** Cashfree as PCI Level 1 PSP keeps customer's PCI scope minimal (tokenization, no card data touches their systems).

**Security-engineer secondary pains:**
- API security (OAuth scopes, rate limit, IDOR risk)
- Webhook security (signing, replay-attack, mTLS)
- Encryption at rest + in transit specifics
- Key management (KMS rotation, vendor-managed vs customer-managed)
- Audit log completeness + tamper-evidence
- Insider-threat protections (vendor employee access to customer data)
- Penetration-test result transparency (vendor sharing their own pen-test)
- Breach-notification SLA
- Data localization (Indian region only)

---

## 3. Success metrics they own

- Number of security incidents (target: zero)
- Vendor security-review cycle time
- Compliance audit result (PCI / SOC2 / ISO27001 / DPDP)
- Pen-test finding count + remediation rate
- Mean Time To Patch (MTTP) for CVEs
- Vendor-risk-score distribution
- Privilege-access incident count

---

## 4. Decision criteria when evaluating Cashfree

Security engineers are gate-grade. Decision criteria:

1. **Trust center completeness (SOC2 + pen-test + threat model + DPDP)** (35%) — non-negotiable
2. **DPDP / PCI compliance posture** (25%)
3. **Webhook + API security depth** (20%)
4. **Audit log + tamper-evidence** (10%)
5. **Reference security engineers at peer companies** (10%)
6. **Pricing** (0%) — security gates don't open with discounts

**Cashfree wins them when:**
- Trust center URL with SOC2 Type II + pen-test summary + threat model + DPDP attestation in FIRST email
- Webhook security spec (HMAC signing, timestamp validation, replay-protection) shared upfront
- Sample audit-log JSON (with tamper-evidence) shared
- Cashfree security lead offered for direct call (security-engineer ↔ security-engineer)
- Recent pen-test result (not just "we did a pen-test")
- Peer security-engineer reference at fintech / BFSI

**Cashfree loses them when:**
- Trust center is marketing-flavored (no technical depth)
- "We're SOC2 compliant" without sharing the report
- DPDP details are vague
- Sales delegates security questions
- Cannot share recent pen-test or scope-of-test details
- Cashfree employee insider-threat controls unclear

---

## 5. Language that resonates / turns them off

### Resonates

- **Trust center URL upfront**: "trust.cashfree.com — SOC2 Type II report, AOC, recent pen-test summary, threat model, DPDP attestation, all in one"
- **Specific compliance citations**: "PCI DSS v4.0 Level 1; SOC2 Type II (last audit Dec 2025, Big-4 attested); ISO 27001 (recertified 2026); DPDP-Act-aligned"
- **Webhook security**: "HMAC-SHA256 signature in header `X-Cashfree-Signature`; timestamp validation 5min window; replay-attack protection via nonce; sample verification code in {language}"
- **Architecture specifics**: "AWS ap-south-1 (Mumbai) only; KMS-managed encryption; key rotation 90d; tokenization removes card data from your scope; sample data flow diagram"
- **Pen-test transparency**: "Recent pen-test by NetSPI (independent); summary findings + remediation status shared under NDA"
- **Insider-threat controls**: "Cashfree employee data access: just-in-time + auditable; sample audit-log; SOC2 control coverage"
- **Peer security-engineer voice**: "{Peer security engineer} at {fintech} approved Cashfree onto vendor panel in 6 weeks; happy to introduce"

### Turns them off

- "We're secure" without specifics
- Marketing PDFs instead of technical docs
- "SOC2 compliant" without sharing the report
- Sales rep handles security questions
- Vague pen-test ("we did one last year")
- Hand-waving on DPDP / PCI specifics
- US-centric framing without India-data-residency

---

## 6. Common objections + Cashfree-specific responses

| Objection | Cashfree response (specific, not generic) |
|---|---|
| **"Send your security questionnaire"** | Send completed CAIQ + SIG-Lite + custom-questionnaire-template all on Day 1. Don't make them ask twice. |
| **"DPDP technical implementation"** | Send DPDP architecture diagram + consent-token API spec + right-to-erasure endpoint + breach-notification SLA. Be specific. |
| **"Webhook security"** | Send HMAC verification spec + sample code + timestamp-validation logic + replay-protection mechanism. Don't summarize — show. |
| **"PCI scope concern"** | Send tokenization architecture diagram + AOC. Show how Cashfree keeps card data out of their environment. |
| **"Pen-test results"** | Share executive summary + scope-of-test under NDA. Offer security-engineer-to-security-engineer call to walk through findings + remediation. |
| **"Insider threat — Cashfree employee access"** | Send SOC2 control coverage on employee data access + just-in-time access architecture + audit-log sample. |
| **"Cashfree's security team — show me the org"** | Offer call with VP Security + Head of AppSec at Cashfree. Show real people, real expertise. |
| **"Breach notification SLA"** | "Notification within 24hr of confirmed breach; details aligned with DPDP Act §8(6); sample breach-notification template attached." |

---

## 7. When this persona is the buyer / when not

### When THIS persona IS the gatekeeper (every fintech / BFSI deal)

- All deals touching customer PII or payment data
- All fintech / BFSI / lending / insurance vendor decisions
- Vendor panel addition requires Security sign-off
- Annual vendor security re-reviews
- Compliance certification gating
- **Pattern:** Security engineer can VETO any deal but rarely champions; gate-grade

### When this persona is NOT the buyer (still must approve)

- Security engineer almost never the economic buyer
- They are the gate between Cashfree and the buyer
- **Pattern:** treat security engineer as a SEPARATE persona track; build security-specific outreach + content; never assume they'll auto-approve

---

## Cashfree-specific outreach hooks for this persona

| Hook angle | Example opener |
|---|---|
| Trust center upfront | "trust.cashfree.com — SOC2 Type II + pen-test + threat model + DPDP attestation in single URL. Cuts vendor-review time. {Peer security engineer at fintech} cleared us in 6 weeks." |
| DPDP technical spec | "DPDP technical implementation guide — consent-token API + right-to-erasure endpoint + breach-notification SLA. We've published a security-engineer-readiness checklist; want me to send?" |
| Webhook security | "Cashfree webhook security: HMAC-SHA256 + timestamp validation + replay-attack protection. Sample verification code in {language}. 20-min security walkthrough?" |
| PCI scope reduction | "Tokenization keeps card data out of your environment = PCI scope minimal. {Peer fintech} reduced PCI scope by 60% post-Cashfree migration." |
| Pen-test transparency | "Recent pen-test by NetSPI (independent); executive summary + scope under NDA. 30-min security-engineer-to-security-engineer call to walk through?" |
| Peer security reference | "{Peer security engineer at {fintech}} happy to share their Cashfree vendor-review playbook (including the hard questions). 30-min peer call?" |

---

## Anti-pattern outreach (DO NOT use with this persona)

- ❌ "We're secure" without proof
- ❌ Marketing PDFs as primary security doc
- ❌ Sales rep answering security questions
- ❌ Schedule a demo without trust center link
- ❌ "Best-in-class security" claims
- ❌ US/EU-centric compliance (SOC2-only) as primary proof for Indian customers
- ❌ Webinar invite
- ❌ Pricing-led pitch

---

## Channel + cadence preferences

| Channel | When | Cadence |
|---|---|---|
| Trust center URL (with personalized email) | First touch | 1 email + completed CAIQ attached |
| LinkedIn DM (peer security-engineer reference) | First touch | 1-2 messages, 7d apart |
| Cold email (DPDP + PCI angle) | Backup | 1 email + trust center link |
| Phone | After 2+ replies | Scheduled, security-engineer ↔ security-engineer |
| In-person | Nullcon / BSides / DEFCON India / OWASP | Annual+ |
| Security newsletter | Continuous | Quarterly DPDP + compliance updates |

**Volume cap:** 2 touches per quarter; security engineers are over-emailed and protective.

---

## Prior known instances

(populated by `cf-drive-transcript-extractor` from real calls; placeholder)

- `Vandana Verma @ Sonatype — Security Engineer + OWASP India`
- `Akash Mahajan @ Cloudsek — CEO + Security Engineer roots`
- `Sumit Siddharth @ NotSoSecure — Founder, fintech security advisory`

## Source

Primary: `llm-wiki/wiki/concepts/dpdp-act.md` + Mothi-conducted security-engineer interviews
Secondary: Nullcon / OWASP India panel signals + India InfoSec Slack
Continuous: `cf-drive-transcript-extractor` updates this file as real security-engineer calls accumulate
Adjacent: `llm-wiki/wiki/concepts/secure-id-platform-architecture.md` for technical security positioning
