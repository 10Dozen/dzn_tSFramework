#include "script_component.hpp"

/*
    Message Rendered component handles drawing of the Radio messages in queue.
*/

private _declaration = [
    //["#str", { format ["Chatter.MessageRenderer (queue: %1)", count (_self get Q(Queue))] }],

    PREP_COMPONENT_FUNCTION(init),

    // Variables
    [Q(LastId), 0]
];

private _component = createHashMapObject [_declaration];
_component call [F(init)];

_component
