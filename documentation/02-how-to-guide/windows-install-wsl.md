---
title: "WSL how-to: install WSL and a Linux distro (Windows 10/11)"
type: "how-to"
owner: "u115478"
last_updated: "2026-04-28"
---

# WSL how-to: install WSL and a Linux distro (Windows 10/11)

## Summary

- **Outcome:** A working WSL distro with an interactive Linux shell on Windows.
- **Use when:** You need Linux tooling on a Windows workstation (dev tools, scripting, SSH, containers, etc.).
- **Do not use when:** Your org prohibits WSL (follow your internal workstation baseline).
- **Time / effort:** 10-30 minutes (plus updates)
- **Risk level:** low

## Cheat sheet

### Install (recommended default)

```powershell
wsl --install
```

### Choose distro

```powershell
wsl --list --online
wsl --install -d Ubuntu
```

### Verify

```powershell
wsl --status
wsl -l -v
```

## Preconditions

### Required access

- Windows 10/11 with local admin rights

### Required inputs

- Distro name (example: `Ubuntu`)

### Required tools

- PowerShell

## Safety

### Notes

- Virtualization should be enabled in BIOS/UEFI for WSL 2.
- Store access may be restricted on corporate images; follow internal software distribution if required.

## Steps

1. Open **PowerShell as Administrator**.
2. Install WSL (and the default distro):
   ```powershell
   wsl --install
   ```
3. Reboot if prompted.
4. (Optional) Install a specific distro:
   ```powershell
   wsl --list --online
   wsl --install -d Ubuntu
   ```
5. (Recommended) Make WSL 2 the default for new distros:
   ```powershell
   wsl --set-default-version 2
   ```
6. Launch WSL and complete first-time setup (create the Linux user):
   ```powershell
   wsl
   ```
7. Update packages inside Linux (Ubuntu/Debian example):
   ```bash
   sudo apt update
   sudo apt -y upgrade
   ```

## Verification

From Windows:

```powershell
wsl --status
wsl -l -v
```

From within WSL:

```bash
uname -a
whoami
```

## Rollback / Undo

Remove a specific distro:

```powershell
wsl -l
wsl --unregister <DistroName>
```

Uninstall WSL components:

- Windows **Settings** -> **Apps** -> uninstall your distro(s)
- Windows **Turn Windows features on or off** -> disable **Windows Subsystem for Linux** / **Virtual Machine Platform** (if enabled)

## Edge cases

WSL installs but runs as version 1:

```powershell
wsl -l -v
wsl --set-version <DistroName> 2
```

Kernel update required:

```powershell
wsl --update
```

## Related docs

- `documentation/03-reference/networking-reference.md` (useful for WSL connectivity checks)

