#include "script_component.hpp"

/*
    Scans other units in group, get it's roles and ranks. Then sorts in order:
      - by role name
      - by rank inside specific role name prefixes (like BLUE, RED)

    (_self)

    Params:
        0: _unit (OBJECT) - unit to check it's group.
        1: _rolePrefixesSortOrder (ARRAY) - optional, specified role name prefix to group (e.g. fireteam names). Defaults to ["RED", "BLUE"]
        2: _collectGear (BOOL) - optional flag to collect brief gear info - main weapon, launcher weapon,
        long range radio and short range radio. Defaults to false

    Return:
        ARRAY:
        0: _groupName (STRING) - name of the group;
        1: _groupSize (NUMBER) - number of units in group;
        2: _leaderInfo (ARRAY) - squad leader info in foramt:
            [@RoleName(STRING), @Rank(NUMBER), @PlayerName(STRING), @IsPlayer(BOOL), @GearInfo(ARRAY)]
        3: _membersInfo (ARRAY) - ordered list of element in the same format.
*/


params ["_unit", ["_rolePrefixesSortOrder", DEFAULT_ORBAT_ORDERING], ["_collectGear", false]];

private _grp = group _unit;
private _count  = count units _grp;

private _leader = leader _grp;
private _leaderInfo = [
    ((roleDescription _leader) splitString "@") # 0,
    name _leader,
    _leader
];
if (_collectGear) then {
    _leaderInfo pushBack (_self call [F(getUnitGearInfo), [_leader]]);
};

private _members = playableUnits select { group _x == _grp && _x != _leader };
private _membersInfo = [];
private ["_member"];
{
    if (_x == _leader) then { continue; };

    _member = [
        roleDescription _x,
        name _x,
        _x
     ];
     if (_collectGear) then {
         _member pushBack (_self call [F(getUnitGearInfo), [_x]]);
     };

    _membersInfo pushBack _member;
} forEach _members;

/*
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
*/

[groupId _grp, _count, _leaderInfo, _membersInfo]
