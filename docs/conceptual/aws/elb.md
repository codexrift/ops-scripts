# AWS Elastic Load Balancing (ELB) (Cheat Sheet)

Managed load balancers to distribute traffic to targets in your VPC.

## Core concepts

- **ALB**: HTTP/HTTPS (L7), host/path routing, integrates with WAF
- **NLB**: TCP/UDP/TLS (L4), high performance, static IPs with EIPs
- **Target group**: registered instances/IPs/Lambda (ALB) and health checks

## TLS basics

- Terminate TLS at ALB/NLB (TLS listener) using ACM certificates
- Use end-to-end TLS to targets when needed (compliance / zero trust)

## Common operational gotchas

- Health checks are often the cause of “it’s down” (path, port, SG rules)
- Idle timeout (ALB) can break long-lived connections
- Cross-zone load balancing and target registration affect cost and behavior

