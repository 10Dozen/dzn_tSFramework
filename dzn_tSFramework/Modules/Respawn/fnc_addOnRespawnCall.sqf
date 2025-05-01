#include "script_component.hpp"

/*
    Adds code snippet to be executed on respawn.
    Code snippet will be execute after respawn position calculated. 
    _priority allows to set some order of execution of the snippets. 
    However, snippets with the same priority will be executed in FIFO order.
    (_self)

    Params:
        _code (CODE) - code to execute on respawn. _this will be [_unit, _corpse,_args].
        _args (ANY) - optional, arguments to _code snippet. Defaults to [].
        _priority (NUMBER) - optional, execution priority, where 0 - max earlier. Defaults to 10.
    Returns:
        string
*/

params ["_code", ["_args", []], ["_priority", 10]];

private _snippets = _self get Q(onRespawnSnippets) getOrDefaultCall [
    _priority, { [] }, true
];

_snippets pushBack [_code, _args];
