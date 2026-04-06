# firewalld Cheat Sheet

Dynamic firewall management (RHEL/Fedora/CentOS).

## Status & zones

```bash
sudo firewall-cmd --state
sudo firewall-cmd --get-default-zone
sudo firewall-cmd --get-active-zones
sudo firewall-cmd --zone=public --list-all
```

## Open ports / services

Runtime (until reload/reboot):

```bash
sudo firewall-cmd --zone=public --add-port=8080/tcp
sudo firewall-cmd --zone=public --add-service=http
```

Permanent:

```bash
sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent
sudo firewall-cmd --zone=public --add-service=http --permanent
sudo firewall-cmd --reload
```

Remove:

```bash
sudo firewall-cmd --zone=public --remove-port=8080/tcp --permanent
sudo firewall-cmd --reload
```

## Rich rules (example)

Allow SSH from a subnet:

```bash
sudo firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="10.0.0.0/8" service name="ssh" accept'
sudo firewall-cmd --reload
```

## Troubleshooting

```bash
sudo firewall-cmd --list-all
sudo firewall-cmd --list-ports
sudo firewall-cmd --list-services
```

