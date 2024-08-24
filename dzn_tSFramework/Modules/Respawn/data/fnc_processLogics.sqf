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
private _locations = createHashMap;
{
    _locations set [_x, objNull];
} forEach keys _configs;

// Process default location - marker-based 
private _mrk = allMapMarkers select { _x in [
    "respawn", "respawn_west", "respawn_east", "respawn_guerrila", "respawn_civilian"
] };
if (_mrk isEqualTo []) exitWith {
    TSF_ERROR(TSF_ERROR_TYPE__NO_MARKER, "Не найден маркер респауна");
};
_locations set [DEFAULT_LOCATION, getMarkerPos (_mrk # 0)];


// Find positions of the GameLogic entities
{
    _logic = _x;
    _logicConfigName = _logic getVariable [GAMELOGIC_CONFIG_ID, ""];
    if (_logicConfigName == "") then { continue; };

    _logicConfig = _configs get _logicConfigName;

    if (isNil "_logicConfig") then {
        TSF_ERROR_1(TSF_ERROR_TYPE__NO_CONFIG, "Не найден конфиг '%1'", _logicConfigName);
        continue;
    };

    _locations set [_logicConfigName, _logic];
} forEach (entities "Logic");



_locations
