# iptables Cheat Sheet

Linux firewall tool for IPv4. Prefer `nftables` on newer distros, but `iptables` is still common.

## Safety basics

- Lock yourself out risk: test rules locally and keep an out-of-band access method.
- Order matters: rules are evaluated top to bottom.

## View rules

List filter table (human readable, with line numbers):

```bash
# List filter table rules with line numbers (numeric + verbose)
sudo iptables -L -n -v --line-numbers
```

List specific table:

```bash
# List NAT table rules with line numbers (numeric + verbose)
sudo iptables -t nat -L -n -v --line-numbers
```

Show exact rule syntax:

```bash
# Show rules in "command form" (filter table)
sudo iptables -S

# Show rules in "command form" (nat table)
sudo iptables -t nat -S
```

## Flush / reset (use with care)

```bash
# Flush (delete) all rules in filter table (destructive)
sudo iptables -F

# Flush (delete) all rules in nat table (destructive)
sudo iptables -t nat -F

# Delete user-defined chains (destructive)
sudo iptables -X
```

Set default policies:

```bash
# Set default policy for INPUT chain (destructive if misapplied)
sudo iptables -P INPUT DROP

# Set default policy for FORWARD chain
sudo iptables -P FORWARD DROP

# Set default policy for OUTPUT chain
sudo iptables -P OUTPUT ACCEPT
```

## Common allow rules

Allow established/related:

```bash
# Allow established/related inbound traffic
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
```

Allow loopback:

```bash
# Allow local loopback traffic
sudo iptables -A INPUT -i lo -j ACCEPT
```

Allow SSH (port 22) from a subnet:

```bash
# Allow SSH from a subnet
sudo iptables -A INPUT -p tcp --dport 22 -s 10.0.0.0/8 -j ACCEPT
```

Allow HTTP/HTTPS:

```bash
# Allow HTTP and HTTPS inbound
sudo iptables -A INPUT -p tcp -m multiport --dports 80,443 -j ACCEPT
```

Drop everything else (if default policy is ACCEPT):

```bash
# Drop all other inbound traffic (if INPUT policy is ACCEPT)
sudo iptables -A INPUT -j DROP
```

## Insert / delete specific rule

Insert at top (before other rules):

```bash
# Insert a rule at position 1 (top of chain)
sudo iptables -I INPUT 1 -p tcp --dport 22 -j ACCEPT
```

Delete by line number:

```bash
# Delete a rule by line number
sudo iptables -D INPUT 3
```

## Logging

Log then drop:

```bash
# Log limited rate then drop (example)
sudo iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables-drop: " --log-level 4

# Drop all other inbound traffic
sudo iptables -A INPUT -j DROP
```

## NAT (port forwarding)

Forward port 80 to an internal host (DNAT):

```bash
# DNAT port 80 to an internal host
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination 192.168.1.10:80

# Allow forwarding to that internal host/port
sudo iptables -A FORWARD -p tcp -d 192.168.1.10 --dport 80 -j ACCEPT
```

Masquerade outbound traffic (common for gateways):

```bash
# Masquerade outbound traffic on eth0 (typical gateway/NAT)
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
```

## Persist rules (varies by distro)

Persistence differs across distros (systemd services, netfilter-persistent, firewalld, etc.). Save rules using your distro's standard mechanism.
