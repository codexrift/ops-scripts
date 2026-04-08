# dig Cheat Sheet

DNS query tool.

```bash
# Query A/AAAA/etc. records
dig example.com

# Short output only
dig +short example.com

# Query using a specific DNS server
dig @8.8.8.8 example.com

# Trace delegation path
dig +trace example.com

# Reverse lookup (PTR)
dig -x 8.8.8.8
```

