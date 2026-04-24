---
type: procedural
standard: Diataxis (How-to Guide)
owner: <team-or-role>
last_updated: 2026-04-24
---

# Windows 11 OOBE: Skip Microsoft Account and create a local account (disable NIC / go offline)

## Goal
- Complete Windows 11 Out-of-Box Experience (OOBE) without signing in to a Microsoft account
- Create a **local** user account by keeping the device **offline** during OOBE

## When to Use
- You want a local account for initial setup (lab devices, kiosks, break-glass, privacy-first installs)
- You are blocked at OOBE because it keeps requesting a Microsoft account sign-in

## Prerequisites
- Physical access to the device during OOBE
- Ability to disconnect networking:
  - Unplug Ethernet (preferred), and/or
  - Disable Wi-Fi / enable airplane mode
- Optional (recommended): a keyboard that supports `Shift+F10` (some laptops require `Fn` as well)

## Inputs
- Local username (example: `localadmin`)
- Local password (if required by your policy)
- Security questions / hints (if prompted)

## Steps
1. Boot into Windows 11 OOBE until you reach the network prompt (for example **"Let's connect you to a network"**).
2. Ensure the device is offline:
   - **Ethernet:** unplug the cable.
   - **Wi-Fi:** do not join a network; enable airplane mode if available.
3. If OOBE shows an offline option, choose it:
   - Select **"I don't have internet"** (or similar wording).
   - Then select **"Continue with limited setup"**.
4. If there is no offline option, disable the NIC from OOBE:
   1. Press `Shift+F10` to open a Command Prompt.
   2. List network adapters:
      - `netsh interface show interface`
   3. Disable the active adapter(s) (replace names as shown in the list):
      - Ethernet: `netsh interface set interface name="Ethernet" admin=disable`
      - Wi-Fi: `netsh interface set interface name="Wi-Fi" admin=disable`
   4. Close Command Prompt and go back to OOBE; proceed until the local account creation flow appears.
5. Create the local account when prompted (name, password, security questions if shown).
6. Finish OOBE and reach the Windows desktop.
7. Re-enable networking after first logon:
   - Plug Ethernet back in, and/or re-enable Wi-Fi.
   - If you disabled adapters via `netsh`, re-enable them:
     - `netsh interface set interface name="Ethernet" admin=enable`
     - `netsh interface set interface name="Wi-Fi" admin=enable`

## Verification
- Confirm the user is a local account:
  - **Settings** -> **Accounts** -> **Your info** shows **"Local account"** (not Microsoft account), or
  - Run `whoami` and confirm it is not a Microsoft-connected identity.
- Confirm network is working again (if desired):
  - Open a browser and load an internal page, or run `ping 1.1.1.1`.

## Rollback / Undo
- Convert the local account to a Microsoft account later:
  - **Settings** -> **Accounts** -> **Your info** -> **Sign in with a Microsoft account instead**
- If you disabled an adapter and lost connectivity unexpectedly:
  - Re-run `netsh interface show interface` and re-enable the adapter with `admin=enable`.

## Edge Cases / Variations
- **Device is managed (Autopilot / MDM / corporate image):** OOBE may enforce Microsoft/Entra ID sign-in and block local accounts. Follow your organization's provisioning process.
- **Only one adapter is present:** disabling it is enough; on some devices, you must disable both Ethernet and Wi-Fi to stay offline.
- **UI wording differs by version/edition:** the offline option may be hidden until Windows detects there is no usable network.

## Troubleshooting (Optional)
- If `Shift+F10` does nothing:
  - Try `Fn+Shift+F10` on laptops.
  - Try an external USB keyboard.
- If OOBE keeps returning to the network screen:
  - Confirm **all** interfaces are disconnected/disabled (Ethernet + Wi-Fi).
  - Reboot and repeat while staying offline from the start of OOBE.

## References
- Related docs (if present):
  - `documentation/_TO_ORDER/how-to/`
