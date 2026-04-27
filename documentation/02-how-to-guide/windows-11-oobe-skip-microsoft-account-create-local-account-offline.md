---
title: "Windows 11 OOBE: Skip Microsoft Account and create a local account (go offline)"
type: "how-to"
owner: "u115478"
last_updated: "2026-04-27"
---

# Windows 11 OOBE: Skip Microsoft Account and create a local account (go offline)

## Summary

- **Outcome:** Finish Windows 11 Out-Of-Box Experience (OOBE) using a local account instead of a Microsoft Account (MSA) by completing setup offline.
- **Use when:** You need a quick local account on a standalone machine / lab device, or your environment requires local accounts.
- **Do not use when:** Your org requires MSA/Entra ID sign-in, Autopilot/MDM enrollment, or has policy forbidding local accounts.
- **Time / effort:** 5-20 minutes
- **Risk level:** low (but can conflict with org compliance requirements)

## Cheat sheet

Fastest safe path (try in this order):

1) Physically disconnect networking (unplug Ethernet + disable Wi-Fi), then proceed until Windows offers local account creation.  
2) If the UI blocks you, open Command Prompt (`Shift`+`F10`) and run:

```bat
OOBE\BYPASSNRO
```

Then after reboot: choose "I don't have internet" -> "Continue with limited setup" -> create local user.

## Preconditions

### Required access

- Physical access to the device during first-boot OOBE.

### Required inputs

- Desired local username: `<local_user>`
- Desired password: `<strong password>`

### Required tools

- None (optional keyboard for easier `Shift`+`F10`).

## Safety

### Impact and blast radius

- **Impact:** Creates a local account; may delay MDM enrollment; may change how recovery keys / device identity are managed in your org.
- **Blast radius:** single device.

### Preconditions for running in a managed environment

- [ ] Confirm your organization allows local accounts on Windows 11.
- [ ] Confirm enrollment requirements (Intune/Autopilot/MDM) and whether offline setup breaks them.
- [ ] If you must enroll later, confirm you still can (and how).

### Rollback plan (required)

**Rollback triggers**

- Device must be enrolled with corporate identity immediately.
- Compliance tooling fails after local account creation.

**Rollback steps (high-level)**

1. Reset the device (Settings -> System -> Recovery -> Reset this PC) and redo OOBE with the required sign-in flow.
2. Or, if allowed, convert later by adding an org account and disabling/removing the local account.

**Rollback validation**

- Device completes the required sign-in/enrollment flow and is compliant.

## Procedure

> **NOTE:** OOBE screens and wording vary by Windows 11 version/build and OEM image. Treat this as a pattern, not pixel-perfect UI steps.

### 1) Start OOBE normally

1. Power on the machine.
2. Select region and keyboard layout.

### 2) Go offline (recommended)

Do this before the "Let's connect you to a network" / account screens if possible.

#### Option A (simplest): physical disconnect

- Unplug Ethernet.
- Turn off Wi-Fi (hardware switch / airplane mode / BIOS toggle if available).

Proceed through OOBE and look for:

- "I don't have internet"
- "Continue with limited setup"

If those options appear, choose them and skip to Step 4.

#### Option B: disable network from OOBE Command Prompt

1. Press `Shift`+`F10` to open Command Prompt (may be `Shift`+`Fn`+`F10` on laptops).
2. Disable networking (pick what applies):

```bat
ipconfig /release
```

If you need to disable an interface explicitly (names vary):

```bat
netsh interface show interface
netsh interface set interface name="Ethernet" admin=disabled
netsh interface set interface name="Wi-Fi" admin=disabled
```

Close Command Prompt and continue OOBE; choose offline/limited setup if offered.

### 3) If Windows still blocks local setup: use `OOBE\BYPASSNRO`

Some OOBE flows strongly push online sign-in. If the offline options are missing:

1. Press `Shift`+`F10`.
2. Run:

```bat
OOBE\BYPASSNRO
```

The device should reboot back into OOBE.

3. After reboot, repeat Step 2 (go offline) and look again for:
   - "I don't have internet"
   - "Continue with limited setup"

### 4) Create the local account

1. Enter local username: `<local_user>`
2. Set a strong password and security questions (if prompted).
3. Complete remaining privacy / telemetry screens per your preference/policy.

### 5) Post-OOBE checks (recommended)

After you land on the desktop:

1. Confirm account type:
   - Settings -> Accounts -> Your info (should indicate local account)
2. Rename the PC if needed (before domain/MDM joining):
   - Settings -> System -> About -> Rename this PC
3. Reconnect networking and run updates:
   - Windows Update
   - OEM driver updates (if applicable)

## Troubleshooting

### `Shift`+`F10` does nothing

Likely causes:

- OEM image or policy disables Command Prompt in OOBE.
- Laptop requires `Fn` key for F-keys.

Fix:

- Try `Shift`+`Fn`+`F10`.
- Try a USB keyboard.
- Use physical disconnect only (Option A).

### No "I don't have internet" / "Continue with limited setup"

Likely causes:

- Windows build/OEM flow hides the offline option unless network is fully disconnected.

Fix:

- Ensure *all* networking is disabled (Ethernet unplugged + Wi-Fi off).
- Use `OOBE\BYPASSNRO` then return offline.

### You accidentally signed in with MSA and want local instead

Options (depends on policy):

- Create a new local admin account after first boot, then sign out and migrate.
- Or reset the PC and redo OOBE offline.

## Best Practices

- Use a strong local admin password; store it securely (password manager).
- Create a standard (non-admin) daily user after setup if you want least privilege.
- If the device will be managed later, confirm naming/enrollment requirements before doing anything irreversible.
- After offline setup, reconnect and patch immediately (Windows Update + drivers).
- Document what you did (Windows version/build, what method worked) because OOBE behavior can change across updates.

## Notes / exceptions

- In corporate environments, the preferred approach is often Autopilot/Intune or an unattended deployment rather than manual OOBE workarounds.
- If BitLocker/device encryption is enabled, confirm how recovery keys are handled in your environment when using local accounts.

## References

- Internal policy/baseline: `<link>`
- Microsoft documentation (if your org requires citations): `<link>`

