# Cisco CLI Cheat Sheet (IOS / IOS-XE / NX-OS basics)

This is a practical reference for common Cisco-style CLI workflows.
Exact commands can differ slightly between **IOS/IOS-XE** and **NX-OS**.

## Session setup (safe defaults)

```text
! Enter privileged EXEC mode
enable

! Disable paging (best for copy/paste)
terminal length 0

! Re-enable paging (common default is 24)
terminal length 24
```

Useful keys:

- Inline help: `?`
- Autocomplete: `<TAB>`
- Abort/escape current input: `Ctrl+C`

## Save / rollback basics

```text
! Show the running config (current state)
show running-config

! Show the startup config (saved state)
show startup-config

! Save running-config to startup-config (IOS/IOS-XE; also works on many NX-OS)
copy running-config startup-config

! Save configuration (often works on IOS/IOS-XE as alias)
write memory
```

## Modes and navigation

```text
! Prompt changes by mode:
! user EXEC:        Switch>
! privileged EXEC:  Switch#
! global config:    Switch(config)#
! interface config: Switch(config-if)#

! Enter global configuration mode
configure terminal

! Exit one level
exit

! Leave config mode and return to privileged EXEC
end
```

## Quick triage (first commands to run)

```text
! Device/software info
show version

! Hardware inventory (platform dependent)
show inventory

! Current time / uptime context
show clock

! Recent log messages
show logging

! Quick interface status table (L3)
show ip interface brief

! Switchport/physical link status table (platform dependent)
show interfaces status
```

## Filtering output (common patterns)

```text
! Short form for "show"
sh <command>

! Filter output (match a string)
show <command> | include <string>

! Show output starting from the first match
show <command> | begin <string>

! Show a whole section (IOS/IOS-XE; support varies)
show <command> | section <string>
```

## Interfaces (status / details)

```text
! Show interfaces information (short form)
sh int

! Detailed interface counters/state
show interfaces GigabitEthernet1/0/1

! Switchport mode/VLAN/trunk info (if supported)
show interfaces GigabitEthernet1/0/1 switchport

! Show interfaces that are connected
sh int status | include connected

! Show interfaces in the VLAN XXX (replace XXX with VLAN ID)
sh int status | include XXX

! Show interfaces where description matches a template/string (replace XXX)
sh int description | include XXX
```

## VLANs and trunks (switching)

```text
! Show VLAN information (short form)
sh vlan

! List VLANs (switching platforms)
show vlan brief

! List trunk ports and allowed VLANs (IOS)
show interfaces trunk

! Spanning-tree overview
show spanning-tree summary
```

Common config patterns (edit as needed):

```text
! Enter global config mode
configure terminal

! Create VLAN 10
vlan 10

! Name VLAN 10
name USERS

! Exit back to privileged EXEC
end
```

Access port example:

```text
! Set an access port in VLAN 10
configure terminal

! Select interface
interface GigabitEthernet1/0/10

! Set access mode
switchport mode access

! Assign VLAN
switchport access vlan 10

! Enable PortFast (access ports only; confirm your policy)
spanning-tree portfast

! Exit back to privileged EXEC
end
```

Trunk port example:

```text
! Set a trunk port and allow VLANs 10,20,30 (IOS-style)
configure terminal

! Select interface
interface GigabitEthernet1/0/48

! Set trunk mode
switchport mode trunk

! Restrict allowed VLANs
switchport trunk allowed vlan 10,20,30

! Exit back to privileged EXEC
end
```

## MAC address table and port security (L2 troubleshooting)

```text
! Show learned MAC addresses
show mac address-table

! Filter by VLAN (platform dependent)
show mac address-table vlan 10

! Filter by interface (platform dependent)
show mac address-table interface GigabitEthernet1/0/10

! Search which MAC address is connected to an interface
sh mac address-table | include Gi4/0/24

! Search on which interface a MAC address is learned
sh mac address-table | include 00be.4386.b96b

! Show port-security info for a specific interface (e.g., max MACs)
sh port-security interface Gi1/0/7
```

## Layer 3 (IP, routing, reachability)

```text
! Show routing table
show ip route

! Show ARP table
show ip arp

! Ping a destination
ping 8.8.8.8

! Traceroute a destination
traceroute 8.8.8.8
```

SVI (gateway) example:

```text
! Enter global config mode
configure terminal

! Create an SVI for VLAN 10 (gateway)
interface vlan 10

! Set IP address (netmask format)
ip address 10.10.10.1 255.255.255.0

! Ensure the SVI is enabled
no shutdown

! Exit back to privileged EXEC
end
```

## Neighbors (CDP/LLDP)

```text
! Show directly connected Cisco neighbors (CDP)
show cdp neighbors

! Detailed CDP neighbor info
show cdp neighbors detail

! Show LLDP neighbors (if enabled)
show lldp neighbors
```

## Port-channel / EtherChannel (quick basics)

```text
! Show EtherChannel/port-channel summary (IOS)
show etherchannel summary

! Show port-channel summary (NX-OS style)
show port-channel summary
```

## Users / access (high-level)

```text
! Show active remote sessions (IOS)
show users
```

Notes:

- SSH server/AAA settings vary by platform; follow your org standard (AAA, local users, key size, vty config, mgmt VRF).

## Common gotchas and tips

- Run `terminal length 0` before pasting long output to avoid `--More--` interruptions.
- Remember: changes in `configure terminal` affect **running-config** immediately; save when ready.
- VLAN/trunk behavior is a frequent cause of "can't get DHCP / wrong subnet" issues.
- NX-OS and IOS sometimes differ in interface naming, feature enablement, and show command variants.
