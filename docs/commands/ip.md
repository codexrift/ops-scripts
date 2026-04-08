# ip Cheat Sheet

Modern Linux networking tool (interfaces, addresses, routes).

```bash
# List network interfaces
ip link

# Show addresses on all interfaces
ip addr

# Show addresses for a specific interface
ip addr show dev eth0

# Show routing table
ip route

# Show which route/interface would be used for a destination
ip route get 8.8.8.8
```

