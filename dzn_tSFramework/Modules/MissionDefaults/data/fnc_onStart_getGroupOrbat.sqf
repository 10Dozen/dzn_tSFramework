#include "script_component.hpp"

/*
    Scans other units in group, get it's roles and ranks. Then sorts in order:
      - by role name
      - by rank inside specific role name prefixes (like BLUE, RED)

    Params:
        0: _unit (OBJECT) - unit to check it's group.
        1: _rolePrefixesSortOrder (ARRAY) - specified role name prefix to group (e.g. fireteam names).

    Return:
        _leaderInfo (ARRAY) - squad leader info in foramt:
            [@RoleName(STRING), @Rank(NUMBER), @PlayerName(STRING), @IsPlayer(BOOL)]
        _orbatInfo (ARRAY) - ordered list of element in the same foramt.
*/

#define STARTS_WITH(STR,SUBSTR) (STR select [0, count SUBSTR] == SUBSTR)
DEBUG_1("[onStart_getGroupOrbat] Params: %1", _this);
params ["_unit", "_rolePrefixesSortOrder"];

private _grp = group _unit;
private _leader = leader _grp;
private _orbatInfo = [];

private _leaderInfo = [
    roleDescription _leader, rankId _leader,
    name _leader, _leader == _unit
];

{
    if (_x == _leader) then { continue; };
    _orbatInfo pushBack [
        roleDescription _x, rankId _x,
        name _x, _x == _player
    ];
} forEach (units _grp);

// Sorts by role name
_orbatInfo = [_orbatInfo, [], { _x # 0 }] call BIS_fnc_sortBy;

// Sort by rank inside prefixes-groups
{
    _orbatInfo = [
        _orbatInfo, [_x],
        {
            if (STARTS_WITH(_x # 0, _input0)) exitWith { _x # 1 };
            (_x # 1) + 99 // other lines make on top in output
        }, "DESCEND"
    ] call BIS_fnc_sortBy;
} forEach _rolePrefixesSortOrder;

DEBUG_2("[onStart_getGroupOrbat] Result: _leaderInfo=%1, _orbatInfo=%2", _leaderInfo, _orbatInfo);
[_leaderInfo, _orbatInfo]
