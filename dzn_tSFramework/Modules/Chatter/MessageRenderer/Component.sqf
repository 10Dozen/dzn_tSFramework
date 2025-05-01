#include "script_component.hpp"

/*
    Message Rendered component handles drawing of the Radio messages in queue.
*/

private _declaration = [
    ["#str", { format ["Chatter.MessageRenderer (queue: %1)", count (_self get Q(Queue))] }],

    PREP_COMPONENT_FUNCTION(init),
    PREP_COMPONENT_FUNCTION(show),
    PREP_COMPONENT_FUNCTION(hide),
    PREP_COMPONENT_FUNCTION(clear),
    PREP_COMPONENT_FUNCTION(createControls),

    PREP_COMPONENT_FUNCTION(addToQueue),
    PREP_COMPONENT_FUNCTION(removeFromQueue),
    PREP_COMPONENT_FUNCTION(handleMainLoop),

    PREP_COMPONENT_FUNCTION(transitToState),
    PREP_COMPONENT_FUNCTION(animateAppear),
    PREP_COMPONENT_FUNCTION(animateHide),
    PREP_COMPONENT_FUNCTION(animateBlur),

    // Variables
    [Q(LastId), 0],
    [Q(Queue), []],
    [Q(PFH), nil],
    [Q(MissionEndHandler), nil]
];

private _component = createHashMapObject [_declaration];
_component call [F(init)];

_component
