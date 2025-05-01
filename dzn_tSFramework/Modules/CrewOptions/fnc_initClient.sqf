#include "script_component.hpp"

/*
    Initialize Component Object and it's features.
    Params:
        none
    Returns:
        nothing
*/

__CLIENT_ONLY__
__EXIT_ON_SETTINGS_PARSE_ERROR__

[
    {
        params ["_self"];
        time > SETTING_2(_self,Init,timeout) &&
        SETTING_2(_self,Init,condition) &&
        !isNil { TSF_COMPONENT(Q(Respawn)) }
    },
    {
        params ["_self"];
        LOG("Client init started");

        private _vehiclesToHandle = _self call [F(processLogics)];
        _self call [F(assignActions), [_vehiclesToHandle]];

        // -- Handle AI crew on respawn
        ECOB(Respawn) call [
            F(addOnRespawnCall),
            [{ COB call [F(expelCrew)]; }]
        ];

        player addEventHandler ["GetOutMan", {
            params ["_unit", "_role", "_vehicle", "_turret", "_isEject"];
            COB call [F(onGetOutMan), _this];
        }];
        
        SET_COMPONENT_STATUS_OK(_self);
        LOG("Client initialized");
    }
    , [_self]
] call CBA_fnc_waitUntilAndExecute;