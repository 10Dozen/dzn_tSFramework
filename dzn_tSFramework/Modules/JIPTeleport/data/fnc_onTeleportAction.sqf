#include "script_component.hpp"

/*
    Teleport player to group leader if exists and alive.
    If leader is in the vehicle - allows teleport only if there is empty
    seat present.

    (_self)

    Params:
        none
    Returns:
        nothing
*/

private _leader = leader group player;
if (_leader == player) exitWith {
    // For some reason player become the only one in his group -
    //  e.g. player's leader is dead or something
    systemChat SETTING(_self,MessageNoLeader);
    _self call [F(removeTeleportAction)];
};

// --- Leader is in the vehicle - try to get empty seat, otherwise - cancel teleport
if (vehicle _leader != _leader) exitWith {
    private _vehicleLeader = vehicle _leader;
    private _vehicleSeats = fullCrew [_vehicleLeader, "", true];

    // --- Skip occupied and FFV (even if not occupied, it's related cargo seat may be)
    private _firstEmptyIdx = _vehicleSeats findIf {
        _x params ["_unit", "_seat", "", "_turretPath"];
        isNull _unit && (_seat != "turret" || (_seat == "turret" && count _turretPath < 2))
    };

    // --- When no seats avaialble - show message to wait until some seats appears
    if (_firstEmptyIdx == -1) exitWith {
        hint parseText format [
            HINT_TEMPLATE,
            SETTING(_self,MessageNoVehicleSeat)
        ];
    };

    moveOut player;
    player moveInAny _vehicleLeader;
    _self call [F(removeTeleportAction)];
};

// --- Leader exists, alive and on foot
private _pos = _leader modelToWorldVisual POSITION_RELATIVE_TO_LEADER;

// Safe teleport to new location,
// makes player immortal for few seconds in case weird terrain/interior clippings
player allowDamage false;
moveOut player;
[{
    params ["_pos"];
    player setPosATL _pos;

    [{ player allowDamage true; }, nil, 2] call CBA_fnc_waitAndExecute;
}, [_pos]] call CBA_fnc_execNextFrame;

_self call [F(removeTeleportAction)];
