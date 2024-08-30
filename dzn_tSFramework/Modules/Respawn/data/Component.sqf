#include "script_component.hpp"

/*
    Respawn component provides controllable respawn logic for individual players.
    ALlows to define specific respawn locations per group and per player.
    Handles putting weapon on safe and putting earplug in on initial spawn
    and on respawn.
*/

private _declaration = [
    COMPONENT_TYPE,
    PREP_COMPONENT_SETTINGS,
    
    PREP_COMPONENT_FUNCTION(initServer),
    PREP_COMPONENT_FUNCTION(processLogics),

    PREP_COMPONENT_FUNCTION(initClient),
    PREP_COMPONENT_FUNCTION(setDefaultEquipment),
    PREP_COMPONENT_FUNCTION(setDefaultRating),

    PREP_COMPONENT_FUNCTION(scheduleRespawn),
    PREP_COMPONENT_FUNCTION(unscheduleRespawn),
    
    PREP_COMPONENT_FUNCTION(onRespawn),

    PREP_COMPONENT_FUNCTION(showMessage),
    PREP_COMPONENT_FUNCTION(getDefaultSpawnLocationName),
    PREP_COMPONENT_FUNCTION(getSpawnLocationsNames),

    [Q(GroupToLocation), createHashMap],
    [Q(GroupName), nil],
    [Q(RespawnLocation), DEFAULT_LOCATION],
    [Q(ForcedRespawnLocation), nil]
];

// Init:
CREATE_AND_REGISTER_COMPONENT(_declaration);
COB call [F(initServer)];
