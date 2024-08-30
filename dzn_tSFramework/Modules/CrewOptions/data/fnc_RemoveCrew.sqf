#include "script_component.hpp"

/*
    Removes AI crew from the seat of the vehicle and deletes unit.
    Do not remove players.

    (_self)

    Params:
        _vehicle (OBJECT) - vehicle to check against.
        _seatCfg (HASHMAP) - seat configuration
    Returns:
        none

    _self call ["fnc_removeCrew", [_vehicle, _seat]];
*/

params ["_vehicle", "_seatCfg"];

private _unit = _self call [F(getUnitOnSeat), [_vehicle, _seatCfg get Q(seat)]];

if (isNull _unit || { isPlayer _unit }) exitWith {};

moveOut _unit;
deleteVehicle _unit;

hintSilent parseText format [
    Q(CREW_OPTIONS_HINT_MEMBER_REMOVED),
    _seatCfg get Q(name)
];