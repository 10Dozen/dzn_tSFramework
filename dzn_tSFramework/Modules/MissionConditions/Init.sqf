call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\MissionConditions\Settings.sqf";
call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\MissionConditions\Functions.sqf";

if (hasInterface) then {
	[] spawn dzn_fnc_missionConditions_startClienListener;
};

if (isServer) then {
	tSF_Ends = [];
	[] spawn dzn_fnc_missionConditions_prepareConditions;	
};
