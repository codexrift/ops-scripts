@echo off

:: powershell -Command "irm https://aka.ms/getwinget -OutFile winget.msixbundle; Add-AppxPackage winget.msixbundle"
winget upgrade --id Microsoft.AppInstaller --silent --accept-package-agreements --accept-source-agreements
set WINGET_INSTALL=winget install -e -h --accept-package-agreements --accept-source-agreements --id

::BASE
call %WINGET_INSTALL% 7zip.7zip & :: 7-Zip - File Compression - Create/extract compressed archives.
call %WINGET_INSTALL% Adobe.Acrobat.Reader.64-bit & :: Adobe Reader - PDF viewer - Free PDF reader.
call %WINGET_INSTALL% CodecGuide.K-LiteCodecPack.Mega & :: K-Lite Codec Pack Mega - Codec Pack - Adds media codecs to Windows.
call %WINGET_INSTALL% Google.Chrome & :: Google Chrome - Web Browser - Fast widely supported browser.
call %WINGET_INSTALL% Microsoft.BingWallpaper & :: Bing Wallpaper - Wallpaper Rotator - Auto-change desktop wallpaper with Bing images.
call %WINGET_INSTALL% Microsoft.PowerToys & :: PowerToys - Utilities Suite - Enhances Windows productivity.
call %WINGET_INSTALL% Mozilla.Firefox & :: Firefox - Secondary Browser - Open-source privacy-focused browser.
call %WINGET_INSTALL% Notepad++.Notepad++ & :: Notepad++ - Text Editor - Lightweight code/text editor.
call %WINGET_INSTALL% TheDocumentFoundation.LibreOffice & :: LibreOffice - Office Suite - Full replacement for Microsoft Office.
call %WINGET_INSTALL% VideoLAN.VLC & :: VLC - Media Player - Plays all audio and video formats.
call %WINGET_INSTALL% voidtools.Everything.Alpha & :: Everything (Alpha) - File Search - Ultra-fast local file search.
call %WINGET_INSTALL% WinDirStat.WinDirStat & :: WinDirStat - Disk Usage Visualization - Shows where disk space is used.

:: SYSADMIN JOB
:: NO PACKAGE IN WINGET - Regshot – Registry Snapshot Tool – Tool for comparing Windows registry changes.
call %WINGET_INSTALL% Amazon.AWSCLI & :: AWS Cli - Cloud/DevOps utility - Unified command-line tool for AWS
call %WINGET_INSTALL% CloneSpy.CloneSpy & :: CloneSpy - Duplicate File Finder - Removes redundant/duplicate files.
call %WINGET_INSTALL% DBeaver.DBeaver.Community & :: DBeaver Community - Database Client - Universal database manager.
call %WINGET_INSTALL% Docker.DockerDesktop & :: Docker Desktop - Container Platform - Run and manage containers for development.
call %WINGET_INSTALL% gerardog.gsudo & :: gsudo – Windows sudo – Run commands as administrator.
call %WINGET_INSTALL% Git.Git & :: Git – Version Control – Tracks changes and manages source history.
call %WINGET_INSTALL% GitHub.GitHubDesktop & :: GitHub Desktop - Git GUI Client - Graphical interface for Git repositories.
call %WINGET_INSTALL% Insecure.Nmap & :: Nmap GUI Network Scanner - Network Scanner (GUI) - Scan networks with graphical front end.
call %WINGET_INSTALL% Microsoft.Sysinternals.Suite & :: Sysinternals Suite - Troubleshooting Toolkit.
call %WINGET_INSTALL% Microsoft.Teams & :: Microsoft Teams - Collaboration Tool - Chat & meetings for work.
call %WINGET_INSTALL% Microsoft.VisualStudioCode & :: Visual Studio Code - Code Editor - Primary programming editor.
call %WINGET_INSTALL% mRemoteNG.mRemoteNG & :: mRemoteNG - Remote Desktop Manager - Tabbed terminals for remote access.
call %WINGET_INSTALL% Paessler.PRTGDesktop & :: PRTG Desktop – Network Monitoring Client – Real-time monitoring interface for PRTG
call %WINGET_INSTALL% Postman.Postman & :: Postman - API Testing - API development & testing platform.
call %WINGET_INSTALL% PuTTY.PuTTY & :: PuTTY - SSH Client - Telnet/SSH terminal app.
call %WINGET_INSTALL% RARLab.WinRAR & :: 7-WinRAR - File Compression - Create/extract compressed archives.
call %WINGET_INSTALL% TeamViewer.TeamViewer & :: Teamviewer - Remote-access - Remote access of computers over the internet
call %WINGET_INSTALL% WinSCP.WinSCP & :: WinSCP – File Transfer Client – Securely upload, download, and manage remote files
call %WINGET_INSTALL% WiresharkFoundation.Wireshark & :: Wireshark - Packet Analyzer - Deep packet inspection and network analysis.

::CREATIVE
:: NO PACKAGE IN WINGET - MadMapper – Projection Mapping Software – Video mapping, LED control, and live visual performance tools.
:: NO PACKAGE IN WINGET - MilkDrop – Music Visualization Engine – Real-time audio-reactive graphics and preset-based visualizations.
:: NO PACKAGE IN WINGET - Rekordbox - DJ Performance - DJ music library and performance system.
:: NO PACKAGE IN WINGET - Serato – DJ Performance – DJ music library and performance system.
call %WINGET_INSTALL% AlexanderKojevnikov.Spek & :: Spek - Audio Spectrum Analyzer - Visualize audio spectrograms.
call %WINGET_INSTALL% Audacity.Audacity & :: Audacity - Audio Editing - Multitrack audio editing.
call %WINGET_INSTALL% BlenderFoundation.Blender & :: Blender - 3D Modeling - Complete 3D creation suite.
call %WINGET_INSTALL% Buanzo.FFmpegforAudacity & :: FFmpeg for Audacity - Audio Codec Add-on - Enables extended audio format support.
call %WINGET_INSTALL% ch.LosslessCut & :: LosslessCut - Lossless Video Cutter - Fast lossless video trimming and cutting.
call %WINGET_INSTALL% dotPDN.PaintDotNet & :: Paint.NET - Lightweight Image Editor - Simple and fast image editor.
call %WINGET_INSTALL% DuongDieuPhap.ImageGlass & :: ImageGlass - Modern Image Viewer - Minimalist modern image viewer.
call %WINGET_INSTALL% FlorianHeidenreich.Mp3tag & :: Mp3tag - Music Tag Editor - Edit audio metadata tags.
call %WINGET_INSTALL% FxSound.FxSound & :: FxSound - Audio Enhancer - Improve system sound output.
call %WINGET_INSTALL% GIMP.GIMP.3 & :: GIMP 3 - Image Editing - Advanced raster graphics editor.
call %WINGET_INSTALL% HandBrake.HandBrake & :: HandBrake - Video Converter - Video transcoder and compressor.
call %WINGET_INSTALL% Inkscape.Inkscape & :: Inkscape - Vector Graphics - Professional vector illustrator.
call %WINGET_INSTALL% IrfanSkiljan.IrfanView & :: IrfanView - Image Viewer - Lightweight and fast viewer.
call %WINGET_INSTALL% irzyxa.Volume2Portable & :: Volume2 (Portable) - Volume Control Utility - Advanced audio volume control.
call %WINGET_INSTALL% Meltytech.Shotcut & :: Shotcut - Video Editing - Non-linear video editor.
call %WINGET_INSTALL% OBSProject.OBSStudio & :: OBS Studio - Screen Recording / Streaming - Recording and streaming suite.
call %WINGET_INSTALL% XnSoft.XnView.Classic & :: XnView Classic - Image Viewer Manager - Image viewer with catalog features.

::GAMING
call %WINGET_INSTALL% EpicGames.EpicGamesLauncher & :: Epic Games Launcher - Game Store - Weekly free games.
call %WINGET_INSTALL% Libretro.RetroArch & :: RetroArch - Frontend for emulators, game engines, and media players
call %WINGET_INSTALL% Valve.Steam & :: Steam - Game Platform - PC games launcher/store.

::MISC
:: NO PACKAGE IN WINGET - FreeFileSync - File Synchronization - Synchronize & mirror local folders.
:: NO PACKAGE IN WINGET - Screamer Radio 0.4.4 - Internet Radio - Streaming radio player.
call %WINGET_INSTALL% AntSoftware.AntRenamer & :: Ant Renamer - Batch File Renamer - Automatic file renaming.
call %WINGET_INSTALL% AtomixProductions.VirtualDJ & :: VirtualDJ - DJ Mixing - Music mixing/DJing software.
call %WINGET_INSTALL% AutoHotkey.AutoHotkey & :: AutoHotkey - Automation & Macros - Hotkeys/scripting automation.
call %WINGET_INSTALL% Bitwarden.Bitwarden & :: Bitwarden - Password Manager - Secure cloud password vault.
call %WINGET_INSTALL% BleachBit.BleachBit & :: BleachBit - System Cleaner - Clean junk and caches.
call %WINGET_INSTALL% calibre.calibre & :: Calibre - eBook Manager - Manage and convert eBooks.
call %WINGET_INSTALL% CodeSector.TeraCopy & :: TeraCopy - File Transfer Utility - Fast and reliable copying.
call %WINGET_INSTALL% CPUID.HWMonitor & :: HWMonitor - Hardware Sensor Monitor - Lightweight real-time hardware monitoring.
call %WINGET_INSTALL% CrystalDewWorld.CrystalDiskInfo & :: CrystalDiskInfo - Disk Health - SMART monitoring for drives.
call %WINGET_INSTALL% Discord.Discord & :: Discord - Communication - Free voice, video, and text chat app.
call %WINGET_INSTALL% Ditto.Ditto & :: Ditto - Clipboard Manager - Persistent clipboard history.
call %WINGET_INSTALL% Eraser.Eraser & :: Eraser – Secure Data Wiping Software – Tool for securely erasing files, folders, and drives.
call %WINGET_INSTALL% GlassWire.GlassWire & :: GlassWire - Network Usage Monitor - Visual network activity and usage monitoring.
call %WINGET_INSTALL% Google.GoogleDrive & :: Google Drive - Cloud Storage Sync - Google Drive desktop sync.
call %WINGET_INSTALL% Henry++.simplewall & :: simplewall - Firewall Controller - Simple WFP rules manager.
call %WINGET_INSTALL% Joplin.Joplin & :: Joplin - Note Taking - Markdown-based notes and knowledge base app.
call %WINGET_INSTALL% KDE.Krita & :: Krita - Digital Painting - Painting/drawing program for artists.
call %WINGET_INSTALL% KeePassXCTeam.KeePassXC & :: KeePassXC - Local Password Manager - Local encrypted password storage (no cloud).
call %WINGET_INSTALL% Malwarebytes.Malwarebytes & :: Malwarebytes - Malware Scanner - On-demand malware removal.
call %WINGET_INSTALL% Microsoft.OpenJDK.25 & :: OpenJDK - Runtime environment - Java runtime and development tools.
call %WINGET_INSTALL% Mozilla.Thunderbird & :: Thunderbird - Email Client - Desktop email and calendar.
call %WINGET_INSTALL% NordSecurity.NordVPN & :: NordVPN - VPN - VPN client (free tier).
call %WINGET_INSTALL% OpenJS.NodeJS & :: Node.js - Runtime Environment - Javascript runtime and package ecosystem (npm).
call %WINGET_INSTALL% Oracle.VirtualBox & :: VirtualBox - Virtualization - Run virtual machines.
call %WINGET_INSTALL% PicoTorrent.PicoTorrent & :: PicoTorrent - Torrent Client - Lightweight Torrent manager.
call %WINGET_INSTALL% PointPlanck.FileBot & :: FileBot - Media Organizer - TV/movie renaming with metadata.
call %WINGET_INSTALL% Rainmeter.Rainmeter & :: Rainmeter - Desktop customization - Customizable desktop widgets.
call %WINGET_INSTALL% REALiX.HWiNFO & :: HWiNFO - Hardware Monitoring - Detailed system sensors.
call %WINGET_INSTALL% Rufus.Rufus & :: Rufus - Bootable USB Maker - Create system install USBs.
call %WINGET_INSTALL% ShareX.ShareX & :: ShareX - Screenshot / Capture - Screen captures & automation.
call %WINGET_INSTALL% Spotify.Spotify & :: Spotify - Music Streaming - Free-tier music streaming.
call %WINGET_INSTALL% Stellarium.Stellarium & :: Stellarium – Planetarium Software – Tool for exploring the night sky, stars, and planets.
call %WINGET_INSTALL% SumatraPDF.SumatraPDF & :: SumatraPDF - PDF Reader - Lightweight PDF and ebook viewer.
call %WINGET_INSTALL% Telegram.TelegramDesktop & :: Telegram Desktop - Messaging App - Fast secure communication app.
call %WINGET_INSTALL% Ventoy.Ventoy & :: Ventoy – Bootable USB Tool – Drag, drop, and boot ISO files
call %WINGET_INSTALL% WACUP.WACUP & :: WACUP - Local Music Player - Winamp-based local audio player.
call %WINGET_INSTALL% WinMerge.WinMerge & :: WinMerge - File Diff/Merge - Compare and merge files/folders.
call %WINGET_INSTALL% Zoom.Zoom & :: Zoom - Video Conferencing - Online meetings.
