# ps Cheat Sheet

Process listing.

## Common listings

All processes:

```bash
# List all processes (BSD-style)
ps aux
```

Tree view:

```bash
# List processes in a tree (show parent/child relationships)
ps -ef --forest
```

## Filter

```bash
# Filter process list (quick-and-dirty; may match grep itself)
ps aux | grep nginx

# Filter process list (System V style)
ps -ef | grep sshd
```

## By PID

```bash
# Show a specific PID with custom columns
ps -p 1234 -o pid,ppid,user,etime,cmd
```

## Sort by CPU / MEM (common)

```bash
# Sort by CPU usage (descending) and show top entries
ps aux --sort=-%cpu | head

# Sort by memory usage (descending) and show top entries
ps aux --sort=-%mem | head
```
