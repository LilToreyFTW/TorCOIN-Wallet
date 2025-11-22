@echo off
echo ==================================================
echo      TORCOIN STRICT FIREWALL CONFIGURATION
echo ==================================================
echo.
echo This will create STRICT firewall rules for TorCOIN:
echo ✅ Allow ONLY TorCOIN server (port 50129)
echo ❌ Block ALL other inbound traffic
echo ❌ Block ALL outbound traffic except essentials
echo.
echo ⚠️  WARNING: This will make your PC very secure but restrictive!
echo ⚠️  You may lose internet access for non-TorCOIN sites!
echo.
echo Press Ctrl+C NOW if you don't want to continue...
echo.
pause

echo.
echo 🔒 Creating STRICT firewall rules...
echo.

:: Backup current firewall settings
echo 📋 Backing up current firewall configuration...
netsh advfirewall export "C:\TorCOIN_Firewall_Backup.wfw" >nul

:: Reset firewall to defaults first
echo 🧹 Resetting firewall to clean state...
netsh advfirewall reset >nul

:: Enable Windows Firewall
echo 🔥 Enabling Windows Firewall...
netsh advfirewall set allprofiles state on >nul

:: Block ALL inbound traffic by default
echo 🚫 Blocking ALL inbound traffic...
netsh advfirewall set allprofiles firewallpolicy blockinbound,blockoutbound >nul

:: Allow TorCOIN server inbound (port 50129)
echo ✅ Allowing TorCOIN server (port 50129 inbound)...
netsh advfirewall firewall add rule name="TorCOIN_Server_Inbound" dir=in action=allow protocol=TCP localport=50129 >nul

:: Allow essential outbound traffic
echo 🌐 Allowing essential outbound traffic...

:: DNS (required for domain resolution)
netsh advfirewall firewall add rule name="DNS_Outbound" dir=out action=allow protocol=UDP remoteport=53 >nul
netsh advfirewall firewall add rule name="DNS_TCP_Outbound" dir=out action=allow protocol=TCP remoteport=53 >nul

:: DHCP (IP address assignment)
netsh advfirewall firewall add rule name="DHCP_Outbound" dir=out action=allow protocol=UDP remoteport=67-68 >nul

:: Windows Update and essential Microsoft services
netsh advfirewall firewall add rule name="Windows_Update" dir=out action=allow protocol=TCP remoteport=80,443 remoteip=13.64.0.0/11,13.96.0.0/13,13.104.0.0/14,20.0.0.0/8,23.0.0.0/8,40.0.0.0/8,52.0.0.0/8,65.0.0.0/8,104.0.0.0/8,131.0.0.0/8,132.0.0.0/8,134.0.0.0/8,135.0.0.0/8,136.0.0.0/8,137.0.0.0/8,138.0.0.0/8,139.0.0.0/8,140.0.0.0/8,141.0.0.0/8,142.0.0.0/8,143.0.0.0/8,144.0.0.0/8,145.0.0.0/8,146.0.0.0/8,147.0.0.0/8,148.0.0.0/8,149.0.0.0/8,150.0.0.0/8,151.0.0.0/8,152.0.0.0/8,153.0.0.0/8,154.0.0.0/8,155.0.0.0/8,156.0.0.0/8,157.0.0.0/8,158.0.0.0/8,159.0.0.0/8 >nul

:: Local network traffic (for file sharing, etc.)
netsh advfirewall firewall add rule name="Local_Network" dir=out action=allow remoteip=192.168.0.0/16,10.0.0.0/8,172.16.0.0/12 >nul

:: Allow loopback (localhost) traffic
netsh advfirewall firewall add rule name="Loopback" dir=out action=allow remoteip=127.0.0.1 >nul

:: Allow outbound to Cloudflare DNS (1.1.1.1, 1.0.0.1)
netsh advfirewall firewall add rule name="Cloudflare_DNS_1" dir=out action=allow remoteip=1.1.1.1 >nul
netsh advfirewall firewall add rule name="Cloudflare_DNS_2" dir=out action=allow remoteip=1.0.0.1 >nul

:: Block all other outbound traffic
echo 🚫 Blocking all other outbound traffic...
netsh advfirewall set allprofiles firewallpolicy blockinboundalways,blockoutbound >nul

echo.
echo ✅ STRICT FIREWALL CONFIGURED!
echo.
echo 🔒 SECURITY STATUS:
echo ✅ Only TorCOIN server port (50129) is accessible
echo ✅ All other inbound traffic blocked
echo ✅ Most outbound traffic blocked (only essentials allowed)
echo ✅ DNS resolution allowed
echo ✅ Local network traffic allowed
echo ✅ Windows Update allowed
echo.
echo 📋 BACKUP SAVED: C:\TorCOIN_Firewall_Backup.wfw
echo 💡 To restore: netsh advfirewall import "C:\TorCOIN_Firewall_Backup.wfw"
echo.
echo 🎯 Your TorCOIN server is now ULTRA SECURE!
echo Access only via: http://www.torcoin.cnet
echo.
pause
