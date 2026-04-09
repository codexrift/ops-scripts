# Firewalls Concepts Cheat Sheet

A firewall enforces network policy (what can talk to what).

## Stateless vs stateful

- **Stateless**: each packet evaluated independently.
- **Stateful**: tracks connections; return traffic is allowed if part of an established session.

## Common dimensions of rules

- Direction: ingress/egress
- Source/destination IP (or CIDR)
- Source/destination ports
- Protocol (TCP/UDP/ICMP)
- Interface/zone
- Action: allow/deny/reject + log

## Zones and segmentation

Many firewalls organize policy by zones (LAN, DMZ, WAN, VPN, etc.).
Default stance should be documented:

- Allow by exception (deny by default) is common for sensitive networks.

## Logging strategy

- Log denies at a controlled rate (avoid noisy logs).
- Log allows selectively for high-value paths.

## Common pitfalls

- Rule order issues (first match wins in many systems)
- Overbroad rules ("any any allow")
- Missing egress rules (outbound blocked)
- Asymmetric routing (stateful firewall sees only one direction)

