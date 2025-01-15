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

params["_veh", "_config", "_configName"];
DEBUG_1("[assignCrewAndGear] Params: %1", _this);

#define Value(NAME) (_config get QUOTE(NAME))
#define ValueOrDefault(NAME) (_config getOrDefault [QUOTE(NAME), SETTING_2(_self,Defaults,NAME)])

private _roles = Value(roles);
private _side = ValueOrDefault(side);
private _crewClass = ValueOrDefault(crewClass);
private _crewKit = ValueOrDefault(crewKit);
private _vehicleKit = ValueOrDefault(vehicleKit);
private _behavior = ValueOrDefault(behavior);
private _skill = ValueOrDefault(skill);

if (_vehicleKit isNotEqualTo "") then {
    [_veh, _vehicleKit, true] call dzn_fnc_gear_assignKit;
};

private _crew = [_veh, _side, _roles, _crewKit, 1, _crewClass] call dzn_fnc_createVehicleCrew;

// -- Adjust skill according to config
{
    [_x, _skill] call dzn_fnc_dynai_applySkillLevels;
} forEach (units _crew);



if (units _crew findIf {isNull objectParent _x} > -1) then {
    TSF_ERROR_4(TSF_ERROR_TYPE__MISCONFIGURED, "Экипаж не поместился в машину %1. Применен конфиг '%2', роли %3, но в машине сейчас %4 человек экипажа", typeof _veh, _configName, _roles, count crew _veh);
};

// All below is about dzn_dynai behaviour
if (_behavior isEqualTo "") exitWith {};

private _behaviourParams = [
    _veh,
    _self get Q(VehicleBehaviorMap) get toLower(_behavior)
];

_behaviourParams call dzn_fnc_dynai_addUnitBehavior;

true
