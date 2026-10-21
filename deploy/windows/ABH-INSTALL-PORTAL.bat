@echo off
title ABH Portal Install Helper v1.0.3.352
cd /d "%~dp0"

echo.
echo === ABH Portal v1.0.3.352 ===
echo.

if not exist "SelfServiceSuite\SelfServiceBackend\.env" (
  echo [!] MISSING: SelfServiceSuite\SelfServiceBackend\.env
  echo.
  echo     1. Copy your OLD working .env here, OR
  echo     2. Copy ENV-TEMPLATE.txt to .env and edit BC_NAV_PASSWORD
  echo.
  pause
  exit /b 1
)

echo Stopping old node processes...
taskkill /IM node.exe /F 2>nul

cd SelfServiceSuite\SelfServiceBackend
echo Starting portal on port 4000...
echo Check: http://100.124.82.121:4000/api/portal-build  (must show v201 / 1.0.3.352)
echo.
node dist\server.js
pause
