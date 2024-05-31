#include "script_component.hpp"

/*
    Initialize Component Object and it's features.
    Params:
        none
    Returns:
        nothing
*/

__CLIENT_ONLY__

private _pfhId = [
    {
        (_this # 0) call [F(handleMainLoop)];
    },
    PFH_DELAY,
    _self
] call CBA_fnc_addPerFrameHandler;

_self set [Q(PFH), _pfhId];

LOG("(Renderer.Init) Client Initialized");
