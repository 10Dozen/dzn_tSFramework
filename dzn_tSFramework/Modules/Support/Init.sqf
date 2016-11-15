call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\Support\Settings.sqf";
call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\Support\Functions.sqf";

/*
tSF_Support_ReturnPoint

getVariable "tSF_Support"

*/

if (hasInterface) then {
	[] spawn {
		waitUntil { !isNil "tSF_Support_Vehicles" && { !(tSF_Support_Vehicles isEqualTo []) } };
		{ _x call tSF_fnc_Support_processVehicleClient } forEach tSF_Support_Vehicles;
	};
};


if (isServer) then {
	waitUntil { time > tSF_Support_initTimeout };
	
	tSF_Support_Vehicles = [];
	tSF_Support_ReturnPoint = objNull;
	
	call tSF_fnc_Support_processLogics;
	{ _x call tSF_fnc_Support_processVehicleServer } forEach tSF_Support_Vehicles;
	
	publicVariable "tSF_Support_Vehicles";
	publicVariable "tSF_Support_ReturnPoint";
};
