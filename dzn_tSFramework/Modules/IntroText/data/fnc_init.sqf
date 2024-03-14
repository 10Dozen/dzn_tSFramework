#include "script_component.hpp"

/*
    Initialize Component Object and it's features.
    Params:
        none
    Returns:
        nothing
*/

if (SETTING(_self,#ERRORS) isNotEqualTo []) exitWith {
    // not implemented - TSF_ERROR(TSF_ERROR_TYPE__SETTINGS_PARSE_ERROR, "- Component initialization aborted")
    LOG(TSF_ERROR_TYPE__SETTINGS_PARSE_ERROR);
    [
        "TaskFailed",
        ["", format ["%1<br/>%2", Q(COMPONENT), TSF_ERROR_TYPE__SETTINGS_PARSE_ERROR]]
    ] call BIS_fnc_showNotification;
};

[
    {
        time > SETTING_2(_this,Init,timeout) &&
        SETTING_2(_this,Init,condition)
    },
    {
        LOG("Client init started");

        _this call [F(showMissionTitles)];

        LOG("Client initialized");
    }
    , _self
] call CBA_fnc_waitUntilAndExecute;
