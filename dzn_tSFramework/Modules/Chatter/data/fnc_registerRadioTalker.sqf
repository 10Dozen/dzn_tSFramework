#include "script_component.hpp"

/*
    Creates and registers radio talker.
    Will be executed only on server!

    (_self)

    Params:
    _callsign - (string) callsign of the talker (will be displayed in message).
    _unit - (object) or (array Pos3D) talker's unit. May be object (the exact unit) or
            position where GameLogic will be created to represent talker.
            When objNull is used - 'virtual' talker (without range limitations) will be initialized.
            Optional, default objNull.
    _lrRange - (number) max broadcast range of LR radio. Optional, default Radio > Range > LR
    _swRange - (number) max broadcast range of SW radio. Optional, default Radio > Range > SW
    _publish - (bool) flag to immediate publish Radio talkers table to all clients. Optional, default true.

    Return: ARRAY in format [
        _callsign (STRING),
         _unit (OBJECT),
         _lrRange (NUMBER),
         _swRange (NUMBER),
         _isDirectSpeaker (BOOL)
     ]
           // Adds to RadioTalker map a key = Callsign and value = array in format:
           // [_callsign, _unit, _lrRange, _swRange, _isDirectSpeaker]

    Example:
    // "PAPA BEAR" talker with unlimited broadcast range
    ["PAPA BEAR"] call tSF_Chatter_fnc_createRadioTalker;

    // "Vulture" JTAC talker somewhere in Takistan mountains
    ["Vulture", vulture_unit, 50000, 3000] call tSF_Chatter_fnc_createRadioTalker;

    // "The Spy" talker with weak short-range radio, that can be heard only in 1.5 km near the given position
    ["The Spy", [1441.23, 4223.33, 12.1], 0, 1500] call tSF_Chatter_fnc_createRadioTalker;
*/

DEBUG_1("(registerRadioTalker) Params: %1", _this);

if (!isServer) exitWith {
    [QCOB, [F(registerRadioTalker), _this]] remoteExec ["call", 2];
};

params [
    "_callsign",
    ["_unit", objNull, [[],objNull]],
    ["_lrRange", SETTING_2(_self,Radio,LR Range)],
    ["_swRange", SETTING_2(_self,Radio,SW Range)],
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

DEBUG_5("(registerRadioTalker) New talker [callsign=%1, unit=%2, LRrange=%3, SWrange=%4, is_direct=%5]", _callsign, _unit, _lrRange, _swRange, _isDirectSpeaker);

RADIO_TALKERS set [
    _callsign,
    [_callsign, _unit, _lrRange, _swRange, _isDirectSpeaker]
];

if (!_publish) exitWith {};
publicVariable Q(RADIO_TALKERS);
