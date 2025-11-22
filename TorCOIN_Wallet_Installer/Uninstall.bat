@echo off
echo ==================================================
echo      TORCOIN WALLET UNINSTALLER
echo ==================================================
echo.
echo This will remove TorCOIN Wallet from your system.
echo Your wallet files will NOT be deleted.
echo.
pause

echo Removing desktop shortcut...
if exist "%USERPROFILE%\Desktop\TorCOIN Wallet.lnk" del "%USERPROFILE%\Desktop\TorCOIN Wallet.lnk"

echo Removing start menu entry...
if exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\TorCOIN Wallet.lnk" del "%APPDATA%\Microsoft\Windows\Start Menu\Programs\TorCOIN Wallet.lnk"

echo ✅ TorCOIN Wallet uninstalled successfully!
echo.
echo Your wallet files are safe in the installation folder.
pause
