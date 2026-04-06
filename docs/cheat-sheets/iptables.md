# iptables Cheat Sheet

Linux firewall tool for IPv4. Prefer `nftables` on newer distros, but `iptables` is still common.

## Safety basics

- Lock yourself out risk: test rules locally and keep an out-of-band access method.
- Order matters: rules are evaluated top to bottom.

## View rules

List filter table (human readable, with line numbers):

```bash
sudo iptables -L -n -v --line-numbers
```

List specific table:

```bash
sudo iptables -t nat -L -n -v --line-numbers
```

Show exact rule syntax:

```bash
sudo iptables -S
sudo iptables -t nat -S
```

## Flush / reset (use with care)

```bash
sudo iptables -F
sudo iptables -t nat -F
sudo iptables -X
```

Set default policies:

```bash
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT
```

## Common allow rules

Allow established/related:

```bash
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
```

Allow loopback:

```bash
sudo iptables -A INPUT -i lo -j ACCEPT
```

Allow SSH (port 22) from a subnet:

```bash
sudo iptables -A INPUT -p tcp --dport 22 -s 10.0.0.0/8 -j ACCEPT
```

Allow HTTP/HTTPS:

```bash
sudo iptables -A INPUT -p tcp -m multiport --dports 80,443 -j ACCEPT
```

Drop everything else (if default policy is ACCEPT):

```bash
sudo iptables -A INPUT -j DROP
```

## Insert / delete specific rule

Insert at top (before other rules):

```bash
sudo iptables -I INPUT 1 -p tcp --dport 22 -j ACCEPT
```

Delete by line number:

```bash
sudo iptables -D INPUT 3
```

## Logging

Log then drop:

```bash
sudo iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables-drop: " --log-level 4
sudo iptables -A INPUT -j DROP
```

## NAT (port forwarding)

Forward port 80 to an internal host (DNAT):

```bash
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination 192.168.1.10:80
sudo iptables -A FORWARD -p tcp -d 192.168.1.10 --dport 80 -j ACCEPT
```

Masquerade outbound traffic (common for gateways):

```bash
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
```

## Persist rules (varies by distro)

Persistence differs across distros (systemd services, netfilter-persistent, firewalld, etc.). Save rules using your distro's standard mechanism.

