#include "script_component.hpp"

/*
    Unsecheduls respawn and reset respawn timer to unreachable and 
    shows on screen message.
    If player's respawn is not scheduled - does nothing.
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
setPlayerRespawnTime RESPAWN_TIME_DISABLED;

player setVariable [QGVAR(Scheduled), false, true];
_self set [Q(SelectedRespawnLocation), nil];

_self call [F(showMessage), [MODE_RESPAWN_CANCELED_MSG, []]];
