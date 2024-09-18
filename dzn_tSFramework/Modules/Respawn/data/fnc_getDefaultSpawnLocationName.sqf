#include "script_component.hpp"

/*
    Returns display name of player's default spawn location (assigned in config).
    (_self)

    Params:
        nothing
    Returns:
        string
*/

SETTING(_self,Locations) get (_self get Q(DefaultRespawnLocation)) getOrDefault [Q(name), ""]
