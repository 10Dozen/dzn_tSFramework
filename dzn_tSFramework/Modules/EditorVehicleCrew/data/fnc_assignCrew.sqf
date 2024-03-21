#include "script_component.hpp"

/*
    Scans mission GameLogic objects with EVC proprty, then picks all synced vehicles
    and creates crew for it

    Params:
        none
    Returns:
        Array of Numbers:
        0: _gameLogicsProcessed -- total count of game logics processed;
        1: _assignmentsDone -- count of vehicles successful assignemnts.

    _statistics = _self call ["processLogics"]
*/

/*
    Assigns crew to given vehicle using given configuration

    Params:
    0: _veh - (object) vehicle to process
    1: _config - (string) config to apply

    Return:
    nothing

    Example:
    [_veh, "OPFOR GNR"] spawn tSF_fnc_EVC_assignCrew
    // creates OPFOR GNR" crew (gunner with default settings)
*/

params["_veh", "_config"];

#define GetValue(NAME) (_config get QUOTE(NAME))
#define GetValueOrDefault(NAME) (_config getOrDefault [QUOTE(NAME), _config get QUOTE(use) get QUOTE(NAME)])

private _roles = GetValue(roles);
private _side = GetValueOrDefault(side);
private _crewClass = GetValueOrDefault(crewClass);
private _crewKit = GetValueOrDefault(crewKit);
private _vehicleKit = GetValueOrDefault(vehicleKit);
private _behavior = GetValueOrDefault(behavior);
private _skill = GetValueOrDefault(skill);

if (!isNil "_crewClass" && { _crewClass isEqualTo "" }) then {
    _crewClass = nil;
};

if ((_crewKit isNotEqualTo "" || _vehicleKit isNotEqualTo "") && !DZN_GEAR_RUNNING) exitWith {
    [
        { DZN_GEAR_RUNNING },
        {
             params ["_cob", "_args"];
             _cob call [cob_FUNC(assignCrew), _args];
        },
        [_self, _this]
    ] call CBA_fnc_waitUntilAndExecute;
    true
};

private _generalSkill = _skill getOrDefault [Q(general), -1];
if (count _skill == 1 && _generalSkill >= 0) then {
    _skill = _generalSkill;
};

private _crew = [_veh, _side, _roles, _crewKit, _skill, _crewClass] call dzn_fnc_createVehicleCrew;

if (units _crew findIf {isNull objectParent _x} > -1) then {
    TSF_ERROR_4(TSF_ERROR_TYPE__MISCONFIGURED, "Crew does not fit vehicle %1. Config '%2' with %3 roles used - but actual mounted crew number is %4.", typeof _veh, _configName, _roles, count crew _veh);
};

if (_behavior isEqualTo "") exitWith {}; // No behaviour assigned

private _behaviourParams = [
    _veh,
    switch (toLower(_behavior)) do {
        case "hold": { "vehicle hold" };
        case "frontal": { "vehicle 45 hold" };
        case "full frontal": { "vehicle 90 hold" };
    }
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
