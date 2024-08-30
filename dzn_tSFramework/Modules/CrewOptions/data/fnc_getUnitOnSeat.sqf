#include "script_component.hpp"


/*
    Returns unit at given seat of the vehicle.

    (_self)

    Params:
        _vehicle (OBJECT) - target vehicle.
        _seat (STRING or ARRAY) - seat identifier (e.g. 'driver' or [0,0] turret path)
    Returns:
        _unit (OBJECT) - unit that occupies the seat, or objNull

    _unit = _self call ["fnc_getUnitOnSeat", [_vehicle, _seat]];
*/

params ["_vehicle", "_seat"];

private _seatFncName = _seat;
private _seatFncParams = _vehicle;
if (_seat isEqualType []) then {
    _seatFncName = "turret";
    _seatFncParams = [_vehicle, _seat];
};
private _seatFnc = _self get Q(GetSeatUnitFunctions) get _seatFncName;

if (isNil "_seatFnc") exitWith {
    TSF_ERROR_1(TSF_ERROR_TYPE__INVALID_ARG, "There is no valid function to define unit of the seat '%1'", _seat);
    objNull
};

_seatFncParams call _seatFnc;