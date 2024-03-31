#include "script_component.hpp"

/*
    Method: AnimateAppear (non-public)
    (_self)

    Animates entity controls to appear.

    Params:
    _qe - (array) queue entity

    Return: nothing

    Example:
    ["AnimateAppear", [_entity]] call tSF_Chatter_fnc_MessageRenderer;
*/


DEBUG_1("(Renderer.animateAppear) Params: %1", _this);
params ["_qe"];

_qe set [QE_STATE, STATE_SHOWING];
DEBUG_2("(Renderer.animateAppear) Entity %1 : On State changed: %2", _qe # QE_ID, _qe # QE_STATE);

(_qe # QE_CONTROLS)  params ["_ctrlGroup", "_ctrlType", "_ctrlTitle", "_ctrlMsg"];

_ctrlType ctrlSetPositionW TYPE_W;
_ctrlTitle ctrlSetPositionW TITLE_W;
_ctrlMsg ctrlSetPositionW MSG_W;

_ctrlType ctrlCommit 0;
_ctrlTitle ctrlCommit ANIM_DUR_APPEAR;
_ctrlMsg ctrlCommit ANIM_DUR_APPEAR;

[{
    (_this # QE_CONTROLS) params ["", "", "_ctrlTitle", "_ctrlMsg"];
    _ctrlMsg ctrlSetStructuredText (_ctrlMsg getVariable "text");
}, _qe, ANIM_DUR_APPEAR_TEXT] call CBA_fnc_waitAndExecute;

DEBUG_2("(Renderer.animateAppear) Entity %1 : State transition scheduled to %2", _qe # QE_ID, STATE_SHOWN);

_self call [F(transitToState), [_qe, STATE_SHOWING, STATE_SHOWN, ANIM_DUR_APPEAR]];
