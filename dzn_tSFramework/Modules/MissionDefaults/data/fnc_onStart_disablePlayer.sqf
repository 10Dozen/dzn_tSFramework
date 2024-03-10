#include "script_component.hpp"

/*
    Initialize DisableOnStart feature on client.
*/

private _settings = _self get Q(Settings) get Q(DisableOnStart);

if !(_settings get Q(disablePlayers)) exitWith {};

private _enableAt = CBA_missionTime + 1;

if !(serverCommandAvailable "#logout" || !(isMultiplayer) || isServer ) then {
    // Disable only non-admin (or not in multiplayer)
    _enableAt = _enableAt + (_settings get Q(time));
    player enableSimulation false;
    disableUserInput true;
};

// Loop each second and update Hint message
[
    {
        (_this # 0) params ["_cob", "_enableAt"];
        _cob call [F(onStart_drawOnTimeout), [_enableAt, _this # 1]];
    },
    1,
    [_self, _enableAt]
] call CBA_fnc_addPerFrameHandler;
