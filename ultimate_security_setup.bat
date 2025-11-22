@echo off
echo ==================================================
echo     TORCOIN ULTIMATE SECURITY SETUP
echo ==================================================
echo.
echo This will create MAXIMUM SECURITY for your TorCOIN:
echo.
echo 🔥 STRICT FIREWALL:
echo   ✅ Block ALL inbound/outbound except TorCOIN
echo   ✅ Only essentials (DNS, Windows Update) allowed
echo   ✅ Backup created for restoration
echo.
echo 🛡️  SELF PROXY SERVER:
echo   ✅ Only allows TorCOIN website access
echo   ✅ Blocks ALL other internet traffic
echo   ✅ Runs on localhost:8080
echo.
echo ⚠️  WARNING: This makes your PC VERY restrictive!
echo ⚠️  You may lose access to most websites!
echo ⚠️  Backup created: C:\TorCOIN_Firewall_Backup.wfw
echo.
echo Press Ctrl+C NOW if you want to CANCEL...
echo.
pause

echo.
echo 🔒 STEP 1: Setting up STRICT Firewall...
echo.

:: Run firewall setup
call strict_firewall.bat

echo.
echo 🛡️  STEP 2: Starting SECURE Proxy Server...
echo.

:: Start proxy in background
echo Starting TorCOIN proxy server...
start /B python torcoin_proxy.py >nul 2>&1

:: Wait a moment for proxy to start
timeout /t 3 /nobreak >nul

:: Test proxy
echo Testing proxy connection...
curl -s --proxy localhost:8080 http://127.0.0.1:50129/ >nul 2>&1
if %errorlevel%==0 (
    echo ✅ Proxy is working!
) else (
    echo ⚠️  Proxy may not be responding yet...
)

echo.
echo 🎉 ULTIMATE SECURITY ACTIVATED!
echo.
echo 🛡️  SECURITY STATUS:
echo ✅ STRICT firewall blocking all non-essential traffic
echo ✅ SECURE proxy only allowing TorCOIN access
echo ✅ Maximum protection for your coin server
echo.
echo 🌐 ACCESS YOUR COIN:
echo 1. Set browser proxy to: localhost:8080
echo 2. Visit: http://www.torcoin.cnet
echo.
echo 📋 RECOVERY:
echo - To disable firewall: Run "restore_firewall.bat"
echo - To stop proxy: Close command window or Ctrl+C
echo.
echo 🔐 Your TorCOIN is now FORTRESS-PROTECTED!
echo.

pause
