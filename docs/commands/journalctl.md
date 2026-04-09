# journalctl Cheat Sheet

Query systemd journal logs.

## Follow logs

```bash
# Follow logs for all units
journalctl -f

# Follow logs for a specific unit
journalctl -u <service> -f
```

## Recent entries

```bash
# Show last 200 log entries
journalctl -n 200

# Show last 200 entries for a unit
journalctl -u <service> -n 200
```

## Time ranges / boots

```bash
# Show logs between absolute timestamps
journalctl --since "2026-04-01 08:00" --until "2026-04-01 12:00"

# Show logs since a relative time
journalctl --since "1 hour ago"

# Show logs for current boot
journalctl -b

# Show logs for previous boot
journalctl -b -1
```

## Priorities

```bash
# Show only errors
journalctl -p err

# Show warnings through alerts
journalctl -p warning..alert
```

## Output formats

```bash
# ISO timestamps
journalctl -o short-iso

# Message-only output (no metadata)
journalctl -o cat

# Pretty JSON output
journalctl -o json-pretty

# Show recent important messages and explain errors
journalctl -xe
```

