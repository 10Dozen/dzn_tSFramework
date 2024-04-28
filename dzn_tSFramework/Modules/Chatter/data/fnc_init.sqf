#include "script_component.hpp"

/*
    Initialize Component Object and it's features.
    Params:
        none
    Returns:
        nothing
*/
__EXIT_ON_SETTINGS_PARSE_ERROR__

private _settings = _self get Q(Settings);
_settings deleteAt "#SOURCE";
_settings deleteAt "#ERRORS";

if (!isServer) exitWith {
    // --- Client waits for Talkers initialized and published
    LOG("Client init started");
    [
        {
            time > SETTING_2(_this,Init,timeout) &&
            SETTING_2(_this,Init,condition) &&
            !isNil Q(RADIO_TALKERS)
        },
        {
            REGISTER_COMPONENT;
            LOG("Client iInitialized");
        },
        _self
    ] call CBA_fnc_waitUntilAndExecute;
};

[
    {
        time > SETTING_2(_this,Init,timeout) &&
        SETTING_2(_this,Init,condition)
    },
    {
        LOG("Server init started");

        _this call [F(prepareTalkers)];
        REGISTER_COMPONENT;

        LOG("Server initialized");
    }
    , _self
] call CBA_fnc_waitUntilAndExecute;
