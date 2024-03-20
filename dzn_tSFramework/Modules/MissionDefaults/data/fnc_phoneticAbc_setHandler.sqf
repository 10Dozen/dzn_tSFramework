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

DEBUG_MSG("[phoneticAbs_setHandle] Setting handler...");

["created", {
    params ["_marker"];
    DEBUG_MSG("[phoneticAbs_setHandle] Handler invoked");
    COB call [F(phoneticAbc_handle), [_marker]];
}] call CBA_fnc_addMarkerEventHandler;
