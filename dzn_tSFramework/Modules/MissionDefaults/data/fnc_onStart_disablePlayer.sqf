#include "script_component.hpp"

/*
    Initialize DisableOnStart feature on client.
*/

private _settings = _self get Q(Settings) get Q(DisableOnStart);

if !(_settings get Q(disablePlayers)) exitWith {};

[
    {time > 0},
    {
        params ["_cob", "_settings"];

        private _enableAt = time + 2;
        // if !(serverCommandAvailable "#logout" || !(isMultiplayer) || isServer ) then {
            _enableAt = time + (_settings get Q(time));
            player enableSimulation false;
            disableUserInput true;
        // };

        DEBUG_1("[onStart] Enable At %1", _enableAt);

        // Loop each second and update Hint message
        [
            {
                params ["_args", "_pfhId"];
                _args params ["_cob", "_enableAt"];

                DEBUG_1("[onStart] PFH executed at %1", time);
                _cob call [F(onStart_drawOnTimeout), [_enableAt, _pfhId]];
            },
            1,
            [_cob, _enableAt]
        ] call CBA_fnc_addPerFrameHandler;
    },
    [_self, _settings]
] call CBA_fnc_waitUntilAndExecute;
