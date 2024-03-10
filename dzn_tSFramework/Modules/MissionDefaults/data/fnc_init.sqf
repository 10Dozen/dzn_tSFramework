#include "script_component.hpp"

if (_self get Q(Settings) get "#ERRORS" isNotEqualTo []) exitWith {
    // not implemented - TSF_ERROR(TSF_ERROR_TYPE__SETTINGS_PARSE_ERROR, "- Component initialization aborted")
    LOG(TSF_ERROR_TYPE__SETTINGS_PARSE_ERROR);
};

[
    {
        time > Component_Setting_Init(_this,timeout) &&
        Component_Setting_Init(_this,condition)
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
