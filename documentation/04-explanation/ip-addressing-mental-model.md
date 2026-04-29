---
title: "IP addressing explanation: IPv4, subnets, gateways, CIDR (mental model)"
type: "explanation"
owner: "u115478"
last_updated: "2026-04-28"
---

# IP addressing explanation: IPv4, subnets, gateways, CIDR (mental model)

## Summary (1-2 paragraphs)

An IPv4 address identifies a host on a network, but it only makes sense together with a subnet (CIDR prefix or subnet mask). The subnet tells you which part of the address is the "network" and which part is the "host". Devices can talk directly only to other devices in the same subnet; traffic to other networks must go through a router (your default gateway).

Most workstation connectivity issues boil down to one of these: wrong IP/subnet, missing or wrong default gateway, wrong DNS servers, or conflicting IPs. This document gives a minimal model so you can reason about those quickly.

## Context

### Problem statement

- You need to know whether two IPs are in the same subnet.
- You need to know when traffic uses a gateway vs stays local.
- You want to interpret basic output from `ipconfig`/`ip addr`.

## Concepts and mental model

### The three essential pieces

- **IP address:** your host identity (e.g., `192.168.1.10`)
- **Subnet mask / CIDR:** which addresses are "local" (e.g., `/24` == `255.255.255.0`)
- **Default gateway:** where non-local traffic goes (e.g., `192.168.1.1`)

### Same subnet vs different subnet

If two hosts are in the same subnet, they can usually talk directly (Layer 2/3) without a router.

Example:

- Host A: `192.168.1.10/24`
- Host B: `192.168.1.50/24`  -> same subnet (both `192.168.1.*`)
- Host C: `192.168.2.10/24`  -> different subnet -> needs routing via a gateway

> **NOTE:** "Same /24" is not always the same network boundary in real orgs (VLANs, ACLs), but it is the baseline model.

### CIDR prefix (why `/24` matters)

- `/24` means: first 24 bits are the network, last 8 bits are host addresses.
- Common mental shortcut: `/24` is often `x.y.z.0 - x.y.z.255` (usable hosts usually `.1` to `.254`).

### Private IPv4 ranges (common)

- `10.0.0.0/8`
- `172.16.0.0/12`
- `192.168.0.0/16`

These are not routed on the public internet by default; they are used inside networks with NAT and routing.

## Tradeoffs and decisions

- Subnetting can be simple (home networks) or complex (enterprise). Start with the essentials: IP + CIDR + gateway.
- DNS is not routing: DNS gives you an IP, but routing determines whether you can reach it.

## Related docs

- Network layers: `documentation/04-explanation/network-layers-osi-tcpip.md`
- Practice checks: `documentation/01-tutorial/networking-troubleshooting-getting-started.md`
- Command lookup: `documentation/03-reference/networking-reference.md`

