@echo off
echo ==================================================
echo         TORCOIN STATUS CHECK
echo ==================================================
echo.

echo 🔍 Checking TorCOIN setup...
echo.

:: Check if server is running
echo 📡 Checking if server is running on port 50129...
netstat -ano | findstr ":50129" >nul 2>&1
if %errorlevel%==0 (
    echo ✅ Server is RUNNING on port 50129
) else (
    echo ❌ Server is NOT running
    echo 💡 Run: full_setup.bat (as Administrator)
)

echo.

:: Check hosts file
echo 🌐 Checking domain configuration...
findstr "www.torcoin.cnet" %windir%\System32\drivers\etc\hosts >nul 2>&1
if %errorlevel%==0 (
    echo ✅ Domain www.torcoin.cnet is configured in hosts file
) else (
    echo ❌ Domain not found in hosts file
    echo 💡 Run: setup_domain.bat (as Administrator)
)

echo.

:: Check DNS
echo 🔧 Checking DNS configuration...
ipconfig /all | findstr "1.1.1.1" >nul 2>&1
if %errorlevel%==0 (
    echo ✅ Cloudflare DNS (1.1.1.1) is configured
) else (
    echo ❌ Cloudflare DNS not configured
    echo 💡 Run: configure_cloudflare_dns.bat (as Administrator)
)

echo.

:: Test connection
echo 🌍 Testing connection to www.torcoin.cnet...
ping -n 1 www.torcoin.cnet >nul 2>&1
if %errorlevel%==0 (
    echo ✅ Domain resolves correctly (127.0.0.1)
) else (
    echo ❌ Domain resolution failed
)

echo.

:: Test local server
echo 🔗 Testing local server connection...
curl -s http://127.0.0.1:50129/ >nul 2>&1
if %errorlevel%==0 (
    echo ✅ Local server responds on HTTP
    echo 💡 Try: http://127.0.0.1:50129/ (not HTTPS)
) else (
    echo ❌ Local server not responding
)

echo.

echo ==================================================
echo                TROUBLESHOOTING
echo ==================================================
echo.
echo 🔴 PROBLEM: "www.torcoin.cnet refused to connect"
echo.
echo ✅ SOLUTIONS:
echo.
echo 1. 🌐 Use HTTP instead of HTTPS:
echo    http://www.torcoin.cnet
echo    (Server currently serves HTTP only)
echo.
echo 2. 🚀 Start the server:
echo    Run: full_setup.bat (as Administrator)
echo.
echo 3. 🔧 Fix domain setup:
echo    Run: setup_domain.bat (as Administrator)
echo.
echo 4. ⚙️ Configure DNS:
echo    Run: configure_cloudflare_dns.bat (as Administrator)
echo.
echo 5. 🧪 Test locally first:
echo    http://127.0.0.1:50129/
echo.

pause
