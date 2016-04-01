@echo off
REM By Tom Chantler - https://tomssl.com/2016/04/01/how-to-reserve-disk-space-to-save-yourself-from-a-world-of-pain
:CheckIfRunningAsAdministrator
net session >nul 2>&1
if %errorlevel% == 0 (
    echo Running as administrator.
) else (
    echo Sorry, you need to run this as an Administrator.
    goto End
)

:CopyFileAndSetPath
mkdir "%ProgramFiles(x86)%\TomSSL"
cd /d %~dp0
copy ReserveDiskSpace.bat "%ProgramFiles(x86)%\TomSSL"
echo %TomSSL% | find /C /I "%ProgramFiles(x86)%\TomSSL" > NUL
if %errorlevel% == 0 (
	echo Path already set
) 
if %errorlevel% == 1 (
	echo Adding "%%ProgramFiles(x86)%%\TomSSL" to system path as ^%TomSSL^%.
	setx TomSSL "%%ProgramFiles(x86)%%\TomSSL" /m
) 
echo Done.
:End
pause