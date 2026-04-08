# initctl Cheat Sheet

Upstart init system control (legacy, older Ubuntu).

## List jobs

```bash
# List upstart jobs
initctl list
```

## Status/start/stop/restart

```bash
# Show job status
status <job>

# Start a job
sudo start <job>

# Stop a job
sudo stop <job>

# Restart a job
sudo restart <job>
```

## Show config

```bash
# Show job configuration
initctl show-config <job>
```

## Logs

```bash
# List upstart logs directory
ls -la /var/log/upstart

# Follow a specific job log
tail -f /var/log/upstart/<job>.log
```

