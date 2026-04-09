# systemctl Cheat Sheet

Manage systemd services and units.

## Status

```bash
# Show unit status (includes recent logs)
systemctl status <service>

# Exit 0 if active, non-zero otherwise
systemctl is-active <service>

# Show whether enabled at boot
systemctl is-enabled <service>
```

## Start/stop/restart/reload

```bash
# Start a service
sudo systemctl start <service>

# Stop a service
sudo systemctl stop <service>

# Restart a service
sudo systemctl restart <service>

# Reload config (if supported by unit)
sudo systemctl reload <service>
```

## Enable/disable at boot

```bash
# Enable at boot
sudo systemctl enable <service>

# Disable at boot
sudo systemctl disable <service>

# Disable and stop immediately
sudo systemctl disable --now <service>
```

## List units

```bash
# List running services
systemctl list-units --type=service --state=running

# List installed service unit files
systemctl list-unit-files --type=service
```

## Unit details

```bash
# Show unit file contents (including drop-ins)
systemctl cat <service>

# Show all properties
systemctl show <service>

# Show selected properties
systemctl show <service> -p FragmentPath,ActiveState,SubState,ExecStart
```

## Reload systemd configuration

```bash
# Reload systemd manager configuration
sudo systemctl daemon-reload
```

## Overrides

```bash
# Create an override drop-in for a unit
sudo systemctl edit <service>

# Edit the full unit file (copied into /etc; use with care)
sudo systemctl edit --full <service>
```

## Timers

```bash
# List timers
systemctl list-timers

# Show a timer status
systemctl status <timer>
```

