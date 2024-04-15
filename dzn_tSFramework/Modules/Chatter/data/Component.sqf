#include "script_component.hpp"

/*
    Chatter component is used to display some LR/SR radio coms and direct speech.
    Used by other componets (like Conversations, Artillery and Airborne Support)
*/

private _declaration = [
    COMPONENT_TYPE,

    PREP_COMPONENT_SETTINGS,

    PREP_COMPONENT_FUNCTION(init),
    PREP_COMPONENT_FUNCTION(prepareTalkers),
    PREP_COMPONENT_FUNCTION(registerRadioTalker),
    PREP_COMPONENT_FUNCTION(getRadioTalkerByCallsign),
    PREP_COMPONENT_FUNCTION(getInVehicleIsolationCoef),
    PREP_COMPONENT_FUNCTION(addNoise),

    // Non-public functions
    PREP_COMPONENT_FUNCTION(say),
    PREP_COMPONENT_FUNCTION(sendMessageOverRadio),
    PREP_COMPONENT_FUNCTION(showMessageOverRadio),
    PREP_COMPONENT_FUNCTION(showMessageLocally),

    [Q(MessageRenderer), call compileScript [Q(COMPONENT_SUBPATH(MessageRenderer,Component))]]
];

COB = createHashMapObject [_declaration];
COB call [F(init)];
