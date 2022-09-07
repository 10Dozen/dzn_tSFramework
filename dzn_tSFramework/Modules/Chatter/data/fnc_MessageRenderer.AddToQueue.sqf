#include "script_component.hpp"
#include "MessageRenderer.h"

/*
    Method: AddToQueue (non-public)

    Adds message to the queue as entity of format:
        0: _id - (number) unique ID of the entity
        1: _type - (string) message type ("LR" or "SW")
        2: _controls - (array) list of controls
        3: _state - (string) see MessageRenderer.h for states enumiration
        4: _ttl (number) - time to live for entity

    Params:
    _type - (string) type fo the queue to clear ('LR' or 'SW'). Optional, if none given - clears both.
    _ctrls - (array) list of the controls with message data.
    _ttl - (number) message's time to live in seconds.

    Return: nothing

    Example:
    ["AddToQueue", ["SW", _controls, 7]] call tSF_Chatter_fnc_MessageRenderer;
*/

params ["_type", "_ctrls", "_ttl"];
DEBUG_1("(Renderer.addToQueue) Params: %1", _this);

private _queue = self_GET(Queue);
DEBUG_1("(Renderer.addToQueue) Queue: %1", _queue);

private _qsize = count _queue;
DEBUG_1("(Renderer.addToQueue) Queue size: %1", _qsize);

// Last 2 messages will be marked as blurred (n - as blur1, n-1 - as blur2), other messages will be marked as Pull
private _blur1Index = (_qsize - 1);
private _blur2Index = (_qsize - 2);

DEBUG_1("(Renderer.addToQueue) Possible blurred 1: %1", _blur1Index);
DEBUG_1("(Renderer.addToQueue) Possible blurred 2: %1", _blur2Index);

if (_blur1Index >= 0) then {
    private _qe = _queue # _blur1Index;
    _qe set [QE_STATE, STATE_BLUR1];
    _qe set [QE_TTL, time + TTL_BLUR];
    DEBUG_2("(Renderer.addToQueue) Blurring message %1 (index: %2) as BLUR1", (_queue # _blur1Index) # QE_ID, _blur1Index);
};
if (_blur2Index >= 0) then {
    private _qe = _queue # _blur2Index;
    _qe set [QE_STATE, STATE_BLUR2];
    _qe set [QE_TTL, time + TTL_BLUR];
    DEBUG_2("(Renderer.addToQueue) Blurring message %1 (index: %2) as BLUR2", (_queue # _blur2Index) # QE_ID, _blur2Index);
};
if (_blur2Index > 0) then {
    for "_i" from 0 to (_blur2Index - 1) do {
        (_queue # _i) set [QE_STATE, STATE_PULL];
        DEBUG_2("(Renderer.addToQueue) Pulling message %1 (index: %2)", (_queue # _i) # QE_ID, _i);
    };
};

// Append new entity and update ID counter
private _id = self_GET(ID) + 1;
self_SET(ID,_id);

DEBUG_1("(Renderer.addToQueue) Assigning ID: %1", _id);

_queue pushBack [_id, _type, _ctrls, STATE_NEW, time + _ttl];

DEBUG_2("(Renderer.addToQueue) Added %1. Queue size now is %2", _queue # (count _queue - 1), count _queue);
