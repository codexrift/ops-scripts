# Windows vs Linux Networking (Where to Look)

This is a quick map of where to check common networking items on each OS.

## IP addressing

Linux:

- `ip -br addr`
- `ip route`
- `/etc/resolv.conf` (resolver config, depending on systemd-resolved)

Windows (PowerShell):

- `Get-NetIPAddress`
- `Get-NetRoute`
- `Get-DnsClientServerAddress`

## DNS troubleshooting

Linux:

```bash
# Query resolver behavior
dig example.com
```

Windows:

```powershell
# Resolve a name using system resolver
Resolve-DnsName example.com
```

## Firewall

Linux:

- `nft list ruleset` (nftables)
- `iptables -S` (legacy)
- `firewall-cmd --list-all` (firewalld)

Windows:

- `Get-NetFirewallRule`
- Windows Defender Firewall UI and event logs

## Common gotchas

- VPN clients often override DNS and routes differently on Windows vs Linux.
- Proxy settings can affect HTTP tools even when basic ping works.

