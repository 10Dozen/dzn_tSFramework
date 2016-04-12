// ********************
// INITIALIZATION
// ********************

call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\CCP\Settings.sqf";
call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\CCP\DefaultCompositions.sqf";
call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\CCP\Functions.sqf";

[] spawn {
	waitUntil { time > 0 };
	dzn_tsf_CCP_Position = call dzn_fnc_tsf_CCP_findMarker;
	if !(dzn_tsf_CCP_Position isEqualTo []) then {
		[
			dzn_tsf_CCP_HealTime
			, dzn_tsf_CCP_Radius
			, dzn_tsf_CCP_PreventPlayerDeath
			, dzn_tsf_CCP_Position
			, dzn_tsf_CCP_DefaultComposition
		]  spawn dzn_fnc_tsf_CCP_createCCP
	};
};
