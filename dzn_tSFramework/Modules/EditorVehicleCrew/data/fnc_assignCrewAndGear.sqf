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

if (_crewClass isEqualTo "") then {
    _crewClass = nil;
};

if (_vehicleKit isNotEqualTo "") then {
    [_veh, _vehicleKit, true] call dzn_fnc_gear_assignKit;
};

// Read/update DynAI skill with mission params and apply adjusted values to crew
[] call dzn_fnc_dynai_getSkillFromParameters;
dzn_dynai_complexSkill params ["_isComplexSkill", "_dynaiSkill"];
private ["_adjustedSkill"];
if (_isComplexSkill) then {
    _adjustedSkill = [];
    {
        _x params ["_skillName", "_skillLevel"];
        if (_skillName in ["general", "aimingSpeed", "aimingAccuracy"]) then {
            _skillLevel = (_skillLevel * _skill) min 1;
        };
        _adjustedSkill pushBack [_skillName, _skillLevel];
    } forEach _dynaiSkill;
} else {
    _adjustedSkill = (_dynaiSkill * _skill) min 1;
};

private _crew = [_veh, _side, _roles, _crewKit, _adjustedSkill, _crewClass] call dzn_fnc_createVehicleCrew;

if (units _crew findIf {isNull objectParent _x} > -1) then {
    TSF_ERROR_4(TSF_ERROR_TYPE__MISCONFIGURED, "Crew does not fit vehicle %1. Config '%2' with %3 roles used - but actual mounted crew number is %4.", typeof _veh, _configName, _roles, count crew _veh);
};

// All below is about dzn_dynai behaviour
if (_behavior isEqualTo "") exitWith {};

private _behaviourParams = [
    _veh,
    _self get Q(VehicleBehaviorMap) get toLower(_behavior)
];
_behaviourParams call dzn_fnc_dynai_addUnitBehavior;
true
