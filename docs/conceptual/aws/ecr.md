# AWS ECR (Cheat Sheet)

Elastic Container Registry: store and scan container images.

## Core concepts

- **Repository**: holds image manifests
- **Tag**: mutable label; use **digests** for immutability in prod
- **Lifecycle policies**: automatically prune old images

## Security

- IAM controls push/pull
- Enable scanning (basic/enhanced depending on account setup)

## Common operational gotchas

- Relying on `latest` makes rollbacks and reproducibility hard
- Cross-account pulls need repository policies + correct principals

