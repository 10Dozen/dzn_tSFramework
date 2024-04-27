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
        SETTING_2(_this,Init,condition) &&
        DZN_DYNAI_RUNNING_SERVER_SIDE &&
        DZN_GEAR_RUNNING
    },
    {
        LOG("Server/Headless init started");

        _this call [F(processLogics)];
        REGISTER_COMPONENT;

        LOG("Server/Headless initialized");
    }
    , _self
] call CBA_fnc_waitUntilAndExecute;
