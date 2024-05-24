#include "script_component.hpp"

/*
    Initialize Component Object and it's features.
    (_self)

    Params:
        0: _respawnLocations (HashMap) - respawn location found by server.
    Returns:
        nothing
*/

__CLIENT_ONLY__

params ["_respawnLocations"];

LOG("Client init started");

_self set [Q(Locations), _respawnLocations];

_self call [F(setDefaultEquipment)];
_self call [F(setDefaultRating)];

_self call [F(addRespawnHandler), [player]];

LOG("Client initialized");
