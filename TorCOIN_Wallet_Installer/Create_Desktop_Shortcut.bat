@echo off
echo Creating desktop shortcut for TorCOIN Wallet...

set SCRIPT="C:\Users\ghost\AppData\Local\Temp\CreateShortcut.vbs"

(
echo Set oWS = WScript.CreateObject("WScript.Shell")
echo sLinkFile = oWS.ExpandEnvironmentStrings("%USERPROFILE%\Desktop\TorCOIN Wallet.lnk")
echo Set oLink = oWS.CreateObject("WScript.Shell").CreateShortcut(sLinkFile)
echo oLink.TargetPath = "%~dp0Run_TorCOIN_Wallet.bat"
echo oLink.WorkingDirectory = "%~dp0"
echo oLink.Description = "TorCOIN Wallet - Privacy-First Digital Currency"
echo oLink.IconLocation = "%SystemRoot%\System32\SHELL32.dll,13"
echo oLink.Save
) > %SCRIPT%

cscript //nologo %SCRIPT%
del %SCRIPT%

echo ✅ Desktop shortcut created!
echo You can now double-click "TorCOIN Wallet" on your desktop.
pause
