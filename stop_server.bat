@echo off
echo ==================================================
echo         STOPPING TORCOIN SERVER
echo ==================================================
echo.

:: Stop TorCOIN server
echo 🛑 Stopping TorCOIN server...
taskkill /FI "WINDOWTITLE eq TorCOIN_Server" /T /F >nul 2>&1
if %errorlevel%==0 (
    echo ✅ TorCOIN server stopped.
) else (
    echo ⚠️  TorCOIN server was not running.
)

:: Stop proxy server
echo 🛑 Stopping secure proxy...
taskkill /FI "WINDOWTITLE eq TorCOIN_Proxy" /T /F >nul 2>&1
if %errorlevel%==0 (
    echo ✅ Proxy server stopped.
) else (
    echo ⚠️  Proxy server was not running.
)

:: Optional: Restore firewall to normal
echo 🔄 Restoring firewall to normal...
call restore_firewall.bat >nul 2>&1

echo.
echo ✅ All TorCOIN services stopped.
echo ✅ Firewall restored to normal settings.
echo.
echo 💡 Your internet access is now restored.
echo To restart TorCOIN: run server.bat
echo.

pause
