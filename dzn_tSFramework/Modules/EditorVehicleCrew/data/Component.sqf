#include "script_component.hpp"

/*
    MissionDefaults component provide general features for every user
    needed in every mission:
    - puts weapon on safe on mission start
    - puts earplugs in
    - disables control for 20 seconds at the beginning (to avoid misfire or grenade)
    - adds useful tools like calculator and marker name autocompltion;
*/

private _declaration = [
    COMPONENT_TYPE,
    PREP_COMPONENT_SETTINGS,

    PREP_COMPONENT_FUNCTION(init),
    PREP_COMPONENT_FUNCTION(assignCrewAndGear),
    PREP_COMPONENT_FUNCTION(processLogics),

    [Q(VehicleBehaviorMap), createHashMapFromArray [
        ["hold", DZN_DYNAI_VEHICLE_HOLD],
        ["frontal", DZN_DYNAI_VEHICLE_HOLD_45],
        ["full frontal", DZN_DYNAI_VEHICLE_HOLD_90]
    ]]
];

COB = createHashMapObject [_declaration];
COB call [F(init)];

