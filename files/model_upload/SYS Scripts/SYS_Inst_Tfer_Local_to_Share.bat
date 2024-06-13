@echo off
rem This script logs onto a share drive using the net use command and copies data from the local machine to the share drive using the xcopy command

set SHARE_DRIVE=%~1
set SHARE_USER=%~2
set SHARE_PASS=%~3
set LOCAL_DATA=%~4
set SHARE_DATA=%~5

rem Log onto the share drive with the specified username and password
net use e: %SHARE_DRIVE% /user:%SHARE_USER% %SHARE_PASS%

rem Get the current date in the format of YYYYMMDD
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"

rem use datestamp, timestamp or the combination of both depending on frequency of backup
set "datestamp=%YYYY%%MM%%DD%" & set "timestamp=%HH%%Min%%Sec%"
set "fullstamp=%YYYY%-%MM%-%DD%_%HH%-%Min%-%Sec%"

rem backup first
xcopy /s /e /y /i "%LOCAL_DATA%" "%LOCAL_DATA%_backup%fullstamp%"
xcopy /s /e /y /i "%LOCAL_DATA%" "%LOCAL_DATA%_copy%fullstamp%"
xcopy /s /e /y /i "%SHARE_DATA%" "%SHARE_DATA%_backup%fullstamp%"

rem delete security objects
del /s /q "%LOCAL_DATA%_copy%fullstamp%\}CAMAssociatedGroups.dim"
del /s /q "%LOCAL_DATA%_copy%fullstamp%\}ClientCAMAssociatedGroups.cub"
del /s /q "%LOCAL_DATA%_copy%fullstamp%\}ClientCAMAssociatedGroups.feeders"
del /s /q "%LOCAL_DATA%_copy%fullstamp%\}ClientCAMAssociatedGroups.RUX"
del /s /q "%LOCAL_DATA%_copy%fullstamp%\}ClientGroups.cub"
del /s /q "%LOCAL_DATA%_copy%fullstamp%\}ClientGroups.RUX"
del /s /q "%LOCAL_DATA%_copy%fullstamp%\}ClientGroups.feeders"
del /s /q "%LOCAL_DATA%_copy%fullstamp%\}ClientProperties.cub"
del /s /q "%LOCAL_DATA%_copy%fullstamp%\}ClientProperties.dim"
del /s /q "%LOCAL_DATA%_copy%fullstamp%\}ClientProperties.feeders"
del /s /q "%LOCAL_DATA%_copy%fullstamp%\}ClientProperties.RUX"
del /s /q "%LOCAL_DATA%_copy%fullstamp%\}Clients.dim"
del /s /q "%LOCAL_DATA%_copy%fullstamp%\}ClientSettings.cub"
del /s /q "%LOCAL_DATA%_copy%fullstamp%\}ClientSettings.dim"
del /s /q "%LOCAL_DATA%_copy%fullstamp%\}ClientSettings.feeders"
del /s /q "%LOCAL_DATA%_copy%fullstamp%\}ClientSettings.RUX"
del /s /q "%LOCAL_DATA%_copy%fullstamp%\}Groups.dim"

rem Copy the data from the local machine to the share drive with the /E /Y options to copy all subdirectories and overwrite existing files
xcopy "%LOCAL_DATA%_copy" "e:%SHARE_DATA%" /E /Y
rem Log off the share drive
net use e: /delete

rmdir /s /q "%LOCAL_DATA%_copy%fullstamp%"

