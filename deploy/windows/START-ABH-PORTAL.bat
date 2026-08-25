@echo off
setlocal EnableExtensions
set "PORT=4000"
set "ROOT=%~dp0"
set "BACKEND=%ROOT%SelfServiceSuite\SelfServiceBackend"
set "ENV_TEMPLATE=%BACKEND%\deploy\windows\host.env.abh-uat-ip.example"

if not exist "%BACKEND%\dist\server.js" (
  echo.
  echo [ERROR] Missing: %BACKEND%\dist\server.js
  echo.
  echo This folder is incomplete. Run VERIFY-SUITE.bat or re-extract the full zip.
  echo Expected layout: %ROOT%SelfServiceSuite\SelfServiceBackend\dist\server.js
  echo.
  pause
  exit /b 1
)

if not exist "%BACKEND%\public\index.html" (
  echo [ERROR] Missing: %BACKEND%\public\index.html
  pause
  exit /b 1
)

pushd "%BACKEND%"

if not exist ".env" (
  if exist "%ENV_TEMPLATE%" (
    echo [SETUP] Creating .env from ABH UAT template...
    copy /Y "%ENV_TEMPLATE%" ".env" >nul
    echo [SETUP] Edit BC_NAV_PASSWORD in .env if BC login fails.
  ) else (
    echo [ERROR] .env missing and no template at deploy\windows\host.env.abh-uat-ip.example
    popd
    pause
    exit /b 1
  )
)

if not exist "node_modules\express\package.json" (
  echo Installing backend dependencies ^(first run only^)...
  call npm install --omit=dev --no-audit --no-fund
  if errorlevel 1 (
    echo [ERROR] npm install failed. Is Node.js installed?
    popd
    pause
    exit /b 1
  )
)

echo.
echo ================================================
echo   ABH Smart ESSP Enterprise Hub
echo ================================================
echo   Backend: %BACKEND%
echo   Login:   http://127.0.0.1:%PORT%/login
echo ================================================
echo.

popd
call "%ROOT%deploy\windows\kill-port.bat" %PORT%

echo Starting server in a new window...
start "ABH Portal Server" /D "%BACKEND%" cmd /k node dist\server.js

echo Waiting for portal to become ready...
set /a TRIES=0
:WAIT_HEALTH
set /a TRIES+=1
curl -s -m 2 http://127.0.0.1:%PORT%/api/health 2>nul | findstr /C:"\"ok\":true" >nul
if %ERRORLEVEL%==0 goto READY
if %TRIES% GEQ 45 (
  echo.
  echo [ERROR] Portal did not start within 45 seconds.
  echo         Check the "ABH Portal Server" window for errors.
  pause
  exit /b 1
)
timeout /t 1 /nobreak >nul
goto WAIT_HEALTH

:READY
echo.
echo Portal is ready.
start "" "http://127.0.0.1:%PORT%/login"
echo Browser opened. Keep the "ABH Portal Server" window open while using the portal.
echo.
pause
exit /b 0
