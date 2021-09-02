@echo off
color a
title Windows 10 Internet speed upgrader By xExmrg

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

:ask
SET /P _inputname= Upgrade(1) or Downgrade(2):
IF "%_inputname%"=="1" goto :upgrade
IF "%_inputname%"=="2" goto :downgrade
echo wrong number 1 - Upgrade 2 - Downgrade
pause
goto :ask

:upgrade
cls
netsh winsock reset
netsh int tcp set global chimney=enabled
netsh int tcp set global autotuninglevel=normal
netsh int tcp set supplemental
netsh int tcp set global dca=enabled
netsh int tcp set global netdma=enabled
netsh int tcp set global ecncapability=enabled
ipconfig /release 
ipconfig /renew
ipconfig /flushdns
netsh advfirewall firewall add rule name="StopThrottling" dir=in action=block
remoteip=173.194.55.0/24,206.111.0.0/16 enable=yes
echo Your PC will reboot now
shutdown /r /t 5
pause
goto :end

:downgrade
cls
netsh int tcp set global dca=disabled
netsh int tcp set global netdma=disabled
netsh int tcp set global ecncapability=disabled
netsh int tcp set global chimney=disabled
echo Your PC will reboot now
shutdown /r /t 5
pause
:end
exit

 