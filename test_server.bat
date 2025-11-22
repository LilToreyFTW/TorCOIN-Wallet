@echo off
echo ==================================================
echo       TORCOIN TEST WEB SERVER STARTER
echo ==================================================
echo.
echo Testing TorCOIN server on localhost:50129
echo.
echo Test your 3D coin locally at:
echo http://127.0.0.1:50129/
echo http://127.0.0.1:50129/torcoin.html
echo.
echo For production deployment, use start_coin_server.bat
echo.
echo Press Ctrl+C to stop the test server
echo ==================================================
echo.

python test_server.py

echo.
echo Test server stopped.
pause
