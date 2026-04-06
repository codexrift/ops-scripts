# ncdu Cheat Sheet

Disk usage analyzer (TUI). Useful for quickly finding large directories.

Scan current directory:

```bash
ncdu
```

Scan a path:

```bash
ncdu /var
```

Do not cross filesystem boundaries:

```bash
ncdu -x /
```

Output / import (for offline viewing):

```bash
ncdu -o scan.json /
ncdu -f scan.json
```

Common keys (inside UI):

- `q` quit
- `d` delete (be careful)
- `g` show % graph
- `?` help

