@echo off
rem This script logs onto a share drive using the net use command and copies data from the local machine to the share drive using the xcopy command

set SHARE_DRIVE=%1
set SHARE_USER=%2
set SHARE_PASS=%3
set LOCAL_DATA=%4
set SHARE_DATA=%5

rem Log onto the share drive with the specified username and password
net use e: %SHARE_DRIVE% /user:%SHARE_USER% %SHARE_PASS%

rem backup first
xcopy /s /e /y /i "%LOCAL_DATA%" "%LOCAL_DATA%_backup"
xcopy /s /e /y /i "%LOCAL_DATA%" "%LOCAL_DATA%_copy"
xcopy /s /e /y /i "e:%SHARE_DATA%" "e:%SHARE_DATA%_backup"

rem delete security objects
del /s /q "%LOCAL_DATA%_copy\}CAMAssociatedGroups.dim"
del /s /q "%LOCAL_DATA%_copy\}ClientCAMAssociatedGroups.cub"
del /s /q "%LOCAL_DATA%_copy\}ClientCAMAssociatedGroups.feeders"
del /s /q "%LOCAL_DATA%_copy\}ClientCAMAssociatedGroups.RUX"
del /s /q "%LOCAL_DATA%_copy\}ClientGroups.cub"
del /s /q "%LOCAL_DATA%_copy\}ClientGroups.RUX"
del /s /q "%LOCAL_DATA%_copy\}ClientGroups.feeders"
del /s /q "%LOCAL_DATA%_copy\}ClientProperties.cub"
del /s /q "%LOCAL_DATA%_copy\}ClientProperties.dim"
del /s /q "%LOCAL_DATA%_copy\}ClientProperties.feeders"
del /s /q "%LOCAL_DATA%_copy\}ClientProperties.RUX"
del /s /q "%LOCAL_DATA%_copy\}Clients.dim"
del /s /q "%LOCAL_DATA%_copy\}ClientSettings.cub"
del /s /q "%LOCAL_DATA%_copy\}ClientSettings.dim"
del /s /q "%LOCAL_DATA%_copy\}ClientSettings.feeders"
del /s /q "%LOCAL_DATA%_copy\}ClientSettings.RUX"
del /s /q "%LOCAL_DATA%_copy\}Groups.dim"

rem Copy the data from the local machine to the share drive with the /E /Y options to copy all subdirectories and overwrite existing files
xcopy "%LOCAL_DATA%_copy" "e:%SHARE_DATA%" /E /Y
rem Log off the share drive
net use e: /delete

rmdir /s /q "%LOCAL_DATA%_copy"

