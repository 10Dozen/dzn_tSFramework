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
        params ["_self"];
        time > SETTING_2(_self,Init,timeout) &&
        SETTING_2(_self,Init,condition) &&
        TSF_COMPONENT_ACTIVE(Respawn) 
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
            COB call [F(onGetOutMan), _this];
        }];
        
        COMPONENT_SET_STATUS(COMPONENT_STATUS_OK);
        LOG("Client initialized");
    }
    , [_self]
] call CBA_fnc_waitUntilAndExecute;