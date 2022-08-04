#include "script_component.hpp"
#include "MessageRenderer.h"

/*
    Method: Hide (public)

    Hides all messages with animation (sets TTL < current time)

    Params:
    _type - (string) type of the messages to hide ('LR' or 'SW')

    Return: none

    Example:
    ["Hide", ["SW"]] call tSF_Chatter_fnc_MessageRenderer;
*/

params ["_type"];
private _queue = [_type] call self_FUNC(getQueue);

{ _x set [QE_TTL, 0]; } forEach _queue;
