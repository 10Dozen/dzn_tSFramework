#include "script_component.hpp"

/*
    Reads Radio Talkers table and defines missing parameters:
        - callsign
        - unit or objNull
        - LR range or default Radio > Range > LR
        - SW range or default Radio > Range > SW

    (_self)

    Params: none
    Return: none
*/

DEBUG_MSG("(prepareTalkers) Invoked");

RADIO_TALKERS = createHashMap;
private _defaultLR = SETTING_2(_self,Radio,LR Range);
private _defaultSW =  SETTING_2(_self,Radio,SW Range);

private ["_callsign","_unit","_lrRange","_swRange", "_talker"];
{
    _callsign = _x get "callsign";
    _unit = _x getOrDefault ["unit", objNull];
    _lrRange = _x getOrDefault ["LR", _defaultLR];
    _swRange = _x getOrDefault ["SW", _defaultSW];

    _self call [
        F(registerRadioTalker),
        [_callsign, _unit, _lrRange, _swRange, false]
    ];
} forEach SETTING(_self,Talkers);

// --- Make talkers public
DEBUG_1("(prepareTalkers) Publushing: %1", RADIO_TALKERS);
publicVariable QRADIO_TALKERS;
