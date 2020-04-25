@echo off
echo.
echo About to install Windows Update hotfixes...
echo.
echo If you have not ran this as administrator, please close and do so now.
echo This patch is only for Windows Vista SP2 x64.
echo Please ensure you are connected to the Internet to download the updates.
echo They will begin downloading as soon as you proceed.
echo.
PAUSE
echo.
bitsadmin /transfer "Hotfix1" http://download.windowsupdate.com/d/msdownload/update/software/secu/2016/11/windows6.0-kb3205638-x64_a52aaa009ee56ca941e21a6009c00bc4c88cbb7c.msu %~dp0\kb3205638.msu
bitsadmin /transfer "Hotfix2" http://download.windowsupdate.com/c/msdownload/update/software/secu/2017/02/windows6.0-kb4012583-x64_f63c9a85aa877d86c886e432560fdcfad53b752d.msu %~dp0\kb4012583.msu
bitsadmin /transfer "Hotfix3" http://download.windowsupdate.com/d/msdownload/update/software/secu/2017/03/windows6.0-kb4015195-x64_2e310724d86b6a43c5ae8ec659685dd6cfb28ba4.msu %~dp0\kb4015195.msu
bitsadmin /transfer "Hotfix4" http://download.windowsupdate.com/c/msdownload/update/software/secu/2017/03/windows6.0-kb4015380-x64_959aedbe0403d160be89f4dac057e2a0cd0c6d40.msu %~dp0\kb4015380.msu
echo.
echo Stopping Windows Update service...
echo.
sc config wuauserv start= demand
net stop wuauserv
echo Installing windows6.0-kb3205638-x64...
wusa.exe %~dp0\kb3205638.msu /quiet /norestart
echo.
echo Installing windows6.0-kb4012583-x64...
wusa.exe %~dp0\kb4012583.msu /quiet /norestart
echo.
echo Installing windows6.0-kb4015195-x64...
wusa.exe %~dp0\kb4015195.msu /quiet /norestart
echo.
echo Installing windows6.0-kb4015380-x64...
wusa.exe %~dp0\kb4015380.msu /quiet /norestart
echo.
echo Restarting Windows Update service...
echo.
sc config wuauserv start= delayed-auto
net start wuauserv
echo Complete! Restart your computer and attempt to run Windows Update.
echo.
PAUSE