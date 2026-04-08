# chkconfig Cheat Sheet

Enable/disable SysV services at boot (RHEL/CentOS).

```bash
# List SysV services
sudo chkconfig --list <service>

# Enable service on boot
sudo chkconfig <service> on

# Disable service on boot
sudo chkconfig <service> off
```

