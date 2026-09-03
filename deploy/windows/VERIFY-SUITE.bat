@echo off
setlocal EnableExtensions
set "ROOT=%~dp0"
set "BACKEND=%ROOT%SelfServiceSuite\SelfServiceBackend"
set "FAIL=0"

echo.
echo ==========================================================
echo   ABH PORTAL SUITE VERIFICATION
echo ==========================================================
echo   ROOT:    %ROOT%
echo   BACKEND: %BACKEND%
echo ==========================================================
echo.

call :check "%BACKEND%\dist\server.js" "Backend server (dist\server.js)"
call :check "%BACKEND%\public\index.html" "Frontend (public\index.html)"
call :check "%BACKEND%\package.json" "package.json"
call :check "%BACKEND%\node_modules\express\package.json" "node_modules\express"
call :check "%ROOT%deploy\windows\host.env.abh-uat-ip.example" ".env template"
call :check "%BACKEND%\deploy\windows\host.env.abh-uat-ip.example" "backend .env template"
if exist "%BACKEND%\.env" (
  echo [OK]   .env present
) else (
  echo [WARN] .env missing — copy your working .env before START
)

echo.
if "%FAIL%"=="0" (
  echo ALL CHECKS PASSED — run START-ABH-PORTAL.bat
) else (
  echo SUITE INCOMPLETE — re-extract the full zip to e.g. C:\TA\ABH-Portal-COMPLETE-1.0.3.344\
  echo Do NOT copy only the .bat files; the SelfServiceSuite folder is required.
)
echo.
pause
exit /b %FAIL%

:check
if exist "%~1" (
  echo [OK]   %~2
) else (
  echo [FAIL] %~2 — missing: %~1
  set "FAIL=1"
)
exit /b 0
