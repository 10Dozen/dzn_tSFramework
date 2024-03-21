#include "script_component.hpp"

/*
    Initialize Component Object and it's features.
    Params:
        none
    Returns:
        nothing
*/

__EXIT_ON_SETTINGS_PARSE_ERROR__

[
    {
        !isNull findDisplay 52 ||
        getClientState == "BRIEFING SHOWN" ||
        time > 0
    },
    {
        LOG("Client init started");

        _this call [F(addTopics)];
        _this call [F(restoreViewDistance)];

        LOG("Client initialized");
    }
    , _self
] call CBA_fnc_waitUntilAndExecute;
