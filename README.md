# ops-scripts

Personal utilities for Windows and Linux, plus small "command help" profiles (`cmdhelp`) for Bash and PowerShell.

This repo is meant for local administration and troubleshooting, not as a packaged application.

## Linux: Bash `cmdhelp`

Files:

- `linux/profile/.bashrc`: defines `cmdhelp` (searches `.cmdlist` and colorizes output)
- `linux/profile/.cmdlist`: command snippets in `command # comment` format
- `linux/profile/install-bashrc.custom.sh`: installer (copies into `~/.bashrc.custom/` and updates `~/.bashrc`)

Install (Linux/WSL):

```bash
bash linux/profile/install-bashrc.custom.sh
# or (to reload immediately in the current shell)
source linux/profile/install-bashrc.custom.sh
```

Use:

```bash
cmdhelp ssh
cmdhelp port
```

## Windows: PowerShell `cmdhelp`

Files:

- `windows/powershell/profile/cmdhelp.ps1`: implements `cmdhelp` for PowerShell
- `windows/powershell/profile/.cmdlist`: command snippets in `command # comment` format
- `windows/powershell/profile/install-profile.ps1`: installer (copies to `profile.custom` and updates `$PROFILE`)
- `windows/powershell/profile/install-profile.bat`: convenience wrapper for the installer

Install (PowerShell):

```powershell
.\windows\powershell\profile\install-profile.ps1
# or
.\windows\powershell\profile\install-profile.bat
```

Use:

```powershell
cmdhelp ssh
ch ssh
chmdhelp ssh
```

Note: `install-profile.ps1` may set the CurrentUser execution policy to `RemoteSigned` (unless blocked by Group Policy).

## Windows: Batch utilities

Located in `windows/cmd/`:

- `windows/cmd/system_diagnostics.bat`: collect a Windows diagnostics snapshot (can include sensitive info)
- `windows/cmd/list_files.bat`: recursive file listing across drive letters
- `windows/cmd/F15.bat`: local helper (repo-specific)

## Requirements

- Windows: Command Prompt / PowerShell
- Linux/WSL: Bash

## Repository Layout

```text
ops-scripts/
|-- docs/
|-- linux/
|   `-- profile/
|-- windows/
    |-- cmd/
    `-- powershell/
        `-- profile/
```

## Safety

These scripts operate on the local machine and may expose system details or trigger changes.

- Review each script before running it.
- Avoid sharing generated diagnostic reports without checking for sensitive information.

## License

No license file is currently present in this repository. Add one if you want to make reuse terms explicit.

