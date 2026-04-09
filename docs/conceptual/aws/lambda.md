# AWS Lambda (Cheat Sheet)

Serverless compute: run code on events without managing servers.

## Core concepts

- **Function**: code + config (runtime, memory, timeout)
- **Trigger**: event source (API Gateway, SQS, EventBridge, etc.)
- **Concurrency**: limits parallel executions; provisioned vs on-demand
- **IAM role**: execution role defines permissions

## Networking

- Default: no VPC attachment; VPC adds ENI management and cold-start impact
- For private resources (RDS, internal APIs), attach to private subnets + SGs

## Common operational gotchas

- Timeouts: design for retries and idempotency
- Event source retries can cause duplicates; use dedupe where needed
- Environment variables are not secrets; store secrets in Secrets Manager/SSM

