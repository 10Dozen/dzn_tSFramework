#include "script_component.hpp"

/*
    Return isolation coeficient of vehicle. Higher value means better hearable.
    Affected by: TFAR's isolation config property, engine state, type of vehicle and
    position of the playr (for tanks - turned in or out)
    (_self)

    Params:
    _unit - (object) crew unit.
    _veh - (object) vehicle to check.

    Return:
    _isolationCoef - (number) coef in 0...1 range.
*/

params ["_unit", "_veh"];

private _vehicleIsolationCoef = _veh getVariable QGVAR(isolatedCoef);
if (isNil "_vehicleIsolationCoef") then {
    _vehicleIsolationCoef = 1 - ([typeOf _veh, "tf_isolatedAmount", 0.3] call TFAR_fnc_getConfigProperty);
    _veh setVariable [QGVAR(isolatedCoef), _vehicleIsolationCoef];
};
_vehicleIsolationCoef = [_vehicleIsolationCoef, 1] select (isTurnedOut _unit);

private _heavyEngineCoef = [1, 0.3] select (_veh isKindOf "Tank" || _veh isKindOf "Plane" || _veh isKindOf "Helicopter");
private _engineCoef = [1, 0.7 * _heavyEngineCoef] select (isEngineOn _veh);

(_vehicleIsolationCoef * _engineCoef)
