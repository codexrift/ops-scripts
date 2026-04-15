@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "SCRIPT_DIR=%~dp0"
set "CMDLIST=%SCRIPT_DIR%.cmdlist"

if not exist "%CMDLIST%" (
  echo cmdhelp: missing cmdlist file: %CMDLIST%
  exit /b 1
)

set "QUERY=%*"

if "%QUERY%"=="" (
  type "%CMDLIST%"
  exit /b 0
)

rem Case-insensitive search; show matching lines
findstr /i /c:"%QUERY%" "%CMDLIST%"
