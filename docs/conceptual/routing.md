# Routing Concepts Cheat Sheet

Routing is how IP traffic moves between networks.

## Key terms

- **Route**: a destination prefix -> next hop/interface
- **Default route**: where to send "everything else" (typically `0.0.0.0/0`)
- **Next hop**: router/gateway IP to forward to
- **Metric / administrative distance**: preference when multiple routes exist
- **Asymmetric routing**: forward and return paths differ (can break stateful firewalls/NAT)

## Static vs dynamic routing

- **Static**: manually configured routes (simple, but manual upkeep)
- **Dynamic**: routing protocols (OSPF, BGP, etc.) exchange routes automatically

## Common routing failure modes

- Wrong default gateway on host
- Missing route on a router
- Overlapping CIDRs (ambiguous ownership)
- MTU/PMTUD issues appear like routing issues

## Quick mental checks

- Can you reach the next hop?
- Is there a return route?
- Are the source and destination in the expected subnets?

