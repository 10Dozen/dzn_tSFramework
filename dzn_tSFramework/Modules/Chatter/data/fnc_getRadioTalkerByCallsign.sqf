#include "script_component.hpp"

/*
    Returns registered talker entity by given callsign. Or empty array if not found.

    Params:
    _callsign - (string) callsign of the talker.

    Return:
    _talkerEntity - (array) array of talker data: 0: unit (object), 1: range of LR comms (number), 2L range of SW radio comms (number).

    Example:
    _talkerEntity = ["PAPA BEAR"] call tSF_Chatter_fnc_getRadioTalkerByCallsign; // Return: [hq_commander, 30000, 5000]
*/

params ["_callsign"];
private _talkerEntity = GVAR(RadioTalkers) get _callsign;

if (isNil "_talkerEntity") exitWith {
    TSF_ERROR_1(TSF_ERROR_TYPE__MISSING_ENTITY, "Failed to find '%1' radio talker! Please, create one before use!", _callsign);
    []
};

_talkerEntity
