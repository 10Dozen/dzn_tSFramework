#include "script_component.hpp"

/*
    Initialize Component Object and it's features.

    Params:
        none
    Returns:
        nothing
*/

//if (_self get Q(Settings) get "#ERRORS" isNotEqualTo []) exitWith {
if (SETTING(_self,#ERRORS) isNotEqualTo []) exitWith {
    // not implemented - TSF_ERROR(TSF_ERROR_TYPE__SETTINGS_PARSE_ERROR, "- Component initialization aborted")
    LOG(TSF_ERROR_TYPE__SETTINGS_PARSE_ERROR);
};

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

        LOG("Client initialized");
    }
    , _self
] call CBA_fnc_waitUntilAndExecute;
