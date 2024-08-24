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

private _locationsToObjects = _self call [F(processLogics)];
LOG_1("(initServer) _locationsToObjects=%1", _locationsToObjects);
if (_locationsToObjects isEqualTo []) exitWith {};

ECOB(Core) call [
    F(remoteExecComponent),
    ["Respawn", F(initClient), [_locationsToObjects], 0, true]
];

LOG("Server initialized");
