@echo off
setlocal
cd /d "%~dp0..\.."

if exist ".env" (
  echo SelfServiceBackend\.env already exists.
  exit /b 0
)

if not exist "deploy\windows\host.env.abh-uat-ip.example" (
  echo ERROR: deploy\windows\host.env.abh-uat-ip.example is missing.
  exit /b 1
)

copy "deploy\windows\host.env.abh-uat-ip.example" ".env" >nul
echo Created SelfServiceBackend\.env from host.env.abh-uat-ip.example
echo Edit BC credentials and CORS_ORIGIN before starting the service.
exit /b 0
