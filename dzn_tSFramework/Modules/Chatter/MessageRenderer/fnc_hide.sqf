#include "script_component.hpp"

/*
    Method: Hide (public)
    (_self)

    Hides all messages with animation (sets TTL < current time)

    Params: none
    Return: none

    Example:
    ["Hide"] call tSF_Chatter_fnc_MessageRenderer;
*/

{ _x set [QE_TTL, 0]; } forEach (_self get Q(Queue));
