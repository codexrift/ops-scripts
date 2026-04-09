# BGP Concepts Cheat Sheet (high level)

BGP (Border Gateway Protocol) exchanges routes between autonomous systems (and is also used internally in many networks).

## Core ideas

- BGP is a **path-vector** protocol: routes carry attributes (AS_PATH, NEXT_HOP, etc.).
- Neighboring routers form **peering sessions** (usually TCP/179).

## Common attributes (simplified)

- **AS_PATH**: which ASes a route traversed (helps loop prevention)
- **NEXT_HOP**: where to forward traffic
- **LOCAL_PREF**: internal preference (higher wins)
- **MED**: hint to external neighbor (lower wins)
- **Communities**: tags used for policy

## Common issues

- Session down (TCP/179 blocked, auth mismatch, wrong source IP)
- Route not advertised (policy filters)
- Route flaps (instability)
- Wrong preference (traffic goes the wrong way)

## Operational notes

- BGP is powerful and easy to misconfigure; changes should be reviewed and staged.

