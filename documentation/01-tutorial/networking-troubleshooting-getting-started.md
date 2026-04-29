---
title: "networking tutorial: basic troubleshooting (IP, DNS, routing, ports)"
type: "tutorial"
owner: "u115478"
last_updated: "2026-04-28"
---

# networking tutorial: basic troubleshooting (IP, DNS, routing, ports)

<!--
Learning-oriented: follow along and practice the most common network checks.
Focus: workstation-to-service connectivity, not advanced network engineering.
-->

## Summary

- **Goal:** Determine whether a connectivity problem is IP config, DNS, routing, firewall, or service/port.
- **What you'll learn:**
  - How to inspect your IP configuration (address, gateway, DNS)
  - How to test DNS resolution vs raw IP connectivity
  - How to test routing and latency (ping/traceroute)
  - How to test a TCP port (is the service reachable?)
- **Estimated time:** 20-45 minutes
- **Difficulty:** beginner
- **Who this is for:** you

## Prerequisites

### Required tools

- Windows: PowerShell (Windows 10/11)
- Linux/macOS: bash/zsh
- Optional but recommended: `curl`

### Inputs you must have

- A target hostname to test, for example: `example.com`
- A target TCP port, for example: `443`

## Safety and scope

### What this tutorial changes

- Nothing; read-only checks only.

### Risks

- Low. Be careful not to run tests against systems you are not allowed to probe.

## Before you start (sanity checks)

Pick your targets:

- `TARGET_HOST`: `example.com`
- `TARGET_PORT`: `443`

## Tutorial steps

### Step 1 - Confirm your local IP configuration

#### Windows (PowerShell)

```powershell
Get-NetIPConfiguration
ipconfig /all
```

Look for:

- IPv4 address (e.g., `192.168.x.y`)
- Default gateway (your way out of the subnet)
- DNS servers

#### Linux/macOS (bash/zsh)

```bash
ip addr || ifconfig
ip route || netstat -rn
cat /etc/resolv.conf
```

Checkpoint:

- You can point to your IP address, default gateway, and DNS server(s).

### Step 2 - Check DNS resolution (name -> IP)

#### Windows (PowerShell)

```powershell
Resolve-DnsName -Name example.com
nslookup example.com
```

#### Linux/macOS (bash/zsh)

```bash
getent hosts example.com || true
dig +short example.com || true
nslookup example.com
```

Checkpoint:

- You have at least one IP address for `example.com`.

> **NOTE:** If DNS fails, you can still test connectivity to a known IP address, but many services require correct hostnames (TLS/SNI).

### Step 3 - Test reachability and latency (ICMP)

#### Windows (PowerShell)

```powershell
ping -n 4 example.com
Test-Connection -Count 4 -ComputerName example.com
```

#### Linux/macOS (bash/zsh)

```bash
ping -c 4 example.com
```

Checkpoint:

- If ping succeeds: basic IP reachability is working.
- If ping fails: it might still be OK (many hosts block ICMP). Continue to port testing.

### Step 4 - Inspect the path (routing / hops)

#### Windows (PowerShell)

```powershell
tracert example.com
```

#### Linux/macOS (bash/zsh)

```bash
traceroute example.com || tracepath example.com
```

Checkpoint:

- You can see where packets stop (if they do).

### Step 5 - Test a TCP port (is the service reachable?)

#### Windows (PowerShell)

```powershell
Test-NetConnection -ComputerName example.com -Port 443
```

#### Linux/macOS (bash/zsh)

```bash
nc -vz example.com 443
```

If `nc` is not installed:

```bash
curl -sS -I https://example.com | head -n 5
```

Checkpoint:

- You can tell the difference between "DNS worked but the port is blocked" vs "DNS failed".

## Common interpretations (quick)

- DNS fails: fix DNS or use a reachable resolver (per your org policy).
- Ping fails but TCP works: ICMP is blocked; not necessarily a problem.
- TCP port fails but DNS/ping works: firewall/security group, service down, or port mismatch.
- Traceroute stops early: routing or intermediate firewall policy (or traceroute blocked).

## Next steps

- Understand the layers: `documentation/04-explanation/network-layers-osi-tcpip.md`
- Understand IP addressing: `documentation/04-explanation/ip-addressing-mental-model.md`
- Command lookup: `documentation/03-reference/networking-reference.md`

