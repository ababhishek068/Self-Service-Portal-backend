@echo off
call "%~dp0deploy\windows\kill-port.bat" 4000
echo ABH Portal stopped (port 4000).
pause
