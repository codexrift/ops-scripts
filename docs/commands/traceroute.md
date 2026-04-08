# traceroute Cheat Sheet

Trace hop-by-hop path to a destination.

```bash
# Trace route (DNS names)
traceroute example.com

# Trace route (numeric; skip reverse DNS)
traceroute -n example.com

# ICMP-based traceroute (may require sudo)
sudo traceroute -I example.com

# TCP SYN-based traceroute to a port (may require sudo)
sudo traceroute -T -p 443 example.com
```

