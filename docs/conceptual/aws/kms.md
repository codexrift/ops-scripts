# AWS KMS (Cheat Sheet)

Key Management Service: managed encryption keys and cryptographic operations.

## Core concepts

- **CMK / KMS key**: customer-managed key (rotation, policy)
- **Key policy**: primary authorization control for a KMS key
- **Grants**: delegated permissions for AWS services
- **Envelope encryption**: data key encrypted by KMS key

## Practical notes

- Choose KMS keys when you need audit/controls beyond SSE-S3 or service defaults
- Plan for cross-account use (key policy + grants)

## Common operational gotchas

- If key policy blocks admins, recovery is painful; keep break-glass access
- KMS calls are billable; high-QPS apps should use data keys appropriately
- Regional service: multi-region keys exist, but still require careful design

