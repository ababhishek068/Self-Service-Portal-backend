@echo off
setlocal EnableExtensions
rem Scheduled-task entrypoint for "ABH Smart ESSP". No pause, no browser.

rem Resolve suite root whether this bat lives at suite root or under deploy\windows.
set "SCRIPT_DIR=%~dp0"
if exist "%SCRIPT_DIR%SelfServiceSuite\SelfServiceBackend\dist\server.js" (
  set "ROOT=%SCRIPT_DIR%"
) else if exist "%SCRIPT_DIR%..\..\SelfServiceSuite\SelfServiceBackend\dist\server.js" (
  pushd "%SCRIPT_DIR%..\.."
  set "ROOT=%CD%\"
  popd
) else (
  echo [%DATE% %TIME%] Could not locate SelfServiceSuite\SelfServiceBackend\dist\server.js from %SCRIPT_DIR%>> "%TEMP%\portal-autostart.log"
  exit /b 1
)

set "BACKEND=%ROOT%SelfServiceSuite\SelfServiceBackend"
set "LOG=%ROOT%portal-autostart.log"
set "KILL=%ROOT%deploy\windows\kill-port.bat"
set "NODE_FILE=%ROOT%deploy\windows\ABH-PORTAL-NODE.txt"

echo.>> "%LOG%"
echo [%DATE% %TIME%] === ABH portal autostart ===>> "%LOG%"
echo [%DATE% %TIME%] ROOT=%ROOT%>> "%LOG%"
echo [%DATE% %TIME%] BACKEND=%BACKEND%>> "%LOG%"

if not exist "%BACKEND%\dist\server.js" (
  echo [%DATE% %TIME%] Missing %BACKEND%\dist\server.js>> "%LOG%"
  exit /b 1
)
if not exist "%BACKEND%\.env" (
  echo [%DATE% %TIME%] Missing %BACKEND%\.env — copy working .env before autostart.>> "%LOG%"
  exit /b 1
)

rem Read PORT from .env for kill-port only; clear PORT before node so dotenv wins.
set "PORT=4000"
for /f "usebackq eol=# tokens=1,* delims==" %%A in (`findstr /b /i "PORT=" "%BACKEND%\.env"`) do set "PORT=%%B"
set "PORT=%PORT:'=%"
set "PORT=%PORT:"=%"
if "%PORT%"=="" set "PORT=4000"

if exist "%KILL%" (
  call "%KILL%" %PORT%
  if not "%PORT%"=="4000" call "%KILL%" 4000
  if not "%PORT%"=="5000" call "%KILL%" 5000
) else (
  echo [%DATE% %TIME%] kill-port.bat missing at %KILL%>> "%LOG%"
)

cd /d "%BACKEND%"
if errorlevel 1 (
  echo [%DATE% %TIME%] cd failed to %BACKEND%>> "%LOG%"
  exit /b 1
)

set "NODE=node"
if exist "%NODE_FILE%" (
  set /p NODE=<"%NODE_FILE%"
)
if not exist "%NODE%" (
  rem Fall back to PATH if the saved absolute path is stale.
  where node >nul 2>&1
  if errorlevel 1 (
    echo [%DATE% %TIME%] node.exe not found. Re-run INSTALL-AUTOSTART.bat as Administrator.>> "%LOG%"
    exit /b 1
  )
  set "NODE=node"
)

echo [%DATE% %TIME%] Starting "%NODE%" dist\server.js ^(env PORT cleared; .env PORT=%PORT%^)>> "%LOG%"
set "PORT="
"%NODE%" dist\server.js >> "%LOG%" 2>&1
set "RC=%ERRORLEVEL%"
echo [%DATE% %TIME%] Portal process exited with code %RC%>> "%LOG%"
exit /b %RC%
