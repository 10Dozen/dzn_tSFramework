#include "script_component.hpp"

/*
    Method: RemoveFromQueue (non-public)
    (_self)

    Removes message entity from Queue

    Params:
    _id - (number) ID of the entity

    Return: none

    Example:
    ["RemoveFromQueue", [23]] call tSF_Chatter_fnc_MessageRenderer;
*/

DEBUG_1("(Renderer.removeFromQueue) Params: %1", _this);

params ["_id"];

private _queue = _self get Q(Queue);
private _index = _queue findIf { _x # QE_ID == _id };

DEBUG_1("(Renderer.removeFromQueue) Queue size is %1", count _queue);
DEBUG_1("(Renderer.removeFromQueue) Entity index: %1", _index);

if (_index < 0) exitWith {
    LOG("(Renderer.removeFromQueue) FAILED to find Entity index");
};

_queue deleteAt _index;

DEBUG_1("(Renderer.removeFromQueue) Removed. Queue size now is %1", count _queue);
