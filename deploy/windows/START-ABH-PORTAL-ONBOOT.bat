@echo off
setlocal EnableExtensions
rem Started by the "ABH Smart ESSP" task after Windows boots. No pause, no browser.
set "PORT=4000"
if exist "%~dp0SelfServiceSuite\SelfServiceBackend\dist\server.js" (
  set "ROOT=%~dp0"
) else (
  set "ROOT=%~dp0..\..\"
)
set "BACKEND=%ROOT%SelfServiceSuite\SelfServiceBackend"
set "LOG=%ROOT%portal-autostart.log"

if not exist "%BACKEND%\dist\server.js" (
  echo [%DATE% %TIME%] Missing %BACKEND%\dist\server.js>> "%LOG%"
  exit /b 1
)
if not exist "%BACKEND%\.env" (
  echo [%DATE% %TIME%] Missing %BACKEND%\.env — copy the existing .env before autostart.>> "%LOG%"
  exit /b 1
)

call "%ROOT%deploy\windows\kill-port.bat" %PORT%
cd /d "%BACKEND%"

set "NODE=node"
if exist "%ROOT%deploy\windows\ABH-PORTAL-NODE.txt" set /p NODE=<"%ROOT%deploy\windows\ABH-PORTAL-NODE.txt"

echo [%DATE% %TIME%] Starting ABH portal on port %PORT%>> "%LOG%"
"%NODE%" dist\server.js >> "%LOG%" 2>&1
exit /b %ERRORLEVEL%
