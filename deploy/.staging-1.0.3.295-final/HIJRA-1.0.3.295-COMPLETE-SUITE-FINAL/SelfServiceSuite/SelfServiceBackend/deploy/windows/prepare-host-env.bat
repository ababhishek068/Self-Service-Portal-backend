@echo off
setlocal
cd /d "%~dp0..\.."

if exist ".env" (
  echo SelfServiceBackend\.env already exists.
  exit /b 0
)

if exist "deploy\windows\host.env.hijra-uat-ip.example" (
  copy "deploy\windows\host.env.hijra-uat-ip.example" ".env" >nul
  echo Created SelfServiceBackend\.env from host.env.hijra-uat-ip.example
  exit /b 0
)

if not exist "deploy\windows\host.env.example" (
  echo ERROR: deploy\windows\host.env.example is missing.
  exit /b 1
)

copy "deploy\windows\host.env.example" ".env" >nul
echo Created SelfServiceBackend\.env from host.env.example
exit /b 0
