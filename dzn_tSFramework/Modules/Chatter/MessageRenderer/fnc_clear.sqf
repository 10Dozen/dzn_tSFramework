#include "script_component.hpp"

/*
    Method: Clear (public)
    (_self)

    Cleans up Queue and remove all displayed messages

    Params:
    _immediate - (boolean) if true - drops queue and removes controls in the same frame, otherwise - only marks all messages in queue to be deleted by main loop.

    Return: none

    Example:
    ["Clear", ["SW", false]] call tSF_Chatter_fnc_MessageRenderer;
*/

params [["_immediate", false]];

private _queue = _self get Q(Queue);

// On immediate - delete all controls and clear queue
if (_immediate) exitWith {
    {
        { ctrlDelete _x } forEach (_x # QE_CONTROLS);
    } forEach _queue;
    _queue deleteRange [0,3];
};

// Otherwise - switch all queue entities to PULL state and let loop to handle the rest
{ _x set [QE_STATE, STATE_PULL]; } forEach _queue;
