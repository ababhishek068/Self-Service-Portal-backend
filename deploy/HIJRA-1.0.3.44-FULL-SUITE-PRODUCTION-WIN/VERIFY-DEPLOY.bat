@echo off
setlocal
cd /d "%~dp0SelfServiceSuite\SelfServiceBackend"
echo ==========================================================
echo   VERIFY DEPLOY - HIJRA SSP v1.0.3.44 (UAT sync)
echo ==========================================================
echo.
echo     EXPECTED: index-cMbc441l.js (or newer UAT sync bundle)
echo.
if exist "dist\server.js" (echo OK dist\server.js) else (echo MISSING dist\server.js)
findstr /M /C:"UAT sync" dist\portalApi.js >nul 2>&1 && echo OK  UAT sync backend || echo MISSING UAT sync backend
findstr /M /C:"profile/trainings" dist\portalApi.js >nul 2>&1 && echo OK  profile trainings route || echo MISSING profile trainings
findstr /M /C:"employee-exit" dist\portalApi.js >nul 2>&1 && echo OK  employee exit route || echo MISSING employee exit
if exist ".env" (echo OK .env) else (echo MISSING .env)
echo.
pause
