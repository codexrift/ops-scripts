@echo off
setlocal EnableExtensions

set "SRC_DIR=%~dp0"
set "TARGET_DIR=%USERPROFILE%\.cmd.profile.custom"
set "TARGET_PROFILE=%TARGET_DIR%\profile.bat"

if not exist "%TARGET_DIR%" mkdir "%TARGET_DIR%" >nul 2>&1

copy /y "%SRC_DIR%.cmdlist" "%TARGET_DIR%\.cmdlist" >nul
copy /y "%SRC_DIR%cmdhelp.bat" "%TARGET_DIR%\cmdhelp.bat" >nul
copy /y "%SRC_DIR%profile.bat" "%TARGET_PROFILE%" >nul

echo Installed CMD profile files to: %TARGET_DIR%

set "KEY=HKCU\Software\Microsoft\Command Processor"
set "NAME=AutoRun"
set "LOADER=call \"%TARGET_PROFILE%\""

set "MODE=enable"
if /i "%~1"=="/disable" set "MODE=disable"
if /i "%~1"=="disable" set "MODE=disable"
if /i "%~1"=="/enable" set "MODE=enable"
if /i "%~1"=="enable" set "MODE=enable"

if /i "%MODE%"=="disable" goto :disable
goto :enable

:disable
reg query "%KEY%" /v "%NAME%" >nul 2>nul
if errorlevel 1 (
  echo AutoRun not set.
  goto :printhelp
)

rem Only remove AutoRun automatically if it is exactly our loader.
reg query "%KEY%" /v "%NAME%" 2>nul | findstr /i /c:"%LOADER%" >nul
if errorlevel 1 (
  reg query "%KEY%" /v "%NAME%" 2>nul | findstr /i /c:"%TARGET_PROFILE%" >nul
  if errorlevel 1 (
    echo AutoRun does not reference: %TARGET_PROFILE%
  ) else (
    echo AutoRun contains other commands; not modifying automatically.
    echo Remove the cmdhelp part manually in: %KEY%\%NAME%
  )
  goto :printhelp
)

reg delete "%KEY%" /v "%NAME%" /f >nul
echo Disabled cmd.exe AutoRun (removed HKCU AutoRun value).
goto :printhelp

:enable
reg query "%KEY%" /v "%NAME%" >nul 2>nul
if errorlevel 1 (
  reg add "%KEY%" /v "%NAME%" /t REG_EXPAND_SZ /d "%LOADER%" /f >nul
  echo Enabled cmd.exe AutoRun for cmdhelp.
  goto :printhelp
)

reg query "%KEY%" /v "%NAME%" 2>nul | findstr /i /c:"%TARGET_PROFILE%" >nul
if errorlevel 1 (
  echo AutoRun already set; not modifying automatically.
  echo To enable cmdhelp AutoRun, append this to your AutoRun value:
  echo   %LOADER%
) else (
  echo AutoRun already references: %TARGET_PROFILE%
)

:printhelp
echo.
echo Current session:
echo   call "%TARGET_PROFILE%"
echo.
echo New Command Prompts (AutoRun):
echo   install-profile.bat    ^(enable, default^)
echo   install-profile.bat /disable
echo.
echo Use:
echo   cmdhelp ssh
endlocal
