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

        _this call [F(equip_setUpEquipment)];
        _this call [F(onStart_disablePlayer)];
        _this call [F(phoneticAbc_setHandler)];
        _this call [F(calc_init)];

        if (SETTING_2(_this,PlayerRating,enable)) then {
            player addRating SETTING_2(_this,PlayerRating,rating);
        };

        LOG("Client initialized");
    }
    , _self
] call CBA_fnc_waitUntilAndExecute;
