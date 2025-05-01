#include "script_component.hpp"

/*
    Method: AnimateHide (non-public)
    (_self)

    Animates message hide (slide to the left edge)

    Params:
    _qe - (array) queue entity

    Return: nothing

    Example:
    ["AnimateHide", [_entity]] call tSF_Chatter_fnc_MessageRenderer;
*/

DEBUG_1("(Renderer.animateHide) Params: %1", _this);

params ["_qe"];
_qe set [QE_STATE, STATE_EXPIRED];
_qe set [QE_TTL, time + TTL_BUFFER];

DEBUG_3("(Renderer.animateHide) Entity %1 : On State changed: %2. TTL updated to %3", _qe # QE_ID, _qe # QE_STATE, _qe # QE_TTL);

(_qe # QE_CONTROLS) params ["_ctrlGroup", "_ctrlType", "_ctrlTitle", "_ctrlMsg"];

_ctrlMsg ctrlSetStructuredText parseText "";
_ctrlGroup ctrlSetPositionW 0;
_ctrlGroup ctrlCommit ANIM_DUR_HIDE;

DEBUG_2("(Renderer.animateHide) Entity %1 : State transition scheduled to %2", _qe # QE_ID, STATE_HIDDEN);

_self call [F(transitToState), [_qe, STATE_EXPIRED, STATE_HIDDEN, ANIM_DUR_HIDE]];
