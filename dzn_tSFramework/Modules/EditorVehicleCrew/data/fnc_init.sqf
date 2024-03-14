#include "script_component.hpp"

#define Q(X) #X
#define Setting_Init(NAME) (_self get "Init" get Q(NAME))

[
    { time > Setting_Init(timeout) &&  Setting_Init(condition) },
    {
        LOG("Server/Headless init started");

        _this call [Q(processLogics)];

        LOG("Server/Headless initialized");
    }
    , _self
] call CBA_fnc_waitUntilAndExecute;
