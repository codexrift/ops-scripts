# DHCP Concepts Cheat Sheet

DHCP automatically configures hosts with network settings.

## What DHCP typically provides

- IP address
- Subnet mask / prefix length
- Default gateway
- DNS servers
- DNS search domain(s)
- Lease time

## The DORA process (classic DHCPv4)

| Step | Message | Direction |
|---|---|---|
| D | Discover | Client -> broadcast (who has DHCP?) |
| O | Offer | Server -> client (here is an IP) |
| R | Request | Client -> server (I want this IP) |
| A | Acknowledge | Server -> client (lease granted) |

## Scopes, reservations, options

- **Scope**: a pool/range of addresses for a subnet.
- **Reservation**: pin a MAC (or client identifier) to a specific IP.
- **Options**: extra config (DNS servers, domain name, NTP, PXE, etc.).

## DHCP relay / IP helper

DHCP uses broadcasts that do not cross routers by default.
To serve DHCP across VLANs/subnets, you use:

- **DHCP relay** (often configured as `ip helper-address` on L3 interface/SVI)

## Common problems

- No DHCP server reachable (wrong VLAN, trunk issue, relay missing)
- Scope exhaustion (no free IPs)
- Wrong options (wrong DNS/gateway -> "network works but name resolution does not")
- Rogue DHCP server (clients get unexpected settings)
- Reservation mismatch (MAC changed, NIC teaming, VM vNIC changes)

## Troubleshooting checklist

- Verify client is in the right VLAN/subnet
- Verify L2/L3 reachability to the DHCP server or relay
- Verify scope has free addresses
- Verify the correct options (DNS, gateway)
- Compare a working host vs broken host settings

