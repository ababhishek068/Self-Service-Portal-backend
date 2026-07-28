@echo off
setlocal
cd /d "%~dp0SelfServiceSuite\SelfServiceBackend"
echo VERIFY DEPLOY - HIJRA v1.0.3.58 COMPLETE SUITE FINAL
if exist "dist\server.js" (echo [OK] dist\server.js) else (echo [FAIL] dist\server.js)
findstr /M /C:"1.0.3.58" dist\portalApi.js >nul 2>&1 && echo [OK] backend v1.0.3.58 || echo [FAIL] backend version
findstr /M /C:"preferPageOriginWhenRemote" public\assets\*.js >nul 2>&1 && echo [OK] login network fix || echo [WARN] portal build
findstr /M /C:"leave-request?application=" public\assets\*.js >nul 2>&1 && echo [OK] leave View action || echo [WARN] leave View
findstr /M /C:"cannot apply a new leave while another" dist\staff.js >nul 2>&1 && echo [FAIL] duplicate block present || echo [OK] duplicate block removed
if exist "public\index.html" (echo [OK] public) else (echo [FAIL] public)
if exist ".env" (echo [OK] .env) else (echo [FAIL] .env MISSING)
if exist "dist\BUILD_ID.txt" (type dist\BUILD_ID.txt)
echo Check: http://10.30.4.23:4000/api/health
pause
