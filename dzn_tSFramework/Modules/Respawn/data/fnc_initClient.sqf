#include "script_component.hpp"

/*
    Initialize Component Object and it's features.
    (_self)

    Params: none
    Returns:
        nothing
*/

__CLIENT_ONLY__
__EXIT_ON_SETTINGS_PARSE_ERROR__

LOG("Client init started");

// -- Update Configs with locationObjects and select player's default spawn location
private _respawnLocations = _self call [F(processLogics)];
private _groupName = groupId group player;
private _playerRespawnLocation = DEFAULT_LOCATION;
{
    _y set [
        Q(positionObject),
        _respawnLocations get _x
    ];

    // -- Check for player's group to be assigned to this location
    if ((_y getOrDefault [Q(groups), []]) findIf {_x == _groupName} > -1) then {
        _playerRespawnLocation = _x;
    };
} forEach SETTING(_self,Locations);

_self set [Q(DefaultRespawnLocation), _playerRespawnLocation];

_self call [F(setDefaultEquipment)];
_self call [F(setDefaultRating)];

player addMPEventHandler ["MPRespawn", {
    private _position = ECOB(Respawn) call [F(onRespawn), _this];
    [1, "BLACK", 3, 1] spawn BIS_fnc_fadeEffect;
    _position
}];

player addEventHandler ["Killed", {
    [1, "BLACK", 5, 1] spawn BIS_fnc_fadeEffect;
}];

player setVariable [QGVAR(Scheduled), false];

_self call [F(addOnRespawnCall), [
    {
        DEBUG_1("(onRespawn) Apply gear and rating modifiers ", 1);
        COB call [F(setDefaultEquipment)];
        COB call [F(setDefaultRating)];
    }
]];

_self call [F(addOnRespawnCall), [
    {
        DEBUG_1("(onRespawn) Re-apply dzn_gear kit", 1);
        private _gearKit = player getVariable "dzn_gear";
        if (isNil "_gearKit") exitWith {};
        player setVariable ["dzn_gear_done", nil];
        [player, _gearKit, false] spawn dzn_fnc_gear_assignKit;
    },
    nil,
    1
]];

_self call [F(addOnRespawnCall), [
    {
        DEBUG_1("(onRespawn) Reset Respawn logic variables", 1);
        setPlayerRespawnTime 9999999;
    },
    _self,
    1
]];

LOG("Client initialized");
