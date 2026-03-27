# ops-scripts

Small Windows batch utilities for diagnostics, workstation setup, and file inventory tasks.

This repository is a personal utility collection centered on `.bat` scripts that run directly on Windows. The scripts are intended for local administration and troubleshooting rather than as a packaged application.

## Included Scripts

### `system_diagnostics.bat`

Collects a broad Windows diagnostics snapshot and writes the results into files in the same folder as the script.

It gathers information such as:

- OS version and system configuration
- environment variables and user security context
- BIOS, CPU, RAM, motherboard, disks, and drivers
- services, scheduled tasks, and Group Policy results
- network configuration, routes, connections, DNS, ping, and traceroute
- firewall, local users/groups, Defender status, and update services
- event logs, DISM logs, CBS logs, and crash-report directories
- battery and energy reports

Typical output files include:

- `report.txt`
- `gpresult.html`
- `batteryreport.html`
- `energyreport.html`

Run it from Command Prompt or PowerShell:

```powershell
.\system_diagnostics.bat
```

Notes:

- Some commands may return more detail when run as Administrator.
- The generated report can contain sensitive local machine data.
- The script can take a while to finish because it runs many system commands.

### `software_install.bat`

Uses `winget` to upgrade App Installer and then install a large set of applications for a Windows workstation.

The package list is grouped broadly into:

- base tools
- sysadmin and developer tools
- creative software
- gaming tools
- miscellaneous utilities

Run it with:

```powershell
.\software_install.bat
```

Notes:

- `winget` must already be available on the system.
- This script installs many packages automatically, so review the list before running it.
- Some installs may prompt, fail, or require elevation depending on package behavior and system policy.

### `list_files.bat`

Scans available drive letters from `C:` through `Z:` and writes a recursive file-only listing to `all_files.txt`.

Run it with:

```powershell
.\list_files.bat
```

Notes:

- The scan can take a long time on large disks or external drives.
- The output file may become very large.
- Access-denied messages from protected folders may still appear depending on permissions.

## Requirements

- Windows
- Command Prompt or PowerShell
- `winget` for `software_install.bat`
- Administrator privileges recommended for fuller diagnostics and some installs

## Repository Layout

```text
ops-scripts/
|-- list_files.bat
|-- software_install.bat
`-- system_diagnostics.bat
```

## Safety

These scripts operate on the local machine and may expose system details or trigger large changes.

- Review each script before running it.
- Avoid sharing generated diagnostic reports without checking them for sensitive information.
- Treat `software_install.bat` as a personal bootstrap script, not a minimal installer.

## License

No license file is currently present in this repository. Add one if you want to make reuse terms explicit.
