#include "script_component.hpp"

/*
    Initialize Component Object and it's features.
    Params:
        none
    Returns:
        nothing
*/

__CLIENT_ONLY__

__EXIT_ON_SETTINGS_PARSE_ERROR__

[
    { /* wait for server to read location logics and publish it */ },
    {
        LOG("Client init started");

        {
            (_this get Q(Locations)) set [_x, []];
        } forEach keys (SETTINGS(_this,Locations));
        
        _this call [F(addRespawnHandler), [player]];

        LOG("Client initialized");
    }
    , _self
] call CBA_fnc_waitUntilAndExecute;
