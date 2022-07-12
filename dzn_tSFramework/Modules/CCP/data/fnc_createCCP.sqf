#include "script_component.hpp"

/*
	Creates CCP composition, set proper markers on proper location and triggers initialization of CCP on client side.
	Params: none
	Return: none
*/

params [];

__SERVER_ONLY__

// Finalize map marker - move CCP_LOGIC to selected position (or leave on default)
private _marker = CCP_LOGIC getVariable QGVAR(Marker);
if (!isNil "_marker") then {
	// Use custom position of marker if was set
	CCP_LOGIC setPos (CCP_LOGIC getVariable QGVAR(PreSelectedPosition));
};

// Create & decorate marker on server
_marker = createMarker [QGVAR(Marker), getPos CCP_LOGIC];
_marker setMarkerShape "ICON";
[_marker] call FUNC(decorateMarker);

CCP_LOGIC setVariable [QGVAR(Marker), _marker];

// Get CCP composition
private _compositionName = CCP_LOGIC getVariable CCP_LOGIC_COMPOSITION_PROPERTY;
if (isNil "_compositionName") then {
	// Check for backward compatibility with old tSF
	_compositionName = if (!isNil QGVAR(Composition)) then {
		GVAR(Composition)
	} else {
		// Or use Setting's based value if none
		GVAR(CompositionDefault)
	};
	CCP_LOGIC setVariable [CCP_LOGIC_COMPOSITION_PROPERTY, _compositionName, true];
};

private _compositionData = GVAR(PrefabCompositions) get _compositionName;
if (isNil "_compositionData") exitWith {
	TSF_ERROR_1(TSF_ERROR_TYPE__NO_CONFIG, "Failed to find composition '%1' in CCP\data\Comspositions.sqf", _compositionName);
};

// Spawn CCP composition
private _composition = [CCP_LOGIC, _compositionData] call dzn_fnc_setComposition;
private _mainVehicle = _composition # 0;

// Lock vehicle and it's inventory
_mainVehicle lock true;
[_mainVehicle, true] remoteExec ["lockInventory"];

// Prepare position of the stretchers
private _stretchersPositions = [_mainVehicle, true] call FUNC(prepareStretchersPositions);

// Add helipad (allow to helicpters sent by zeus to land properly)
private _hpadPos = (getPos CCP_LOGIC) findEmptyPosition [20, 50, "B_Heli_Transport_01_camo_F"];
if (_hpadPos isEqualTo []) then { _hpadPos = getPos CCP_LOGIC; };
private _hpad = GVAR(HelipadClass) createVehicle _hpadPos;
_composition pushBack _hpad;

// Finalize
CCP_LOGIC setVariable [QGVAR(CompositionObjects), _composition, true];
CCP_LOGIC setVariable [QGVAR(CompositionName), _compositionName, true];
CCP_LOGIC setVariable [QGVAR(StretchersPositions), _stretchersPositions, true];
CCP_LOGIC setVariable [QGVAR(StretchersInUse), [], true];

// Init on clients
[] remoteExec [QFUNC(initCCP)];
