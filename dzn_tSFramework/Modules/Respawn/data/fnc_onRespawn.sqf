#include "script_component.hpp"

/*
    Handles "Respawn" event. 
    Executes registered respawn code, calculate and return new position.
    (_self)

    Params:
        0: _unit (OBJECT) - player's respawned unit
        1: _corpse (OBJECT) - player's previous unit
    Returns:
        Pos3D (ASL) - new position to be moved to
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
private _location = _self get Q(SelectedRespawnLocation);

private _positionObject = _location get Q(position);
private _snap = _location get Q(snapToSurface);
private _locationDisplayName = _location get Q(name);

DEBUG_1("(onRespawn) _location=%1", _location);
DEBUG_1("(onRespawn) _positionObject=%1", _positionObject);
DEBUG_1("(onRespawn) _snap=%1", _snap);
DEBUG_1("(onRespawn) _locationDisplayName=%1", _locationDisplayName);

// -- Get actual position to be teleported to
private _position = [
    _positionObject,
    _snap
] call dzn_fnc_getSurfacePos;

DEBUG_1("(onRespawn) _position=%1", _position);

// -- Reset
player setVariable [QGVAR(Scheduled), false, true];
_self set [Q(SelectedRespawnLocation), nil];

// -- Show intro text again (Date + Location name)
ECOB(IntroText) call [F(showTitles), [
    SETTING(ECOB(IntroText),Date),
    nil,
    nil,
    _locationDisplayName
]];

DEBUG_1("(onRespawn) Show intro text = %1 ", _locationDisplayName);

// Clear hint messages
_self call [F(showMessage), [MODE_CLEAR]];
_self call [F(showMessage), [MODE_ON_RESPAWN_HINT]];

// Return position to allow engine to safely move player here
DEBUG_1("(onRespawn) Return _position=%1", _position);

_position
