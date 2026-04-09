# AWS IAM (Cheat Sheet)

Identity and Access Management: users, roles, policies, and permissions boundaries.

## Core concepts

- **Principal**: user/role/service that makes an API call
- **Policy**: JSON allow/deny statements (identity- or resource-based)
- **Role**: assumed identity (recommended for workloads)
- **STS**: temporary credentials when assuming roles

## Practical patterns

- Human access via SSO/Identity Center + roles (avoid long-lived IAM users)
- Workloads use roles (EC2 instance profile, ECS task role, Lambda execution role)
- Use least privilege + explicit denies for guardrails

## Common operational gotchas

- “Access denied” can be: missing allow, explicit deny, SCP, permissions boundary
- Wildcards (`*`) are tempting; scope by resource ARNs where feasible
- Cross-account access needs both: trust policy + permission policy

