#include "script_component.hpp"

/*
    Initialize Component Object and it's features.
    Params:
        none
    Returns:
        nothing
*/

__CLIENT_ONLY__

LOG("(Renderer.Init) Client Initializing...");

// Clearing controls that may be left from previous game...
{ ctrlDelete _x } forEach (uiNamespace getVariable QGVAR(ControlsBuffer));
uiNamespace setVariable [QGVAR(ControlsBuffer), []];


private _pfhId = [
    {
        (_this # 0) call [F(handleMainLoop)];
    },
    PFH_DELAY,
    _self
] call CBA_fnc_addPerFrameHandler;

private _ehId = addMissionEventHandler ["Ended", {
    LOG("(Renderer.OnMissionEnded) Clearing...");
    private _cob = _thisArgs # 0;
    _cob call [F(clear), [false]];
    (_cob get Q(PFH)) call CBA_fnc_removePerFrameHandler;
}, [_self]];

_self set [Q(PFH), _pfhId];
_self set [Q(MissionEndHandler), _ehId];

LOG("(Renderer.Init) Client Initialized");
