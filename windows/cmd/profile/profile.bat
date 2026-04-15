@echo off
setlocal EnableExtensions

set "SCRIPT_DIR=%~dp0"

rem Define handy aliases (doskey macros) for this CMD session
doskey cmdhelp=call "%SCRIPT_DIR%cmdhelp.bat" $*

endlocal
