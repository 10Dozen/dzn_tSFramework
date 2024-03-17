#include "script_component.hpp"

/*
    Loops through conditions and check is any of it is completed.

    (_self)

    Params:
        _handlerId - pfh handler id.
    Returns:
        nothing
*/

DEBUG_1("[checkConditions] Params: %1", _this);
params ["_pfhId"];

private _defaultTimeout = SETTING(_self,Timeout);
private _conditions = SETTING(_self,Conditions);
private _currentTime = CBA_missionTime;

private ["_successfulCondition"];

DEBUG_1("[checkConditions] _currentTime=%1", _currentTime);

{
    DEBUG_1("[checkConditions] Cond=%1", _x);
    // --- Test conditions that expired, exit if passed, othewise - update expiration timer
    if (_currentTime <= (_x get Q(expiresAt))) then {
        DEBUG_MSG("[checkConditions] Not expired yet");
        continue;
    };

    if ([] call (_x get Q(condition))) exitWith {
        DEBUG_MSG("[checkConditions] SUCCESS! Stop checks and plan mission end");
        _successfulCondition = _x get Q(name);
    };

    _x set [Q(expiresAt), _currentTime + (_x get Q(timeout))];
} forEach SETTING(_self,Conditions);

// -- No successful condition - wait for next step
if (isNil "_successfulCondition") exitWith {
    DEBUG_MSG("[checkConditions] No conditions met this time.");
};

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
