#include "script_component.hpp"

/*

*/

private _declaration = [
    COMPONENT_TYPE,
    PREP_COMPONENT_SETTINGS,

    PREP_COMPONENT_FUNCTION(init),
    PREP_COMPONENT_FUNCTION(onRespawn),

    PREP_COMPONENT_FUNCTION(processLogics),

    [Q(Locations), createHashMap]
];

if (isServer) then {
    _declaration pushBack PREP_COMPONENT_FUNCTION(get)
}

COB = createHashMapObject [_declaration];
COB call [F(init)];
