#include "script_component.hpp"

/*
	Adds 'Deploy CCP' action to the vehicle.

	Params:
	_veh - (object) vehicle object.

	Return: none

	Example:
	[_veh] call tSF_CCP_fnc_initDeplayAction;
*/

params ["_veh"];

[
	_veh
	, "Deploy CCP"
	, {
		params ["_target"];
		[_target] call FUNC(deploy);
	}
	, 5
	, "(crew _target) isEqualTo []"
	, 6
] call dzn_fnc_addAction;
