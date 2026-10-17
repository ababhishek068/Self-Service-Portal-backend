@echo off
setlocal EnableExtensions
net session >nul 2>&1
if errorlevel 1 (
  echo Requesting Administrator permission...
  powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b
)

echo.
echo Installing ABH portal autostart ^(Scheduled Task: ABH Smart ESSP^)...
echo Portal port is taken from SelfServiceSuite\SelfServiceBackend\.env
echo.

rem Prefer local copy next to this bat (suite root), else deploy\windows.
set "PS1=%~dp0INSTALL-AUTOSTART.ps1"
if not exist "%PS1%" set "PS1=%~dp0deploy\windows\INSTALL-AUTOSTART.ps1"
if not exist "%PS1%" (
  echo [ERROR] INSTALL-AUTOSTART.ps1 not found next to this bat or under deploy\windows.
  pause
  exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -File "%PS1%"
if errorlevel 1 (
  echo.
  echo [ERROR] Autostart was not installed.
  pause
  exit /b 1
)
echo.
pause
exit /b 0
