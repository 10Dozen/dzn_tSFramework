#include "script_component.hpp"

/*
    Loops through conditions and check is any of it is completed.

    (_self)

    Params:
        _handlerId - pfh handler id.
    Returns:
        nothing
*/

params ["_pfhId"];

private _defaultTimeout = SETTING(_self,Timeout);
private _conditions = SETTING(_self,Conditions);
private _currentTime = CBA_missionTime;

private ["_successfulCondition"];
{
    // --- Test conditions that expired, exit if passed, othewise - update expiration timer
    if (_currentTime <= (_x get Q(expiresAt))) then {
        continue;
    };

    if ([] call (_x get Q(condition))) exitWith {
        _successfulCondition = _x get Q(name);
    };

    _x set [Q(expiresAt), _currentTime + (_x get Q(timeout))];
} forEach SETTING(_self,Conditions);

// -- No successful condition - wait for next step
if (isNil "_successfulCondition") exitWith {};

// -- There is a successfully tested condition - end mission by global call
[_pfhId] call CBA_fnc_removePerFrameHandler;

[
    {
        DEBUG_1("[waitAndExecute] Invoke ending [%1]", _this);
        [_this, true, 2] remoteExec ["BIS_fnc_endMission", 0, true];
    },
    _successfulCondition,
    SETTING(_self,MissionEndTimeout)
] call CBA_fnc_waitAndExecute;
