# TCP vs UDP (Transport Layer) Cheat Sheet

TCP and UDP are the two most common transport protocols on IP networks.

## High-level differences

| Topic | TCP | UDP |
|---|---|---|
| Connection | Connection-oriented | Connectionless |
| Reliability | Retransmissions, ordering, congestion control | No built-in reliability/ordering |
| Latency | Higher setup cost (handshake) | Lower overhead |
| Use cases | Web (HTTP/1.1, HTTP/2), SSH, SMTP, databases | DNS, VoIP, streaming, some games |

## TCP basics

- 3-way handshake: SYN -> SYN/ACK -> ACK
- Provides:
  - ordered byte stream
  - retransmissions
  - flow control (receiver window)
  - congestion control

Common TCP symptoms:

- SYN timeout: port filtered / path blocked
- RST: port closed or active reject
- Slow transfers: loss/latency/MTU/congestion window issues

## UDP basics

- No handshake.
- Each packet (datagram) is independent.
- Applications must handle:
  - retransmission
  - ordering
  - duplication

Common UDP symptoms:

- Works sometimes, drops under load (loss/buffering)
- "No response": firewall/NAT blocks, server not listening

## MTU and PMTUD (why it matters)

- Too-large packets can be dropped if fragmentation is blocked.
- Path MTU Discovery relies on ICMP "fragmentation needed" messages.

## QUIC note

QUIC runs over UDP but implements TCP-like reliability and TLS at the protocol level.
Many modern HTTP stacks use QUIC for HTTP/3.

