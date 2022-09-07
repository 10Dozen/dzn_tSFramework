#include "script_component.hpp"
#include "MessageRenderer.h"

/*
    Method: TransitToState (non-public)

    Performs animation-delayed transition to target state. Do nothing if initial state was changed during timeout.

    Params:
    _qe - (array) queue entity
    _fromState - (string) initial state
    _toState - (string) target state to transit
    _delay - (number) delay before transit attempt

    Return: none
    Example:
    ["TransitToState", [_qe, "STATE_SHOWING", "STATE_SHOWN", 2]] call tSF_Chatter_fnc_MessageRenderer;
*/

params ["_qe", "_fromState", "_toState", "_delay"];

DEBUG_1("(Renderer.transitToState) Params: %1", _this);

[{
    params ["_qe", "_fromState", "_toState"];
    DEBUG_1("(Renderer.transitToState:onDelayReached) Params: %1", _this);
    DEBUG_2("(Renderer.transitToState:onDelayReached) Expected state [%1] vs current [%2]", _fromState, _qe # QE_STATE);

    if (_qe # QE_STATE != _fromState) exitWith {
        LOG("(Renderer.transitToState:onDelayReached) State doesn't match. No transition performed");
    };

    DEBUG_1("(Renderer.transitToState:onDelayReached) Transition to state %1", _toState);
    _qe set [QE_STATE, _toState];
    DEBUG_1("(Renderer.transitToState:onDelayReached) Entity: %1", _qe);

}, [_qe, _fromState, _toState], _delay] call CBA_fnc_waitAndExecute;
