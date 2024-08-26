#include "script_component.hpp"

/*
    Initialize Component Object and it's features.
    (_self)

    Params:
        0: _respawnLocations (HashMap) -
    Returns:
        nothing
*/

__CLIENT_ONLY__

__EXIT_ON_SETTINGS_PARSE_ERROR__

params ["_respawnLocations"];

LOG("Client init started");

// Update Configs with locationObjects and select player's default spawn location
private _groupName = groupId group player;
private _playerRespawnLocation = DEFAULT_LOCATION;
{
    _y set [
        Q(positionObject), 
        _respawnLocations get _x
    ];

    // Check for player's group to be assigned to this location
    if ((_y getOrDefault [Q(groups), []]) findIf {_x == _groupName} > -1) then {
        _playerRespawnLocation = _x;
    };
} forEach SETTING(_self,Locations);

_self set [Q(GroupName), _groupName];
_self set [Q(RespawnLocation), _playerRespawnLocation];

_self call [F(setDefaultEquipment)];
_self call [F(setDefaultRating)];

player addEventHandler ["Respawn", {
    private _position = ECOB(Respawn) call [F(onRespawn), _this];
    _position
}];

player addEventHandler ["Killed", {
	[1, "BLACK", 5, 1] spawn BIS_fnc_fadeEffect;
}];

player setVariable [QGVAR(Scheduled), false];

LOG("Client initialized");
