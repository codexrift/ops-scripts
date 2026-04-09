# VLAN (802.1Q) Cheat Sheet

A **VLAN** (Virtual LAN) lets you split a physical switch/network into multiple **logical Layer-2 networks**.
Devices in different VLANs are separated at L2; to communicate between VLANs you need **Layer-3 routing**.

## Core concepts

- **VLAN ID (VID)**: number from `1` to `4094` (0 and 4095 are reserved)
- **Access port**: switchport that carries **one** VLAN (frames are untagged on the wire)
- **Trunk port**: switchport that carries **multiple** VLANs (frames are typically **tagged** with 802.1Q)
- **802.1Q tag**: extra header inserted in Ethernet frames to identify the VLAN
- **Native VLAN**: VLAN carried **untagged** on a trunk (vendor behavior differs; avoid relying on it)
- **SVI (Switched Virtual Interface)**: L3 interface for a VLAN on a switch/router (gateway IP for that VLAN)

## Access vs trunk (what’s the difference?)

Access port:

- Endpoint port (PC, printer, camera, AP uplink in some designs)
- Untagged traffic only
- Switch assigns untagged frames to the configured VLAN

Trunk port:

- Uplink between switches, switch <-> router, switch <-> hypervisor, switch <-> firewall
- Carries multiple VLANs using tags
- Usually has an **allowed VLAN list** (which VLANs may traverse it)

## “VLAN != subnet” (common confusion)

- VLAN is **Layer 2 segmentation**
- Subnet is **Layer 3 addressing/routing**

Common design pattern:

- 1 VLAN <-> 1 subnet (simple and common)

But not required:

- Multiple subnets can exist on one VLAN (usually a bad idea operationally)
- A subnet can be extended across multiple switches via trunks (still one VLAN)

## Why VLANs are used

- Security segmentation (user vs server vs guest vs IoT)
- Reduce broadcast domains (smaller L2 segments)
- Operational separation (different DHCP scopes, different gateways, policies)
- Multi-tenant separation (lab environments)

## Quick troubleshooting mapping (OSI layers)

- VLAN issues are typically **Layer 2** (tagging, trunking, native VLAN, allowed VLANs).
- “Can’t reach gateway” might be L2 VLAN mismatch or L3 IP/subnet/gateway config.

## Common failure modes

- **Port in wrong VLAN** (access port misconfigured)
- **Trunk doesn’t allow VLAN** (allowed VLAN list missing the VID)
- **Native VLAN mismatch** (untagged frames land in different VLANs on each side)
- **Double-tagging / tag-stripping** issues (less common, but painful)
- **DHCP scope mismatch** (client gets IP from wrong VLAN)
- **Gateway/SVI missing** (VLAN exists but no L3 interface routes it)
- **STP changes** causing unexpected forwarding/blocked paths (indirect symptoms)

## Commands & checks (vendor-agnostic ideas)

On the switch:

- Confirm port mode (access vs trunk)
- Confirm VLAN membership / allowed VLANs on trunks
- Confirm SVI/gateway exists (if switch is doing inter-VLAN routing)
- Check MAC address table for the endpoint (is the MAC learned on the expected VLAN/port?)

On the host:

- Confirm IP/subnet/gateway are correct for the intended VLAN
- Confirm link is up
- If using tagged VLANs on the host/hypervisor, confirm the VLAN tag matches

## Practical examples

Example layout:

- VLAN 10 = Users (subnet `10.10.10.0/24`, gateway `10.10.10.1`)
- VLAN 20 = Servers (subnet `10.10.20.0/24`, gateway `10.10.20.1`)
- VLAN 30 = Guest Wi-Fi (subnet `10.10.30.0/24`, gateway `10.10.30.1`)

Traffic rules:

- Within a VLAN: switching (L2) is enough
- Between VLANs: requires routing + firewall policy (L3/L4)

## Best-practice notes

- Prefer explicit trunk allowed VLAN lists (do not “allow all” by default)
- Avoid relying on the native VLAN; tag everything if possible
- Keep a consistent VLAN/subnet naming convention (e.g., `VLAN10_USERS`, `VLAN20_SERVERS`)
- Document trunk links and their allowed VLANs (saves hours during incidents)

