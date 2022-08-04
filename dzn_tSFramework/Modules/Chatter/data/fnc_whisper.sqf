#include "script_component.hpp"

/*
    Same as tSF_Chatter_fnc_Say, but for shorter distance (5 meters)
*/

params ["_unit", "_message","_name"];

[_unit, _message, _name, 5] call FUNC(Say);
