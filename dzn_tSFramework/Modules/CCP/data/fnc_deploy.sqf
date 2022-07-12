#include "script_component.hpp"

/*
	Deploys CCP from the given vehicle.

	Params:
	_veh - (object) some vehicle. Optional, default is CCP Logic object.

	Return: none

	Example:
	[_car] call tSF_CCP_fnc_deploy;
*/

if (!isServer) exitWith {
	_this remoteExec [QFUNC(deploy), 2];
};

params [["_veh", CCP_LOGIC]];

private _pos = getPos _veh;
private _dir = getDir _veh;

// If deployed from the vehicle - adjust position
if (_veh != CCP_LOGIC) then {
	// Adjust CCP_LOGIC position to match position of the vehicle in composition
	private _compositionData = GVAR(PrefabCompositions) get (CCP_LOGIC getVariable QGVAR(CompositionName));
	(_compositionData # 0) params ["", "_relDir", "_relDistance", "_orientation"];

	// Get base point direction (compensate object orientation)
	_dir = _dir + (360 - _orientation);

	// Get direction to base point (inversed direction from base point to object from composition data)
	private _dirToPoint = _dir + (_relDir - 180);
	_pos = [_pos, _dirToPoint, _relDistance] call dzn_fnc_getPosOnGivenDir;

	// Remove the vehicle
	{ moveOut _x } forEach (crew _veh);
	deleteVehicle _veh;
};

// Update CCP_LOGIC position
CCP_LOGIC setPos _pos;
CCP_LOGIC setDir _dir;

(format ["CCP deployed at grid %1", _pos call dzn_fnc_getMapGrid]) remoteExec ["systemChat"];

[{ [] call FUNC(createCCP); }] call CBA_fnc_execNextFrame;
