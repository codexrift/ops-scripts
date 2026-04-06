@echo off
setlocal EnableExtensions EnableDelayedExpansion

where winget >nul 2>&1 || (
    echo winget not found.
    exit /b 1
)

call :update_winget_if_needed

call :maybe_install_wsl
call :ask "Install browsers?" "Google Chrome, Mozilla Firefox" && call :category_browsers
call :ask "Install chat apps?" "Discord, Telegram Desktop, Spotify" && call :category_chat
call :ask "Install meetings and email apps?" "Microsoft Teams, Mozilla Thunderbird, Zoom" && call :category_meetings
call :ask "Install cloud and VPN apps?" "AWS CLI, Google Drive, NordVPN" && call :category_cloud
call :ask "Install editors and notes apps?" "Joplin, Visual Studio Code, Notepad++" && call :category_editors
call :ask "Install developer tools?" "DBeaver Community, Git, GitHub Desktop, OpenJDK 25, Node.js, Postman" && call :category_devtools
call :ask "Install terminals and transfer tools?" "gsudo, PuTTY, WinSCP" && call :category_terminal
call :ask "Install virtualization and boot media tools?" "Docker Desktop, Oracle VirtualBox, Rufus, Ventoy" && call :category_virtualization
call :ask "Install archive and file tools?" "7-Zip, Ant Renamer, CloneSpy, TeraCopy, Ditto, Everything Alpha, WinDirStat, WinMerge" && call :category_file_utils
call :ask "Install office and document apps?" "Adobe Acrobat Reader, Calibre, SumatraPDF, LibreOffice" && call :category_documents
call :ask "Install Windows productivity tools?" "AutoHotkey, Bitwarden, BleachBit, Bing Wallpaper, PowerToys, Sysinternals Suite, Rainmeter, ShareX" && call :category_windows_utils
call :ask "Install audio creation apps?" "Spek, VirtualDJ, Audacity, FFmpeg for Audacity, Mp3tag" && call :category_audio_creation
call :ask "Install audio playback apps?" "FxSound, Volume2 Portable, WACUP" && call :category_audio_playback
call :ask "Install image viewers?" "ImageGlass, IrfanView, XnView Classic" && call :category_image_viewers
call :ask "Install design and graphics apps?" "Blender, Paint.NET, GIMP 3, Inkscape, Krita" && call :category_graphics
call :ask "Install video and streaming apps?" "LosslessCut, K-Lite Codec Pack Mega, HandBrake, RetroArch, Shotcut, OBS Studio, PicoTorrent, FileBot, WinRAR, Stellarium, VLC" && call :category_video
call :ask "Install system monitoring apps?" "HWMonitor, CrystalDiskInfo, GlassWire, PRTG Desktop, HWiNFO" && call :category_monitoring
call :ask "Install security apps?" "Eraser, simplewall, KeePassXC, Malwarebytes" && call :category_security
call :ask "Install remote access and network apps?" "Nmap, mRemoteNG, TeamViewer, Wireshark" && call :category_network
call :ask "Install games and launchers?" "Epic Games Launcher, Steam" && call :category_games

exit /b 0

:maybe_install_wsl
where wsl >nul 2>&1 || exit /b 0
wsl -l -q 2>nul | findstr /ix "Ubuntu" >nul && exit /b 0
call :ask "Install Ubuntu on WSL?" "Ubuntu" && call :install_wsl
exit /b 0

:update_winget_if_needed
set "WINGET_CHECK=%temp%\winget_appinstaller_check.txt"
winget upgrade --id Microsoft.AppInstaller --accept-source-agreements > "%WINGET_CHECK%" 2>&1

findstr /i /c:"No available upgrade found." /c:"No installed package found matching input criteria." "%WINGET_CHECK%" >nul && (
    del "%WINGET_CHECK%" >nul 2>&1
    exit /b 0
)

echo Updating winget...
winget upgrade --id Microsoft.AppInstaller --silent --accept-package-agreements --accept-source-agreements
echo.
del "%WINGET_CHECK%" >nul 2>&1
exit /b 0

:ask
echo.
echo %~1
if not "%~2"=="" echo   %~2
set "ANSWER="
set /p "ANSWER=> [Y/n] "
if not defined ANSWER exit /b 0
if /i "!ANSWER!"=="Y" exit /b 0
if /i "!ANSWER!"=="YES" exit /b 0
exit /b 1

:install_wsl
where wsl >nul 2>&1 || (
    echo WSL is not available on this Windows installation.
    echo.
    exit /b 0
)

wsl -l -q 2>nul | findstr /ix "Ubuntu" >nul && (
    echo Ubuntu is already installed on WSL.
    echo.
    exit /b 0
)

echo Installing Ubuntu on WSL...
wsl --install -d Ubuntu
echo.
exit /b 0

:category_browsers
call :install Google.Chrome "Google Chrome"
call :install Mozilla.Firefox "Mozilla Firefox"
exit /b 0

:category_chat
call :install Discord.Discord "Discord"
call :install Telegram.TelegramDesktop "Telegram Desktop"
call :install Spotify.Spotify "Spotify"
exit /b 0

:category_meetings
call :install Microsoft.Teams "Microsoft Teams"
call :install Mozilla.Thunderbird "Mozilla Thunderbird"
call :install Zoom.Zoom "Zoom"
exit /b 0

:category_cloud
call :install Amazon.AWSCLI "AWS CLI"
call :install Google.GoogleDrive "Google Drive"
call :install NordSecurity.NordVPN "NordVPN"
exit /b 0

:category_editors
call :install Joplin.Joplin "Joplin"
call :install Microsoft.VisualStudioCode "Visual Studio Code"
call :install Notepad++.Notepad++ "Notepad++"
exit /b 0

:category_devtools
call :install DBeaver.DBeaver.Community "DBeaver Community"
call :install Git.Git "Git"
call :install GitHub.GitHubDesktop "GitHub Desktop"
call :install Microsoft.OpenJDK.25 "OpenJDK 25"
call :install OpenJS.NodeJS "Node.js"
call :install Postman.Postman "Postman"
exit /b 0

:category_terminal
call :install gerardog.gsudo "gsudo"
call :install PuTTY.PuTTY "PuTTY"
call :install WinSCP.WinSCP "WinSCP"
exit /b 0

:category_virtualization
call :install Docker.DockerDesktop "Docker Desktop"
call :install Oracle.VirtualBox "Oracle VirtualBox"
call :install Rufus.Rufus "Rufus"
call :install Ventoy.Ventoy "Ventoy"
exit /b 0

:category_file_utils
call :install 7zip.7zip "7-Zip"
call :install AntSoftware.AntRenamer "Ant Renamer"
call :install CloneSpy.CloneSpy "CloneSpy"
call :install CodeSector.TeraCopy "TeraCopy"
call :install Ditto.Ditto "Ditto"
call :install voidtools.Everything.Alpha "Everything Alpha"
call :install WinDirStat.WinDirStat "WinDirStat"
call :install WinMerge.WinMerge "WinMerge"
exit /b 0

:category_documents
call :install Adobe.Acrobat.Reader.64-bit "Adobe Acrobat Reader"
call :install calibre.calibre "Calibre"
call :install SumatraPDF.SumatraPDF "SumatraPDF"
call :install TheDocumentFoundation.LibreOffice "LibreOffice"
exit /b 0

:category_windows_utils
call :install AutoHotkey.AutoHotkey "AutoHotkey"
call :install Bitwarden.Bitwarden "Bitwarden"
call :install BleachBit.BleachBit "BleachBit"
call :install Microsoft.BingWallpaper "Bing Wallpaper"
call :install Microsoft.PowerToys "PowerToys"
call :install Microsoft.Sysinternals.Suite "Sysinternals Suite"
call :install Rainmeter.Rainmeter "Rainmeter"
call :install ShareX.ShareX "ShareX"
exit /b 0

:category_audio_creation
call :install AlexanderKojevnikov.Spek "Spek"
call :install AtomixProductions.VirtualDJ "VirtualDJ"
call :install Audacity.Audacity "Audacity"
call :install Buanzo.FFmpegforAudacity "FFmpeg for Audacity"
call :install FlorianHeidenreich.Mp3tag "Mp3tag"
exit /b 0

:category_audio_playback
call :install FxSound.FxSound "FxSound"
call :install irzyxa.Volume2Portable "Volume2 Portable"
call :install WACUP.WACUP "WACUP"
exit /b 0

:category_image_viewers
call :install DuongDieuPhap.ImageGlass "ImageGlass"
call :install IrfanSkiljan.IrfanView "IrfanView"
call :install XnSoft.XnView.Classic "XnView Classic"
exit /b 0

:category_graphics
call :install BlenderFoundation.Blender "Blender"
call :install dotPDN.PaintDotNet "Paint.NET"
call :install GIMP.GIMP.3 "GIMP 3"
call :install Inkscape.Inkscape "Inkscape"
call :install KDE.Krita "Krita"
exit /b 0

:category_video
call :install ch.LosslessCut "LosslessCut"
call :install CodecGuide.K-LiteCodecPack.Mega "K-Lite Codec Pack Mega"
call :install HandBrake.HandBrake "HandBrake"
call :install Libretro.RetroArch "RetroArch"
call :install Meltytech.Shotcut "Shotcut"
call :install OBSProject.OBSStudio "OBS Studio"
call :install PicoTorrent.PicoTorrent "PicoTorrent"
call :install PointPlanck.FileBot "FileBot"
call :install RARLab.WinRAR "WinRAR"
call :install Stellarium.Stellarium "Stellarium"
call :install VideoLAN.VLC "VLC"
exit /b 0

:category_monitoring
call :install CPUID.HWMonitor "HWMonitor"
call :install CrystalDewWorld.CrystalDiskInfo "CrystalDiskInfo"
call :install GlassWire.GlassWire "GlassWire"
call :install Paessler.PRTGDesktop "PRTG Desktop"
call :install REALiX.HWiNFO "HWiNFO"
exit /b 0

:category_security
call :install Eraser.Eraser "Eraser"
call :install Henry++.simplewall "simplewall"
call :install KeePassXCTeam.KeePassXC "KeePassXC"
call :install Malwarebytes.Malwarebytes "Malwarebytes"
exit /b 0

:category_network
call :install Insecure.Nmap "Nmap"
call :install mRemoteNG.mRemoteNG "mRemoteNG"
call :install TeamViewer.TeamViewer "TeamViewer"
call :install WiresharkFoundation.Wireshark "Wireshark"
exit /b 0

:category_games
call :install EpicGames.EpicGamesLauncher "Epic Games Launcher"
call :install Valve.Steam "Steam"
exit /b 0

:install
call :is_installed "%~1"
if not errorlevel 1 (
    echo %~2 is already installed.
    echo.
    exit /b 0
)

echo Installing %~2...
winget install -e -h --accept-package-agreements --accept-source-agreements --id %~1
echo.
exit /b 0

:is_installed
set "WINGET_INSTALLED_CHECK=%temp%\winget_installed_%RANDOM%.txt"
winget list --id %~1 -e --accept-source-agreements > "%WINGET_INSTALLED_CHECK%" 2>&1
findstr /i /c:"No installed package found matching input criteria." "%WINGET_INSTALLED_CHECK%" >nul && (
    del "%WINGET_INSTALLED_CHECK%" >nul 2>&1
    exit /b 1
)

del "%WINGET_INSTALLED_CHECK%" >nul 2>&1
exit /b 0
