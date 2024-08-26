#include "script_component.hpp"

/*
    (_self)

    Params:
        nothing
    Returns:
        nothing
*/

params ["_unit", "_corpse"];

player setVariable [QGVAR(Scheduled), false, true];

private _targetLocation = _self get Q(ForcedRespawnLocation);
if (isNil "_targetLocation") then {
    _targetLocation = _self get Q(RespawnLocation);
};

private _locConfig = SETTING(_self,Locations) get _targetLocation;

private _positionObject = _locConfig get Q(positionObject);
private _snap = _locConfig getOrDefault [Q(snapToSurface), true];
private _locationDisplayName = _locConfig get Q(name);
private _gearKit = player getVariable "dzn_gear";

// Get actual position to be teleported to
private _position = [
    _positionObject,
    _snap
] call dzn_fnc_getSurfacePos;


// Re-apply gear
if (!isNil "_gearKit") then {
    player setVariable ["dzn_gear_done", nil];
    [player, _gearKit, false] spawn dzn_fnc_gear_assignKit;
};

_self call [F(setDefaultRating)];
_self call [F(setDefaultEquipment)];

// Show intro text again (Date + Location name)
ECOB(IntroText) call [F(showTitles), [
    SETTING(ECOB(IntroText),Date), 
    nil, 
    nil, 
    _locationDisplayName
]];

// Show hint messages
_self call [F(showMessage), [MODE_CLEAR]];
_self call [F(showMessage), [MODE_ON_RESPAWN_HINT]];

// Reset
_self set [Q(ForcedRespawnLocation), nil];
setPlayerRespawnTime 9999999;

// Return position to allow engine to safely move player here
_position
