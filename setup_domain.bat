@echo off
echo ==================================================
echo       TORCOIN DOMAIN SETUP HELPER
echo ==================================================
echo.
echo This will add www.torcoin.cnet to your hosts file
echo so you can access your coin at https://www.torcoin.cnet
echo.
echo You may need administrator privileges.
echo.
pause

echo Adding domain to hosts file...

echo. >> %windir%\System32\drivers\etc\hosts
echo # TorCOIN Local Domain >> %windir%\System32\drivers\etc\hosts
echo 127.0.0.1 www.torcoin.cnet >> %windir%\System32\drivers\etc\hosts

echo.
echo ✅ Domain configured!
echo.
echo Now you can access your coin at:
echo https://www.torcoin.cnet
echo.
echo (Make sure your server is running on port 50129)
echo.
pause
