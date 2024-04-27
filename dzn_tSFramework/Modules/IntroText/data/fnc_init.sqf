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
        time > SETTING_2(_this,Init,timeout) &&
        SETTING_2(_this,Init,condition)
    },
    {
        LOG("Client init started");

        _this call [F(showMissionTitles)];
        REGISTER_COMPONENT;

        LOG("Client initialized");
    }
    , _self
] call CBA_fnc_waitUntilAndExecute;
