#include "script_component.hpp"

/*
    MissionDefaults component provide general features for every user
    needed in every mission:
    - puts weapon on safe on mission start
    - puts earplugs in
    - disables control for 20 seconds at the beginning (to avoid misfire or grenade)
    - adds useful tools like calculator and marker name autocompltion;
*/

private _declaration = [
    COMPONENT_TYPE,
    PREP_COMPONENT_SETTINGS,

    PREP_COMPONENT_FUNCTION(init),
    PREP_COMPONENT_FUNCTION(onStart_disablePlayer),
    PREP_COMPONENT_FUNCTION(onStart_composeOrbatHint),
    PREP_COMPONENT_FUNCTION(onStart_drawOnTimeout),

    PREP_COMPONENT_FUNCTION(showORBATHint),

    PREP_COMPONENT_FUNCTION(phoneticAbc_setHandler),
    PREP_COMPONENT_FUNCTION(phoneticAbc_handle),
    PREP_COMPONENT_FUNCTION(phoneticAbc_getNextAbcCode),
    PREP_COMPONENT_FUNCTION(phoneticAbc_getNextNumeric),

    PREP_COMPONENT_FUNCTION(calc_init),
    PREP_COMPONENT_FUNCTION(calc_handle)
];

COB = createHashMapObject [_declaration];
COB call [F(init)];
