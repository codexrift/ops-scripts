# Linux Service Management Cheat Sheet

Different Linux systems use different init systems. Common ones you may encounter:

- `systemd` (most modern distros)
- SysVinit (legacy)
- Upstart (legacy, older Ubuntu)

## Detect the init system

Check PID 1:

```bash
ps -p 1 -o comm=
```

Quick checks:

```bash
command -v systemctl && systemctl --version
command -v initctl && initctl version
```

## systemd (`systemctl`)

Status:

```bash
systemctl status <service>
systemctl is-active <service>
systemctl is-enabled <service>
```

Start/stop/restart/reload:

```bash
sudo systemctl start <service>
sudo systemctl stop <service>
sudo systemctl restart <service>
sudo systemctl reload <service>
```

Enable/disable at boot:

```bash
sudo systemctl enable <service>
sudo systemctl disable <service>
sudo systemctl disable --now <service>
```

List units:

```bash
systemctl list-units --type=service --state=running
systemctl list-unit-files --type=service
```

Unit details:

```bash
systemctl cat <service>
systemctl show <service>
systemctl show <service> -p FragmentPath,ActiveState,SubState,ExecStart
```

Reload systemd configuration:

```bash
sudo systemctl daemon-reload
```

Overrides:

```bash
sudo systemctl edit <service>
sudo systemctl edit --full <service>
```

Dependencies & boot troubleshooting:

```bash
systemctl list-dependencies <service>
systemd-analyze blame
systemd-analyze critical-chain
```

Timers:

```bash
systemctl list-timers
systemctl status <timer>
```

## systemd logs (`journalctl`)

Follow logs:

```bash
journalctl -f
journalctl -u <service> -f
```

Recent entries:

```bash
journalctl -n 200
journalctl -u <service> -n 200
```

Time ranges / boots:

```bash
journalctl --since "2026-04-01 08:00" --until "2026-04-01 12:00"
journalctl --since "1 hour ago"
journalctl -b
journalctl -b -1
```

Priorities:

```bash
journalctl -p err
journalctl -p warning..alert
```

Output formats:

```bash
journalctl -o short-iso
journalctl -o cat
journalctl -o json-pretty
```

“What just happened?”:

```bash
journalctl -xe
```

## SysVinit (legacy)

Service status:

```bash
service --status-all
service <service> status
```

Start/stop/restart:

```bash
sudo service <service> start
sudo service <service> stop
sudo service <service> restart
```

Direct scripts:

```bash
sudo /etc/init.d/<service> status
sudo /etc/init.d/<service> restart
```

Enable/disable at boot:

- Debian/Ubuntu:
  ```bash
  sudo update-rc.d <service> defaults
  sudo update-rc.d -f <service> remove
  ```
- RHEL/CentOS:
  ```bash
  sudo chkconfig --list <service>
  sudo chkconfig <service> on
  sudo chkconfig <service> off
  ```

Runlevels:

```bash
runlevel
```

## Upstart (legacy)

List jobs:

```bash
initctl list
```

Status/start/stop/restart:

```bash
status <job>
sudo start <job>
sudo stop <job>
sudo restart <job>
```

Show job config (often in `/etc/init/*.conf`):

```bash
initctl show-config <job>
```

Logs (often):

```bash
ls -la /var/log/upstart
tail -f /var/log/upstart/<job>.log
```

