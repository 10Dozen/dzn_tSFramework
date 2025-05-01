#include "script_component.hpp"

/*
    tSNotes component adds useful information notes to player's diary.
*/

private _declaration = [
    COMPONENT_TYPE,
    PREP_COMPONENT_SETTINGS,

    PREP_COMPONENT_FUNCTION(init),
    PREP_COMPONENT_FUNCTION(addTopics),
    PREP_COMPONENT_FUNCTION(composeFrameworkNotes)
];

COB = CREATE_AND_REGISTER_COMPONENT(_declaration);
COB call [F(init)];
