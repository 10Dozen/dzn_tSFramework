call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\EditorVehicleCrew\Settings.sqf";

if (isServer) then {
	tSF_fnc_EVC_assignCrew = {
		// [@Vehicle, @ConfigName] spawn tSF_fnc_EVC_assignCrew
		params["_v","_configName"];
		
		private _config = [tSF_EVC_CrewConfig, _configName] call dzn_fnc_getValueByKey;
		
		if (typename _config == "BOOL") exitWith { 
			[format ["tSF - EVC :: There is no %1 config!", _configName]] call BIS_fnc_error;
		};
		
		private _roles 			= if (typename (_config select 0) == "ARRAY") then { _config select 0 } else { [_config select 0] };
		private _side 			= _config select 1;
		private _skill 			= _config select 2;
		private _kit 			= _config select 3;		
		private _applyVehicleHold 	= false;
		private _vehicleHoldAspect	= "";
		if (!isNil {_config select 4}) then {
			_applyVehicleHold = true;
			_vehicleHoldAspect = switch (toLower(_config select 4)) do {
				case "hold": { "vehicle hold" };
				case "frontal": { "vehicle 45 hold" };
				case "full frontal": { "vehicle 90 hold" };			
			};
		};
		
		if !(_kit == "") then {
			waitUntil { !isNil "dzn_gear_serverInitDone" };
		};	
		
		[_v, _side, _roles, if (_kit == "") then { nil } else { _kit }, _skill] call dzn_fnc_createVehicleCrew;
		
		if (_applyVehicleHold) then {
			waitUntil { !isNil "dzn_dynai_initialized" && { dzn_dynai_initialized && !isNil "dzn_fnc_dynai_addUnitBehavior"} };	
			[_v, _vehicleHoldAspect] call dzn_fnc_dynai_addUnitBehavior;
		};
	};
	
	tSF_fnc_EVC_processEVCLogics = {
		{
			private _logic = _x;
			private _syncUnits = synchronizedObjects _x;
			
			if !(isNil {_logic getVariable "tSF_EVC"}) then {
				private _configName = _logic getVariable "tSF_EVC";				
				{ [_x, _configName] spawn tSF_fnc_EVC_assignCrew; } forEach _syncUnits;
			};
		} forEach (entities "Logic");	
	};


	waitUntil { time > tSF_EVC_initTimeout };
	call tSF_fnc_EVC_processEVCLogics;
};
