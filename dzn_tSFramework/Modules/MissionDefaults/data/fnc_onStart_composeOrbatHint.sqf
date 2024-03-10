#include "script_component.hpp"

/*
    (_self)
    Compose unit's group ORBAT into a number of stylized lines for hint.
*/

#define LEADER_ROLE_LINE "<t align='left' color='#FFE240'>%1</t><br/><t align='right'>%2</t>"
#define ROLE_LINE "<t align='left' color='#e3e3e3'>%1</t><br/><t align='right'>%2</t>"
#define HIGHLIGHT_ROLE_LINE "<t align='left' color='#a1d5ff'>%1</t><br/><t align='right' color='#f0f8ff'>%2</t>"

params ["_leaderInfo", "_orbatInfo"];

_leaderInfo params ["_leaderRole", "", "_leaderName", "_isCurrentPlayer"];
private _lines = [
    "ORBAT",
    format [LEADER_ROLE_LINE, _leaderRole, _leaderName],
    ""
];

{
    _x params ["_roleName", "", "_name", "_isCurrentPlayer"];

    _lines pushBack format [
         [ROLE_LINE, HIGHLIGHT_ROLE_LINE] select _isCurrentPlayer,
        _roleName,
        _name
    ];
} forEach _orbatInfo;

_lines
