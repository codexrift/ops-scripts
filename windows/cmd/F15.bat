title F15
echo F15... Press Ctrl+C to stop.

:loop
powershell -NoProfile -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.SendKeys]::SendWait('{F15}')"
timeout /t 60 /nobreak >nul
goto loop