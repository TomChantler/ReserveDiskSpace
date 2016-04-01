@echo off
REM By Tom Chantler - https://tomssl.com/2016/04/01/how-to-reserve-disk-space-to-save-yourself-from-a-world-of-pain
:CheckIfAnyParametersPassedIn
set _fileSizeParam=%~1
set _fileCountParam=%~2
set _filePathParam=%~3
set _hasParams=T
REM If either of the first two parameters is blank, then go to interactive mode.
if [%_fileSizeParam%] == [] set _hasParams=F
if [%_fileCountParam%] == [] set _hasParams=F
REM If the third parameter is missing, just use the current (working) directory.
if [%_filePathParam%] == [] set _filePathParam=%cd%
if "%_hasParams%" == "T" goto UseParams

REM If we get to here then we didn't have any parameters.
:GetFileSize
REM First we get the desired size for each placeholder file.
echo How large do you want to make each placeholder file?
echo 1: 100MB
echo 2: 250MB
echo 3: 500MB
echo 4: 1GB
echo Q: Quit
CHOICE /C:1234Q
goto Choice%errorlevel%

:Choice1
set _fileSizeMB=100
goto GetNumberOfFiles
:Choice2
set _fileSizeMB=250
goto GetNumberOfFiles
:Choice3
set _fileSizeMB=500
goto GetNumberOfFiles
:Choice4
set _fileSizeMB=1024
goto GetNumberOfFiles
:Choice5
goto :eof

:GetNumberOfFiles
REM Get number of files next and do a quick sum to show the total amount of space we're going to reserve.
echo How many placeholder files do you want to make?
set /a "_totalSize=_fileSizeMB"
echo 1: 1 [%_totalSize% MB total]
set /a "_totalSize=2*_fileSizeMB"
echo 2: 2 [%_totalSize% MB total]
set /a "_totalSize=3*_fileSizeMB"
echo 3: 3 [%_totalSize% MB total]
set /a "_totalSize=4*_fileSizeMB"
echo 4: 4 [%_totalSize% MB total]
set /a "_totalSize=5*_fileSizeMB"
echo 5: 5 [%_totalSize% MB total]
echo Q: Quit
CHOICE /C:12345Q
if %errorlevel% == 6 goto :eof
set _numberOfFiles=%errorlevel%
goto MakeFiles

:UseParams
REM If we passed in parameters let's skip the interactive bit and just use them in here.
set _fileSizeMB=%_fileSizeParam%
set _numberOfFiles=%_fileCountParam%
if not exist %_filePathParam% (
    mkdir %_filePathParam%
)
if not exist %_filePathParam% (
    echo Unable to find ^(or create^) directory %_filePathParam%. Exiting.
	goto :eof
)
goto MakeFiles

:MakeFiles
set /a "_fileSizeBytes=_fileSizeMB*1024*1024"
set /a "_totalSize=_numberOfFiles*_fileSizeMB"
echo Creating %_numberOfFiles% files of %_fileSizeMB% MB each (%_totalSize% MB in total).
setlocal EnableDelayedExpansion
for /l %%i in (1,1,%_numberOfFiles%) DO (
	set "%%i=000000%%i"
	fsutil file createnew "%_filePathParam%\EmptyFile_%_fileSizeMB%MB_!%%i:~-3!.dat" %_fileSizeBytes%
)
echo Done.