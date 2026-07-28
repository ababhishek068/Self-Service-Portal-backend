@echo off
setlocal
echo Installing Self Service attendance MAC helper for current user...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install-client-mac-helper.ps1" -Scope User
if errorlevel 1 (
  echo Install failed.
  pause
  exit /b 1
)
echo.
echo Install complete. You can close this window.
pause
