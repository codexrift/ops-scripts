# WinGet (Windows Package Manager)

This page installs the software list used in this repo via `winget`.

## Prerequisites

- Windows 10/11
- `winget` available (installed with Microsoft "App Installer")

Quick check:

```powershell
winget --version
```

## Recommended basics

Update sources:

```powershell
winget source update
```

List installed packages / upgrades:

```powershell
winget list
winget upgrade
```

Upgrade everything (review first):

```powershell
winget upgrade --all
```

## Install everything from this list

### Install by category (recommended)

Run in PowerShell:

```powershell
$categories = @{
  Browsers = @(
    'Google.Chrome',
    'Mozilla.Firefox'
  )
  Communication = @(
    'Discord.Discord',
    'Microsoft.Teams',
    'Mozilla.Thunderbird',
    'Telegram.TelegramDesktop',
    'Zoom.Zoom'
  )
  Security = @(
    'Bitwarden.Bitwarden',
    'GlassWire.GlassWire',
    'Henry++.simplewall',
    'KeePassXCTeam.KeePassXC',
    'Malwarebytes.Malwarebytes',
    'NordSecurity.NordVPN'
  )
  Developer = @(
    'Amazon.AWSCLI',
    'DBeaver.DBeaver.Community',
    'Docker.DockerDesktop',
    'Git.Git',
    'GitHub.GitHubDesktop',
    'Insecure.Nmap',
    'Microsoft.OpenJDK.25',
    'Microsoft.VisualStudioCode',
    'mRemoteNG.mRemoteNG',
    'OpenJS.NodeJS',
    'Oracle.VirtualBox',
    'Postman.Postman',
    'PuTTY.PuTTY',
    'WinSCP.WinSCP',
    'WiresharkFoundation.Wireshark'
  )
  SystemTools = @(
    'BleachBit.BleachBit',
    'CodeSector.TeraCopy',
    'CodecGuide.K-LiteCodecPack.Mega',
    'CPUID.HWMonitor',
    'CrystalDewWorld.CrystalDiskInfo',
    'CrystalDewWorld.CrystalDiskMark',
    'Ditto.Ditto',
    'Eraser.Eraser',
    'gerardog.gsudo',
    'HaraldBoegeholz.h2testw',
    'irzyxa.Volume2Portable',
    'Microsoft.PowerToys',
    'Microsoft.Sysinternals.Suite',
    'NirSoft.USBDeview',
    'Paessler.PRTGDesktop',
    'REALiX.HWiNFO',
    'voidtools.Everything.Alpha',
    'WinDirStat.WinDirStat',
    'WinMerge.WinMerge'
  )
  Productivity = @(
    'Adobe.Acrobat.Reader.64-bit',
    'Google.GoogleDrive',
    'Joplin.Joplin',
    'Notepad++.Notepad++',
    'SumatraPDF.SumatraPDF',
    'TheDocumentFoundation.LibreOffice'
  )
  MediaCreative = @(
    'AlexanderKojevnikov.Spek',
    'AtomixProductions.VirtualDJ',
    'Audacity.Audacity',
    'BlenderFoundation.Blender',
    'Buanzo.FFmpegforAudacity',
    'ch.LosslessCut',
    'dotPDN.PaintDotNet',
    'DuongDieuPhap.ImageGlass',
    'FlorianHeidenreich.Mp3tag',
    'FxSound.FxSound',
    'GIMP.GIMP.3',
    'HandBrake.HandBrake',
    'Inkscape.Inkscape',
    'IrfanSkiljan.IrfanView',
    'KDE.Krita',
    'Meltytech.Shotcut',
    'OBSProject.OBSStudio',
    'ShareX.ShareX',
    'Spotify.Spotify',
    'Stellarium.Stellarium',
    'VideoLAN.VLC',
    'WACUP.WACUP',
    'XnSoft.XnView.Classic'
  )
  Games = @(
    'EpicGames.EpicGamesLauncher',
    'Libretro.RetroArch',
    'Valve.Steam'
  )
  StorageFiles = @(
    '7zip.7zip',
    'AntSoftware.AntRenamer',
    'calibre.calibre',
    'CloneSpy.CloneSpy',
    'PicoTorrent.PicoTorrent',
    'PointPlanck.FileBot',
    'RARLab.WinRAR'
  )
  BootUsbDesktop = @(
    'Microsoft.BingWallpaper',
    'Rainmeter.Rainmeter',
    'Rufus.Rufus',
    'Ventoy.Ventoy'
  )
}

$selectedCategories = @(
  'Browsers',
  'Communication',
  'Security',
  'Developer',
  'SystemTools',
  'Productivity',
  'MediaCreative',
  'Games',
  'StorageFiles',
  'BootUsbDesktop'
)

$packages = $selectedCategories | ForEach-Object { $categories[$_] } | Select-Object -Unique

foreach ($id in $packages) {
  winget install --id $id --exact --accept-source-agreements --accept-package-agreements --silent --disable-interactivity
}
```

Notes:

- Some packages may still prompt or fail silently depending on installer behavior.
- If you want to review each step, remove `--silent` and/or `--disable-interactivity`.

## Export / import (alternative approach)

Export installed packages to a JSON file:

```powershell
winget export -o winget-export.json
```

Reinstall from an export:

```powershell
winget import -i winget-export.json --accept-source-agreements --accept-package-agreements
```

## Software catalog (by category)

### Browsers

| WinGet ID | App | Description |
| --- | --- | --- |
| `Google.Chrome` | Google Chrome | Web browser (Chromium-based). |
| `Mozilla.Firefox` | Mozilla Firefox | Web browser focused on privacy. |

### Communication

| WinGet ID | App | Description |
| --- | --- | --- |
| `Discord.Discord` | Discord | Voice/text chat for communities. |
| `Microsoft.Teams` | Microsoft Teams | Work chat and meetings. |
| `Mozilla.Thunderbird` | Thunderbird | Desktop email and calendar client. |
| `Telegram.TelegramDesktop` | Telegram | Messaging client (desktop). |
| `Zoom.Zoom` | Zoom | Video meetings and webinars. |

### Security

| WinGet ID | App | Description |
| --- | --- | --- |
| `Bitwarden.Bitwarden` | Bitwarden | Password manager + vault sync. |
| `GlassWire.GlassWire` | GlassWire | Network monitor + firewall UI. |
| `Henry++.simplewall` | simplewall | Lightweight Windows firewall controller. |
| `KeePassXCTeam.KeePassXC` | KeePassXC | Offline password manager (KeePass). |
| `Malwarebytes.Malwarebytes` | Malwarebytes | Malware detection/cleanup tool. |
| `NordSecurity.NordVPN` | NordVPN | VPN client for secure tunneling. |

### Developer

| WinGet ID | App | Description |
| --- | --- | --- |
| `Amazon.AWSCLI` | AWS CLI | Command-line tools for AWS. |
| `DBeaver.DBeaver.Community` | DBeaver | Universal SQL database client. |
| `Docker.DockerDesktop` | Docker Desktop | Containers + local Kubernetes integration. |
| `Git.Git` | Git | Distributed version control CLI. |
| `GitHub.GitHubDesktop` | GitHub Desktop | Git GUI for GitHub workflows. |
| `Insecure.Nmap` | Nmap | Network scanner and discovery. |
| `Microsoft.OpenJDK.25` | OpenJDK 25 | Java runtime + development kit. |
| `Microsoft.VisualStudioCode` | VS Code | Code editor and extensions. |
| `mRemoteNG.mRemoteNG` | mRemoteNG | RDP/SSH/VNC session manager. |
| `OpenJS.NodeJS` | Node.js | JavaScript runtime. |
| `Oracle.VirtualBox` | VirtualBox | Desktop virtualization platform. |
| `Postman.Postman` | Postman | API client for testing. |
| `PuTTY.PuTTY` | PuTTY | SSH/Telnet client (Windows). |
| `WinSCP.WinSCP` | WinSCP | SFTP/SCP file transfer client. |
| `WiresharkFoundation.Wireshark` | Wireshark | Packet capture and analysis. |

### System tools

| WinGet ID | App | Description |
| --- | --- | --- |
| `BleachBit.BleachBit` | BleachBit | Disk cleanup and privacy cleaner. |
| `CodeSector.TeraCopy` | TeraCopy | Faster copy/move with verification. |
| `CodecGuide.K-LiteCodecPack.Mega` | K-Lite Codec Pack (Mega) | Media codecs/filters for Windows. |
| `CPUID.HWMonitor` | HWMonitor | Hardware sensors monitoring. |
| `CrystalDewWorld.CrystalDiskInfo` | CrystalDiskInfo | SMART disk health monitor. |
| `Ditto.Ditto` | Ditto | Clipboard manager/history. |
| `Eraser.Eraser` | Eraser | Secure file deletion tool. |
| `gerardog.gsudo` | gsudo | Sudo-like elevated command runner. |
| `irzyxa.Volume2Portable` | Volume2 Portable | Advanced volume control/OSD utility. |
| `Microsoft.PowerToys` | PowerToys | Windows productivity power tools. |
| `Microsoft.Sysinternals.Suite` | Sysinternals Suite | Advanced Windows admin tools. |
| `Paessler.PRTGDesktop` | PRTG Desktop | Desktop client for PRTG monitoring. |
| `REALiX.HWiNFO` | HWiNFO | Hardware info and sensors. |
| `voidtools.Everything.Alpha` | Everything (Alpha) | Instant file search (preview builds). |
| `WinDirStat.WinDirStat` | WinDirStat | Disk usage visualization. |
| `WinMerge.WinMerge` | WinMerge | File/folder diff and merge tool. |

### Productivity

| WinGet ID | App | Description |
| --- | --- | --- |
| `Adobe.Acrobat.Reader.64-bit` | Adobe Reader | PDF viewer. |
| `Google.GoogleDrive` | Google Drive | File sync client for Drive. |
| `Joplin.Joplin` | Joplin | Notes app with sync options. |
| `Notepad++.Notepad++` | Notepad++ | Lightweight text/code editor. |
| `SumatraPDF.SumatraPDF` | SumatraPDF | Fast PDF/ebook viewer. |
| `TheDocumentFoundation.LibreOffice` | LibreOffice | Office suite (docs/sheets/slides). |

### Media & creative

| WinGet ID | App | Description |
| --- | --- | --- |
| `AlexanderKojevnikov.Spek` | Spek | Audio spectrum analyzer. |
| `AtomixProductions.VirtualDJ` | VirtualDJ | DJ mixing software. |
| `Audacity.Audacity` | Audacity | Audio editor/recorder. |
| `BlenderFoundation.Blender` | Blender | 3D creation suite. |
| `Buanzo.FFmpegforAudacity` | FFmpeg for Audacity | Extra codecs for Audacity exports. |
| `ch.LosslessCut` | LosslessCut | Lossless video/audio trimming. |
| `dotPDN.PaintDotNet` | Paint.NET | Lightweight image editor. |
| `DuongDieuPhap.ImageGlass` | ImageGlass | Image viewer. |
| `FlorianHeidenreich.Mp3tag` | Mp3tag | Audio tag editor. |
| `FxSound.FxSound` | FxSound | Audio enhancement/equalizer. |
| `GIMP.GIMP.3` | GIMP | Raster graphics editor. |
| `HandBrake.HandBrake` | HandBrake | Video transcoder. |
| `Inkscape.Inkscape` | Inkscape | Vector graphics editor. |
| `IrfanSkiljan.IrfanView` | IrfanView | Fast image viewer/editor. |
| `KDE.Krita` | Krita | Digital painting and illustration. |
| `Meltytech.Shotcut` | Shotcut | Video editor. |
| `OBSProject.OBSStudio` | OBS Studio | Streaming/recording suite. |
| `ShareX.ShareX` | ShareX | Screenshot capture and sharing. |
| `Spotify.Spotify` | Spotify | Music streaming client. |
| `Stellarium.Stellarium` | Stellarium | Planetarium/sky map app. |
| `VideoLAN.VLC` | VLC | Media player for many formats. |
| `WACUP.WACUP` | WACUP | Winamp community update project. |
| `XnSoft.XnView.Classic` | XnView Classic | Image viewer and organizer. |

### Games

| WinGet ID | App | Description |
| --- | --- | --- |
| `EpicGames.EpicGamesLauncher` | Epic Games Launcher | Store + game launcher. |
| `Libretro.RetroArch` | RetroArch | Retro emulation frontend. |
| `Valve.Steam` | Steam | Game store and launcher. |

### Storage & file organization

| WinGet ID | App | Description |
| --- | --- | --- |
| `7zip.7zip` | 7-Zip | File archiver (7z/zip/rar…). |
| `AntSoftware.AntRenamer` | Ant Renamer | Batch rename utility. |
| `calibre.calibre` | Calibre | Ebook library manager. |
| `CloneSpy.CloneSpy` | CloneSpy | Duplicate file finder. |
| `PicoTorrent.PicoTorrent` | PicoTorrent | Lightweight BitTorrent client. |
| `PointPlanck.FileBot` | FileBot | Rename media files and subtitles. |
| `RARLab.WinRAR` | WinRAR | Archive manager (RAR/ZIP). |

### Boot/USB & desktop customization

| WinGet ID | App | Description |
| --- | --- | --- |
| `Microsoft.BingWallpaper` | Bing Wallpaper | Daily wallpaper changer. |
| `Rainmeter.Rainmeter` | Rainmeter | Desktop widgets/skins framework. |
| `Rufus.Rufus` | Rufus | Bootable USB creation tool. |
| `Ventoy.Ventoy` | Ventoy | Multi-ISO bootable USB toolkit. |
