@echo off
setlocal
cd /d "%~dp0SelfServiceSuite\SelfServiceBackend"
echo ==========================================================
echo   VERIFY DEPLOY - HIJRA SSP v1.0.3.44 (restored build)
echo ==========================================================
echo.
echo [1] Bundle the server will serve:
type public\index.html ^| findstr /C:"index-"
echo     EXPECTED: index-k6-MjTel.js
echo.
echo [2] Backend build:
if exist "dist\server.js" (echo     OK dist\server.js) else (echo     MISSING dist\server.js)
if exist "dist\staffModules.js" (echo     OK staffModules.js) else (echo     MISSING staffModules.js)
type dist\BUILD_ID.txt 2>nul
echo.
echo [3] .env present:
if exist ".env" (echo     OK .env) else (echo     MISSING .env - copy your existing one here)
echo.
echo [4] Training fix in backend:
findstr /M /C:"SaveTrainingAssessment" dist\staffModules.js >nul 2>&1 && echo     OK  SaveTrainingAssessment || echo     MISSING SaveTrainingAssessment
findstr /M /C:"__OTHER__" dist\staffModules.js >nul 2>&1 && echo     OK  Others course handling || echo     MISSING Others handling
echo.
echo [5] Training UI in frontend bundle:
findstr /M /C:"Others (not in the ERP list)" public\assets\*.js >nul 2>&1 && echo     OK  Training Others option || echo     MISSING Training Others option
echo.
echo [6] After login: Profile -^> Portal build must contain "training"
echo.
pause
