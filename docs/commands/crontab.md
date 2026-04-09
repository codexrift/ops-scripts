# crontab Cheat Sheet

Schedule commands on Linux/Unix using cron.

## View / edit / remove

List current user's crontab:

```bash
# List current user's crontab
crontab -l
```

Edit:

```bash
# Edit current user's crontab in $EDITOR
crontab -e
```

Remove (use with care):

```bash
# Remove current user's crontab (destructive)
crontab -r
```

Other user (requires privileges):

```bash
# List another user's crontab (requires privileges)
sudo crontab -u <user> -l

# Edit another user's crontab (requires privileges)
sudo crontab -u <user> -e
```

## Format

```text
* * * * * command
| | | | |
| | | | +--- day of week (0-7; 0/7=Sun)
| | | +----- month (1-12)
| | +------- day of month (1-31)
| +--------- hour (0-23)
+----------- minute (0-59)
```

Special strings:

```text
@reboot  command
@hourly  command
@daily   command
@weekly  command
@monthly command
```

## Examples

Every 5 minutes:

```cron
# Run a job every 5 minutes
*/5 * * * * /usr/local/bin/job.sh
```

Every day at 02:15:

```cron
# Run a backup daily at 02:15
15 2 * * * /usr/local/bin/backup.sh
```

Every weekday at 08:00:

```cron
# Run a report on weekdays at 08:00
0 8 * * 1-5 /usr/local/bin/report.sh
```

Run at boot:

```cron
# Run once at boot
@reboot /usr/local/bin/startup.sh
```

Log stdout/stderr:

```cron
# Append stdout/stderr to a logfile
0 2 * * * /usr/local/bin/backup.sh >>/var/log/backup.log 2>&1
```

Avoid overlapping runs (with `flock`):

```cron
# Prevent overlapping runs using a non-blocking lockfile
*/5 * * * * flock -n /tmp/myjob.lock /usr/local/bin/job.sh
```

## Environment tips

Cron runs with a minimal environment. Prefer:

- absolute paths (`/usr/bin/python3`, `/usr/local/bin/mytool`)
- setting variables at top of crontab if needed:

```cron
# Force a predictable shell
SHELL=/bin/bash

# Provide PATH explicitly (cron's PATH is usually minimal)
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```

## System cron locations

- System-wide crontab: `/etc/crontab`
- Drop-in directories: `/etc/cron.d/`
- Periodic jobs: `/etc/cron.hourly/`, `/etc/cron.daily/`, `/etc/cron.weekly/`, `/etc/cron.monthly/`

## Troubleshooting

Service status:

```bash
# Check Debian/Ubuntu cron service status
systemctl status cron

# Check RHEL/CentOS/Fedora cron service status
systemctl status crond
```

Logs (varies by distro):

```bash
# View recent logs for cron service (Debian/Ubuntu naming)
journalctl -u cron -n 200

# View recent logs for crond service (RHEL/CentOS/Fedora naming)
journalctl -u crond -n 200
```

Common gotchas:

- missing `PATH` (command works interactively, fails in cron)
- using relative paths
- script not executable or missing shebang
- timezone differences (server TZ vs your local TZ)
