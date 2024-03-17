#include "script_component.hpp"

/*
    Adds user action to teleport if player is JIP
    (_self)

    Params:
        none
    Returns:
        nothing
*/

if (isMultiplayer && !didJIP) exitWith {};

if (player == leader group player) exitWith {
    systemChat SETTING(_self,MessageNoLeader);
};

private _expirationTimeout = SETTING(_self,ExpirationTime);
private _expirationDistance = SETTING(_self,ExpirationDistance);

// --- Welcome message
systemChat format [
    SETTING(_self,Message),
    _expirationTimeout,
    _expirationDistance
];

player setVariable [
    QGVAR(Action),
    player addAction [
        ACTION_TITLE,
        {
            params ["_target", "_caller", "_actionId", "_self"];
            _self call [F(onTeleportAction)];
        },
        _self,
        6
    ]
];

// Handle expiration of the action
[
    {
        params ["_args", "_handle"];
        _args params ["_self", "_initPos", "_expirationDistance", "_expiresAt"];
        if (player distance _initPos > _expirationDistance || CBA_missionTime > _expiresAt) then {
            _self call [F(removeTeleportAction)];
            [_handle] call CBA_fnc_removePerFrameHandler;
        };
    },
    1,
    [
        _self,
        getPosATL player,
        _expirationDistance,
        CBA_missionTime + _expirationTimeout
    ]
] call CBA_fnc_addPerFrameHandler;
