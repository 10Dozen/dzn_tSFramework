#include "script_component.hpp"

/*
    Reads Radio Talkers table and defines missing parameters:
        - callsign
        - unit or objNull
        - LR range or default Radio > Range > LR
        - SW range or default Radio > Range > SW
    Params: none
    Return: none
*/

private _defaultLR = GET_ "Radio", "Range", "LR" _SETTING;
private _defaultSW = GET_ "Radio", "Range", "SW" _SETTING;

{
    private _callsign = _x get "callsign";
    private _unit = _x getOrDefault ["unit", objNull];
    private _lrRange = _x getOrDefault ["LR", _defaultLR];
    private _swRange = _x getOrDefault ["SW", _defaultSW];

    [_callsign, _unit, _lrRange, _swRange, false] call FUNC(createRadioTalker);
} forEach (GET_ "Talkers" _SETTING);

publicVariable QGVAR(RadioTalkers);
