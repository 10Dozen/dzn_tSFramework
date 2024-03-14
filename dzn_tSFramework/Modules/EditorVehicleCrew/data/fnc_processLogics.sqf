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

private _logicsCount = 0;
private _assignmentsCount = 0;
private _configs = _self get Q(Configs);

private ["_logic", "_logicConfigName", "_logicConfig", "_assignmentResult"];

{
    _logic = _x;
    _logicConfigName = _logic getVariable [EVC_GAMELOGIG_FLAG, ""];
    if (_logicConfigName == "") then { continue; };

    _logicsCount = _logicsCount + 1;

    _vehicles = synchronizedObjects _logic;
    _logicConfig = _configs get _logicConfigName;
    if (isNil "_logicConfig") then {
        TSF_ERROR_1(TSF_ERROR_TYPE__NO_CONFIG, "Failed to find config '%1'", _logicConfigName);
        continue;
    };
    if (_vehicles isEqualTo []) then {
        TSF_ERROR_1(TSF_ERROR_TYPE__NO_CONFIG, "Failed to find any synchronized objects for EVC GameLogic '%1'", _logic);
        continue;
    };

    {
        _assignmentResult = _self call [cob_FUNC(assignCrew) ,[_x, _logicConfig]];
        _assignmentsCount = _assignmentsCount + ([0,1] select _assignmentResult);
    } forEach _vehicles;
} forEach (entities "Logic");

[_logicsCount, _assignmentsCount]
