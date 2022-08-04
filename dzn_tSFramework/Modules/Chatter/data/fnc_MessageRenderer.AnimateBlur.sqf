#include "script_component.hpp"
#include "MessageRenderer.h"

/*
    Method: AnimateBlur (non-public)

    Animates messages movement to proper position on update

    Params:
    _qe - (array) queue entity
    _position - (number) message position id (1 or 2)

    Return: nothing

    Example:
    ["AnimateBlur", [_entity, 1]] call tSF_Chatter_fnc_MessageRenderer;
*/

DEBUG_1("(Renderer.animateBlur) Params: %1", _this);

params ["_qe", "_position"];
_qe set [QE_STATE, STATE_BLURRING];

(_qe # QE_CONTROLS) params ["_ctrlGroup", "_ctrlType", "_ctrlTitle", "_ctrlMsg"];

private _grpPosition = ctrlPosition _ctrlGroup;

// Move group to new position
_ctrlGroup ctrlSetPositionY ((_grpPosition # 1) - BOX_BLUR_OFFSET_Y);

// Make message a bit transparent
private _alpha = 1 - ([BG_ALPHA_BLUR2, BG_ALPHA_BLUR1] select (_position == 1));
DEBUG_1("(Renderer.animateBlur) Alpha: %1", _alpha);
_ctrlGroup ctrlSetFade _alpha;

_ctrlGroup ctrlCommit ANIM_DUR_BLUR;

// Schedule unhide anim
if (_grpPosition # 2 == 0) then {
    [{
        (_this # QE_CONTROLS) params ["_ctrlGroup", "_ctrlType", "_ctrlTitle", "_ctrlMsg"];
        _ctrlMsg ctrlSetStructuredText (_ctrlMsg getVariable "text");
        _ctrlGroup ctrlSetPositionW BOX_W;
        _ctrlGroup ctrlCommit ANIM_DUR_BLUR_APPEAR;
    }, _qe, ANIM_DUR_BLUR_APPEAR] call CBA_fnc_waitAndExecute;
};
// Schedule state switch
DEBUG_2("(Renderer.animateBlur) Entity %1 : State transition scheduled to %2", _qe # QE_ID, STATE_SHOWN);
[_qe, STATE_BLURRING, STATE_BLURRED, ANIM_DUR_BLUR] call self_FUNC(transitToState);
