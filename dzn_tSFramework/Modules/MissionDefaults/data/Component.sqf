#include "script_component.hpp"

/*
    Test:
    [ok] - Calc
    [ok] - equip
    [ok] - phoneticAbc
    [] - numeric autocomplete
    [] - adjust numeric autocomplete (move into settings?)
    [] - disable on start
    [] - orbat

*/

private _declaration = [
    ["#type", { format ["%1_ComponentObject", Q(COMPONENT)] }],
    /* ["#str", { format ["%1_ComponentObject", QUOTE(COMPONENT)] }],*/

    [Q(Settings), [Q(COMPONENT_PATH(Settings.yaml))] call dzn_fnc_parseSFML],

    PREP_COMPONENT_FUNCTION(init),
    PREP_COMPONENT_FUNCTION(onStart_disablePlayer),
    PREP_COMPONENT_FUNCTION(onStart_composeOrbatHint),
    PREP_COMPONENT_FUNCTION(onStart_getGroupOrbat),
    PREP_COMPONENT_FUNCTION(onStart_drawOnTimeout),

    PREP_COMPONENT_FUNCTION(equip_setUpEquipment),

    PREP_COMPONENT_FUNCTION(phoneticAbc_setHandler),
    PREP_COMPONENT_FUNCTION(phoneticAbc_handle),
    PREP_COMPONENT_FUNCTION(phoneticAbc_getNextAbcCode),
    PREP_COMPONENT_FUNCTION(phoneticAbc_getNextNumeric),

    PREP_COMPONENT_FUNCTION(calc_init),
    PREP_COMPONENT_FUNCTION(calc_handle)
];

GVAR(ComponentObject) = createHashMapObject [_declaration];
GVAR(ComponentObject) call [F(init)];
