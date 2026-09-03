@echo off
title ABH Portal Install Helper v1.0.3.345
cd /d "%~dp0"

echo.
echo === ABH Portal v1.0.3.345 ===
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
echo Check: http://146.161.102.7:4000/api/portal-build  (must show v194 / 1.0.3.345)
echo.
node dist\server.js
pause
