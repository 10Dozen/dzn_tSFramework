#include "script_component.hpp"

/*
    Creates and registers some 'virtual' radio talker group with dummy unit and given callsign.

    Params:
    _side - (side) side of the talker group (should be same as players to see messages).
    _callsign - (string) callsign of the talker (will be displayed in message).
    _position - (Pos3D array) position of the talker. Optional.
    _range - (array) max broadcast range of LR and SW radios. Optional, default [-1, -1] means unlimited.

    Return: none

    Example:
    // "PAPA BEAR" talker with unlimited broadcast range
    [west, "PAPA BEAR"] call tSF_Chatter_fnc_createVirtualRadioTalker;

    // "The Spy" talker with weak short-range radio, that can be heard only in 1.5 km near the given position
    [west, "The Spy", [1244, 2330, 0], [0, 1500]] call tSF_Chatter_fnc_createVirtualRadioTalker
*/

// Creates dummy radio talker
params ["_side", "_callsign", "_position", ["_range", [-1,-1]]];

private _grp = [_side, if (isNil "_position") then { nil } else { _position }] call FUNC(createDummy);
_grp setGroupIdGlobal [_callsign];

GVAR(RadioTalkers) set [_callsign, [_grp, _range # 0, _range # 1]];
