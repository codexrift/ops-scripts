# firewalld Cheat Sheet

Dynamic firewall management (RHEL/Fedora/CentOS).

## Status & zones

```bash
# Show whether firewalld is running
sudo firewall-cmd --state

# Show the default zone
sudo firewall-cmd --get-default-zone

# List active zones and their interfaces
sudo firewall-cmd --get-active-zones

# Show all settings for a zone
sudo firewall-cmd --zone=public --list-all
```

## Open ports / services

Runtime (until reload/reboot):

```bash
# Open a TCP port at runtime (until reload/reboot)
sudo firewall-cmd --zone=public --add-port=8080/tcp

# Allow a named service at runtime (until reload/reboot)
sudo firewall-cmd --zone=public --add-service=http
```

Permanent:

```bash
# Open a TCP port permanently
sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent

# Allow a named service permanently
sudo firewall-cmd --zone=public --add-service=http --permanent

# Reload firewalld to apply permanent changes
sudo firewall-cmd --reload
```

Remove:

```bash
# Remove a permanent port rule
sudo firewall-cmd --zone=public --remove-port=8080/tcp --permanent

# Reload firewalld to apply permanent changes
sudo firewall-cmd --reload
```

## Rich rules (example)

Allow SSH from a subnet:

```bash
# Add a rich rule (example: allow SSH from 10.0.0.0/8)
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="10.0.0.0/8" service name="ssh" accept'

# Reload firewalld to apply permanent changes
sudo firewall-cmd --reload
```

## Troubleshooting

```bash
# Show zone configuration
sudo firewall-cmd --list-all

# List open ports
sudo firewall-cmd --list-ports

# List allowed services
sudo firewall-cmd --list-services
```
