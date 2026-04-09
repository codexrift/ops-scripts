# ncdu Cheat Sheet

Disk usage analyzer (TUI). Useful for quickly finding large directories.

Scan current directory:

```bash
# Scan current directory
ncdu
```

Scan a path:

```bash
# Scan a specific path
ncdu /var
```

Do not cross filesystem boundaries:

```bash
# Do not cross filesystem boundaries
ncdu -x /
```

Output / import (for offline viewing):

```bash
# Export scan results to a file
ncdu -o scan.json /

# Import and view a previous scan
ncdu -f scan.json
```

Common keys (inside UI):

- `q` quit
- `d` delete (be careful)
- `g` show % graph
- `?` help
