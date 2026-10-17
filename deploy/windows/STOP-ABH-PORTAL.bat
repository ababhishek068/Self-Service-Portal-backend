@echo off
setlocal EnableExtensions

rem Works from suite root OR from deploy\windows.
set "SCRIPT_DIR=%~dp0"
if exist "%SCRIPT_DIR%SelfServiceSuite\SelfServiceBackend\dist\server.js" (
  set "ROOT=%SCRIPT_DIR%"
) else if exist "%SCRIPT_DIR%..\..\SelfServiceSuite\SelfServiceBackend\dist\server.js" (
  pushd "%SCRIPT_DIR%..\.."
  set "ROOT=%CD%\"
  popd
) else (
  set "ROOT=%SCRIPT_DIR%"
)

set "BACKEND=%ROOT%SelfServiceSuite\SelfServiceBackend"
set "KILL=%ROOT%deploy\windows\kill-port.bat"
if not exist "%KILL%" set "KILL=%SCRIPT_DIR%kill-port.bat"

set "PORT=4000"
if exist "%BACKEND%\.env" (
  for /f "usebackq eol=# tokens=1,* delims==" %%A in (`findstr /b /i "PORT=" "%BACKEND%\.env"`) do set "PORT=%%B"
)
set "PORT=%PORT:'=%"
set "PORT=%PORT:"=%"
if "%PORT%"=="" set "PORT=4000"

if exist "%KILL%" (
  call "%KILL%" %PORT%
  if not "%PORT%"=="4000" call "%KILL%" 4000
  if not "%PORT%"=="5000" call "%KILL%" 5000
) else (
  echo [WARN] kill-port.bat not found; trying taskkill via netstat...
  for /f "tokens=5" %%P in ('netstat -ano ^| findstr ":%PORT%" ^| findstr LISTENING') do taskkill /F /PID %%P >nul 2>&1
)

echo ABH Portal stopped (port %PORT%; also cleared 4000/5000 leftovers).
pause
