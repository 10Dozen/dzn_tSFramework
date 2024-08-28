#include "script_component.hpp"

/*
    Removes AI crew from the seat of the vehicle and deletes unit. 
    Do not remove players.

    (_self)

    Params:
        _vehicle (OBJECT) - vehicle to check against.
        _seatName (STRING) - name of the seat
    Returns:
        none

    _self call ["fnc_removeCrew", [_vehicle, _seatName]];
*/

params ["_vehicle", "_seatName"];

private _unit = _self call [F(getUnitOfSeat), [_vehicle, _seatName]];

if (isNull _unit || { isPlayer _unit }) exitWith {};

moveOut _unit;
deleteVehicle _unit;
