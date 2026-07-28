@echo off
setlocal
title Hijra Self Service Portal v1002
cd /d "%~dp0SelfServiceSuite\SelfServiceBackend"

if not exist ".env" (
  echo.
  echo  [!] .env NOT FOUND
  echo      Copy your existing .env into:
  echo      %CD%
  echo.
  pause
  exit /b 1
)

if not exist "node_modules" (
  echo Installing backend dependencies ^(first run only, needs internet^)...
  call npm install --omit=dev --no-audit --no-fund
)

echo.
echo ==========================================================
echo   HIJRA SELF SERVICE PORTAL  v1002
echo   API + Portal UI served on the SAME port
echo   UI is served from SelfServiceBackend\public
echo ==========================================================
echo.
node dist\server.js
pause
