# AWS CloudTrail (Cheat Sheet)

Audit log of AWS API activity (who did what, when, and from where).

## Core concepts

- **Management events**: control plane API calls (most audit use cases)
- **Data events**: high-volume events (e.g., S3 object-level) — enable selectively
- **Trail**: delivers events to S3/CloudWatch Logs

## Practical patterns

- Centralize trails into a security/audit account
- Alert on high-risk API calls (IAM changes, KMS key policy changes, etc.)

## Common operational gotchas

- If you don’t centralize and retain logs, incidents are harder to investigate
- Data events can be expensive; scope to critical buckets/resources

