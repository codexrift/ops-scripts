# AWS Systems Manager (SSM) (Cheat Sheet)

Fleet management for EC2 and hybrid servers: run commands, patch, inventory, and secure access.

## Core concepts

- **SSM Agent**: runs on instances/servers
- **Run Command**: execute commands at scale
- **Session Manager**: shell access without inbound SSH
- **Parameter Store**: configuration values (optionally encrypted with KMS)

## Practical patterns

- Prefer Session Manager over SSH/RDP for access paths
- Use Parameter Store for non-secret config; Secrets Manager for secrets

## Common operational gotchas

- Requires instance IAM role + network access to SSM endpoints (or VPC endpoints)
- Patching needs maintenance windows and reboots; plan downtime

