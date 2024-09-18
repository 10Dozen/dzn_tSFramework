#include "script_component.hpp"

/*
    Schedules the respawn: sets desired location and timeout before respawn, to 
    start resoawn countdown.
    (_self)

    Params:
        0: _positionInfo (ARRAY or STRING) - array of 
                               [description (STRING), Pos3d/object, snapToSuface(BOOL)] 
                               or location config name
                               or empty (default spawn location will be used). 
        1: _timeout (NUMBER) - optional, base timeout before respawn. 
                               Will be modified by Settings.BeforeRespawnTimeout . 
                               Defaults to 0.
    Returns:
        nothing
*/

__CLIENT_ONLY__

params [
    ["_positionInfo", _self get Q(DefaultRespawnLocation)], 
    ["_timeout", 0]
];
DEBUG_1("(scheduleRespawn) Params: %1", _this);

if (alive player) exitWith {
    setPlayerRespawnTime RESPAWN_TIME_DISABLED;
};

player setVariable [QGVAR(Scheduled), true, true];

// -- Check for location config 
private "_respawnLocation";
if (_positionInfo isEqualType "") then {
    private _location = SETTING(_self,Locations) get _positionInfo;
    if (isNil "_location") exitWith {
        TSF_ERROR_1(TSF_ERROR_TYPE__NO_CONFIG,"Не найдена локация респауна ""%1""", _positionInfo);
    };

    _respawnLocation = createHashMapObject [_self get Q(TargetLocationObject), [
        _location getOrDefault [Q(name), ""], 
        _location get Q(positionObject), 
        _location getOrDefault [Q(snapToSurface), true]
    ]];
} else {
    _respawnLocation = createHashMapObject [_self get Q(TargetLocationObject), _positionInfo];
};

_self set [Q(SelectedRespawnLocation), _respawnLocation];

_timeout = _timeout + SETTING(_self,BeforeRespawnTimeout);
_self call [F(showMessage), [MODE_BEFORE_RESPAWN_MSG, [_timeout]]];

setPlayerRespawnTime _timeout;
