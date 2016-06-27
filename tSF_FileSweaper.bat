Echo "tSF Sweaper Engaged"

@RD /S /Q %~dp0dzn_dynai\tools
@RD /S /Q %~dp0dzn_tSFramework\3DEN
@RD /S /Q %~dp0dzn_tSFramework\Tools
@RD /S /Q %~dp0dzn_tSFramework\Modules\Briefing\BriefingHelper
@RD /S /Q %~dp0dzn_tSFramework\Modules\MissionConditions\EndingsHelper
del  /q /f  %~dp0init3DEN.sqf

Echo "tSF Sweaper Finished his work. Or non-arma files were removed. Have a nice day!"

( del /q /f "%~f0" >nul 2>&1 & exit /b 0  )
