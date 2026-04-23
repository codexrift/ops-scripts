# Windows OOBE: Create a local account (Shift+F10 + `OOBE\BYPASSNRO`)

This note documents a common way to complete Windows 11 out-of-box experience (OOBE) using a **local** Windows account during installation, by opening a command prompt with **Shift + F10** and running `OOBE\BYPASSNRO`.

> Microsoft can change OOBE flows at any time. If the UI looks different, use the same intent: bypass the network requirement and select the “limited/offline” setup path.

## Steps

1. Boot into Windows Setup and proceed until the OOBE screens (region/keyboard, etc.).
2. When you reach the screen that asks you to connect to a network / sign in, press:
   - `Shift` + `F10` (on some laptops: `Shift` + `Fn` + `F10`)
3. In the Command Prompt that opens, run:

   ```bat
   OOBE\BYPASSNRO
   ```

4. The machine will reboot and return to OOBE.
5. Continue OOBE again. On the network screen you should now have an offline option such as:
   - “I don’t have internet”
   - “Continue with limited setup”
6. Choose the offline/limited setup path and create your **local** username and password.

## After setup

- You can still add a Microsoft account later (Settings → Accounts).
- If this is a work machine, follow your organization’s standard hardening and enrollment steps after first login.

## Troubleshooting

- **Shift+F10 does nothing:** try `Shift+Fn+F10` (laptops) or use an external keyboard.
- **No offline/limited setup option after reboot:** you may not be at the right OOBE stage, or the installer flow has changed; rerun `OOBE\BYPASSNRO` and check again after the reboot.
