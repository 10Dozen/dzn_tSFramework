call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\MissionConditions\Settings.sqf";
call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\MissionConditions\Functions.sqf";

if (hasInterface) then {
	[] spawn dzn_fnc_missionConditions_startClienListener;
	
	if (tSF_MissionCondition_EnableMissionEndsControl) then {
		[] spawn {
			waitUntil { call dzn_fnc_missionConditions_checkIsAdmin };
			[] spawn dzn_fnc_missionConditions_addMissionEndsControls;
		};
	};
};

if (isServer) then {
	tSF_Ends = [];
	[] spawn dzn_fnc_missionConditions_prepareConditions;
	
	publicVariable "tSF_Ends";
};
