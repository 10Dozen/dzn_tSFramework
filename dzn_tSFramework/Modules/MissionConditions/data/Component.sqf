#include "script_component.hpp"

/*
    MissionConditions component defines and track condition of specific mission ends.
*/

private _declaration = [
    COMPONENT_TYPE,
    PREP_COMPONENT_SETTINGS,

    PREP_COMPONENT_FUNCTION(init),
    PREP_COMPONENT_FUNCTION(startConditionsTracking),
    PREP_COMPONENT_FUNCTION(checkConditions),
    PREP_COMPONENT_FUNCTION(publishEndings)
];

COB = createHashMapObject [_declaration];
COB call [F(init)];
