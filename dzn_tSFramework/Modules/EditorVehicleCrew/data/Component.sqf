#include "script_component.hpp"

/*
    Editor Vehicle Crew allows to automatically populate marked static turrets
    and vehicles with specific crew.
    Also allows to apply DYNAI vehicle behaviour to crew.
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
