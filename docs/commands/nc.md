# nc Cheat Sheet

Netcat: quick TCP/UDP connectivity checks.

```bash
# Test TCP connectivity (verbose, zero-I/O)
nc -vz example.com 443

# Test UDP connectivity (verbose, zero-I/O)
nc -vzu 10.0.0.5 53
```

