#include "script_component.hpp"

/*
    Turns vehicle's headlights and collision light in cycle:
     - OFF / OFF 
     - OFF / ON (collision only)
     - ON / ON

    (_self)

    Params:
        _vehicle (OBJECT) - target vehicle.
    Returns:
        none

    _self call ["fnc_lightAction", [_vehicle]];
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

[_vehicle, "LIGHTS"] remoteExec ["disableAI", _vehicle]; 
[_vehicle, _headlight] remoteExec ["setPilotLight", _vehicle];
[_vehicle, _collision] remoteExec ["setCollisionLight", _vehicle];

hintSilent parseText format [
    Q(CREW_OPTIONS_HINT_LIGHTS),
    ["Выкл.", "Вкл."] select _collision,
    ["Выкл.", "Вкл."] select _headlight
];