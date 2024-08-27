#include "script_component.hpp"


/*   TBD
    Assigns actions to given vehicle, based on given radio config. If some config
    values are missing - settings from Defaults section will be used instead.

    (_self)

    Params:
        _vehiclesMap (HASHMAP) - map of configs vs vehicles assigned with it.
    Returns:
        none

    _self call ["fnc_assignActions", [_vehiclesMap]];
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
    LOG_1("There is no valid function to define unit of the seat '%1'", _seat);
    objNull
};

_seatFncParams call _seatFnc;