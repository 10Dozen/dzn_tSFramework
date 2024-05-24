#include "script_component.hpp"

/*

*/

private _declaration = [
    COMPONENT_TYPE,
    PREP_COMPONENT_SETTINGS,

    PREP_COMPONENT_FUNCTION(initClient),
    PREP_COMPONENT_FUNCTION(setDefaultEquipment),
    PREP_COMPONENT_FUNCTION(setDefaultRating),

    PREP_COMPONENT_FUNCTION(addRespawnHandler),

    [Q(Locations), createHashMap]
];

if (isServer) then {
    _declaration pushBack PREP_COMPONENT_FUNCTION(initServer);
    _declaration pushBack PREP_COMPONENT_FUNCTION(processLogics);
}

COB = createHashMapObject [_declaration];
COB call [F(initServer)];
