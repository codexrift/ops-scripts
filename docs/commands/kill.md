# kill Cheat Sheet

Send signals to processes.

## Common signals

- `TERM` (15): ask process to stop gracefully (default)
- `KILL` (9): force stop (no cleanup)
- `HUP` (1): reload / hangup (depends on program)

List signals:

```bash
# List all available signals
kill -l
```

## Kill by PID

Graceful:

```bash
# Send default signal (TERM) to a PID
kill <PID>

# Explicitly send SIGTERM
kill -TERM <PID>
```

Force:

```bash
# Send SIGKILL (force stop; no cleanup)
kill -KILL <PID>
```

## Kill by name

```bash
# Kill processes by name
pkill nginx

# Kill processes matching a full command line regex
pkill -f "python .*app.py"

# Kill processes by exact name (may kill multiple)
killall nginx
```

## Find PID then kill

```bash
# Find a PID by name (quick-and-dirty; may match grep itself)
ps aux | grep nginx
```
