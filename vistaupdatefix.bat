@echo off
:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

REM  --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"

REM  --> Script credits: https://sites.google.com/site/eneerge/scripts/batchgotadmin

echo.
echo About to install Windows Update hotfixes...
echo.
echo If you have not ran this as administrator, please close and do so now.
echo This patch is only for Windows Vista SP2.
echo It will automatically detect architecture and download the appropriate files.
echo Please ensure you are connected to the Internet to download the updates.
echo They will begin downloading as soon as you proceed.
echo.
PAUSE

REM  --> Check architecture

reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && set OS=32BIT || set OS=64BIT

if %OS%==32BIT goto 32bit
if %OS%==64BIT goto 64bit

:64bit
echo.
bitsadmin /transfer "Hotfix1" http://download.windowsupdate.com/d/msdownload/update/software/secu/2016/11/windows6.0-kb3205638-x64_a52aaa009ee56ca941e21a6009c00bc4c88cbb7c.msu %~dp0\kb3205638-x64.msu
bitsadmin /transfer "Hotfix2" http://download.windowsupdate.com/c/msdownload/update/software/secu/2017/02/windows6.0-kb4012583-x64_f63c9a85aa877d86c886e432560fdcfad53b752d.msu %~dp0\kb4012583-x64.msu
bitsadmin /transfer "Hotfix3" http://download.windowsupdate.com/d/msdownload/update/software/secu/2017/03/windows6.0-kb4015195-x64_2e310724d86b6a43c5ae8ec659685dd6cfb28ba4.msu %~dp0\kb4015195-x64.msu
bitsadmin /transfer "Hotfix4" http://download.windowsupdate.com/c/msdownload/update/software/secu/2017/03/windows6.0-kb4015380-x64_959aedbe0403d160be89f4dac057e2a0cd0c6d40.msu %~dp0\kb4015380-x64.msu
echo.
echo Stopping Windows Update service...
echo.
sc config wuauserv start= demand
net stop wuauserv
echo Installing windows6.0-kb3205638-x64...
wusa.exe %~dp0\kb3205638-x64.msu /quiet /norestart
echo.
echo Installing windows6.0-kb4012583-x64...
wusa.exe %~dp0\kb4012583-x64.msu /quiet /norestart
echo.
echo Installing windows6.0-kb4015195-x64...
wusa.exe %~dp0\kb4015195-x64.msu /quiet /norestart
echo.
echo Installing windows6.0-kb4015380-x64...
wusa.exe %~dp0\kb4015380-x64.msu /quiet /norestart
goto end

:32bit
echo.
bitsadmin /transfer "Hotfix1" http://download.windowsupdate.com/d/msdownload/update/software/secu/2016/11/windows6.0-kb3205638-x86_e2211e9a6523061972decd158980301fc4c32a47.msu %~dp0\kb3205638.msu
bitsadmin /transfer "Hotfix2" http://download.windowsupdate.com/c/msdownload/update/software/secu/2017/02/windows6.0-kb4012583-x86_1887cb5393b62cbd2dbb6a6ff6b136e809a2fbd0.msu %~dp0\kb4012583.msu
bitsadmin /transfer "Hotfix3" http://download.windowsupdate.com/d/msdownload/update/software/secu/2017/03/windows6.0-kb4015195-x86_eb045e0144266b20b615f29fa581c4001ebb7852.msu %~dp0\kb4015195.msu
bitsadmin /transfer "Hotfix4" http://download.windowsupdate.com/d/msdownload/update/software/secu/2017/03/windows6.0-kb4015380-x86_3f3548db24cf61d6f47d2365c298d739e6cb069a.msu %~dp0\kb4015380.msu
echo.
echo Stopping Windows Update service...
echo.
sc config wuauserv start= demand
net stop wuauserv
echo Installing windows6.0-kb3205638-x64...
wusa.exe %~dp0\kb3205638-x64.msu /quiet /norestart
echo.
echo Installing windows6.0-kb4012583-x64...
wusa.exe %~dp0\kb4012583-x64.msu /quiet /norestart
echo.
echo Installing windows6.0-kb4015195-x64...
wusa.exe %~dp0\kb4015195-x64.msu /quiet /norestart
echo.
echo Installing windows6.0-kb4015380-x64...
wusa.exe %~dp0\kb4015380-x64.msu /quiet /norestart
goto end

:end
echo.
echo Restarting Windows Update service...
echo.
sc config wuauserv start= delayed-auto
net start wuauserv
echo Complete! Restart your computer and attempt to run Windows Update.
echo.
PAUSE