#include "script_component.hpp"
#include "MessageRenderer.h"

/*
    Method: RemoveFromQueue (non-public)

    Removes message entity from Queues

    Params:
    _type - (string) type fo the queue to clear ('LR' or 'SW'). Optional, if none given - clears both.
    _id - (number) ID of the entity

    Return: none

    Example:
    ["RemoveFromQueue", ["LR", 23]] call tSF_Chatter_fnc_MessageRenderer;
*/

DEBUG_1("(Renderer.removeFromQueue) Params: %1", _this);

params ["_queueType", "_id"];

private _queue = [_queueType] call self_FUNC(getQueue);
private _index = _queue findIf { _x # QE_ID == _id };

DEBUG_1("(Renderer.removeFromQueue) Queue size is %1", count _queue);
DEBUG_1("(Renderer.removeFromQueue) Entity index: %1", _index);

if (_index < 0) exitWith {
    LOG("(Renderer.removeFromQueue) FAILED to find Entity index");
};
_queue deleteAt _index;

DEBUG_1("(Renderer.removeFromQueue) Removed. Queue size now is %1", count _queue);
