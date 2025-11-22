@echo off
echo ==================================================
echo     CLOUDFLARE DNS CONFIGURATION FOR TORCOIN
echo ==================================================
echo.
echo This will configure your system to use Cloudflare DNS:
echo 🔹 Primary DNS: 1.1.1.1
echo 🔹 Secondary DNS: 1.0.0.1
echo.
echo This helps resolve www.torcoin.cnet and improves speed!
echo.
echo ⚠️  REQUIRES ADMINISTRATOR PRIVILEGES
echo.
pause

echo.
echo 🔄 Configuring DNS settings...
echo.

:: Get network adapter name (usually "Wi-Fi" or "Ethernet")
for /f "tokens=*" %%i in ('netsh interface show interface ^| findstr /C:"Connected"') do (
    for /f "tokens=4*" %%a in ("%%i") do (
        set INTERFACE_NAME=%%a %%b
    )
)

if "%INTERFACE_NAME%"=="" (
    echo ❌ Could not detect network interface.
    echo Please run: netsh interface ipv4 set dns "Wi-Fi" static 1.1.1.1
    echo Or:        netsh interface ipv4 set dns "Ethernet" static 1.1.1.1
    goto end
)

echo 📡 Detected interface: %INTERFACE_NAME%
echo.

:: Set primary DNS
echo Setting primary DNS (1.1.1.1)...
netsh interface ipv4 set dns "%INTERFACE_NAME%" static 1.1.1.1

:: Set secondary DNS
echo Setting secondary DNS (1.0.0.1)...
netsh interface ipv4 add dns "%INTERFACE_NAME%" 1.0.0.1 index=2

echo.
echo ✅ Cloudflare DNS configured successfully!
echo.
echo 🌐 Your DNS servers are now:
echo    Primary: 1.1.1.1 (Cloudflare)
echo    Secondary: 1.0.0.1 (Cloudflare)
echo.
echo 🔗 Your TorCOIN domain should now resolve:
echo    https://www.torcoin.cnet
echo.
echo 📋 To verify, run: nslookup www.torcoin.cnet
echo.

:end
pause
