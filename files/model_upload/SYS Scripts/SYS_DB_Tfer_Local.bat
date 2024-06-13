@echo off

set source=%~1
set dest=%~2

REM Get the current date in the format of YYYYMMDD
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"

REM use datestamp, timestamp or the combination of both depending on frequency of backup
set "datestamp=%YYYY%%MM%%DD%" & set "timestamp=%HH%%Min%%Sec%"
set "fullstamp=%YYYY%-%MM%-%DD%_%HH%-%Min%-%Sec%"

rem backup first
xcopy /s /e /y /i "%source%" "%source%_backup%fullstamp%"
xcopy /s /e /y /i "%source%" "%source%_copy%fullstamp%"
xcopy /s /e /y /i "%dest%" "%dest%_backup%fullstamp%"

rem delete security objects
del /s /q "%source%_copy%fullstamp%\}CAMAssociatedGroups.dim"
del /s /q "%source%_copy%fullstamp%\}ClientCAMAssociatedGroups.cub"
del /s /q "%source%_copy%fullstamp%\}ClientCAMAssociatedGroups.feeders"
del /s /q "%source%_copy%fullstamp%\}ClientCAMAssociatedGroups.RUX"
del /s /q "%source%_copy%fullstamp%\}ClientGroups.cub"
del /s /q "%source%_copy%fullstamp%\}ClientGroups.RUX"
del /s /q "%source%_copy%fullstamp%\}ClientGroups.feeders"
del /s /q "%source%_copy%fullstamp%\}ClientProperties.cub"
del /s /q "%source%_copy%fullstamp%\}ClientProperties.dim"
del /s /q "%source%_copy%fullstamp%\}ClientProperties.feeders"
del /s /q "%source%_copy%fullstamp%\}ClientProperties.RUX"
del /s /q "%source%_copy%fullstamp%\}Clients.dim"
del /s /q "%source%_copy%fullstamp%\}ClientSettings.cub"
del /s /q "%source%_copy%fullstamp%\}ClientSettings.dim"
del /s /q "%source%_copy%fullstamp%\}ClientSettings.feeders"
del /s /q "%source%_copy%fullstamp%\}ClientSettings.RUX"
del /s /q "%source%_copy%fullstamp%\}Groups.dim"

rem Copy the data from the local machine to the share drive with the /E /Y options to copy all subdirectories and overwrite existing files
xcopy "%source%_copy%fullstamp%" "%dest%" /E /Y

rem delete copy and all subdirectories
rmdir /s /q "%source%_copy%fullstamp%"

