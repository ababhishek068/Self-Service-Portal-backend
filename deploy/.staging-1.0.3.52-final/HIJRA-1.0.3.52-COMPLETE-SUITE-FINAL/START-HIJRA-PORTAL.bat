@echo off
setlocal
title Hijra Self Service Portal v1.0.3.52
cd /d "%~dp0SelfServiceSuite\SelfServiceBackend"

if not exist ".env" (
  echo.
  echo  [!] .env NOT FOUND
  echo      Copy your EXISTING .env from backup into:
  echo      %CD%
  echo      Do NOT use .env.example for production.
  echo.
  pause
  exit /b 1
)

if not exist "node_modules" (
  echo Installing backend dependencies ^(first run only^)...
  call npm install --omit=dev --no-audit --no-fund
)

echo.
echo ==========================================================
echo   HIJRA SELF SERVICE PORTAL  v1.0.3.52 FINAL
echo   http://YOUR-SERVER-IP:4000
echo ==========================================================
echo.
node dist\server.js
pause
