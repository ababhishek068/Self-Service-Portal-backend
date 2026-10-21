@echo off
setlocal enabledelayedexpansion
title ABH Portal - Diagnose

REM Collects everything needed to tell WHY the portal is not working and
REM writes it to a single report file on the Desktop. Send that file back.

set "REPORT=%USERPROFILE%\Desktop\ABH-PORTAL-DIAGNOSTIC.txt"
set "ROOT=%~dp0"
if exist "%ROOT%..\..\SelfServiceSuite\SelfServiceBackend" (
  set "BACKEND=%ROOT%..\..\SelfServiceSuite\SelfServiceBackend"
) else (
  set "BACKEND=%ROOT%..\..\.."
)

echo ABH PORTAL DIAGNOSTIC > "%REPORT%"
echo Generated: %DATE% %TIME% >> "%REPORT%"
echo ============================================ >> "%REPORT%"
echo. >> "%REPORT%"

echo [1/6] Node.js version
echo --- NODE VERSION --- >> "%REPORT%"
node --version >> "%REPORT%" 2>&1
if errorlevel 1 echo NODE NOT FOUND ON PATH - install Node.js LTS >> "%REPORT%"
echo. >> "%REPORT%"

echo [2/6] Suite files
echo --- REQUIRED FILES --- >> "%REPORT%"
for %%F in (
  "%BACKEND%\dist\server.js"
  "%BACKEND%\public\index.html"
  "%BACKEND%\package.json"
  "%BACKEND%\node_modules\express\package.json"
  "%BACKEND%\.env"
) do (
  if exist %%F ( echo OK      %%F >> "%REPORT%" ) else ( echo MISSING %%F >> "%REPORT%" )
)
echo. >> "%REPORT%"

echo [3/6] .env BC endpoints ^(passwords hidden^)
echo --- ENV BC ENDPOINTS --- >> "%REPORT%"
if exist "%BACKEND%\.env" (
  findstr /B /C:"BC_ODATA_BASE_URL" /C:"BC_SOAP_CODEUNIT_URL" /C:"BC_SOAP_PAGE_BASE_URL" /C:"BC_ODATA_PAGE_BASE_URL" /C:"BC_AUTH_MODE" /C:"BC_NAV_USER" /C:"PORT" /C:"CORS_ORIGIN" "%BACKEND%\.env" >> "%REPORT%" 2>&1
  echo. >> "%REPORT%"
  echo NOTE: SOAP/Page URLs must be port 7047. OData V4 must be port 7048. >> "%REPORT%"
) else (
  echo .env NOT FOUND at %BACKEND%\.env >> "%REPORT%"
  echo Copy deploy\windows\host.env.abh-uat-ip.example there and rename to .env >> "%REPORT%"
)
echo. >> "%REPORT%"

echo [4/6] Port 4000 listener
echo --- PORT 4000 --- >> "%REPORT%"
netstat -ano ^| findstr ":4000" >> "%REPORT%" 2>&1
if errorlevel 1 echo NOTHING LISTENING ON 4000 - portal is not running >> "%REPORT%"
echo. >> "%REPORT%"

echo [5/6] Portal build stamp
echo --- /api/portal-build --- >> "%REPORT%"
powershell -NoProfile -Command "try { (Invoke-WebRequest -Uri 'http://127.0.0.1:4000/api/portal-build' -UseBasicParsing -TimeoutSec 15).Content } catch { 'REQUEST FAILED: ' + $_.Exception.Message }" >> "%REPORT%" 2>&1
echo. >> "%REPORT%"

echo [6/6] Business Central connectivity ^(this can take up to a minute^)
echo --- /api/bc-diagnostics --- >> "%REPORT%"
powershell -NoProfile -Command "try { $r = Invoke-WebRequest -Uri 'http://127.0.0.1:4000/api/bc-diagnostics' -UseBasicParsing -TimeoutSec 180; $r.Content | ConvertFrom-Json | ConvertTo-Json -Depth 8 } catch { 'REQUEST FAILED: ' + $_.Exception.Message }" >> "%REPORT%" 2>&1
echo. >> "%REPORT%"

echo --- BC INTEGRATION LOG (last 60 lines) --- >> "%REPORT%"
if exist "%BACKEND%\bc-integration.log" (
  powershell -NoProfile -Command "Get-Content -Path '%BACKEND%\bc-integration.log' -Tail 60" >> "%REPORT%" 2>&1
) else (
  echo no bc-integration.log yet >> "%REPORT%"
)

echo.
echo ============================================
echo Report written to:
echo   %REPORT%
echo Send that file back.
echo ============================================
echo.
start "" notepad "%REPORT%"
pause
