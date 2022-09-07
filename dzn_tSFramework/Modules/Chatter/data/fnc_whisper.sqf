#include "script_component.hpp"

/*
    Same as tSF_Chatter_fnc_Say, but for shorter distance (~7 meters, see Settings)
*/

params ["_unit", "_message","_name"];

[
    _unit,
    _message,
    _name,
    GET_ "Direct", "Range", "Whisper" _SETTING
] call FUNC(Say);
