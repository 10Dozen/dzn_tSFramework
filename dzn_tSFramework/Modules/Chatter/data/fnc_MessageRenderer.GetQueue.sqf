#include "script_component.hpp"
#include "MessageRenderer.h"

/*
    Method: GetQueue (non-public)

    Returns queue of given type.

    Params:
    _type - (string) type fo the queue to clear ('LR' or 'SW'). Optional, if none given - clears both.

    Return:
    _queue - (array) queue of messages

    Example:
    _queue = ["GetQueue", ["SW"]] call tSF_Chatter_fnc_MessageRenderer;
*/


params ["_type"];
private _queue = switch toUpper _type do {
    case QUEUE_LR: { self_GET(Queue LR) };
    case QUEUE_SW: { self_GET(Queue SW) };
};

_queue
