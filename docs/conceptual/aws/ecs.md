# AWS ECS (Cheat Sheet)

Elastic Container Service: run containers as tasks/services on EC2 or Fargate.

## Core concepts

- **Cluster**: logical grouping of capacity (EC2 or Fargate)
- **Task definition**: container specs (image, CPU/mem, env, secrets, IAM role)
- **Service**: desired count + deployment controller + optional load balancer
- **Task role vs execution role**: app permissions vs pull/logging permissions

## Networking

- `awsvpc` network mode gives each task its own ENI (common with Fargate)
- Use private subnets + ALB/NLB for ingress

## Common operational gotchas

- Image pull failures (ECR auth/execution role) look like “task stopped”
- Health checks + deployment circuit breaker can cause churn
- Capacity providers / scaling policies should match workload behavior

