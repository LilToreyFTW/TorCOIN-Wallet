@echo off
echo ==================================================
echo         TORCOIN WEB SERVER STARTER
echo ==================================================
echo.
echo 🔥 Starting TorCOIN Server...
echo 📡 Binding to all interfaces (0.0.0.0:50129)
echo.
echo 🎯 ULTRA HARDCODED ACCESS LINK:
echo 🔗 https://www.torcoin.cnet
echo.
echo 💡 Note: Run setup_domain.bat first if domain not configured
echo.
echo 🛑 Press Ctrl+C to stop the server
echo ==================================================
echo.

python coin_server.py

echo.
echo Server stopped.
pause
