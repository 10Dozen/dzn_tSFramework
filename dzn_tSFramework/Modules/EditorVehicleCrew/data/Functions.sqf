#include "script_component.hpp"

FUNC(processEVCLogics) = {
	private ["_logic","_logicConfigName"];

	{
		_logic = _x;
		_logicConfigName = _logic getVariable "tSF_EVC";

		if !(isNil {_logicConfigName}) then {
			{
				[_x, _logicConfigName] call FUNC(assignCrew);
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

	private _config = GVAR(CrewConfig) get _configName;
	if (isNil "_config") exitWith {
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

	if (_kit isNotEqualTo "" && isNil "dzn_gear_serverInitDone") then {
		[
			{ !isNil "dzn_gear_serverInitDone" },
			{ _this call FUNC(assignCrew) },
			_this
		] call CBA_fnc_waitUntilAndExecute;
	};

	private _crew = [_veh, _side, _roles, _kit, _skill, _crewClass] call dzn_fnc_createVehicleCrew;

	if (_behavior isEqualTo "") exitWith {}; // No behaviour assigned
	private _vehicleBehaviour = switch (toLower(_config # 4)) do {
		case "hold": { "vehicle hold" };
		case "frontal": { "vehicle 45 hold" };
		case "full frontal": { "vehicle 90 hold" };
	};
	private _behaviourParams = [_veh, _vehicleBehaviour];

	if (isNil "dzn_dynai_initialized" && isNil "dzn_fnc_dynai_addUnitBehavior") exitWith {
		[
			{ !isNil "dzn_dynai_initialized" && !isNil "dzn_fnc_dynai_addUnitBehavior"},
			{ _this call dzn_fnc_dynai_addUnitBehavior; },
			_behaviourParams
		] call CBA_fnc_waitUntilAndExecute;
	};

	_behaviourParams call dzn_fnc_dynai_addUnitBehavior
};
