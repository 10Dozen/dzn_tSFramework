#include "script_component.hpp"

/*
    Creates and registers radio talker.
    Will be executed only on server!

    Params:
    _callsign - (string) callsign of the talker (will be displayed in message).
    _unit - (object) or (array Pos3D) talker's unit. May be object (the exact unit) or
            position where GameLogic will be created to represent talker.
            When objNull is used - 'virtual' talker (without range limitations) will be initialized.
            Optional, default objNull.
    _lrRange - (number) max broadcast range of LR radio. Optional, default Radio > Range > LR
    _swRange - (number) max broadcast range of SW radio. Optional, default Radio > Range > SW
    _publish - (bool) flag to immediate publish Radio talkers table to all clients. Optional, default true.

    Return: none
            Adds to RadioTalker map a key = Callsign and value = array in format:
            [_callsign, _unit, _lrRange, _swRange, _isDirectSpeaker]

    Example:
    // "PAPA BEAR" talker with unlimited broadcast range
    ["PAPA BEAR"] call tSF_Chatter_fnc_createRadioTalker;

    // "Vulture" JTAC talker somewhere in Takistan mountains
    ["Vulture", vulture_unit, 50000, 3000] call tSF_Chatter_fnc_createRadioTalker;

    // "The Spy" talker with weak short-range radio, that can be heard only in 1.5 km near the given position
    ["The Spy", [1441.23, 4223.33, 12.1], 0, 1500] call tSF_Chatter_fnc_createRadioTalker;
*/


if (!isServer) exitWith {
    _this remoteExec [QFUNC(createRadioTalker), 2];
};

params [
    "_callsign",
    ["_unit", objNull],
    ["_lrRange", GET_ "Radio","Range","LR" _SETTING],
    ["_swRange", GET_ "Radio","Range","SW" _SETTING],
    ["_publish", true]
];

// Create GameLogic if position is passed as argument
if (_unit isEqualType []) then {
    _unit = createSimpleObject ["Logic", _unit];
};

private _isDirectSpeaker = false;
if !(isNull _unit || _unit isKindOf "Logic") then {
    // Real unit - apply groupd id
    (group _unit) setGroupIdGlobal [_callsign];
    _isDirectSpeaker = true;
};

GVAR(RadioTalkers) set [_callsign, [_callsign, _unit, _lrRange, _swRange, _isDirectSpeaker]];

if (!_publish) exitWith {};

publicVariable QGVAR(RadioTalkers);
