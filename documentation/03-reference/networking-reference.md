---
title: "networking reference (layers, IP, DNS, ports, common commands)"
type: "reference"
owner: "u115478"
last_updated: "2026-04-28"
---

# networking reference (layers, IP, DNS, ports, common commands)

## Scope

- **In scope:** OSI/TCP-IP layers at a practical level, IPv4 basics, DNS basics, common troubleshooting commands.
- **Out of scope:** BGP/OSPF, VLAN design, packet captures deep dive, enterprise firewall rule design.

## Cheat sheet

### Layer mapping (practical)

| OSI | Name | Examples |
|---:|---|---|
| 7 | Application | HTTP(S), DNS, SSH |
| 6 | Presentation | TLS |
| 5 | Session | (often blended into apps) |
| 4 | Transport | TCP/UDP, ports |
| 3 | Network | IP, routing |
| 2 | Data link | Ethernet, Wi-Fi, MAC |
| 1 | Physical | cables, radio, NIC |

### IPv4 quick facts

| Item | Example | Notes |
|---|---|---|
| IPv4 address | `192.168.1.10` | host address |
| Subnet mask | `255.255.255.0` | equivalent to `/24` |
| CIDR prefix | `/24` | network bits |
| Default gateway | `192.168.1.1` | router out of subnet |
| DNS server | `1.1.1.1` | resolves names to IPs |

### Common service ports (selected)

| Service | Port | Transport |
|---|---:|---|
| DNS | 53 | UDP/TCP |
| HTTP | 80 | TCP |
| HTTPS | 443 | TCP |
| SSH | 22 | TCP |
| NTP | 123 | UDP |
| RDP | 3389 | TCP |

### Troubleshooting flow (fast)

1. Check local IP config (address/gateway/DNS)
2. Check DNS resolution
3. Check routing/path
4. Check TCP port reachability
5. Check application-level behavior (HTTP/TLS)

## Commands (most used)

### Windows (PowerShell)

| Task | Command |
|---|---|
| IP config | `Get-NetIPConfiguration` / `ipconfig /all` |
| DNS lookup | `Resolve-DnsName <name>` / `nslookup <name>` |
| Ping | `Test-Connection -Count 4 <host>` / `ping <host>` |
| Trace route | `tracert <host>` |
| Port test | `Test-NetConnection <host> -Port <port>` |
| View routes | `route print` |

### Linux/macOS (bash/zsh)

| Task | Command |
|---|---|
| IP config | `ip addr` (or `ifconfig`) |
| Routes | `ip route` |
| DNS lookup | `nslookup <name>` / `dig <name>` |
| Ping | `ping -c 4 <host>` |
| Trace route | `traceroute <host>` / `tracepath <host>` |
| Port test | `nc -vz <host> <port>` |
| HTTP test | `curl -I https://<host>` |

## Common errors

| Symptom | Likely cause | Next check |
|---|---|---|
| "Name or service not known" | DNS resolution failed | resolver, VPN, split-DNS |
| "No route to host" | routing issue | default gateway, routes, VPN |
| "Connection timed out" | firewall or path drop | port test + traceroute |
| "Connection refused" | service reachable but not listening | service status, port mismatch |

## Security

- Only run connectivity tests against systems you are authorized to access.
- Avoid pasting internal IPs/hostnames into public tickets or chats.

