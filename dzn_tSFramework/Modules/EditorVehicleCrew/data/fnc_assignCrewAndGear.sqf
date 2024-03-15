#include "script_component.hpp"

/*
    Assigns crew to given vehicle using given configuration

    (_self)

    Params:
        0: _veh - (object) vehicle to process
        1: _config - (string) config to apply
    Returns:
        _result - true if crew was assigned.
*/

params["_veh", "_config"];

#define Value(NAME) (_config get QUOTE(NAME))
#define ValueOrDefault(NAME) (_config getOrDefault [QUOTE(NAME), SETTING_2(_self,Defaults,NAME)])

private _roles = Value(roles);
private _side = ValueOrDefault(side);
private _crewClass = ValueOrDefault(crewClass);
private _crewKit = ValueOrDefault(crewKit);
private _vehicleKit = ValueOrDefault(vehicleKit);
private _behavior = ValueOrDefault(behavior);
private _skill = ValueOrDefault(skill);


// If dzn_gear is needed, but is not running at the moment -
// schedule execution after dzn_gear init done
if ((_crewKit isNotEqualTo "" || _vehicleKit isNotEqualTo "") && !DZN_GEAR_RUNNING) exitWith {
    [
        { DZN_GEAR_RUNNING },
        {
            params ["_cob", "_args"];
            _cob call [F(assignCrew), _args];
        },
        [_self, _this]
    ] call CBA_fnc_waitUntilAndExecute;
    true
};

[_veh, _vehicleKit, true] call dzn_fnc_gear_assignKit;

if (_crewClass isEqualTo "") then {
    _crewClass = nil;
};

private _crew = [_veh, _side, _roles, _crewKit, _skill, _crewClass] call dzn_fnc_createVehicleCrew;


if (units _crew findIf {isNull objectParent _x} > -1) then {
    TSF_ERROR_4(TSF_ERROR_TYPE__MISCONFIGURED, "Crew does not fit vehicle %1. Config '%2' with %3 roles used - but actual mounted crew number is %4.", typeof _veh, _configName, _roles, count crew _veh);
};

// All below is about dzn_dynai behaviour
if (_behavior isEqualTo "") exitWith {};

private _behaviourParams = [
    _veh,
    _self get Q(VehicleBehaviorMap) get toLower(_behavior)
];

if (!DZN_DYNAI_RUNNING_SERVER_SIDE && isNil "dzn_fnc_dynai_addUnitBehavior") exitWith {
    [
        { DZN_DYNAI_RUNNING_SERVER_SIDE && !isNil "dzn_fnc_dynai_addUnitBehavior"},
        { _this call dzn_fnc_dynai_addUnitBehavior; },
        _behaviourParams
    ] call CBA_fnc_waitUntilAndExecute;
    true
};

_behaviourParams call dzn_fnc_dynai_addUnitBehavior;
true
