# VPN Concepts Cheat Sheet

VPNs provide secure connectivity over untrusted networks.

## Common VPN types

- **Site-to-site VPN**: connects networks (office <-> cloud VPC/VNet)
- **Client VPN**: connects a user device to a network

## Split tunnel vs full tunnel

- **Full tunnel**: all traffic goes through VPN (strong control, can impact performance)
- **Split tunnel**: only selected routes go through VPN (better performance, more risk)

## Common failure modes

- DNS issues (wrong resolver, split-horizon conflicts)
- Route overlap (home network overlaps corporate network)
- MTU issues (tunnels add overhead)
- Auth failures (certs, MFA, expired tokens)

## Troubleshooting checklist

- Confirm routes installed by the VPN client
- Confirm DNS settings while connected
- Check for overlapping CIDRs
- Reduce MTU to test if fragmentation is the issue

