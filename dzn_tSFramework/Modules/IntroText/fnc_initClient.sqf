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
        time > SETTING_2(_this,Init,timeout) &&
        SETTING_2(_this,Init,condition)
    },
    {
        LOG("Client init started");

        _this call [F(showMissionTitles)];

        COMPONENT_SET_STATUS(COMPONENT_STATUS_OK);
        LOG("Client initialized");
    }
    , _self
] call CBA_fnc_waitUntilAndExecute;
