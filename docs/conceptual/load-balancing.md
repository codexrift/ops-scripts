# Load Balancing Concepts Cheat Sheet

Load balancers distribute traffic across multiple backends.

## L4 vs L7

- **Layer 4**: TCP/UDP forwarding (IP:port level), faster, less app-aware.
- **Layer 7**: HTTP-aware (hosts, paths, headers), supports advanced routing and auth.

## Health checks

Health checks decide which backends are eligible:

- TCP connect check
- HTTP GET `/healthz`
- Custom checks

Common pitfalls:

- Health check path requires auth
- Health check succeeds but app is degraded (check is too weak)

## Common features

- TLS termination
- Sticky sessions (session affinity)
- Connection draining (graceful backend removal)
- Rate limiting / WAF (often adjacent)

