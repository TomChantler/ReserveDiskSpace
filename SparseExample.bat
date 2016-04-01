@echo off
REM By Tom Chantler - https://tomssl.com/2016/04/01/how-to-reserve-disk-space-to-save-yourself-from-a-world-of-pain
REM 100GB of files takes up no disk space
setlocal EnableDelayedExpansion
for /l %%i in (1,1,10) DO (
    set "%%i=0000%%i"
    fsutil file createnew C:\10GB_!%%i:~-3!.dat 10737418240
    fsutil sparse setflag C:\10GB_!%%i:~-3!.dat
    fsutil sparse setrange C:\10GB_!%%i:~-3!.dat 0 10737418240
)