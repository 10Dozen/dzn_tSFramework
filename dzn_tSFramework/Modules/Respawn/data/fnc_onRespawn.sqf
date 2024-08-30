#include "script_component.hpp"

/*
    (_self)

    Params:
        nothing
    Returns:
        nothing
*/

params ["_unit", "_corpse"];

private _snippets = _self get Q(onRespawnSnippets);
private _snippetsOrder = keys _snippets;
_snippetsOrder sort true;
{
    DEBUG_1("(onRespawn) Executing snippets with priority %1", _x);
    {
        DEBUG_1("(onRespawn) Executing snippets %1", _forEachIndex);
        _x params ["_code", "_codeArgs"];
       [_unit, _corpse, _codeArgs] call _code;
    } forEach (_snippets get _x);
} forEach _snippetsOrder;


// -- Find location
private _targetLocation = _self get Q(ForcedRespawnLocation);
if (isNil "_targetLocation") then {
    _targetLocation = _self get Q(RespawnLocation);
};

private _locConfig = SETTING(_self,Locations) get _targetLocation;
private _positionObject = _locConfig get Q(positionObject);
private _snap = _locConfig getOrDefault [Q(snapToSurface), true];
private _locationDisplayName = _locConfig get Q(name);

// -- Get actual position to be teleported to
private _position = [
    _positionObject,
    _snap
] call dzn_fnc_getSurfacePos;

LOG_1("(onRespawn) _targetLocation=%1", _targetLocation);
LOG_1("(onRespawn) _locConfig=%1", _locConfig);
LOG_1("(onRespawn) _positionObject=%1", _positionObject);
LOG_1("(onRespawn) _snap=%1", _snap);
LOG_1("(onRespawn) _locationDisplayName=%1", _locationDisplayName);
LOG_1("(onRespawn) _position=%1", _position);

// -- Reset
player setVariable [QGVAR(Scheduled), false, true];
_self set [Q(ForcedRespawnLocation), nil];

// -- Show intro text again (Date + Location name)
ECOB(IntroText) call [F(showTitles), [
    SETTING(ECOB(IntroText),Date),
    nil,
    nil,
    _locationDisplayName
]];

LOG_1("(onRespawn) Show intro text = %1 ", _locationDisplayName);

// Clear hint messages
_self call [F(showMessage), [MODE_CLEAR]];
_self call [F(showMessage), [MODE_ON_RESPAWN_HINT]];

// Return position to allow engine to safely move player here
LOG_1("(onRespawn) Return _position=%1", _position);

_position
