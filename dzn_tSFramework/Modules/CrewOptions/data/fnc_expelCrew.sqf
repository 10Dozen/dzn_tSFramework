#include "script_component.hpp"

/*
    Checks for AI crew units in player's group and if any - stop 'em and expel from players group

    (_self)

    Params:
        none
    Returns:
        none

    _self call ["fnc_expelCrew", []];
*/

private _ai = (_self get Q(AddedCrew)) select { !isNull _x && alive _x };

if (_ai isEqualTo []) exitWith {
    LOG_1("(expelCrew) No AI members",1);
};

private _expelExternalGroup = grpNull;
{
    private _aiUnit = _x;
    private _aiVehicle = vehicle _aiUnit; 
    
    // -- Check that AI not in vehicle OR in vehicle, but not under other player's command
    //    and stop AI from moving.
    if (_aiUnit isEqualTo _aiVehicle || { !isPlayer (effectiveCommander _aiVehicle) }) then {
        LOG_1("(expelCrew) Stopping unit out of vehicle / not under other player command",1);
        doStop _aiUnit;
    };

    // -- Expel to vehicle group OR to external group, if out of vehicle or some non-CrewOptioned vehicle
    private _grp = _aiVehicle getVariable [QGVAR(Group), grpNull];
    if (isNull _grp) then {
        LOG_1("(expelCrew) Group is not defined in vehicle / not in vehicle - assign to extrenal",1);
        if (isNull _expelExternalGroup) then {
            LOG_1("(expelCrew) Create external group",1);
            _expelExternalGroup = createGroup (side player);
        };
        _grp = _expelExternalGroup;
    };
    
    LOG_1("(expelCrew) Expel to new group",1);
    [_aiUnit] joinSilent _grp;
} forEach _ai;

if (isNull _expelExternalGroup) exitWith {};

// -- Pass external group to server
[_expelExternalGroup, 2] remoteExec ["setGroupOwner", 2];