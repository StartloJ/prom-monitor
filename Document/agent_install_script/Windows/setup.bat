@echo off
for /r %%f in (wmi*.msi) do (
    SET file=%%~nxf
)
:promt

SET /P CHOICE=What are you want to monitor (mssql / iis / both[mssql+iis])?

IF /I "%CHOICE%" EQU "mssql" goto :mssql
IF /I "%CHOICE%" EQU "iis" goto :iis
IF /I "%CHOICE%" EQU "both" goto :both
goto :promt

:mssql
echo mssql
msiexec /i %CD%\%file% ENABLED_COLLECTORS=cpu,cs,logical_disk,net,mssql,os,process,service,system,tcp,textfile
pause
goto :EOF

:iis
echo iis
msiexec /i %CD%\%file% ENABLED_COLLECTORS=cpu,cs,logical_disk,net,iis,os,process,service,system,tcp,textfile
pause
goto :EOF

:both
echo iis and mssql
msiexec /i %CD%\%file% ENABLED_COLLECTORS=cpu,cs,logical_disk,net,mssql,iis,os,process,service,system,tcp,textfile
goto :EOF
pause