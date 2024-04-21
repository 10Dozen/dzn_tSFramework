#include "script_component.hpp"

/*
    Composes roster info for given unit.
    (_self)

    Params:
        0: _roleName (STRING)
        1: _rank (NUMBER)
        2: _name (STRING)
        3: _unit (OBJECT)
        4: _gear (ARRAY)
    Returns:
        nothing
*/

params ["_roleName", "_name", "_unit", "_gear"];

DEBUG_1("(formatUnitRosterLine) Params: %1", _this);

private _isMyGroup = _unit == player;
if (_isMyGroup) then {
    _roleName = format ["*%1", _roleName];
};

private _gearLines = ["?"];
if (_gear isNotEqualTo []) then {
    _gear params ["_primaryWeapon", "_secondaryWeapon", "_lrRadio", "_swRadio"];
    _gearLines = [];

    // PW + SW or PW or SW
    if (_primaryWeapon isNotEqualTo "" && _secondaryWeapon isNotEqualTo "") then {
        _gearLines pushBack format ["%1 + %2", _primaryWeapon, _secondaryWeapon];
    } else {
        if (_primaryWeapon isNotEqualTo "") then {
            _gearLines pushBack _primaryWeapon;
        } else {
            _gearLines pushBack _secondaryWeapon;
        };
    };

    if (_lrRadio) then {
        _gearLines pushBack LR_RADIO_TAG;
    };

    if (_swRadio) then {
        _gearLines pushBack SW_RADIO_TAG;
    };
};

private _data = format [
    "%1<br/>%2%3",
    format [ROLE_WRAPPER, _roleName],
    format [NAME_WRAPPER, _name],
    format [GEAR_WRAPPER, _gearLines joinString ""]
];

DEBUG_2("(formatUnitRosterLine) Data: %1 | Is My group: %2", _data, _isMyGroup);

[_data, _isMyGroup]
