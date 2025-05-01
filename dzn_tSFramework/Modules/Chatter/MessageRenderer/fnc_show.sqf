#include "script_component.hpp"

/*
    Method: Show (Public)
    (_self)

    Adds message to queue to be drawn on screen.

    Params:
    _type - (string) 'LR' for long-range or 'SW' for short-range radio style.
    _title - (string) callsign or name of the caller to display.
    _msg - (string) message to display.
    _ttl - (number) time to display message. Optional, default 7 seconds.

    Return: none
    Example:
    ["Show", ["LR", "Bird-1-1", "RTB, Over'n'out"]] call tSF_Chatter_fnc_MessageRenderer;
*/

params ["_type", "_title", "_message", ["_ttl", TTL_SHOW]];
DEBUG_2("(Renderer.Show) Params: %1. TTL: %2", _this, _ttl);

private _bgColor = [BG_COLOR_LR, BG_ALPHA_ACTIVE];
private _titleType = "ДВ";
if (toUpper _type == "SW") then {
    _bgColor = [BG_COLOR_SW, BG_ALPHA_ACTIVE];
    _titleType = "КВ";
};

DEBUG_1("(Renderer.Show) bgColor: %1", _bgColor);

private _ctrls = _self call [F(createControls), [_title, _titleType, _message, BOX_INIT_Y, _bgColor]];
DEBUG_2("(Renderer.Show) Controls created: %1. Adding to queue", count(_ctrls));

_self call [F(addToQueue), [_type, _ctrls, _ttl]];
