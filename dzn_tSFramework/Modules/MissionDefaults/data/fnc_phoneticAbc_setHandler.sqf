#include "script_component.hpp"

/*
    Sets phonetic/numeric autocompletion handlersю
    (_self)

    Params:
        none
    Returns:
        nothing
*/

if !(SETTING_OR_DEFAULT_2(_self,PhoneticAlphabet,enable,false)) exitWith {};

["created", {
    params ["_marker"];
    GVAR(ComponentObject) call [F(phoneticAbc_handle), [_marker]];
}] call CBA_fnc_addMarkerEventHandler;
