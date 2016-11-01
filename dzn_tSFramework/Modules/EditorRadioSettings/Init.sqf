call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\EditorRadioSettings\Settings.sqf";

if (isServer) then {
	tSF_fnc_ERS_assignRadioBySide = {
	
	};
	
	tSF_fnc_ERS_processLogics = {
		{
			private _logic = _x;
			private _syncUnits = synchronizedObjects _x;
			
			if !(isNil {_logic getVariable "tSF_ERS_LRBySide"}) then {
				private _LRBySide = _logic getVariable "tSF_ERS_LRBySide";
				{ [_x, _LRBySide] call tSF_fnc_ERS_assignRadioBySide } forEach _syncUnits;
			};
		} forEach (entities "Logic");	
	};

	waitUntil { time > tSF_ERS_initTimeout };
	call tSF_fnc_ERS_processLogics;
};
