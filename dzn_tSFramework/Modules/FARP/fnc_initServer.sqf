#include "script_component.hpp"

/*
    Initialize Component Object and it's features.
    (_self)

    Params: none
    Returns:
        nothing
*/

__SERVER_ONLY__
__EXIT_ON_SETTINGS_PARSE_ERROR__

[
    SETTING_2(_self,Init,condition),
    {
        LOG("Server init started");

        _this call [
            F(processLogics),
            [
                (entities "Logic") select { _x getVariable [GAMELOGIC_IS_FARP_FLAG, false] },
                true
            ]
        ];
        _this call [F(handleBriefing)];

        [
            { time > 0 },
            { _this call [F(handleMissionStart)]},
            _self
        ] call CBA_fnc_waitUntilAndExecute;

        SET_COMPONENT_STATUS_OK(_this);
        LOG("Server initialized");
    },
    _self
] call CBA_fnc_waitUntilAndExecute;
