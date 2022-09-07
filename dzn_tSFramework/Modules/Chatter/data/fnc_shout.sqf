#include "script_component.hpp"

/*
    Same as tSF_Chatter_fnc_Say, but for larger distance (~75 meters, see defaults in Settings)
*/

params ["_unit", "_message", "_name"];
[
    _unit,
    _message,
    _name,
    GET_ "Direct", "Range", "Shout" _SETTING
] call FUNC(Say);
