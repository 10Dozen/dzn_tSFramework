#include "script_component.hpp"

/*
    Editor Radio Settings allow to apply specifc TFAR LR Radio class to
    specifc vehicle, overriding or adding chosen radio to it.
*/

private _declaration = [
    COMPONENT_TYPE,
    PREP_COMPONENT_SETTINGS,

    PREP_COMPONENT_FUNCTION(init),
    PREP_COMPONENT_FUNCTION(assignRadio),
    PREP_COMPONENT_FUNCTION(processLogics)
];

COB = createHashMapObject [_declaration];
COB call [F(init)];
