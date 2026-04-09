# AWS WAF (Cheat Sheet)

Web Application Firewall: protect HTTP(S) apps from common attacks.

## Core concepts

- **Web ACL**: set of rules (managed or custom)
- **Rule groups**: reusable bundles (AWS Managed Rules are a good baseline)
- Attach points: ALB, API Gateway, CloudFront (depends on architecture)

## Practical notes

- Start with managed rules + logging, then tune to reduce false positives
- Add rate-based rules for basic DDoS/bot mitigation

## Common operational gotchas

- Overly strict rules can block legitimate traffic; monitor before enforce
- CloudFront vs regional WAF scope differs; attach in the right place

