---
title: "network layers explanation: OSI vs TCP/IP (practical mental model)"
type: "explanation"
owner: "u115478"
last_updated: "2026-04-28"
---

# network layers explanation: OSI vs TCP/IP (practical mental model)

## Summary (1-2 paragraphs)

Networking problems are easier to debug when you separate *where* a failure happens. The OSI model is a layered way to talk about it: cables/Wi‑Fi (Layer 1/2), IP/routing (Layer 3), TCP/UDP/ports (Layer 4), and application protocols like HTTP, DNS, and SSH (Layer 7). Most real-world troubleshooting is identifying the *lowest layer that is failing*.

The TCP/IP model is the "real" stack used on systems, but the OSI names remain useful vocabulary. Treat the models as a shared language to narrow down root cause, not as strict rules.

## Context

### Problem statement

- "I cannot reach X" can mean many different failures (DNS, routing, firewall, service down).
- You need a quick way to ask the right questions and run the right tests.

### Constraints

- ICMP (ping/traceroute) may be blocked even when services work.
- Many applications require DNS names (TLS certificates, SNI) even when IP is reachable.

## Concepts and mental model

### What each layer answers

- **Layer 1/2 (link):** Do I have a working connection to the local network? (Wi‑Fi/Ethernet)
- **Layer 3 (IP):** Do I have an IP address and a route to the destination network?
- **Layer 4 (TCP/UDP):** Can I open a connection to the destination port?
- **Layer 7 (application):** Does the protocol work (HTTP response, SSH handshake, DNS reply)?

### Typical failure patterns

- **DNS issue (Layer 7):** name does not resolve, but IP might still be reachable.
- **Routing issue (Layer 3):** no route to destination; traceroute often stops early.
- **Firewall/ACL issue (Layer 4):** DNS resolves, ping maybe works, but TCP port times out.
- **Service issue (Layer 7):** TCP connects, but app errors (HTTP 500, TLS error, auth failure).

## Tradeoffs and decisions

- OSI helps communicate and triage; it does not prove root cause by itself.
- Start low (link/IP) and move up (ports/apps) to avoid chasing symptoms.

## Related docs

- Practice the checks: `documentation/01-tutorial/networking-troubleshooting-getting-started.md`
- IP basics: `documentation/04-explanation/ip-addressing-mental-model.md`
- Commands: `documentation/03-reference/networking-reference.md`

