# Synthetic Developer ICP — Indian Payment Ecosystem

RAG-pipeline-ready dataset for building a synthetic developer persona to test landing pages, email copies, ad creatives, and sales talk tracks for Cashfree Payments.

## Dataset Summary

| Channel | Posts | Comments | Text | Unique Authors |
|---------|-------|----------|------|----------------|
| HackerNews | 326 | 17,460 | 6.0 MB | 8,608 |
| Reddit | 126 | 4,996 | 1.0 MB | 2,672 |
| Dev.to | 228 | 30 | 1.6 MB | ~228 |
| GitHub | 238+ | 500+ | 90 KB | N/A |
| Quora | 40+ | 100+ | ~80 KB | ~60 |
| **TOTAL** | **958+** | **23,086+** | **8.7 MB** | **11,280+** |

## Search Terms Covered

**Gateways:** Razorpay, Cashfree, PayU, PhonePe, Pine Labs, Easebuzz, CCAvenue, Instamojo, Juspay, BillDesk, Paytm, Stripe

**Payment Methods:** UPI, UPI autopay, eNACH, NACH mandate, netbanking, credit/debit cards, RuPay, BNPL, wallets

**Infrastructure:** Payment gateway, payout, auto collect, settlement, webhook, sandbox, payment split, subscription billing

**Identity/KYC:** KYC, eKYC, Aadhaar API, PAN verification, DigiLocker

**Regulatory:** RBI, NPCI, payment aggregator, PA licence

**Cross-border:** International payments, forex, Merchant of Record

## File Structure

```
synthetic-icp/
  cashfree-synthetic-developer-icp.md    # Persona framework (5 archetypes, 7 channels, simulation prompts)
  raw-data/
    hn_scraped_data_v2.json              # 326 HN threads with 17,460 comments (8.7 MB)
    reddit_scraped_data.json             # 126 Reddit threads with 4,996 comments (1.9 MB)
    devto_scraped_data_v2.json           # 228 Dev.to articles with full text (1.7 MB)
    github-sdk-issues-raw.md             # 88+ issues from Razorpay/Cashfree SDKs
    github-sdk-issues-expanded.md        # 150+ issues from PayU/PhonePe/Juspay/KYC repos
  scored-data/
    hn_scored.json                       # HN threads with engagement scores
    reddit_scored.json                   # Reddit threads with engagement scores
    devto_scored.json                    # Dev.to articles with engagement scores
```

## Engagement Scoring

Each post/thread has a platform-specific engagement score for RAG weighting.

**HackerNews:** `(points x 3) + (comments x 2) + (depth_bonus x 10)` x quality_multiplier

**Reddit:** `(ups x 1) + (comments x 3) + (avg_comment_ups x 2) + diversity_bonus + controversy_bonus` x quality_multiplier

**Dev.to:** `(reactions x 2) + (comments x 5) + depth_score + code_bonus + (reading_time x 0.5)`

## Usage

Feed the `scored-data/` JSONs into your RAG pipeline. Each entry contains:
- `engagement.final_score` — use for retrieval weighting
- `comments[]` — array of developer voices with author + full text
- `url` — source for citation

Generated: 2026-04-09
