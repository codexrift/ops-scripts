# Windows Optimization (Checklist)

Practical baseline tweaks for a clean, stable Windows setup.

## Quick “first hour” checklist

- Run Windows Update and reboot until fully up to date.
- Install GPU + chipset/network drivers if Windows Update didn’t cover them.
- Confirm Windows Security (Defender + Firewall) is enabled.
- Create a restore point.
- Enable file extensions in File Explorer.
- Review startup apps and disable what you don’t need.

## Useful built-in tools

- Startup apps: Task Manager (`Ctrl` + `Shift` + `Esc`) → `Startup apps`
- Services: `services.msc`
- Scheduled tasks: `taskschd.msc`
- System restore: `Control Panel` → `System` → `System protection`

## Security & system safety

- Activate Windows with a valid license (`Settings` → `System` → `Activation`).
- Install Windows Updates (`Settings` → `Windows Update`) and reboot until fully up to date.
- Update device drivers (OEM tools or Windows Update “Optional updates”).
- Update GPU driver (NVIDIA / AMD / Intel) if you use gaming or GPU workloads.
- Set UAC to maximum (`Control Panel` → `User Accounts` → `Change User Account Control settings`).
- Ensure Windows Security is enabled (Defender + Firewall).
- Create a restore point:
  - `Control Panel` → `System` → `System protection` → `Create`
- Check disk if you suspect errors:
  ```powershell
  chkdsk C: /f /r
  ```

## Appearance & comfort

- Enable Dark mode (`Settings` → `Personalization` → `Colors`).
- Disable system sounds (`Control Panel` → `Sound` → `Sounds` tab).
- Enable Night light (choose a comfortable strength/schedule).
- Enable HDR if supported (`Settings` → `System` → `Display`).
- Set display scaling to a readable value (`Settings` → `System` → `Display`).

## Notifications & taskbar

- Configure notifications and “Do not disturb” (`Settings` → `System` → `Notifications`).
- Show all tray icons (Taskbar settings → “Other system tray icons”).
- Pin your most-used apps to Start/Taskbar.

## File Explorer & desktop organization

- Disable “Group by” in File Explorer for simpler lists (Folder view options).
- Show file extensions (`File Explorer` → `View` → `Show` → `File name extensions`).
- Keep desktop clean (e.g., store shortcuts in a `Softwares` folder).
- Rename drives if you use multiple volumes (e.g., `SYSTEM`, `DATA`).

## Performance & daily use

- Choose an appropriate power mode (Balanced is usually fine).
- Uninstall bloatware you don’t use (`Settings` → `Apps` → `Installed apps`).
- Set up backups:
  - OneDrive (user files) and/or external disk backups

## Startup configuration (what runs on sign-in)

Primary places to manage startup items:

- `Settings` → `Apps` → `Startup`
- Task Manager (`Ctrl` + `Shift` + `Esc`) → `Startup apps`
- App settings (look for “Start with Windows”)

Startup folders:

- User:
  - `shell:startup`
  - `C:\Users\<YourUsername>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`
- All users:
  - `shell:common startup`
  - `C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup`

Advanced (use with care):

- Services: `services.msc` (Startup type: Automatic / Manual / Disabled)
- Scheduled tasks: `taskschd.msc` (disable “At startup”/“At log on” triggers you don’t need)
- System config: `msconfig` (Win11 redirects to Task Manager)
- Registry run keys:
  - `HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run`
  - `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run`
- Group Policy (Pro/Enterprise):
  - `gpedit.msc` → Computer Configuration → Windows Settings → Scripts (Startup/Shutdown)
  - `gpedit.msc` → User Configuration → Administrative Templates → System → Logon

Suggested “start with Windows” (optional): BingWallpaper, NordVPN, Rainmeter, simplewall
