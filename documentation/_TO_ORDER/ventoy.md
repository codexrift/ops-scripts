# Ventoy (Bootable USB Toolkit)

Ventoy lets you create a bootable USB drive where you simply copy ISO files (and optionally other image formats) onto the drive. At boot time, Ventoy shows a menu to pick which ISO to boot.

## Create a Ventoy USB drive

1. Download Ventoy from the official project release page.
2. Plug in the target USB drive.
3. Run the Ventoy installer (`Ventoy2Disk`) as Administrator.
4. Select the correct USB device.
5. Click `Install` (this wipes the USB drive).

## Add ISOs

After Ventoy is installed, the USB drive contains a normal data partition.

- Copy ISO files to the Ventoy USB (root or folders, your choice).
- Safely eject and boot from the USB.
- Select the ISO from the Ventoy boot menu.

Suggested folder layout:

```text
VentoyUSB:/
  ISOs/
    Windows/
    Linux/
    Rescue/
```

## Secure Boot

Depending on your machine, Secure Boot may block booting Ventoy.

Common options:

- Disable Secure Boot in firmware (fastest).
- Enroll Ventoy’s Secure Boot key (Ventoy provides a helper utility for this).

## Persistence (Linux live ISOs)

Persistence lets a live distro keep changes across reboots.

Typical flow:

1. Create a persistence file (Ventoy includes tools/utilities for this).
2. Enable a persistence plugin configuration.
3. Boot the ISO and select the persistence option when available.

Persistence support and configuration differs per distro.

## Updating Ventoy

Ventoy can be updated without re-copying ISOs in most cases:

1. Run the Ventoy installer again.
2. Select the same USB device.
3. Choose `Update`.

## Troubleshooting

- UEFI vs Legacy: try toggling boot mode in BIOS/UEFI.
- USB not detected: try another port (especially USB 2.0 vs 3.x), or disable “Fast Boot”.
- Some ISOs need special modes: Ventoy includes boot options/compat modes in its menu.
- BitLocker: if you boot Windows recovery media, have your recovery key available.

## Suggested ISO library

Only keep what you actually use. Examples:

- **Memory test:** MemTest86
- **Disk/partition tools:** SystemRescue, GParted Live
- **Imaging/cloning:** Clonezilla
- **Boot repair:** Super Grub2 Disk
- **Windows recovery:** Windows 10/11 installation media, Hiren’s BootCD PE
- **Malware cleanup:** Kaspersky Rescue Disk
- **Linux desktop:** Ubuntu Desktop
- **Server rescue:** Rocky Linux (for RHEL-like environments)
- **Privacy:** Tails
- **Security testing (authorized use only):** Kali Linux, Parrot Security OS, BlackArch
