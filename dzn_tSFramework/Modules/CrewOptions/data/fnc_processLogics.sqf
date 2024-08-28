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

    
    diag_log format ["_logicConfigName = %1", _logicConfigName];
    private _f = _logicConfigName in _configs;
    diag_log format ["In configs? = %1", _f];
    if !(_logicConfigName in _configs) then {
        TSF_ERROR_1(TSF_ERROR_TYPE__NO_CONFIG, "Не найден конфиг '%1'", _logicConfigName);
        
        diag_log "Going to Continue...";
        continue;
    };
    diag_log "Processing vehicles...";

    _vehicles = synchronizedObjects _logic;
    if (_vehicles isEqualTo []) then {
        TSF_ERROR_1(TSF_ERROR_TYPE__MISSING_ENTITY, "Не найдено объектов синхронизированных с GameLogic '%1', чтобы назначить конфиг", _logic);
        continue;
    };
    diag_log "Mapping vehicles...";

    _vehiclesInMap = _vehiclesToHandle getOrDefaultCall [_logicConfigName, { [] }, true];
    _vehiclesInMap append _vehicles;
} forEach (entities "Logic");

MyMAP = _vehiclesToHandle;

ECOB(Core) call [
    F(remoteExecComponent),
    [
        Q(COMPONENT),
        F(assignActions),
        [_vehiclesToHandle],
        0,
        true
    ]
];