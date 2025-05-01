#include "script_component.hpp"

/*
    Finds GameLogics with FARP property and handle them.

    Params:
        none
    Returns:
        nothing
*/
params ["_logics", ["_validate", false]];

DEBUG_1("Params: %1", _this);
private _farps = [];

// Find positions of the GameLogic entities
private ["_logic", "_displayName", "_config", "_configName", "_composition", "_classes"];
{
    _logic = _x;
    _farp = createHashMapObject [_self get Q(FARPObjectDeclaration), []];

    // -- Basic attributes
    _farp set [Q(Logic), _logic];
    _farp set [Q(Name), _logic getVariable [GAMELOGIC_FARP_NAME, str(1 + count _farps)]];
    _farp set [Q(Config), SETTING(_self,Defaults)];
    _farp set [Q(CompositionType), _logic getVariable [GAMELOGIC_COMPOSITION, ""]];
    _farp set [Q(VehicleClasses), _logic getVariable [GAMELOGIC_CLASSES, []]];

    _configName = _logic getVariable [GAMELOGIC_CONFIG_ID, ""];
    if (_configName isNotEqualTo "") then {
        _config = SETTING_3(_self,Configs,_configName);
        if (_validate && isNil "_config") then {
            TSF_ERROR_1(TSF_ERROR_TYPE__NO_CONFIG, "Не найден конфиг '%1'", _configName);
            continue;
        };

        _farp set [Q(Config), _config];
        // -- If no Composition and/or Classes variable use config values
        if ((_farp get Q(Composition)) == "") then {
            _farp set [Q(Composition), _config get Q(Composition)];
        };
        if ((_farp get Q(Classes)) == "") then {
            _farp set [Q(Classes), _config get Q(Classes)];
        };
    };

    if (_validate && { !((_x get Q(Composition)) in (_self get Q(Compositions))) }) then {
        TSF_ERROR_1(TSF_ERROR_TYPE__MISCONFIGURED, "Неизвестное имя композиции '%1'", _x get Q(Composition));
        continue;
    };

    // Locations and stuff
    private _syncedObjects = synchronizedObjects _logic;
    _farp set [Q(SyncedObjects), _syncedObjects];

    if (_validate && { !({ _logic inArea _x } count _syncedObjects > 0) }) then {
        TSF_ERROR_1(TSF_ERROR_TYPE__MISCONFIGURED, "FARP '%1' по-умолчанию находится вне разрешенной зоны!", _farp get Q(Name));
        // continue;
    };

    _farps pushBack _farp;
} forEach _logics;

_self set [Q(FARPs), _farps];
