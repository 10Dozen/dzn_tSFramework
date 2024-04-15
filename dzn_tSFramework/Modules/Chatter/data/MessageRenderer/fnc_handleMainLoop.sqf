#include "script_component.hpp"

/*
    Method: HandleMainLoop (non-public)
    (_self)

    Processes queues, tiggers new animations and handles entities expiration.

    Params: none
    Return: nothing

    Example:
    ["HandleMainLoop"] call tSF_Chatter_fnc_MessageRenderer;
*/

DEBUG_1("(Renderer.handleMainLoop) Invoked", time);
if (isGamePaused) exitWith {};

DEBUG_1("(Renderer.handleMainLoop) START queue handling at %1", time);
private _trashcan = [];
{
    private _qe = _x;
    _qe params ["_id", "_type", "_ctrls", "_state", "_ttl"];
    DEBUG_2("(Renderer.handleMainLoop) Entity %1 == %2", _id, _qe);

    switch _state do {
        case STATE_NEW: {
            DEBUG_1("(Renderer.handleMainLoop) Entity %1 : State NEW -> Animate appear", _id);
            _self call [F(animateAppear), [_qe]];
        };
        case STATE_BLUR1: {
            DEBUG_1("(Renderer.handleMainLoop) Entity %1 : State BLUR1 -> Animate Blur 1", _id);
            _self call [F(animateBlur), [_qe, 1]];
        };
        case STATE_BLUR2: {
            DEBUG_1("(Renderer.handleMainLoop) Entity %1 : State BLUR2 -> Animate Blur 2", _id);
            _self call [F(animateBlur), [_qe, 2]];
        };
        case STATE_BLURRED;
        case STATE_SHOWN: {
            DEBUG_1("(Renderer.handleMainLoop) Entity %1 : State SHOWN. Check for TTL...", _id);
            if (time >= _ttl) then {
                DEBUG_1("(Renderer.handleMainLoop) Entity %1 : State SHOWN -> TTL is reached. Animate Hide", _id);
                _self call [F(animateHide), [_qe]];
            };
        };
        case STATE_HIDDEN: {
            DEBUG_1("(Renderer.handleMainLoop) Entity %1 : State HIDDEN. Check for TTL...", _id);
            if (time >= _ttl) then {
                DEBUG_1("(Renderer.handleMainLoop) Entity %1 : State HIDDEN -> TTL is reached. Pulling out message", _id);
                _qe set [QE_STATE, STATE_PULL];
            };
        };
        case STATE_PULL: {
            DEBUG_1("(Renderer.handleMainLoop) Entity %1 : State PULL. Deleting controls and moving to trash.", _id);
            { ctrlDelete _x } forEach _ctrls;

            DEBUG_1("(Renderer.handleMainLoop) Adding to the trashcan: %1", _id);
            _trashcan pushBack _id;
        };
        default {
            DEBUG_2("(Renderer.handleMainLoop) Entity %1 : State is %2", _id, _state);
        };
    };
} forEach (_self get Q(Queue));

if (_trashcan isEqualTo []) exitWith {};

DEBUG_1("(Renderer.handleMainLoop) Deleting %1 items from trashcan", count(_trashcan));
{ _self call [F(removeFromQueue), [_x]]; } forEach _trashcan;
