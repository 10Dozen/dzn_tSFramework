#include "script_component.hpp"

/*
    (_self)
    Handles phonetic alphabet wildcard in marker name and update marker name
    with suggested value.

    ABF % -> ABF Alpha
    BOF % -> BOF Charlie

    or auto-generate name:

    % -> Delta

    Params:
        0: _marker (STRING) - marker system name

    Returns:
        nothing
*/

params ["_marker"];

DEBUG_1("(phoneticAbs_handle) Params: %1", _this);

forceUnicode 1;
private _name = markerText _marker;
private _idxPhonetic = _name find PHONETIC_ABC_WILDCARD;

// Phonetic alphabet replacement -> $ to Alpha
if (_idxPhonetic > -1) exitWith {
    private _suggestion = _self call [F(phoneticAbc_getNextAbcCode)];
    if (isNil "_suggestion") exitWith { DEBUG_MSG("(phoneticAbs_handle) No suggestions. Exit"); };
    DEBUG_1("(phoneticAbs_handle) [Abc] Suggested = %1", _suggestion);

    // Replace entire name
    if (_name == PHONETIC_ABC_WILDCARD) exitWith {
        _marker setMarkerText _suggestion;
    };

    // Replace inside
    _marker setMarkerText format [
        "%1%2%3",
        _name select [0, _idxPhonetic],
        _suggestion,
        _name select [_idxPhonetic + 1, count _name]
    ];
    DEBUG_MSG("(phoneticAbs_handle) [Abc]  Marker renamed!");
};

// Numeric replacement -> # to 1, ## -> 10, ### -> 100
private _numericWildcards = _name regexFind [format ["(\d*)(%1{1,3})$", NUMERIC_WILDCARD]];
if (_numericWildcards isNotEqualTo []) exitWith {
    DEBUG_MSG("(phoneticAbs_handle) [Numeric] Look for numeric option!");
    (_numericWildcards # 0 # 0) params ["_matched", "_idx"];

    private _suggestion = _self call [F(phoneticAbc_getNextNumeric), [_numericWildcards # 0]];
    if (isNil "_suggestion") exitWith { DEBUG_MSG("(phoneticAbs_handle) [Numeric] No suggestions. Exit"); };

    // Replace entire name
    if (_name == _wildcards) exitWith {
        _marker setMarkerText _suggestion;
    };

    _marker setMarkerText format [
        "%1%2%3",
        _name select [0, _idx],
        _suggestion,
        _name select [_idx + count _matched, count _name]
    ];
    DEBUG_MSG("(phoneticAbs_handle) [Numeric] Marker (numeric) renamed!");
};
