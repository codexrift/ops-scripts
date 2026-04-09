# AWS EKS (Cheat Sheet)

Managed Kubernetes control plane with AWS-integrated node and networking options.

## Core concepts

- **Cluster**: control plane + API endpoint
- **Node groups**: managed worker nodes (or self-managed)
- **Fargate profiles**: serverless pods for certain namespaces/selectors
- **CNI**: pod networking (commonly VPC CNI)

## Access control

- IAM identity mapping (cluster auth) + Kubernetes RBAC
- Prefer SSO/Identity Center + roles for humans

## Common operational gotchas

- Cluster upgrades require testing across addons (CNI, CoreDNS, kube-proxy)
- Pod IP consumption can exhaust subnet CIDRs with VPC CNI
- “Works in dev” often differs due to IAM/RBAC and admission policies

