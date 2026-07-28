@echo off
setlocal
cd /d "%~dp0SelfServiceSuite\SelfServiceBackend"
echo VERIFY DEPLOY - HIJRA SSP v1.0.3.51
if exist "dist\server.js" (echo OK dist\server.js) else (echo MISSING dist\server.js)
findstr /M /C:"1.0.3.51" dist\portalApi.js >nul 2>&1 && echo OK v1.0.3.51 backend || echo MISSING v1.0.3.51
if exist "public\index.html" (echo OK public\index.html) else (echo MISSING public)
findstr /M /C:"VITE_AUTH_API_URL:``" public\assets\*.js >nul 2>&1 && echo OK onprem portal build || echo WARN check portal build
if exist ".env" (echo OK .env) else (echo MISSING .env)
if exist "dist\BUILD_ID.txt" (type dist\BUILD_ID.txt)
pause
