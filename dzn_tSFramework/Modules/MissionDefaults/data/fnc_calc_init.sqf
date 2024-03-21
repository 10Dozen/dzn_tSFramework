#include "script_component.hpp"

/*
    Inits calculator chat command handlers.

    Params:
        none
    Returns:
        nothing
*/

if !(SETTING_OR_DEFAULT_2(_self,Calculator,enable,false)) exitWith {};

[
    "=",
    {  COB call [F(calc_handle), _this]; },
    "all"
] call CBA_fnc_registerChatCommand;

[
    "c",
    {  COB call [F(calc_handle), _this]; },
    "all"
] call CBA_fnc_registerChatCommand;
