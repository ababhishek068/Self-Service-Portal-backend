@echo off
setlocal EnableExtensions
if "%~1"=="" (
  echo Usage: kill-port.bat PORT
  exit /b 1
)
for /f "tokens=5" %%P in ('netstat -ano ^| findstr ":%~1" ^| findstr LISTENING') do (
  taskkill /F /PID %%P >nul 2>&1
)
exit /b 0
