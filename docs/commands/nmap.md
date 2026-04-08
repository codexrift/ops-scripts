# nmap Cheat Sheet

Network scanner. Only scan/test systems you own or have explicit permission to test.

```bash
# Quick scan common ports
nmap <host>

# Scan specific ports
nmap -p 22,80,443 <host>

# Scan all TCP ports
nmap -p- <host>

# Service/version detection
nmap -sV <host>

# Ping scan a subnet (host discovery)
nmap -sn 10.0.0.0/24

# OS detection (requires privileges)
sudo nmap -O <host>
```

