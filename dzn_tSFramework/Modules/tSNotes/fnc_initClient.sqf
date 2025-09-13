#include "script_component.hpp"

/*
    Initialize Component Object and it's features.
    Params:
        none
    Returns:
        nothing
*/

[
    {
        !isNull findDisplay 52 ||
        getClientState == "BRIEFING SHOWN" ||
        time > 0
    },
    {
        LOG("Client init started");

        _this call [F(addTopics)];
        
        COMPONENT_SET_STATUS(COMPONENT_STATUS_OK);
        LOG("Client initialized");
    }
    , _self
] call CBA_fnc_waitUntilAndExecute;
