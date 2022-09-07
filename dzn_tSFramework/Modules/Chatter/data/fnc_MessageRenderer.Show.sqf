#include "script_component.hpp"
#include "MessageRenderer.h"

/*
    Method: Show (Public)

    Adds message to queque and then draw it on screen.

    Params:
    _type - (string) 'LR' for long-range or 'SW' for short-range radio.
    _title - (string) callsign or name of the caller to display.
    _msg - (string) message to display.
    _ttl - (number) time to display message. Optional, default 7 seconds.

    Return: none
    Example:
    ["Show", ["LR", "Bird-1-1", "RTB, Over'n'out"]] call tSF_Chatter_fnc_MessageRenderer;
*/

params ["_type", "_title", "_message", ["_ttl", TTL_SHOW]];
DEBUG_2("(Renderer.Show) Params: %1. TTL: %2", _this, _ttl);

_type = toUpper _type;

private _bgColor = switch _type do {
    case "LR": { [BG_COLOR_LR, BG_ALPHA_ACTIVE] };
    case "SW": { [BG_COLOR_SW, BG_ALPHA_ACTIVE] };
};
DEBUG_1("(Renderer.Show) bgColor: %1", _bgColor);

private _ctrls = [_title, _message, BOX_INIT_Y, _bgColor] call self_FUNC(CreateControls);
DEBUG_2("(Renderer.Show) Controls created: %1. Adding to queue", count(_ctrls));

[_type, _ctrls, _ttl] call self_FUNC(AddToQueue);
