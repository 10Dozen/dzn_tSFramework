#include "script_component.hpp"

/*
    TBD

    (_self)

    Params:
        _vehiclesMap (HASHMAP) - map of configs vs vehicles assigned with it.
    Returns:
        none

    _self call ["fnc_assignActions", [_vehiclesMap]];
*/

params ["_vehicle"];

doStop (driver _vehicle);
[_vehicle, false] remoteExec ["engineOn", _vehicle];