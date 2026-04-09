# AWS API Gateway (Cheat Sheet)

Managed API front door for HTTP/REST (and WebSocket) endpoints.

## Core concepts

- **HTTP API**: simpler/cheaper, common for modern REST-ish APIs
- **REST API**: more features/legacy patterns
- **Authorizers**: JWT/Lambda/Cognito (depends on flavor)
- **Custom domain**: Route 53 + ACM certificate + base path mappings

## Integrations (common)

- Lambda
- Private backends via VPC link (for some configurations)

## Common operational gotchas

- CORS must be configured explicitly (and differs by API type)
- Throttling/quotas can surprise clients; set per-stage limits intentionally
- Logging and tracing need explicit enablement

