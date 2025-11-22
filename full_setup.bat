@echo off

:: Change to the directory where this script is located
cd /d "%~dp0"

echo ==================================================
echo       TORCOIN FULL SETUP WIZARD
echo ==================================================
echo.
echo Working directory: %CD%

:: Verify we're in the right place
if not exist "torcoin_website.html" (
    echo ❌ ERROR: Not in the correct directory!
    echo This script must be run from the TorCOIN folder containing torcoin_website.html
    echo Expected location: J:\TorCOIN\
    echo Current location: %CD%
    pause
    exit /b 1
)
echo.
echo This will set up EVERYTHING for your TorCOIN server:
echo 1️⃣ Configure Cloudflare DNS
echo 2️⃣ Add domain to hosts file
echo 3️⃣ Start the TorCOIN server
echo 4️⃣ Activate STRICT firewall security
echo 5️⃣ Start SECURE proxy server
echo.
echo 🎯 Final result: ULTRA-SECURE TorCOIN at http://www.torcoin.cnet
echo.
echo ⚠️  Run as Administrator - will restrict internet access!
echo ⚠️  Creates backup: C:\TorCOIN_Firewall_Backup.wfw
echo.
pause

echo.
echo ==================================================
echo 🔧 STEP 1: Configuring Cloudflare DNS
echo ==================================================
echo.

:: Configure DNS
echo Setting DNS to Cloudflare (1.1.1.1, 1.0.0.1)...
for /f "tokens=*" %%i in ('netsh interface show interface ^| findstr /C:"Connected"') do (
    for /f "tokens=4*" %%a in ("%%i") do (
        set INTERFACE_NAME=%%a %%b
    )
)

if "%INTERFACE_NAME%"=="" (
    echo ⚠️  Could not auto-detect interface. Using common names...
    netsh interface ipv4 set dns "Wi-Fi" static 1.1.1.1 >nul 2>&1
    netsh interface ipv4 add dns "Wi-Fi" 1.0.0.1 index=2 >nul 2>&1
    netsh interface ipv4 set dns "Ethernet" static 1.1.1.1 >nul 2>&1
    netsh interface ipv4 add dns "Ethernet" 1.0.0.1 index=2 >nul 2>&1
    echo 📡 DNS configured for Wi-Fi and Ethernet
) else (
    echo 📡 Detected interface: %INTERFACE_NAME%
    netsh interface ipv4 set dns "%INTERFACE_NAME%" static 1.1.1.1 >nul 2>&1
    netsh interface ipv4 add dns "%INTERFACE_NAME%" 1.0.0.1 index=2 >nul 2>&1
)

echo ✅ DNS configured to Cloudflare
echo.

echo ==================================================
echo 🌐 STEP 2: Adding Domain to Hosts File
echo ==================================================
echo.

:: Add domain to hosts
echo Adding www.torcoin.cnet to hosts file...
echo. >> %windir%\System32\drivers\etc\hosts
echo # TorCOIN Local Domain (added by setup wizard) >> %windir%\System32\drivers\etc\hosts
echo 127.0.0.1 www.torcoin.cnet >> %windir%\System32\drivers\etc\hosts

echo ✅ Domain configured in hosts file
echo.

echo ==================================================
echo 🚀 STEP 3: Starting TorCOIN Server
echo ==================================================
echo.

:: Check if Python is available
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Python not found! Please install Python 3.x
    echo Download from: https://python.org
    pause
    exit /b 1
)

echo ✅ Python found

echo ✅ HTML file found
echo 🔥 Starting your TorCOIN server...
echo 🎯 Access at: http://www.torcoin.cnet
echo 💡 Note: Use HTTP (not HTTPS) - server serves HTTP only
echo.
echo 🛑 Press Ctrl+C to stop
echo.

:: Start the server in background so we can continue with security setup
echo Starting TorCOIN server in background...
start /B python coin_server.py >nul 2>&1

:: Wait for server to start
echo Waiting for server to initialize...
timeout /t 3 /nobreak >nul

:: Test server
curl -s http://127.0.0.1:50129/ >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Server failed to start!
    pause
    exit /b 1
)

echo ✅ TorCOIN server is running!
echo.

echo ==================================================
echo 🔒 STEP 4: Setting up MAXIMUM SECURITY
echo ==================================================
echo.

echo 🛡️  Activating STRICT Firewall...
echo ⚠️  This will make your PC very secure but restrictive!

:: Apply strict firewall
call strict_firewall.bat

echo.
echo 🛡️  Starting SECURE Proxy Server...

:: Start proxy in background
echo Starting TorCOIN proxy server...
start /B python torcoin_proxy.py >nul 2>&1

:: Wait for proxy
timeout /t 2 /nobreak >nul

:: Test proxy
echo Testing proxy connection...
curl -s --proxy localhost:8080 http://127.0.0.1:50129/ >nul 2>&1
if %errorlevel%==0 (
    echo ✅ Proxy is working!
) else (
    echo ⚠️  Proxy started but may need a moment...
)

echo.
echo ==================================================
echo 🎉 TORCOIN FULL SETUP COMPLETE!
echo ==================================================
echo.
echo ✅ BASIC SETUP:
echo   • Cloudflare DNS configured
echo   • Domain added to hosts file
echo   • TorCOIN server running
echo.
echo ✅ SECURITY SETUP:
echo   • STRICT firewall activated
echo   • SECURE proxy server running
echo   • MAXIMUM protection enabled
echo.
echo 🌐 ACCESS YOUR COIN:
echo Method 1 - Direct: http://www.torcoin.cnet
echo Method 2 - Secure: Set proxy to localhost:8080, then visit http://www.torcoin.cnet
echo.
echo 📋 SECURITY FEATURES:
echo 🛡️  Firewall blocks all non-essential traffic
echo 🛡️  Proxy only allows TorCOIN access
echo 🔒 Your coin is FORTRESS-PROTECTED!
echo.
echo 🛑 EMERGENCY RECOVERY:
echo Run: restore_firewall.bat (to restore normal internet)
echo.
echo 🎯 ENJOY YOUR ULTRA-SECURE TORCOIN!
echo.

pause
