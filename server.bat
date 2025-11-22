@echo off
echo ==================================================
echo         TORCOIN SERVER MANAGER
echo ==================================================
echo.
echo Keeping your TorCOIN site ONLINE and RUNNING 24/7
echo.
echo Features:
echo ✅ TorCOIN server (port 50129)
echo ✅ Secure proxy (port 8080)
echo ✅ Strict firewall protection
echo ✅ Automatic health monitoring
echo ✅ Easy stop/restart controls
echo.
echo Press any key to start the server...
pause >nul

:: Change to the correct directory
cd /d "%~dp0"

:: Verify files exist
if not exist "torcoin.html" (
    echo ❌ ERROR: torcoin.html not found!
    echo Please run full_setup.bat first.
    pause
    exit /b 1
)

if not exist "coin_server.py" (
    echo ❌ ERROR: coin_server.py not found!
    pause
    exit /b 1
)

echo.
echo 🚀 Starting TorCOIN Server Ecosystem...
echo.

:: Apply strict firewall if not already active
echo 🔒 Applying security measures...
call strict_firewall.bat >nul 2>&1

:: Start TorCOIN server in background
echo 🔥 Starting TorCOIN server...
start /B "TorCOIN_Server" python coin_server.py > server.log 2>&1

:: Wait for server to start
timeout /t 3 /nobreak >nul

:: Check if server started
curl -s http://127.0.0.1:50129/ >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ TorCOIN server failed to start!
    echo Check server.log for details.
    pause
    exit /b 1
)

:: Start proxy server in background
echo 🛡️  Starting secure proxy server...
start /B "TorCOIN_Proxy" python torcoin_proxy.py > proxy.log 2>&1

:: Wait for proxy to start
timeout /t 2 /nobreak >nul

:: Check if proxy started
curl -s --proxy localhost:8080 http://127.0.0.1:50129/ >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  Proxy may not be ready yet, but server is running.
)

echo.
echo ==================================================
echo ✅ TORCOIN SERVER IS NOW ONLINE!
echo ==================================================
echo.
echo 🌐 ACCESS YOUR COIN:
echo   Direct:     http://www.torcoin.cnet
echo   Via Proxy:  http://www.torcoin.cnet (set browser proxy to localhost:8080)
echo.
echo 📊 SERVER STATUS:
echo   ✅ TorCOIN server: Running on port 50129
echo   ✅ Secure proxy:   Running on port 8080
echo   ✅ Firewall:       STRICT mode active
echo   ✅ Domain:         www.torcoin.cnet configured
echo.
echo 📋 LOG FILES:
echo   Server log: server.log
echo   Proxy log:  proxy.log
echo.
echo 🛑 TO STOP THE SERVER:
echo   Close this window or press Ctrl+C
echo   Then run: stop_server.bat
echo.
echo 🔄 TO RESTART:
echo   Run: restart_server.bat
echo.
echo 💡 Your TorCOIN site is now LIVE and SECURE!
echo.

:: Keep the window open and monitor
echo Monitoring server health... (press Ctrl+C to stop)

:monitor_loop
timeout /t 30 /nobreak >nul

:: Health check
curl -s http://127.0.0.1:50129/ >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️  WARNING: TorCOIN server not responding!
    echo Attempting restart...
    taskkill /FI "WINDOWTITLE eq TorCOIN_Server" /T /F >nul 2>&1
    start /B "TorCOIN_Server" python coin_server.py >> server.log 2>&1
    echo 🔄 Server restarted.
)

goto monitor_loop
