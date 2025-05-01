#include "script_component.hpp"

/*
    Initialize DisableOnStart feature on client.

    (_self)

    Params:
        none
    Returns:
        nothing
*/

private _settings = SETTING(_self,DisableOnStart);

if !(_settings get Q(disablePlayers)) exitWith {};

[
    { ON_MISSION_STARTED },
    {
        params ["_cob", "_settings"];

        private _enableAt = time + 1;
        if (isMultiplayer && !isServer && !serverCommandAvailable "#logout") then {
            _enableAt = time + (_settings get Q(time));
            player enableSimulation false;
            disableUserInput true;
        };

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
