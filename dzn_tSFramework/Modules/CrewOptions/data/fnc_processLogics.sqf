#include "script_component.hpp"

/*
    Scans mission GameLogic objects with component's property, then picks all synced vehicles
    and sets actions for them.

    (_self)

    Params:
        none
    Returns:
        none

    _statistics = _self call ["processLogics"]
*/

private _configs = SETTING(_self,Configs);

private ["_logic", "_logicConfigName", "_logicConfig", "_assignmentResult"];
private _vehiclesToHandle = createHashMap;
{
    _logic = _x;
    _logicConfigName = _logic getVariable [GAMELOGIC_FLAG, ""];
    if (_logicConfigName == "") then { continue; };

    if !(_logicConfigName in _configs) then {
        TSF_ERROR_1(TSF_ERROR_TYPE__NO_CONFIG, "Не найден конфиг '%1'", _logicConfigName);
        continue;
    };

    _vehicles = synchronizedObjects _logic;
    if (_vehicles isEqualTo []) then {
        TSF_ERROR_1(TSF_ERROR_TYPE__MISSING_ENTITY, "Не найдено объектов синхронизированных с GameLogic '%1', чтобы назначить конфиг", _logic);
        continue;
    };

    _vehiclesInMap = _vehiclesToHandle getOrDefaultCall [_logicConfigName, [], true];
    _vehiclesInMap append _vehicles;
} forEach (entities "Logic");


ECOB(Core) call [
    F(remoteExecComponent),
    [
        Q(COMPONENT),
        F(assignActions),
        [_vehiclesInMap],
        0
    ]
];