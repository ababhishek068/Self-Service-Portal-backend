@echo off
setlocal EnableExtensions EnableDelayedExpansion
title HIJRA - Find employee salary field
color 0A
echo.
echo ============================================================
echo   HIJRA UAT - Employee salary lookup (Business Central)
echo ============================================================
echo.

set "BC_HOST=10.30.7.14"
set "BASE2448=http://%BC_HOST%:2448/BC240/ODataV4/Company('HIJRA%%20BANK')"
set "BASE2447=http://%BC_HOST%:2447/BC240/ODataV4/Company('HIJRA%%20BANK')"

echo Employee number for Beza is: E0083  (letter E, not zero)
echo.
set /p EMPNO=Type employee number [default E0083]: 
if "%EMPNO%"=="" set "EMPNO=E0083"

echo.
echo Password is in host .env as BC_NAV_PASSWORD (NOT the text YOUR_PASSWORD)
echo Example from template: Test@3223!$
echo.
set /p BC_PASS=BC password for Admin: 
if "%BC_PASS%"=="" (
  echo.
  echo ERROR: You must type the real password.
  pause
  exit /b 1
)

set "OUTDIR=%USERPROFILE%\Desktop\hijra-salary-check"
if not exist "%OUTDIR%" mkdir "%OUTDIR%"
set "OUT=%OUTDIR%\%EMPNO%"

echo.
echo Saving results to: %OUTDIR%
echo.

call :query "basic" "%BASE2448%/QyHREmployee" "2448-QyHREmployee-basic"
call :query "ntlm" "%BASE2448%/QyHREmployee" "2448-QyHREmployee-ntlm"
call :query "basic" "%BASE2448%/QyPREmployee" "2448-QyPREmployee-basic"
call :query "basic" "%BASE2447%/QyHREmployee" "2447-QyHREmployee-basic"
call :query "basic" "%BASE2447%/Employee_Card" "2447-Employee_Card-basic"

echo.
echo ============================================================
echo   DONE - open folder on Desktop: hijra-salary-check
echo ============================================================
echo.
echo In each .json file look for:
echo   "value": [ { ... fields ... } ]
echo.
echo - If you see "value": []  = wrong employee number OR wrong auth
echo - If file is 0 bytes       = curl failed (see .err files)
echo - Search inside for: Basic  Salary  Gross  Pay
echo.
echo Then add to host .env:
echo   BC_SALARY_BASE_FIELD=FieldNameFromJson
echo   BC_AUTH_MODE=basic
echo.
echo Restart backend + Ctrl+Shift+R in browser.
echo ============================================================
explorer "%OUTDIR%"
pause
exit /b 0

:query
set "MODE=%~1"
set "URL=%~2"
set "LABEL=%~3"
set "FILE=%OUT%-!LABEL!.json"
set "ERR=%OUT%-!LABEL!.err"
set "FULLURL=!URL!?$filter=No%%20eq%%20'%EMPNO%'^&$top=1"

echo [!LABEL!] ...
if /i "!MODE!"=="ntlm" (
  curl --silent --show-error --write-out "HTTP%%{http_code}" --ntlm -u "Admin:%BC_PASS%" "!FULLURL!" -H "Accept: application/json" -o "!FILE!" 2>"!ERR!"
) else (
  curl --silent --show-error --write-out "HTTP%%{http_code}" -u "Admin:%BC_PASS%" "!FULLURL!" -H "Accept: application/json" -o "!FILE!" 2>"!ERR!"
)

for %%A in ("!FILE!") do set SIZE=%%~zA
echo     saved !FILE!  size=!SIZE! bytes
if !SIZE! EQU 0 (
  echo     WARNING: empty file - read !ERR!
  type "!ERR!" 2>nul
) else (
  findstr /i "Basic Salary Gross Pay Wage value" "!FILE!" >nul 2>&1
  if errorlevel 1 (
    echo     file content preview:
    more +0 "!FILE!"
  ) else (
    echo     found salary-related fields - open this file in Notepad
  )
)
echo.
goto :eof
