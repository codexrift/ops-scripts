---
type: procedural
standard: Diataxis (How-to Guide)
owner: <team-or-role>
last_updated: 2026-04-24
---

# Install WSL (Windows Subsystem for Linux)

## Goal
- Install WSL and a Linux distribution (distro)
- Launch a working Linux shell on Windows

## When to Use
- You need a Linux environment on a Windows workstation (dev tools, scripting, containers, SSH, etc.)
- You are setting up a new machine or rebuilding a Windows install

## Prerequisites
- Windows 10/11 with admin access
- Virtualization enabled in BIOS/UEFI (recommended for WSL 2)
- Internet access (recommended) to install and update WSL and the distro

## Inputs
- Distro name (example: `Ubuntu`)

## Steps
1. Open **PowerShell as Administrator**.
2. Install WSL (and the default distro):
   ```powershell
   wsl --install
   ```
3. Reboot if prompted.
4. (Optional) Choose a specific distro instead of the default:
   ```powershell
   wsl --list --online
   wsl --install -d Ubuntu
   ```
5. (Recommended) Ensure WSL 2 is the default for new distros:
   ```powershell
   wsl --set-default-version 2
   ```
6. Launch the distro and complete first-time setup (create the Linux user):
   ```powershell
   wsl
   ```
7. Update packages inside Linux (Ubuntu/Debian example):
   ```bash
   sudo apt update
   sudo apt -y upgrade
   ```

## Verification
- Confirm WSL is installed and the distro is running as expected:
  ```powershell
  wsl --status
  wsl -l -v
  ```
- From within WSL, confirm the Linux environment:
  ```bash
  uname -a
  whoami
  ```

## Rollback / Undo
- Remove a specific distro:
  ```powershell
  wsl -l
  wsl --unregister <DistroName>
  ```
- Uninstall WSL components:
  - Windows **Settings** -> **Apps** -> uninstall your distro(s)
  - Windows **Turn Windows features on or off** -> disable WSL / Virtual Machine Platform (if enabled)

## Edge Cases / Variations
- WSL installs but runs as version 1:
  ```powershell
  wsl -l -v
  wsl --set-version <DistroName> 2
  ```
- "WSL 2 requires an update to its kernel component":
  ```powershell
  wsl --update
  ```
- Corporate images may restrict Store installs:
  - Use `wsl --install` where allowed, or follow your internal software distribution process.

## Troubleshooting (Optional)
- If `wsl --install` fails:
  - Ensure Windows is fully updated.
  - Check virtualization is enabled (Task Manager -> Performance -> CPU -> Virtualization).
- If WSL 2 is slow or fails to start:
  - Reboot the host.
  - Confirm Hyper-V / virtualization features are not blocked by policy.

## References
- Related docs:
  - `documentation/03-reference/` (if present)

