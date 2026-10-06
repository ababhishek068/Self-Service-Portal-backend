@echo off
setlocal EnableExtensions
net session >nul 2>&1
if errorlevel 1 (
  echo Requesting Administrator permission...
  powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b
)

echo.
echo Installing ABH portal autostart...
echo After this server restarts, the portal will start on port 4000.
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0INSTALL-AUTOSTART.ps1"
if errorlevel 1 (
  echo.
  echo [ERROR] Autostart was not installed.
  pause
  exit /b 1
)
echo.
pause
exit /b 0
