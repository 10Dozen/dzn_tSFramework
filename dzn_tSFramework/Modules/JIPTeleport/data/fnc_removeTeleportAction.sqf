#include "script_component.hpp"

/*
    Removes user action to teleport

    (_self)

    Params:
        none
    Returns:
        nothing
*/

player removeAction (player getVariable QGVAR(Action));
player setVariable [QGVAR(Action), nil];
