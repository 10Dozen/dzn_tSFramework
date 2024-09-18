#include "script_component.hpp"

/*
    Turns vehicle's engine off.

    (_self)

    Params:
        _vehicle (OBJECT) - target vehicle.
    Returns:
        none

    _self call ["fnc_engineAction", [_vehicle]];
*/

params ["_vehicle"];

doStop (driver _vehicle);
[_vehicle, false] remoteExec ["engineOn", 0];