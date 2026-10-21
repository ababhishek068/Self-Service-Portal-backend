@echo off
setlocal EnableExtensions
net session >nul 2>&1
if errorlevel 1 (
  echo Requesting Administrator permission...
  powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b
)

echo Removing ABH portal autostart tasks...
schtasks /Delete /TN "ABH Smart ESSP" /F >nul 2>&1
schtasks /Delete /TN "Self Service Portal" /F >nul 2>&1
schtasks /Delete /TN "ABH Portal" /F >nul 2>&1
echo Done. Autostart tasks removed ^(portal process not killed^).
echo Use STOP-ABH-PORTAL.bat if you also want to stop the running portal.
echo.
pause
exit /b 0
