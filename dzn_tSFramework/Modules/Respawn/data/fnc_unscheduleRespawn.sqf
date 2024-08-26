#include "script_component.hpp"

/*
    (_self)

    Params:
        nothing
    Returns:
        nothing
*/

__CLIENT_ONLY__


// -- Do nothing, if respawn is not scheduled
if !(player getVariable [QGVAR(Scheduled), false]) exitWith {};

// --- Otherwise revert respawn
setPlayerRespawnTime 999999;
player setVariable [QGVAR(Scheduled), false, true];

_self call [F(showMessage), [MODE_RESPAWN_CANCELED_MSG, []]];
