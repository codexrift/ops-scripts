# AWS ACM (Cheat Sheet)

AWS Certificate Manager: request, validate, and deploy TLS certificates for AWS services.

## Core concepts

- **Public certs** for internet-facing endpoints (managed renewal)
- **Private CA** (ACM PCA) for internal PKI (separate service/cost)
- Validation: **DNS** is preferred over email for automation

## Where certificates are used

- ALB/NLB TLS listeners
- CloudFront distributions
- API Gateway custom domains

## Common operational gotchas

- Certificates are region-scoped (CloudFront uses us-east-1 for ACM public certs)
- DNS validation requires control of the zone and correct CNAME records

