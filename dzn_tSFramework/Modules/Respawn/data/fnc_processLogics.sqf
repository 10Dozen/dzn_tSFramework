#include "script_component.hpp"

/*
    Finds GameLogics with RespawnLocation property and add it
    to Config2GameLogic mapping.

    Params:
        none
    Returns:
        nothing
*/

private ["_logic", "_logicConfigName", "_logicConfig", "_locationsForConfig"];
private _configs = SETTING(_self,Locations);
private _locations = _self get Q(Locations);
{
    _locations set [_x, []];
} forEach keys _configs;

{
    _logic = _x;
    _logicConfigName = _logic getVariable [GAMELOGIC_CONFIG_ID, ""];
    if (_logicConfigName == "") then { continue; };

    _logicConfig = _configs get _logicConfigName;

    if (isNil "_logicConfig") then {
        TSF_ERROR_1(TSF_ERROR_TYPE__NO_CONFIG, "Не найден конфиг '%1'", _logicConfigName);
        continue;
    };

    _locationsForConfig = _locations getOrDefaultCall [_logicConfigName, { [] }, true];
    _locationsForConfig pushBack _logic;
} forEach (entities "Logic");
