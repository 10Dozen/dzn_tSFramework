#include "script_component.hpp"

/*
	Displays (types) intro text lines
	in selected style.

	Params:
		none
	Returns:
		nothing
*/

private _linesAndStyles = [];

private _dateTitle = SETTING(_self,Date);
private _locTitle = SETTING(_self,Location);
private _opTitle = SETTING(_self,Operation);

if (_dateTitle != "") then {
    if (_dateTitle != DATE_TITLE_DEFAULT) exitWith {
        // User defined date, show as is
        _linesAndStyles pushBack [_dateTitle, SETTING_2(_self,Templates,date)];
    };

    MissionDate params ["_year", "_month", "_day", "_hour", "_minutes"];
    _dateTitle = format [
        "%4 " + _dateTitle,
        STR_DATE(_day),
        STR_DATE(_month),
        _year,
        [_hours + _minutes/60, "HH:MM"] call BIS_fnc_timeToString
    ];

    _linesAndStyles pushBack [_dateTitle, SETTING_2(_self,Templates,date)];
};

if (_locTitle != "" && _locTitle != LOCATION_TITLE_DEFAULT) then {
    _linesAndStyles pushBack [
        _locTitle,
        SETTING_2(_self,Templates,location)
    ];
};

if (_opTitle != "" && _opTitle != OPERATION_TITLE_DEFAULT) then {
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
