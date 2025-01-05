#include "script_component.hpp"

/*
    Method: CreateControls (non-public)
    (_self)

    Creates controls (control group + 3 items inside) and hides it.

    Params:
    _title - (string) callsign or name of the caller to display.
    _titleType - (string) type of message - LR/SW to be shown in title.
    _msg - (string) message to display.
    _yInit - (number) UI Y position (depends on LR or SW message type)
    _bgColor - (array) RGBA array of background color (depends on LR or SW message type)

    Return: none
    Example:
    ["CreateControls", ["Bird-1-1", "RTB, Over'n'out", 0.04, [0,0,0,0.5]]] call tSF_Chatter_fnc_MessageRenderer;
*/

params ["_title", "_titleType", "_msg", "_yInit", "_bgColor"];

disableSerialization;

// Create ctrlGroup and controls
private _display = findDisplay 46;

private _ctrlGroup = _display ctrlCreate ["RscControlsGroupNoScrollbars", -1];
_ctrlGroup ctrlSetPosition [BOX_INIT_X, _yInit];
_ctrlGroup ctrlCommit 0;

private _ctrlLabel = _display ctrlCreate ["RscStructuredText", -1, _ctrlGroup];
_ctrlLabel ctrlSetBackgroundColor _bgColor;
_ctrlLabel ctrlSetPosition [0, 0, TYPE_W, TYPE_H];
_ctrlLabel ctrlCommit 0;

private _ctrlTitle  = _display ctrlCreate ["RscStructuredText", -1, _ctrlGroup];
private _titleText = parseText format [
    "<t align='left'>%1</t><t align='right'>%2 @ %3</t>",
    parseText _title,
    _titleType,
    [dayTime] call BIS_fnc_timeToString
];
_ctrlTitle setVariable ["text", _titleText];
_ctrlTitle ctrlSetStructuredText _titleText;
_ctrlTitle ctrlSetBackgroundColor _bgColor;
_ctrlTitle ctrlSetPosition [TITLE_X, TITLE_Y, 0, TITLE_H];
_ctrlTitle ctrlCommit 0;

private _ctrlMsg = _display ctrlCreate ["RscStructuredText", -1, _ctrlGroup];
_ctrlMsg setVariable ["text", parseText _msg];
_ctrlMsg ctrlSetBackgroundColor [BG_COLOR, BG_ALPHA_ACTIVE];
_ctrlMsg ctrlSetPosition [MSG_X, MSG_Y, 0, MSG_H];
_ctrlMsg ctrlCommit 0;

private _controls = [_ctrlGroup, _ctrlLabel, _ctrlTitle, _ctrlMsg];

(uiNamespace getVariable QGVAR(ControlsBuffer)) append _controls;

_controls
