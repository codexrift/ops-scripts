# NAT Concepts Cheat Sheet

NAT (Network Address Translation) rewrites IP addresses (and often ports).

## Common NAT types

- **SNAT** (source NAT): change source IP/port (typical for outbound internet)
- **DNAT** (destination NAT): change destination IP/port (port-forwarding)
- **PAT** (port address translation): many internal hosts share one public IP via different ports

## Where NAT usually happens

- Edge firewall/router
- Cloud NAT gateway
- Sometimes inside Kubernetes nodes or service meshes (implementation-specific)

## How NAT can break things

- Protocols that embed IPs in payload (unless helper/ALG fixes it)
- Inbound access without DNAT and firewall rules
- Asymmetric routing (return path bypasses NAT device)
- Port exhaustion (too many connections through one public IP)

## Troubleshooting checklist

- Confirm:
  - which device is doing NAT
  - which direction (SNAT, DNAT)
  - which translated IP/port you expect
- Check state tables / conntrack / session tables on the NAT device
- Verify return path symmetry (same device both ways)

