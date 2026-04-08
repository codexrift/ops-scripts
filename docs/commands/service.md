# service Cheat Sheet

SysVinit service control (legacy systems).

## Status

```bash
# List all service status lines
service --status-all

# Show status for a specific service
service <service> status
```

## Start/stop/restart

```bash
# Start a service
sudo service <service> start

# Stop a service
sudo service <service> stop

# Restart a service
sudo service <service> restart
```

## Direct init scripts

```bash
# Call the init script directly (status)
sudo /etc/init.d/<service> status

# Call the init script directly (restart)
sudo /etc/init.d/<service> restart
```

