# AWS Secrets Manager (Cheat Sheet)

Managed secrets storage with optional rotation.

## Core concepts

- Secrets are versioned (staging labels like `AWSCURRENT`, `AWSPREVIOUS`)
- Access controlled via IAM and (optionally) resource policies
- Rotation uses Lambda (built-in templates for some engines)

## Practical patterns

- Prefer IAM auth / federation where possible; use secrets for what can’t be federated
- Separate secrets per environment and per application
- Use least privilege on `secretsmanager:GetSecretValue`

## Common operational gotchas

- Rotation can break apps if they cache credentials too long
- Don’t embed secrets in user data or container images
- Cross-account secrets require careful resource policies and KMS access

