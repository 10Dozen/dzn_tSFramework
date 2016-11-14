call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\Support\Settings.sqf";
call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\Support\Functions.sqf";

/*
tSF_Support_ReturnPoint

getVariable "tSF_Support"

*/

if (isServer) then {
	tSF_fnc_Support_processLogics = {
		{
			private _logic = _x;
			
			if !(isNil {_logic getVariable "tSF_Support"}) then {				
				tSF_Support_Vehicles pushBack [
					(synchronizedObjects _logic) select 0
					, _logic getVariable "tSF_Support"
				];
			};
			
			if !(isNil {_logic getVariable "tSF_Support_ReturnPoint"}) then {
				tSF_Support_ReturnPoint = _logic;
			};			
		} forEach (entities "Logic");
		
	};

	waitUntil { time > tSF_Support_initTimeout };
	tSF_Support_Vehicles = [];
	tSF_Support_ReturnPoint = objNull;
	call tSF_fnc_Support_processLogics;
};
