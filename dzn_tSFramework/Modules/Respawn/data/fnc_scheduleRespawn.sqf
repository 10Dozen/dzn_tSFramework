#include "script_component.hpp"

/*
    (_self)

    Params:
        nothing
    Returns:
        nothing
*/

__CLIENT_ONLY__

params [
    ["_forcedLocation", nil],
    ["_timeout", 0]
];

_timeout = _timeout + SETTING(_self,BeforeRespawnTimeout);

if (!isNil "_forcedLocation") then {
    _self set [Q(ForcedRespawnLocation), _forcedLocation];
};

_self call [F(showMessage), [MODE_BEFORE_RESPAWN_MSG, [_timeout]]];
setPlayerRespawnTime _timeout;