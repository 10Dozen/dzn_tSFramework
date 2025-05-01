
//	Tacitcal Shift Framework initialization
[{ !isNil "MissionDate" }, {
	if (!isServer && getClientStateNumber < 10) then { setDate MissionDate; };

	// TS Framework (set true to engage dzn_gear's Edit mode)
	[true] call compileScript ["dzn_tSFramework\dzn_tSFramework_Init.sqf"];
	// dzn AAR
	[] execVM "dzn_brv\dzn_brv_init.sqf";
}] call CBA_fnc_waitUntilAndExecute;
