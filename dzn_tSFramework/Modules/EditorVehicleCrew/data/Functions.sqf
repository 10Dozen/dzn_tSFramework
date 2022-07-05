#include "script_component.hpp"

FUNC(processEVCLogics) = {
	/*
		Checks mission's GameLogics and execute EVC scripts on
		logics with non empty 'tSF_EVC' variables
		Params: none
		Return: none
	*/
	private ["_logic","_logicConfigName"];

	private _logicsCount = 0;
	private _assignementsSuccessCount = 0;

	{
		private _logic = _x;
		private _logicConfigName = _logic getVariable EVC_GAMELOGIC_FLAG;

		if !(isNil {_logicConfigName}) then {
			{
				private _result = [_x, _logicConfigName] call FUNC(assignCrew);
				_assignementsSuccessCount = _assignementsSuccessCount + ([0, 1] select _result);
			} forEach (synchronizedObjects _logic);
			_logicsCount = _logicsCount + 1;
		};
	} forEach (entities "Logic");

	[_logicsCount, _assignementsSuccessCount]
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
		TSF_ERROR_1(TSF_ERROR_TYPE__NO_CONFIG, "Failed to find config '%1'", _configName);
		false
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

	if (_kit isNotEqualTo "" && isNil "dzn_gear_serverInitDone") exitWith {
		[
			{ !isNil "dzn_gear_serverInitDone" },
			{ _this call FUNC(assignCrew) },
			_this
		] call CBA_fnc_waitUntilAndExecute;
		true
	};

	private _crew = [_veh, _side, _roles, _kit, _skill, _crewClass] call dzn_fnc_createVehicleCrew;

	if (units _crew findIf {isNull objectParent _x} > -1) then {
		TSF_ERROR_4(TSF_ERROR_TYPE__MISCONFIGURED, "Crew does not fit vehicle %1. Config '%2' with %3 roles used - but actual mounted crew number is %4.", typeof _veh, _configName, _roles, count crew _veh);
	};

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
		true
	};

	_behaviourParams call dzn_fnc_dynai_addUnitBehavior;
	true
};
