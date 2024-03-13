#include "script_component.hpp"

/*
    Handles phonetic alphabet wildcard and numeric wildcard
    in marker name and update marker name with suggested
    (unused phonetic or numeric) value.

    ABF $ -> ABF Alpha
    TRP ### -> TRP 100

    (_self)

    Params:
        0: _marker (STRING) - marker system name

    Returns:
        nothing
*/

params ["_marker"];

DEBUG_1("(phoneticAbs_handle) Params: %1", _this);


forceUnicode 1;
private _name = markerText _marker;
private _wildcards = PHONETIC_ABC_WILDCARD;
private _idx = _name find PHONETIC_ABC_WILDCARD;
private _len = 1;
private ["_suggestion"];

if (_idx > -1) then {
    // Phonetic alphabet replacement -> $ to Alpha
    _suggestion = _self call [F(phoneticAbc_getNextAbcCode)];
} else {
    // Numeric replacement -> ### -> 100
    private _numericWildcards = _name regexFind [format ["(\d*)(%1{1,3})$", NUMERIC_WILDCARD]];
    if (_numericWildcards isEqualTo []) exitWith {};

    DEBUG_MSG("(phoneticAbs_handle) [Numeric] Look for numeric option!");
    _len = count (_numericWildcards # 0 # 0 # 0);
    _idx = (_numericWildcards # 0 # 0 # 1);

    _suggestion = _self call [
        F(phoneticAbc_getNextNumeric),
        [_numericWildcards # 0]
    ];
};

if (isNil "_suggestion") exitWith { DEBUG_MSG("(phoneticAbs_handle) No suggestions. Exit"); };

// Replace entire name
if (_name == _wildcards) exitWith {
    _marker setMarkerText _suggestion;
};

// Replace inside
_marker setMarkerText format [
    "%1%2%3",
    _name select [0, _idx],
    _suggestion,
    _name select [_idx + _len, count _name]
];
