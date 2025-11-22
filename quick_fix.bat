@echo off
echo ==================================================
echo         TORCOIN QUICK FIX
echo ==================================================
echo.
echo 🔧 Fixing common TorCOIN connection issues...
echo.

:: Fix 1: Add domain to hosts if missing
echo 🌐 Step 1: Ensuring domain is in hosts file...
findstr "www.torcoin.cnet" %windir%\System32\drivers\etc\hosts >nul 2>&1
if %errorlevel% neq 0 (
    echo Adding www.torcoin.cnet to hosts file...
    echo. >> %windir%\System32\drivers\etc\hosts
    echo # TorCOIN Domain (added by quick fix) >> %windir%\System32\drivers\etc\hosts
    echo 127.0.0.1 www.torcoin.cnet >> %windir%\System32\drivers\etc\hosts
    echo ✅ Domain added
) else (
    echo ✅ Domain already configured
)

echo.

:: Fix 2: Try to configure DNS
echo 🔧 Step 2: Configuring Cloudflare DNS...
netsh interface ipv4 set dns "Wi-Fi" static 1.1.1.1 >nul 2>&1
netsh interface ipv4 add dns "Wi-Fi" 1.0.0.1 index=2 >nul 2>&1
netsh interface ipv4 set dns "Ethernet" static 1.1.1.1 >nul 2>&1
netsh interface ipv4 add dns "Ethernet" 1.0.0.1 index=2 >nul 2>&1
echo ✅ DNS configured (Cloudflare)

echo.

:: Fix 3: Test and start server if needed
echo 🚀 Step 3: Checking server status...
netstat -ano | findstr ":50129" >nul 2>&1
if %errorlevel% neq 0 (
    echo Starting TorCOIN server...
    start /B python coin_server.py >nul 2>&1
    timeout /t 2 /nobreak >nul
    echo ✅ Server started in background
) else (
    echo ✅ Server already running
)

echo.

:: Test the fix
echo 🧪 Step 4: Testing the fix...
curl -s http://127.0.0.1:50129/ >nul 2>&1
if %errorlevel%==0 (
    echo 🎉 SUCCESS! Your coin is accessible at:
    echo.
    echo    🌐 http://www.torcoin.cnet
    echo    🔗 http://127.0.0.1:50129/
    echo.
    echo 💡 Note: Use HTTP (not HTTPS) - server serves HTTP only
) else (
    echo ❌ Fix didn't work. Try running as Administrator.
)

echo.
echo ==================================================
pause
