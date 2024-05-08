#include "script_component.hpp"

/*
    Initialize Component Object and it's features.
    Params:
        none
    Returns:
        nothing
*/

__SERVER_ONLY__

__EXIT_ON_SETTINGS_PARSE_ERROR__

[
    { true },
    {
        LOG("Server init started");

        {
            (_this get Q(Locations)) set [_x, []];
        } forEach keys (SETTINGS(_this,Locations));         

        LOG("Server initialized");
    }
    , _self
] call CBA_fnc_waitUntilAndExecute;
