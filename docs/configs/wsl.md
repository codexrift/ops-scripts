# WSL Installation (Windows)

## Install

Recommended (Windows 11 / recent Windows 10):

```powershell
wsl --install
```

Reboot if prompted.

## Common follow-up commands

List distros:

```powershell
wsl --list --online
wsl --list --verbose
```

Install a specific distro:

```powershell
wsl --install -d Ubuntu
```

Set default WSL version:

```powershell
wsl --set-default-version 2
```

Update WSL:

```powershell
wsl --update
```

Shutdown all distros:

```powershell
wsl --shutdown
```

## Troubleshooting

- Check WSL status: `wsl --status`
- If WSL2 won’t start, confirm virtualization is enabled in BIOS/UEFI and Windows features support it.

