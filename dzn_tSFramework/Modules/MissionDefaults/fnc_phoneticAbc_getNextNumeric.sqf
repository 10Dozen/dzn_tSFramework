#include "script_component.hpp"
/*

[fails] - numeric autocomplete
   -- криво переименовыает - оставляет # или ставит новое число не туда
   -- если вводить 42# - то по достижению 430 начинает всегда отдавать 430
        потому что
        */
/*
    Returns next appropriate numeric value for marker.
    Scans map markers and collects used numbers, then
    selects next unused number that correspond to limits
    and returns it.

    If no number that match criteria is available - returns nil.

    Use cases:
    # -> 1...9
    ## -> 11...99
    ### -> 101...999
    3# -> 30...39
    15# -> 150...159
    2## -> 200...299

    Params:
        0: _groups (ARRAY) - regex groups array:
            [_fullMatch, _leadingNumbers, _wildcards].

    Returns:
        _suggestion (NUMBER) or nil - suggested number.
*/

#define REGEX_TEMPLATE "(?<!\d)\d{%1}(?!\d)"

DEBUG_1("(phoneticAbs_handleNumeric) Params: %1", _this);

forceUnicode 1;
params ["_groups"];

_groups params ["", "_leadingNumber", "_wildcards"];
DEBUG_1("(phoneticAbs_handleNumeric) Leading Number group: %1", _leadingNumber);
DEBUG_1("(phoneticAbs_handleNumeric) _wildcards group: %1", _wildcards);

_leadingNumber = _leadingNumber # 0;
_wildcardsSize = count (_wildcards # 0);

DEBUG_2("(phoneticAbs_getNextNumeric) Leading Number=%1, wildcards size=%2", _leadingNumber, _wildcardsSize);

private _leadingNumberSize = count _leadingNumber;
private _regex = format [REGEX_TEMPLATE, _wildcardsSize + _leadingNumberSize];

DEBUG_1("(phoneticAbs_getNextNumeric) Regex=%1", _regex);

private _usedNumbers = [];
private ["_name", "_found"];
{
    _name = markerText _x;
    _found = (_name regexFind [_regex]);
    if (_found isEqualTo []) then { continue; };

    (_found # 0 # 0) params ["_num", ""];
    _usedNumbers pushBack parseNumber _num;
} forEach (allMapMarkers);

_usedNumbers sort true;
DEBUG_1("Found numbers: %1", _usedNumbers);

DEBUG_3("(phoneticAbs_getNextNumeric) Case: %1 (leading=%2, wildcards=%3)", _wildcardsSize + _leadingNumberSize, _leadingNumberSize, _wildcardsSize);

private _numericRange = SETTING_2(_self,PhoneticAlphabet,numeric) # (_wildcardsSize + _leadingNumberSize - 1);
private _base = _numericRange get Q(base);
private _max = _numericRange get Q(max);
private _limit = _numericRange get Q(limit);

if (_leadingNumber != "") then {
    _base = (parseNumber _leadingNumber) * _base / 10^(_leadingNumberSize-1);
    DEBUG_1("Modify _base with leading number: %1", _base);
};

DEBUG_2("(phoneticAbs_getNextNumeric) Suggestion params: _base=%1, _max=%2", _base, _max);

private _suggestion = _base;
DEBUG_1("(phoneticAbs_getNextNumeric) Search for suggestion. First: %1", _suggestion);

while {
    DEBUG_1("(phoneticAbs_getNextNumeric)Check that suggested is occupied: %1", _suggestion in _usedNumbers);
    _suggestion in _usedNumbers && _suggestion <= _max
} do {
    private _other = _suggestion % _base;
    DEBUG_1("(phoneticAbs_getNextNumeric) _other = %1", _other);
    if (_other == _limit) then {
        _suggestion = _suggestion - _limit + _base - 1;
        DEBUG_1("(phoneticAbs_getNextNumeric) Jump to next step = %1", _suggestion);
    };
    _suggestion = _suggestion + 1;
    DEBUG_1("(phoneticAbs_getNextNumeric) New suggestion = %1", _suggestion);
};
if (_suggestion > _max) exitWith {
    DEBUG_1("(phoneticAbs_getNextNumeric) Suggestion = %1 is out of allowed range", _suggestion);
    nil
};

DEBUG_1("(phoneticAbs_getNextNumeric) Resulting suggestion = %1", _suggestion);
_suggestion
