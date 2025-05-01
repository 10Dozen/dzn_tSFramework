#include "script_component.hpp"

/*
    Scans mission GameLogic objects with ERS property, then picks all synced vehicles
    and sets up radio for it.

    (_self)

    Params:
        none
    Returns:
        none

    _statistics = _self call ["processLogics"]
*/

private _configs = SETTING(_self,Configs);

private ["_logic", "_logicConfigName", "_logicConfig", "_assignmentResult"];

{
    _logic = _x;
    _logicConfigName = _logic getVariable [GAMELOGIC_FLAG, ""];

    if (_logicConfigName == "") then { continue; };

    _vehicles = synchronizedObjects _logic;
    _logicConfig = _configs get _logicConfigName;

    if (isNil "_logicConfig") then {
        TSF_ERROR_1(TSF_ERROR_TYPE__NO_CONFIG, "Failed to find config '%1'", _logicConfigName);
        continue;
    };

    if (_vehicles isEqualTo []) then {
        TSF_ERROR_1(TSF_ERROR_TYPE__MISSING_ENTITY, "Failed to find any synchronized objects for ERS GameLogic '%1'", _logic);
        continue;
    };

    {
        _self call [F(assignRadio), [_x, _logicConfig]];
    } forEach _vehicles;
} forEach (entities "Logic");
