
#include "script_component.hpp"

/*
    Handles numeric auto-completion.
    # -> 1...9
    ## -> 11...99
    ### -> 101...999



    TRP 3## -> 300 -> 301 -> 302..

    Params:
        0: _size (NUMBER) - number of digits to suggest.

    Returns:
        nothing
*/

DEBUG_1("(phoneticAbs_handleNumeric) Params: %1", _this);
params ["_groups"];

_groups params ["", "_leadingNumber", "_wildcards"];
DEBUG_1("(phoneticAbs_handleNumeric) Leading Number group: %1", _leadingNumber);
DEBUG_1("(phoneticAbs_handleNumeric) _wildcards group: %1", _wildcards);

_leadingNumber = _leadingNumber # 0;
_wildcardsSize = count (_wildcards # 0);

DEBUG_1("(phoneticAbs_getNextNumeric) Leading Number=%1, wildcards size=%2", _leadingNumber, _wildcardsSize);


private ["_name", "_found"];


private _regex = [
    format ["(?<!\d)\d{%1}(?!\d)", _wildcardsSize],
    format ["(?<!\d)%2\d{%1}(?!\d)", _wildcardsSize, _leadingNumber]
] select (_leadingNumber != "");

DEBUG_1("(phoneticAbs_getNextNumeric) Regex=%1", _regex);

private _usedNumbers = [];
{
    _name = markerText _x;
    _found = (_name regexFind [_regex]);
    if (_found isEqualTo []) then { continue; };

    (_found # 0 # 0) params ["_num", ""];
    _usedNumbers pushBack parseNumber _num;
} forEach (allMapMarkers);

_usedNumbers sort true;

DEBUG_1("Found numbers: %1", _usedNumbers);

// TODO: Adjust min-maxes
DEBUG_1("_wildcardsSize=%1", _wildcardsSize);
private _leadingNumberMod = count _leadingNumber;
DEBUG_1("_leadingNumberModifier=%1", _leadingNumberMod);
DEBUG_3("Case: %1 (_size=%2, _numOfLeading=%3)", _wildcardsSize + _leadingNumberMod, _wildcardsSize, count _leadingNumber);

// 1 ## = 2 + 1 =3
// 10 # = 1 + 2 = 3
// 100 * (1)

private _leadingNumberSize = count _leadingNumber;
(switch (_wildcardsSize + _leadingNumberSize) do {
    case 3: { NUMERIC_RANGES_3 };
    case 2: { NUMERIC_RANGES_2 };
    case 1: { NUMERIC_RANGES_1 };
}) params ["_base", "_othersMax", "_totalMax"];

if (_leadingNumber != "") then {
    _base = (parseNumber _leadingNumber) * _base / 10^(_leadingNumberSize-1);

    // _base = (parseNumber (_leadingNumber select [0]) * _base;
    DEBUG_1("Modify _base with leading number: %1", _base);
};

DEBUG_2("(phoneticAbs_getNextNumeric) Suggestion params: _base=%1, _totalMax=%2", _base, _totalMax);

private _suggestion = _base;
DEBUG_1("(phoneticAbs_getNextNumeric) Search for suggestion. First: %1", _suggestion);

while {
    DEBUG_1("(phoneticAbs_getNextNumeric)Check that suggested is occupied: %1", _suggestion in _usedNumbers);
    _suggestion in _usedNumbers && _suggestion <= _totalMax
} do {
    private _other = _suggestion % _base;
    DEBUG_1("(phoneticAbs_getNextNumeric) _other = %1", _other);
    if (_other == _othersMax) then {
        _suggestion = _suggestion - _othersMax + _base - 1;
        DEBUG_1("(phoneticAbs_getNextNumeric) Jump to next step = %1", _suggestion);
    };
    _suggestion = _suggestion + 1;
    DEBUG_1("(phoneticAbs_getNextNumeric) New suggestion = %1", _suggestion);
};
if (_suggestion > _totalMax) exitWith {
    DEBUG_1("(phoneticAbs_getNextNumeric) Suggestion = %1 is out of allowed range", _suggestion);
    nil
};

DEBUG_1("(phoneticAbs_getNextNumeric) Resulting suggestion = %1", _suggestion);
_suggestion
