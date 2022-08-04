#include "script_component.hpp"
/*
    Registres existing unit as radio talker by given callsign.
    Also changes group callsign to given.

    Params:
    _unit - (object) unit (should be some soldier, not a vehicle/object).
    _callsign - (string) callsign of the talker (will be displayed in message).
    _range - (array) max broadcast range of LR and SW radios. Optional, default [-1, -1] means unlimited.

    Return: none

    Example:
    // Unit hq_commander with 'PAPA BEAR' callsign and broadcast range 30km for LR and 5km for SW
    [hq_commander, "PAPA BEAR", [30000, 5000]] call tSF_Chatter_fnc_registerUnitAsRadioTalker;
*/
params ["_unit", "_callsign", ["_range", [-1,-1]]];

private _grp = group _unit;
_grp setGroupIdGlobal [_callsign];

GVAR(RadioTalkers) set [_callsign, [_grp, _range # 0, _range # 1]];
