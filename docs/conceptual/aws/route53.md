# AWS Route 53 (Cheat Sheet)

DNS and domain management, plus health checks and routing policies.

## Core concepts

- **Hosted zone**: DNS namespace (public or private)
- **Record**: A/AAAA/CNAME/MX/TXT/NS/SRV etc.
- **Alias record**: AWS-specific record that targets AWS resources (no extra cost)
- **TTL**: caching duration (lower TTL = faster changes, more queries)

## Routing policies (high level)

- **Simple**: one record
- **Weighted**: gradual cutovers / canary
- **Latency**: route to lowest latency region
- **Failover**: primary/secondary with health checks
- **Geolocation/Geoproximity**: route by location

## Common operational gotchas

- DNS propagation is caching + TTL; plan migrations accordingly
- Private hosted zones only resolve from associated VPCs (and resolvers)
- Avoid “CNAME at apex”; use Alias instead for AWS targets

