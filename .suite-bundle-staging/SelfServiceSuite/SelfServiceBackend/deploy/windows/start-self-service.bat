@echo off
setlocal

cd /d "%~dp0..\.."

if not exist ".env" (
  echo ERROR: .env is missing in %CD%
  pause
  exit /b 1
)

if not exist "dist\server.js" (
  echo ERROR: dist\server.js is missing. Build the backend before deployment.
  pause
  exit /b 1
)

if not exist "public\index.html" (
  echo ERROR: public\index.html is missing. Run npm run build:all before deployment.
  pause
  exit /b 1
)

if not exist "logs" mkdir "logs"

set NODE_ENV=production

echo Starting Self Service Portal...
echo Open http://HOST-IP:4000 from another device.
echo Press Ctrl+C to stop.
echo.

node dist\server.js >> logs\server-console.log 2>&1
