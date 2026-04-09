# Subnets (IPv4) Cheat Sheet

This is a practical guide to understanding IPv4 subnets, CIDR notation, and how to quickly calculate ranges.

## Core terms

- **IP address**: e.g. `192.168.10.37`
- **CIDR prefix length**: e.g. `/26` (how many bits are the network)
- **Netmask**: e.g. `255.255.255.192` (another way to express `/26`)
- **Network address**: first address in the subnet (all host bits = 0)
- **Broadcast address**: last address in the subnet (all host bits = 1) (not used with `/31`)
- **Usable host range**: typically `network+1` .. `broadcast-1` (not true for `/31` and `/32`)

## Quick math

- **Addresses per subnet** = `2^(32 - prefix)`
- **Usable hosts** (typical) = `2^(32 - prefix) - 2`
  - Exceptions:
    - **/31**: point-to-point (2 addresses; both usable; no broadcast in practice)
    - **/32**: single host route (1 address)

## Common prefix sizes

| CIDR | Netmask | Addresses | Usable hosts (typical) | Notes |
|---:|---|---:|---:|---|
| /24 | 255.255.255.0 | 256 | 254 | Very common LAN subnet |
| /25 | 255.255.255.128 | 128 | 126 | Half of a /24 |
| /26 | 255.255.255.192 | 64 | 62 | Quarter of a /24 |
| /27 | 255.255.255.224 | 32 | 30 | Often used for small VLANs |
| /28 | 255.255.255.240 | 16 | 14 | Small segment |
| /29 | 255.255.255.248 | 8 | 6 | Tiny segment |
| /30 | 255.255.255.252 | 4 | 2 | Legacy point-to-point |
| /31 | 255.255.255.254 | 2 | 2 | Point-to-point (modern) |
| /32 | 255.255.255.255 | 1 | 1 | Host route |

## How to find the subnet range (fast method)

1. Convert prefix to a **block size** in the "interesting" octet.
2. The network boundaries occur every **block size**.
3. Find which block your IP falls into.

Example: `192.168.10.37/26`

- `/26` means netmask `255.255.255.192`
- Interesting octet is the 4th octet: `192` corresponds to block size `256 - 192 = 64`
- Blocks: `0-63`, `64-127`, `128-191`, `192-255`
- `37` is in `0-63`

Result:

- **Network**: `192.168.10.0`
- **Broadcast**: `192.168.10.63`
- **Usable range**: `192.168.10.1` - `192.168.10.62`

## Another worked example

Example: `10.20.30.140/28`

- `/28` netmask: `255.255.255.240` => block size `256 - 240 = 16`
- 4th octet blocks: `0-15`, `16-31`, `32-47`, ..., `128-143`, `144-159`, ...
- `140` is in `128-143`

Result:

- **Network**: `10.20.30.128`
- **Broadcast**: `10.20.30.143`
- **Usable range**: `10.20.30.129` - `10.20.30.142`

## "Are these two IPs in the same subnet?"

They're in the same subnet if:

- `(ip1 AND netmask) == (ip2 AND netmask)`

In practice, use tooling rather than doing bitwise math by hand.

## Useful IPv4 ranges to recognize

Private (RFC1918):

- `10.0.0.0/8`
- `172.16.0.0/12` (172.16.0.0 - 172.31.255.255)
- `192.168.0.0/16`

Other common special-use ranges:

- `100.64.0.0/10` (CGNAT)
- `127.0.0.0/8` (loopback)
- `169.254.0.0/16` (link-local/APIPA)
- `224.0.0.0/4` (multicast)

## Tools (quick checks)

Linux:

```bash
# Show addresses in a compact form
ip -br addr

# Show routes (often includes your default gateway)
ip route

# Install ipcalc (Debian/Ubuntu)
sudo apt update && sudo apt install -y ipcalc

# Compute network/broadcast/host range
ipcalc 192.168.10.37/26
```

Python (works anywhere with Python 3):

```bash
# Print network details using the ipaddress module
python -c "import ipaddress as i; n=i.ip_interface('192.168.10.37/26').network; print(n, n.network_address, n.broadcast_address, n.num_addresses)"
```

PowerShell:

```powershell
# Show IPs configured on the system
Get-NetIPAddress | Select-Object InterfaceAlias,IPAddress,PrefixLength
```

