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

params ["_respawnLocations"];

LOG("Client init started");

// Update Configs with locationObjects and select player's default spawn location
private _groupName = groupId player;
private _defaultRespawnLocation = DEFAULT_LOCATION;
{
    private _locObject = _respawnLocations get _x;
    _y set [Q(positionObject), _locObjet];

    // Check for player's group to be assigned to this location
    if ((_y get Q(groups)) findIf {_x == _groupName} > -1) then {
        _defaultRespawnLocation = _x;
    };
} forEach SETTING(_self,Locations);

_self set [Q(GroupName), _groupName];
_self set [Q(RespawnLocation), _defaultRespawnLocation];

//_self call [F(setDefaultEquipment)];
//_self call [F(setDefaultRating)];

player addEventHandler ["Respawn", {
    private _position = ECOB(Respawn) call [F(onRespawn), _this];
    _position
}];

player addEventHandler ["Killed", {
	[1, "BLACK", 5, 1] spawn BIS_fnc_fadeEffect;
}];

LOG("Client initialized");
