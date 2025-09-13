
//	Tacitcal Shift Framework initialization
[{ !isNil "MissionDate" }, {
	if (!isServer && getClientStateNumber < 10) then { setDate MissionDate; };

	// TS Framework (true для включения режима редактирования в dzn_gear)
	[true] call compileScript ["dzn_tSFramework\Modules\Core\PreInit.sqf"];

	// dzn AAR
	[] execVM "dzn_brv\dzn_brv_init.sqf";
}] call CBA_fnc_waitUntilAndExecute;
