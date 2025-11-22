@echo off
echo ==================================================
echo       RESTARTING TORCOIN SERVER
echo ==================================================
echo.

:: Stop existing services
echo 🛑 Stopping current services...
call stop_server.bat >nul 2>&1

:: Brief pause
timeout /t 2 /nobreak >nul

:: Start fresh
echo 🔄 Starting fresh TorCOIN server...
call server.bat

pause
