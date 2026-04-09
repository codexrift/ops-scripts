# tcpdump Cheat Sheet

Packet capture and inspection.

```bash
# Capture packets on an interface (numeric output; verbose)
sudo tcpdump -i eth0 -nn -vv

# Capture only traffic to/from a port
sudo tcpdump -i eth0 port 443

# Write capture to a file
sudo tcpdump -i eth0 -w capture.pcap

# Read a capture file
tcpdump -nn -r capture.pcap
```

