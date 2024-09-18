#include "script_component.hpp"

/*
    Respawn component provides controllable respawn logic for individual players.
    Allows to define specific respawn locations per group.
    Handles putting weapon on safe and putting earplug in on initial spawn
    and on respawn.
*/

private _declaration = [
    COMPONENT_TYPE,
    PREP_COMPONENT_SETTINGS,
    
    PREP_COMPONENT_FUNCTION(initClient),
    PREP_COMPONENT_FUNCTION(processLogics),
    
    PREP_COMPONENT_FUNCTION(setDefaultEquipment),
    PREP_COMPONENT_FUNCTION(setDefaultRating),

    PREP_COMPONENT_FUNCTION(addOnRespawnCall),
    PREP_COMPONENT_FUNCTION(scheduleRespawn),
    PREP_COMPONENT_FUNCTION(unscheduleRespawn),
    
    PREP_COMPONENT_FUNCTION(onRespawn),

    PREP_COMPONENT_FUNCTION(showMessage),
    PREP_COMPONENT_FUNCTION(getDefaultSpawnLocationName),
    PREP_COMPONENT_FUNCTION(getSpawnLocations),

    [Q(GroupToLocation), createHashMap],
    [Q(GroupName), nil],
    [Q(DefaultRespawnLocation), DEFAULT_LOCATION],
    [Q(SelectedRespawnLocation), nil],
    [Q(onRespawnSnippets), createHashMap],

    [Q(TargetLocationObject), [
        ["#type", "IRespawnLocation"],
        ["#create", { 
            _this params ["_name", "_pos", ["_snap", true]];
            _self set [Q(position), _pos];
            _self set [Q(snapToSurface), _snap];
            _self set [Q(name), _name];
        }]
    ]]
];

// Init:
CREATE_AND_REGISTER_COMPONENT(_declaration);
COB call [F(initClient)];
