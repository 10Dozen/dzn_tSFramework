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
        !isNull findDisplay 52 || getClientState == "BRIEFING SHOWN" || time > 0
    },
    {
        LOG("Client init started");
        
        // -- Add briefing topics 
        [] call compileScript [Q(BRIEFING_FILE_PATH)];

        // -- Handle ORBAT/Roster
        if (SETTING_2(_this,Roster,enabled)) then {
            _this call [F(initRoster)];
        };

        SET_COMPONENT_STATUS_OK(_this);
        LOG("Client initialized");
    }
    , _self
] call CBA_fnc_waitUntilAndExecute;
