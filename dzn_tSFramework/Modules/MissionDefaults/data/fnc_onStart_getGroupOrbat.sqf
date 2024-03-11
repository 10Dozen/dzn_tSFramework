#include "script_component.hpp"

/*
    Scans other units in group, get it's roles and ranks. Then sorts in order:
      - by role name
      - by rank inside specific role name prefixes (like BLUE, RED)

    (_self)

    Params:
        0: _unit (OBJECT) - unit to check it's group.
        1: _rolePrefixesSortOrder (ARRAY) - specified role name prefix to group (e.g. fireteam names).

    Return:
        _groupName (STRING) - name of the group;
        _leaderInfo (ARRAY) - squad leader info in foramt:
            [@RoleName(STRING), @Rank(NUMBER), @PlayerName(STRING), @IsPlayer(BOOL)]
        _membersInfo (ARRAY) - ordered list of element in the same foramt.
*/


DEBUG_1("[onStart_getGroupOrbat] Params: %1", _this);
params ["_unit", "_rolePrefixesSortOrder"];

private _grp = group _unit;
private _leader = leader _grp;
private _membersInfo = [];
private _leaderInfo = [
    roleDescription _leader, rankId _leader,
    name _leader, _leader == _unit
];

{
    if (_x == _leader) then { continue; };
    _membersInfo pushBack [
        roleDescription _x, rankId _x,
        name _x, _x == _player
    ];
} forEach (units _grp);

// Sorts by role name
_membersInfo = [_membersInfo, [], { _x # 0 }] call BIS_fnc_sortBy;

// Sort by rank inside prefixes-groups
{
    _membersInfo = [
        _membersInfo, [_x],
        {
            if (STARTS_WITH(_x # 0, _input0)) exitWith { _x # 1 };
            (_x # 1) + 99 // other lines make on top in output
        }, "DESCEND"
    ] call BIS_fnc_sortBy;
} forEach _rolePrefixesSortOrder;

DEBUG_3("[onStart_getGroupOrbat] Result: _grp=%1, _leaderInfo=%2, _membersInfo=%3", groupId _grp, _leaderInfo, _membersInfo);
[groupId _grp, _leaderInfo, _membersInfo]
