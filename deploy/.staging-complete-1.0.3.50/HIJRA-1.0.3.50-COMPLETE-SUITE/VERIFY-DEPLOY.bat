@echo off
setlocal
cd /d "%~dp0SelfServiceSuite\SelfServiceBackend"
echo ==========================================================
echo   VERIFY DEPLOY - HIJRA SSP v1.0.3.50 (leave fix)
echo ==========================================================
echo.
if exist "dist\server.js" (echo OK dist\server.js) else (echo MISSING dist\server.js)
findstr /M /C:"1.0.3.50" dist\portalApi.js >nul 2>&1 && echo OK  v1.0.3.50 backend || echo MISSING v1.0.3.50 backend
findstr /M /C:"no auto-approval ghost LV" dist\portalApi.js >nul 2>&1 && echo OK  leave create fix || echo MISSING leave create fix
findstr /M /C:"computeLeaveBalanceFromBcAllocations" dist\staff.js >nul 2>&1 && echo OK  leave balance BC formula || echo MISSING leave balance fix
if exist "public\index.html" (echo OK public\index.html) else (echo MISSING public\index.html)
if exist ".env" (echo OK .env) else (echo MISSING .env - copy from backup)
if exist "dist\BUILD_ID.txt" (type dist\BUILD_ID.txt) else (echo MISSING BUILD_ID.txt)
echo.
pause
