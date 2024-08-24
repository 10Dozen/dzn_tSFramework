#include "script_component.hpp"

/*
    (_self)

    Params:
        nothing
    Returns:
        nothing
*/

params ["_unit", "_corpse"];

private _targetLocation = _self get Q(ForcedRespawnLocation);
if (isNil "_targetLocation") then {
    _targetLocation = _self get Q(RespawnLocation);
};

LOG_1("(onRespawn) Default respawn loc = %1", _self get Q(RespawnLocation));

private _locConfig = SETTING(_self,Locations) get _targetLocation;

private _positionObject = _locConfig get Q(positionObject);
private _snap = _locConfig getOrDefault [Q(snapToSurface), true];
private _locationDisplayName = _locConfig get Q(name);
private _gearKit = player getVariable "dzn_gear";


LOG_1("(onRespawn) Target Location = %1", _targetLocation);
LOG_1("(onRespawn) Position = %1", _positionObject);
LOG_1("(onRespawn) Location display name = %1", _locationDisplayName);
LOG_1("(onRespawn) _snap = %1", _snap);
LOG_1("(onRespawn) _gearKit = %1", _gearKit);

// Get actual position to be teleported to
private _position = [
    _positionObject,
    _snap
] call dzn_fnc_getSurfacePos;


LOG_1("(onRespawn) _position = %1", _position);


// Re-apply gear
if (!isNil "_gearKit") then {
    player setVariable ["dzn_gear_done", nil];
    [player, _gearKit, false] spawn dzn_fnc_gear_assignKit;
};

[{
    _this call [F(setDefaultRating)];
    _this call [F(setDefaultEquipment)];
}, _self] call CBA_fnc_execNextFrame;

// Show intro text again (Date + Location name)
ECOB(IntroText) call [F(showTitles), [
    nil, nil, nil, _locationDisplayName
]];

// Show hint messages
_self call [F(showMessage), [MODE_ON_RESPAWN_HINT]];


// Reset
_self set [Q(ForcedRespawnLocation), nil];
setPlayerRespawnTime 9999999;

// Return position to allow engine to safely move player here
_position
