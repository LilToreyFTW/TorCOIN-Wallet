@echo off
echo ==================================================
echo        TORCOIN SECURE PROXY STARTER
echo ==================================================
echo.
echo Starting TorCOIN Self Proxy Server...
echo 🔒 STRICT MODE: Only TorCOIN traffic allowed
echo 🌐 Proxy will run on port 8080
echo.
echo 📋 To use:
echo 1. Set browser proxy to: localhost:8080
echo 2. Access: http://www.torcoin.cnet
echo.
echo 🛑 Press Ctrl+C to stop
echo ==================================================
echo.

python torcoin_proxy.py

echo.
echo Proxy stopped.
pause
