#include "script_component.hpp"

/*
    Displays (types) intro text lines
    in selected style.

    Params:
        0: _component (STRING) - name of the reporter component.
        1: _type (STRING) - error type.
        2: _msg (STRING) - error message.

    Returns:
        nothing

    Example:
    tSF_Core_Component call ["fnc_reportError",[
        "EditorVehicleCrew",
        "Misconfigured",
        "Crew failed to mount!"
    ]]
*/

params ["_component", "_type", "_msg"];


[
    { time > 5 && !(call BIS_fnc_isLoading) },
    { ["TaskFailed", ["", _this]] call BIS_fnc_showNotification; },
    format ["%1<br/>%2", _component, _type]
] call CBA_fnc_waitUntilAndExecute;


private _log_msg = format [
    '[%1] Error in %2: %3 - %4',
    QUOTE(PREFIX),
    _component,
    _type,
    _msg
];
diag_log text _log_msg;


private _timestamped_msg = format [
    "(%1) %2 - %3",
    if (CBA_missionTime == 0) then { "on init" } else { format ["+%1 s", CBA_missionTime] },
    _type,
    _msg
];
private _errors = _self get Q(ReportedErrors) get _component;
if (isNil "_errors") then {
    (_self get Q(ReportedErrors)) set [_component, [_timestamped_msg]];
} else {
    _errors pushBack _timestamped_msg;
};
