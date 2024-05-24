#include "script_component.hpp"

/*
    Initialize Component Object and it's features.
    (_self)

    Params:
        none
    Returns:
        nothing
*/

__SERVER_ONLY__

__EXIT_ON_SETTINGS_PARSE_ERROR__

LOG("Server init started");

_self call [F(processLogics)];

ECOB(Core) call [
    F(remoteExecComponent),
    ["Respawn", F(initClient), [_self get Q(Locations)], 0]
];

LOG("Server initialized");
