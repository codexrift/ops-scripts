# netstat Cheat Sheet

Legacy network socket tool (often replaced by `ss`), still common in older environments.

## Listeners with PID/program

```bash
# Show listening TCP/UDP sockets with PID/program (requires sudo)
sudo netstat -tulpn
```

## All connections

```bash
# Show all connections with PID/program (may require sudo depending on OS)
netstat -tunap
```

## Routes

```bash
# Show routing table (numeric)
netstat -rn
```

