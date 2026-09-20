@echo off
cd /d "%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup-integrations.ps1"
if errorlevel 1 (
  echo.
  echo A configuracao terminou com erro. Leia a mensagem acima.
)
pause
