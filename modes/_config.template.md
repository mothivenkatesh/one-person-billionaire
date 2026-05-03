# AI SDR Agent — User Configuration

> Copy this to `_config.md` and customize. This file is YOURS — never overwritten by updates.
> Values here override defaults in `_shared.md`.

---

## Company Identity

```yaml
company_name: Sogolytics
product_names:
  - SogoCX (Customer Experience)
  - SogoEX (Employee Experience)
  - SogoCore (Survey Platform)
website: https://www.sogolytics.com
one_liner: "Experience management platform for enterprises"
```

## Outreach Voice

```yaml
tone: conversational-professional  # Options: conversational-professional, direct-executive, technical-peer
formality: medium                  # Options: low, medium, high
humor: none                        # Options: none, light, moderate
max_email_words: 150               # Per email variant
max_linkedin_words: 75             # Per LinkedIn message
```

## Vertical Priorities

```yaml
# Order determines processing priority when multiple accounts qualify
priority_verticals:
  - Technology
  - Banking & Finance
  - HR
  - Education
  - Hospitality
  - Travel & Aviation
  - Restaurants
  - Fitness
```

## Exclusions

```yaml
# Companies to never contact (domains)
excluded_domains:
  - competitor1.com
  - competitor2.com

# Job titles to skip
excluded_titles:
  - Intern
  - Junior
  - Assistant

# Companies already in active deals (skip to avoid SDR/AE conflict)
active_deal_domains: []
```

## Score Overrides

```yaml
# Override default score gates from _shared.md
min_score_full_pipeline: 4.0    # Default: 4.0
min_score_research_only: 3.0    # Default: 3.0
min_score_skip: 3.0             # Below this: auto-skip
```

## Smartlead Campaign Mapping

```yaml
# Map verticals to different Smartlead campaigns (optional)
# If not set, all go to the default campaign in .env
campaign_overrides:
  # Technology: 2626058
  # Banking & Finance: 2626059
```

## Custom Email Hooks

```yaml
# Add custom proof points per vertical for email generation
custom_proof_points:
  Technology:
    - "40% lift in survey response rates for SaaS companies"
    - "Integration with Salesforce and HubSpot in under 2 hours"
  Banking & Finance:
    - "SOC 2 Type II certified, GDPR compliant"
    - "Used by 3 of the top 20 regional banks"
```
