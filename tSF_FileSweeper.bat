Echo "tSF Sweeper Engaged"

cd %~dp0
del  /q /f  init3DEN.sqf
del  /q /f  README.md

cd dzn_tSFramework
@RD /S /Q 3DEN
@RD /S /Q Tools

cd Modules\Briefing
@RD /S /Q BriefingHelper

cd ..
cd MissionConditions
@RD /S /Q EndingsHelper

cd ..
cd ..
cd ..
cd dzn_dynai
@RD /S /Q tools

Echo "tSF Sweeper Finished his work. All non-arma files were removed. Have a nice day!"

( del /q /f "%~f0" >nul 2>&1 & exit /b 0  )
