#include "script_component.hpp"

/*
    Starts server-side loop to check conditions.

    Params:
        none
    Returns:
        nothing
*/

DEBUG_MSG("[startConditionsTracking] Invoked");

private _defaultTimeout = SETTING(_self,Timeout);
private _conditions = SETTING(_self,Conditions);
private _currentTime = CBA_missionTime;

{
    private _timeout = _x getOrDefault [Q(timeout), _defaultTimeout];
    _x set [Q(timeout), _timeout];
    _x set [Q(expiresAt), _currentTime + _timeout];

    // --- Update Special Condition with actual code
    private _condExpr = _x get Q(condition);
    if (
        typename _condExpr == "STRING"
        && { _condExpr == SE__ALL_DEAD__NAME}
    ) then {
        _x set [Q(condition), SE__ALL_DEAD__EXPR]
    };
} forEach SETTING(_self,Conditions);


DEBUG_MSG("[startConditionsTracking] Initialize tracker...");

[
    {
        params ["_self", "_pfhId"];
        _self call [F(checkConditions), [_pfhId]];
    },
    1,
    _self
] call CBA_fnc_addPerFrameHandler;
