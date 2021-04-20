#include "script_component.hpp"

FUNC(processEVCLogics) = {
	private ["_logic","_logicConfig"];

	{
		_logic = _x;
		_logicConfigName = _logic getVariable "tSF_EVC";

		if !(isNil {_logicConfigName}) then {
			{
				[_x, _logicConfigName] spawn FUNC(assignCrew);
			} forEach (synchronizedObjects _logic);
		};
	} forEach (entities "Logic");
};


FUNC(assignCrew) = {
	/*
	 	Assigns crew to given vehicle using given configuration

		Params:
		_veh - (object) vehicle to process
		_configName - (string) config nmae to apply

		Return:
		nothing

		Example:
		[_veh, "OPFOR GNR"] spawn tSF_fnc_EVC_assignCrew
		// creates OPFOR GNR" crew (gunner with default settings)
	*/

	params["_veh","_configName"];

	private _config = [GVAR(CrewConfig), _configName] call dzn_fnc_getValueByKey;
	if (typename _config == "BOOL") exitWith {
		[format ["tSF - EVC :: There is no %1 config!", _configName]] call BIS_fnc_error;
	};

	_config params [
		"_roles"
		,"_side"
		,"_skill"
		,["_kit",""]
		,["_behavior",""]
		,["_crewClass",""]
	];

	if (typename _roles != "ARRAY") then { _roles = [_roles]; };
	if (!(_kit isEqualTo "") && isNil "dzn_gear_serverInitDone") then {
		waitUntil { sleep 1; !isNil "dzn_gear_serverInitDone" };
	};

	[_veh, _side, _roles, if (_kit == "") then { nil } else { _kit }, _skill, _crewClass] call dzn_fnc_createVehicleCrew;

	if (_behavior isEqualTo "") exitWith {}; // No behaviour assigned
	private _vehicleHoldAspect = switch (toLower(_config select 4)) do {
		case "hold": { "vehicle hold" };
		case "frontal": { "vehicle 45 hold" };
		case "full frontal": { "vehicle 90 hold" };
	};

	waitUntil { !isNil "dzn_dynai_initialized" && !isNil "dzn_fnc_dynai_addUnitBehavior" };
	[_veh, _vehicleHoldAspect] call dzn_fnc_dynai_addUnitBehavior;
};
