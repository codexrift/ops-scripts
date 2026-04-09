# update-rc.d Cheat Sheet

Enable/disable SysV services at boot (Debian/Ubuntu).

```bash
# Enable service on boot
sudo update-rc.d <service> defaults

# Disable service on boot
sudo update-rc.d -f <service> remove
```

