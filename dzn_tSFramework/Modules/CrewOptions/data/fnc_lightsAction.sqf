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

private _headlight = isLightOn _vehicle;
private _collision = isCollisionLightOn _vehicle;

if (!_headlight && !_collision) then {
    // Headlights OFF, Collision OFF - turn on Collision lights only
    _headlight = false;
    _collision = true;
} else {
    if (!_headlight && _collision) then {
        // Headlights OFF, Collision ON - turn on both lights 
        _headlight = true;
        _collision = true;
    } else {
        // Headlights ON, Collision ON - turn off both lights
        _headlight = false;
        _collision = false;
    };
};

[_vehicle, _headlight] remoteExec ["setPilotLight", _vehicle];
[_vehicle, _collision] remoteExec ["setCollisionLight", _vehicle];