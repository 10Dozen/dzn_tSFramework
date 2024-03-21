#include "script_component.hpp"

/*
    JIP Teleport component allows JIP player to silently join the game
    by teleporting to it's group leader
*/

private _declaration = [
    COMPONENT_TYPE,
    PREP_COMPONENT_SETTINGS,

    PREP_COMPONENT_FUNCTION(init),
    PREP_COMPONENT_FUNCTION(addTeleportAction),
    PREP_COMPONENT_FUNCTION(removeTeleportAction),
    PREP_COMPONENT_FUNCTION(onTeleportAction)
];

COB = createHashMapObject [_declaration];
COB call [F(init)];
