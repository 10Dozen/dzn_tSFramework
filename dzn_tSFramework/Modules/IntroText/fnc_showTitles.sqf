#include "script_component.hpp"

/*
    Displays (types) intro text lines
    in selected style.

    Params:
        none
    Returns:
        nothing
*/

params [
    ["_dateTitle", nil],
    ["_locTitle", nil],
    ["_opTitle", nil],
    ["_spawnLocationTitle", nil]
];

private _linesAndStyles = [];

if (!isNil "_dateTitle") then {
    // User defined date, show as is
    if (_dateTitle != DATE_TITLE_DEFAULT) exitWith {
        _linesAndStyles pushBack [_dateTitle, SETTING_2(_self,Templates,date)];
    };

    date params ["_year", "_month", "_day", "_hours", "_minutes"];
    _dateTitle = format [
        _dateTitle,
        [_hours + _minutes/60, "HH:MM"] call BIS_fnc_timeToString,
        STR_DATE(_day),
        STR_DATE(_month),
        _year
    ];

    _linesAndStyles pushBack [_dateTitle, SETTING_2(_self,Templates,date)];
};

if (!isNil "_locTitle" && { _locTitle != LOCATION_TITLE_DEFAULT }) then {
    _linesAndStyles pushBack [
        _locTitle,
        SETTING_2(_self,Templates,location)
    ];
};

if (!isNil "_spawnLocationTitle" && { _spawnLocationTitle != "" }) then {
    _linesAndStyles pushBack [
        _spawnLocationTitle,
        SETTING_2(_self,Templates,spawnLocation)
    ];
};

if (!isNil "_opTitle" && { _opTitle != OPERATION_TITLE_DEFAULT }) then {
    _linesAndStyles pushBack [
        _opTitle,
        SETTING_2(_self,Templates,operation)
    ];
};

// No lines defined - skip
if (_linesAndStyles isEqualTo []) exitWith {};

// Add timeout for last line
(_linesAndStyles select -1) pushBack (
    CURSOR_CLICK_PER_SECOND * SETTING_2(_self,General,displayTime)
);

SETTING_2(_self,General,position) params ["_posX", "_posY"];
[_linesAndStyles, _posX, _posY] spawn BIS_fnc_typeText;
