cls
@echo off
setlocal

: Mission directory
set main=%~dp0
for %%a in (.) do set currentfolder=%%~na

cd %main%

echo #####################################################################
echo #                                                                   #
echo #    tSF File Sweeper                                               #      
echo #    Remove all non-arma files from your mission                    #
echo #    (e.g. html-helpers) and unused tSFramework files               #
echo #    (according to dzn_tSFramework_Init.sqf settings)               #
echo #                                                                   #
echo #####################################################################

set /p exitout="Do you want to remove unused files? [y]es [n]o   "
if %exitout%==n exit

echo "####### tSF File Sweeper Engaged #######" > tSF_FS_log.txt
echo Mission directory:     %main% >> tSF_FS_log.txt
echo Mission fodler name:   %currentfolder% >> tSF_FS_log.txt

cd %main%
echo Removing tSF Helpers
echo Removing tSF Helpers >> tSF_FS_log.txt
del /q /f  init3DEN.sqf
del /q /f  README.md
del /q /f  dzn_tSFramework\tS_SettingsOverview.html
@RD /S /Q dzn_tSFramework\3DEN
@RD /S /Q dzn_tSFramework\Modules\Briefing\BriefingHelper
@RD /S /Q dzn_tSFramework\Modules\MissionConditions\EndingsHelper

echo Removing DynAI Helpers
echo Removing DynAI Helpers >> tSF_FS_log.txt
@RD /S /Q dzn_dynai\tools

: Clearing unused folders
echo Removing unused tSF Modules
echo Removing unused tSF Modules >> tSF_FS_log.txt

call :removeFolder tSF_module_ACEActions ACEActions
call :removeFolder tSF_module_AirborneSupport AirborneSupport
call :removeFolder tSF_module_ArtillerySupport ArtillerySupport
call :removeFolder tSF_module_Authorization Authorization
call :removeFolder tSF_module_Briefing Briefing
call :removeFolder tSF_module_CCP CCP
call :removeFolder tSF_module_Conversations Conversations
call :removeFolder tSF_module_EditorRadioSettings EditorRadioSettings
call :removeFolder tSF_module_EditorUnitBehavior EditorUnitBehavior
call :removeFolder tSF_module_EditorVehicleCrew EditorVehicleCrew
call :removeFolder tSF_module_FARP FARP
call :removeFolder tSF_module_Interactives Interactives
call :removeFolder tSF_module_IntroText IntroText
call :removeFolder tSF_module_JIPTeleport JIPTeleport
call :removeFolder tSF_module_MissionConditions MissionConditions
call :removeFolder tSF_module_MissionDefaults MissionDefaults
call :removeFolder tSF_module_POM POM
call :removeFolder tSF_module_tSAdminTools tSAdminTools
call :removeFolder tSF_module_tSNotes tSNotes
call :removeFolder tSF_module_tSSettings tSSettings

echo #####################################################################
echo #                                                                   #
echo #    tSF File Sweeper has finished his work.                        #      
echo #    All non-arma files were removed. Have a nice day!              #
echo #                                                                   #
echo #####################################################################

del /q /f  tSFS_temp.txt
del /q /f  tSFS_temp2.txt

echo Done! >> tSF_FS_log.txt
( del /q /f "%~f0" >nul 2>&1 & exit /b 0  )

pause
exit

:removeFolder
set tsfparam="%1"
set  tsffolder=%2

findstr  /c:%tsfparam% dzn_tSFramework\dzn_tSFramework_Init.sqf  > tSFS_temp.txt
findstr  "true" tSFS_temp.txt > tSFS_temp2.txt
for /f %%i in ("tSFS_temp2.txt") do set size=%%~zi
if NOT %size% gtr 0 (
	echo     Folder is not used: Removing %tsffolder% >> tSF_FS_log.txt
	@RD /S /Q dzn_tSFramework\Modules\%tsffolder%
)
