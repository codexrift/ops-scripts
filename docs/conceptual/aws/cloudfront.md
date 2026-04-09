# AWS CloudFront (Cheat Sheet)

CDN for caching and delivering content with low latency.

## Core concepts

- **Distribution**: CDN configuration
- **Origin**: S3, ALB, or custom HTTP(S) origin
- **Cache behaviors**: path-based rules for TTL, headers, methods

## Security

- TLS via ACM (public cert in `us-east-1` for CloudFront)
- Use signed URLs/cookies for restricted content
- Integrate with WAF for L7 protections

## Common operational gotchas

- Caching rules (headers/cookies/query strings) can cause unexpected cache misses
- Invalidation is slower/costly; use versioned asset names for deploys

