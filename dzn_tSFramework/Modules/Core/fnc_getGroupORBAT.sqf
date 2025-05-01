#include "script_component.hpp"

/*
    Scans other units in group, get it's roles and ranks. Then sorts in order:
      - by role name
      - by rank inside specific role name prefixes (like BLUE, RED)

    (_self)

    Params:
        0: _unit (OBJECT) - unit to check it's group.
        1: _collectGear (BOOL) - optional flag to collect brief gear info - main weapon, launcher weapon,
        long range radio and short range radio. Defaults to false

    Return:
        ARRAY:
        0: _groupName (STRING) - name of the group;
        1: _groupSize (NUMBER) - number of units in group;
        2: _leaderInfo (ARRAY) - squad leader info in foramt:
            [@RoleName(STRING), @Rank(NUMBER), @PlayerName(STRING), @IsPlayer(BOOL), @GearInfo(ARRAY)]
        3: _membersInfo (ARRAY) - ordered list of element in the same format.
*/

params ["_unit", ["_collectGear", false]];

private _getRoleParts = {
    private ["_rolename", "_roleId"];
    private _roleDescription = roleDescription _this;
    if (_roleDescription isNotEqualTo "") then {
        private _roleParts = _roleDescription splitString "@";
        _rolename = _roleParts # 0;
        _roleId = _roleParts # (count _roleParts - 1);
    } else {
        _rolename = getText(configFile >> "CfgVehicles" >> typeof vehicle _this >> "displayName");
        _roleId = 0;
    };

    [_rolename, _roleId]
};

private _grp = group _unit;
private _count  = count units _grp;

private _leader = leader _grp;

((_leader) call _getRoleParts) params ["_roleName", "_roleId"];
private _leaderInfo = [
    _roleId,
    _roleName,
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

    (_x call _getRoleParts) params ["_roleName", "_roleId"];
    _member = [
        _roleId,
        _roleName,
        name _x,
        _x
    ];
    if (_collectGear) then {
        _member pushBack (_self call [F(getUnitGearInfo), [_x]]);
    };

    _membersInfo pushBack _member;
} forEach _members;

// Sort by roleID
_members sort true;

[groupId _grp, _count, _leaderInfo, _membersInfo]
