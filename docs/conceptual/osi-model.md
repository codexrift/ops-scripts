# OSI Model (7 Layers) Cheat Sheet

The **OSI model** is a conceptual way to describe how data moves through a network stack, from physical signals up to application data.

## The 7 layers (top -> bottom)

| # | Layer | What it’s about | Examples |
|---:|---|---|---|
| 7 | Application | User-facing network services | HTTP(S), DNS, SMTP, SSH (as an app protocol) |
| 6 | Presentation | Data format, encoding, encryption | TLS/SSL, JSON, UTF-8, compression |
| 5 | Session | Dialog/connection management | Sessions, renegotiation, keepalives (conceptual) |
| 4 | Transport | End-to-end delivery between hosts | TCP, UDP, QUIC (often discussed here) |
| 3 | Network | Routing between networks | IP, ICMP, routing, NAT (commonly here) |
| 2 | Data Link | Local network delivery (same link) | Ethernet, Wi-Fi, ARP, VLANs, MAC addresses |
| 1 | Physical | Signals and media | Copper/fiber, radio, connectors, link speed |

Notes:

- OSI is a **model**, not a strict description of real implementations.
- Some items (like **TLS** or **QUIC**) get placed differently depending on who you ask; the table is the most common ops-friendly framing.

## Encapsulation (what wraps what)

As data goes down the stack, each layer adds a header (and sometimes a trailer):

- **L7 data** (e.g. HTTP request)
- becomes a **L4 segment/datagram** (TCP/UDP adds ports, sequence, checksums)
- becomes a **L3 packet** (IP adds source/destination IP)
- becomes a **L2 frame** (Ethernet/Wi-Fi adds source/destination MAC, VLAN tag, FCS)
- becomes **L1 bits** on the wire/air

Reverse happens on receive (decapsulation).

## Common “where is the problem?” mapping

Typical symptoms by layer:

- **Layer 1**: link down, no carrier, bad cable, wrong duplex/speed, Wi-Fi signal issues
- **Layer 2**: wrong VLAN, MAC learning/port security, ARP problems, switching loops
- **Layer 3**: wrong IP/subnet/gateway, routing missing, ICMP unreachable, MTU issues
- **Layer 4**: port closed, firewall blocks, TCP resets, UDP not reaching, timeouts
- **Layer 5–7**: authentication failures, TLS handshake errors, HTTP 4xx/5xx, DNS NXDOMAIN

## Practical troubleshooting flow (fast)

1. **L1**: is there link/signal? is interface up?
2. **L2**: are you on the right VLAN/Wi-Fi? can you resolve ARP on local subnet?
3. **L3**: correct IP/subnet/gateway? can you reach next hop? routes ok?
4. **L4**: is the port reachable (listen vs blocked)? stateful firewall/NAT ok?
5. **L7**: does the actual protocol work (DNS/HTTP/SSH)? auth/certs/headers correct?

## OSI vs TCP/IP model (quick mapping)

The Internet stack is often described with 4 layers:

- **Application** ~= OSI **L5–L7**
- **Transport** ~= OSI **L4**
- **Internet** ~= OSI **L3**
- **Link** ~= OSI **L1–L2**

## Mnemonics

From Layer 7 down to 1:

- **A**ll **P**eople **S**eem **T**o **N**eed **D**ata **P**rocessing

From Layer 1 up to 7:

- **P**lease **D**o **N**ot **T**hrow **S**ausage **P**izza **A**way

