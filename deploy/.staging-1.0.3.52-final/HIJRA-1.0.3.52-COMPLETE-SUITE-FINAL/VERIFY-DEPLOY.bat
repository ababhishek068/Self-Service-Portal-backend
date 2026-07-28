@echo off
setlocal
cd /d "%~dp0SelfServiceSuite\SelfServiceBackend"
echo ==========================================================
echo   VERIFY DEPLOY - HIJRA v1.0.3.52 COMPLETE SUITE FINAL
echo ==========================================================
echo.
if exist "dist\server.js" (echo [OK] dist\server.js) else (echo [FAIL] dist\server.js)
findstr /M /C:"1.0.3.52" dist\portalApi.js >nul 2>&1 && echo [OK] backend v1.0.3.52 || echo [FAIL] backend version
findstr /M /C:"resolveDashboardAnnualLeaveBalance" dist\portalApi.js >nul 2>&1 && echo [OK] dashboard leave balance fix || echo [FAIL] dashboard balance
findstr /M /C:"preferPageOriginWhenRemote" public\assets\*.js >nul 2>&1 && echo [OK] login network fix || echo [WARN] check portal build
findstr /M /C:"cannot apply a new leave while another" dist\staff.js >nul 2>&1 && echo [FAIL] duplicate leave block still present || echo [OK] duplicate leave block removed
if exist "public\index.html" (echo [OK] public\index.html) else (echo [FAIL] public)
if exist ".env" (echo [OK] .env present) else (echo [FAIL] .env MISSING - copy from backup)
if exist "dist\BUILD_ID.txt" (echo BUILD_ID: & type dist\BUILD_ID.txt)
echo.
echo Open in browser: http://10.30.4.23:4000/api/health
echo Must show portalApiBuild containing 1.0.3.52
echo.
pause
