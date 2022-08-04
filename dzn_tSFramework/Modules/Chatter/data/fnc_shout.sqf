#include "script_component.hpp"

/*
    Same as tSF_Chatter_fnc_Say, but for larger distance (75 meters)
*/

params ["_unit", "_message", "_name"];
[_unit, _message, _name, 75] call FUNC(Say);
