#include "script_component.hpp"

/*
	Calculates positions for stretchers at CCP.

	Params:
	_base - (object) object to use as base pont for calculations
	_cutTheGrass - (boolean) flag to spawn grasscutters on stretcher positions

	Return:
	_stretchersPositions - (array) list of absolute positions of the stretchers around the _base object

	Example:
	[_ccpVehicle] call tSF_CCP_fnc_prepareStretchersPositions;
*/

params ["_base"];

private _baseDir = getDir _base;
private _stretcherPositions = [
	[[4, -3, 0], 90]
	,[[4, -1, 0], 90]
	,[[4, 1, 0], 90]
	,[[4, 3, 0], 90]
	,[[-4, -3, 0], -90]
	,[[-4, -1, 0], -90]
	,[[-4, 1, 0], -90]
	,[[-4, 3, 0], -90]
] apply {
	_x params ["_offset", "_rotate"];

	private _pos = _base modelToWorld _offset;
	_pos set [2, 0];
	private _dir = _baseDir + _rotate;

	[_pos, _dir]
};

_stretcherPositions
