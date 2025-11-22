@echo off
echo ==================================================
echo       FIREWALL STATUS CHECK
echo ==================================================
echo.

echo 🔍 Checking your current firewall status...
echo.

:: Check firewall state
echo 📊 Firewall State:
netsh advfirewall show allprofiles state | findstr "State"
echo.

:: Check current policies
echo 📋 Current Firewall Policies:
netsh advfirewall show allprofiles | findstr "Policy"
echo.

:: Check for TorCOIN rules
echo 🛡️  Checking for TorCOIN firewall rules:
netsh advfirewall firewall show rule name=all | findstr /C:"TorCOIN" >nul 2>&1
if %errorlevel%==0 (
    echo ❌ FOUND: TorCOIN firewall rules are still active!
    echo 💡 You need to run restore_firewall.bat as Administrator
) else (
    echo ✅ No TorCOIN firewall rules found
)
echo.

:: Test internet connectivity
echo 🌐 Testing internet connectivity...
ping -n 1 google.com >nul 2>&1
if %errorlevel%==0 (
    echo ✅ Internet connection: WORKING
) else (
    echo ❌ Internet connection: FAILED
    echo 💡 Possible firewall issue
)
echo.

:: Check DNS
echo 🔧 Checking DNS settings...
ipconfig /all | findstr "DNS Servers"
echo.

echo ==================================================
echo                DIAGNOSIS COMPLETE
echo ==================================================
echo.
echo If you see "FAILED" or "TorCOIN rules still active":
echo 1. Right-click restore_firewall.bat
echo 2. Select "Run as administrator"
echo 3. Follow the prompts
echo.
echo If internet still doesn't work after restore:
echo - Restart your computer
echo - Check your network connection
echo - Contact your network administrator
echo.

pause
