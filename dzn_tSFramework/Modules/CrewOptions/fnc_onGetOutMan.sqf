#include "script_component.hpp"


/*
    Handles Getting out from vehicle.
    Halts AI crew of vehicle to prevent it from driving around to keep formation.

    (_self)

    Params:
        _vehicle (OBJECT) - vehicle to check against
    Returns:
        none

    _self call ["fnc_actionCondition", [_vehicle]];
*/

params ["_unit", "_role", "_vehicle", "_turret", "_isEject"]; 

private _aiCrew = (crew _vehicle) select { !isPlayer _x };

{
    DEBUG_1("(onGetOutMan) Stop unit %1", _x);
    doStop _x;
} forEach _aiCrew;
