@echo off
echo ==================================================
echo       FIREWALL EMERGENCY RESTORE
echo ==================================================
echo.
echo 🔴 EMERGENCY: Restoring Windows Firewall to Normal
echo.
echo This will COMPLETELY reset your firewall and remove ALL TorCOIN restrictions.
echo.
echo ⚠️  REQUIRES ADMINISTRATOR PRIVILEGES
echo ⚠️  Your internet will work normally again
echo ⚠️  All custom firewall rules will be removed
echo.
echo Press Ctrl+C NOW if you don't want to continue...
echo.
timeout /t 10 >nul

echo.
echo 🔄 Starting firewall restoration...
echo.

:: Method 1: Try to restore from backup
echo 📋 Attempting to restore from backup...
if exist "C:\TorCOIN_Firewall_Backup.wfw" (
    echo ✅ Backup file found at C:\TorCOIN_Firewall_Backup.wfw
    netsh advfirewall import "C:\TorCOIN_Firewall_Backup.wfw" 2>nul
    if %errorlevel%==0 (
        echo ✅ Firewall restored from backup successfully!
        goto success
    ) else (
        echo ❌ Backup restore failed, trying reset...
    )
) else (
    echo ⚠️  No backup file found, will reset to defaults...
)

:: Method 2: Reset to Windows defaults
echo 🔄 Resetting firewall to Windows default settings...
netsh advfirewall reset >nul 2>&1
if %errorlevel%==0 (
    echo ✅ Firewall reset to Windows defaults successfully!
) else (
    echo ❌ Firewall reset failed. You may need to run this as Administrator.
    echo Right-click this file and select "Run as administrator"
    pause
    exit /b 1
)

:: Method 3: Ensure firewall is enabled with default settings
echo 🔧 Ensuring firewall is properly enabled...
netsh advfirewall set allprofiles state on >nul 2>&1
netsh advfirewall set allprofiles firewallpolicy blockinbound,allowoutbound >nul 2>&1

:success
echo.
echo ==================================================
echo ✅ FIREWALL SUCCESSFULLY RESTORED!
echo ==================================================
echo.
echo 🌐 Your internet access is now fully restored!
echo.
echo ✅ What was fixed:
echo   • Removed all strict TorCOIN firewall rules
echo   • Restored normal outbound internet access
echo   • Reset to standard Windows firewall settings
echo   • You can now visit any website normally
echo.
echo 📋 Your firewall is back to normal Windows defaults.
echo All websites and internet services should work again.
echo.
echo 🔒 For future use, avoid the strict firewall unless necessary.
echo.

pause
