# kill Cheat Sheet

Send signals to processes.

## Common signals

- `TERM` (15): ask process to stop gracefully (default)
- `KILL` (9): force stop (no cleanup)
- `HUP` (1): reload / hangup (depends on program)

List signals:

```bash
kill -l
```

## Kill by PID

Graceful:

```bash
kill <PID>
kill -TERM <PID>
```

Force:

```bash
kill -KILL <PID>
```

## Kill by name

```bash
pkill nginx
pkill -f "python .*app.py"
killall nginx
```

## Find PID then kill

```bash
ps aux | grep nginx
```

