#include "script_component.hpp"

/*
    Composes group ORBAT info into a number of stylized lines for hint.

    (_self)

    Params:
        0: _groupName (STRING) - name of the group.
        1: _leaderInfo(ARRAY) - leader information, in format
                [rolename(STRING), rankId(NUMBER), name(STIRNG), isPlayer(BOOL)]
        2: _membersInfo(ARRAY of arrays) - members information in same format as leader

    Returns:
        _orbat (ARRAY) - prepared lines of orbat text.
*/

#define HINT_TITLE_TEMPLATE "<t size='1.2'>%1</t> (ORBAT)"
#define LEADER_ROLE_TEMPLATE "<t align='left' color='#FFE240'>%1</t><br/><t align='right'>%2</t>"
#define ROLE_TEMPLATE "<t align='left' color='#e3e3e3'>%1</t><br/><t align='right'>%2</t>"
#define HIGHLIGHT_ROLE_TEMPLATE "<t align='left' color='#a1d5ff'>%1</t><br/><t align='right' color='#f0f8ff'>%2</t>"

params ["_groupName", "_leaderInfo", "_membersInfo"];

_leaderInfo params ["_leaderRole", "", "_leaderName", "_isCurrentPlayer"];
private _lines = [
    format [HINT_TITLE_TEMPLATE, _groupName],
    format [LEADER_ROLE_TEMPLATE, _leaderRole, _leaderName],
    ""
];

{
    _x params ["_roleName", "", "_name", "_isCurrentPlayer"];

    _lines pushBack format [
         [ROLE_TEMPLATE, HIGHLIGHT_ROLE_TEMPLATE] select _isCurrentPlayer,
        _roleName,
        _name
    ];
} forEach _membersInfo;

_lines
