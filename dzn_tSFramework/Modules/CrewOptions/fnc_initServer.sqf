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
    {
        params ["_self"];
        time > SETTING_2(_self,Init,timeout) &&
        SETTING_2(_self,Init,condition)
    },
    {
        params ["_self"];
        LOG("Server init started");

        // -- Set default vehicle settings on server too
        private _vehiclesToHandle = _self call [F(processLogics)];
        {
            {
                _x disableAI "LIGHTS";
                _x allowCrewInImmobile [true, true];
            } forEach _y;
        } forEach _vehiclesToHandle;

        LOG("Server initialized");
    }
    , [_self]
] call CBA_fnc_waitUntilAndExecute;