#include "script_component.hpp"

/*
    
*/

private _declaration = [
    COMPONENT_TYPE,
    PREP_COMPONENT_SETTINGS,

    PREP_COMPONENT_FUNCTION(initServer),
    PREP_COMPONENT_FUNCTION(initClient),

    PREP_COMPONENT_FUNCTION(processLogics),
    PREP_COMPONENT_FUNCTION(assignActions),
    PREP_COMPONENT_FUNCTION(actionCondition),

    PREP_COMPONENT_FUNCTION(openCrewMenu),
    PREP_COMPONENT_FUNCTION(AddCrew),
    PREP_COMPONENT_FUNCTION(RemoveCrew),

    PREP_COMPONENT_FUNCTION(onEngineAction),
    PREP_COMPONENT_FUNCTION(onLightsAction),

    [Q(MoveToSeatFunctions), createHashMapFromArray [
        ["driver", { params ["_unit", "_vehicle"]; _unit moveInDriver _vehicle; _unit assignAsDriver _vehicle; }],
        ["gunner", { params ["_unit", "_vehicle"]; _unit moveInGunner _vehicle; _unit assignAsGunner _vehicle; }],
        ["commander", { params ["_unit", "_vehicle"]; _unit moveInCommander _vehicle; _unit assignAsCommander _vehicle; }],
        ["turret", { 
            params ["_unit", "_vehicle", "_turretPath"]; 
            _unit moveInTurret [_vehicle, _turretPath];
            _unit assignAsTurret [_vehicle, _turretPath];
        }]
    ]],
    [Q(GetSeatUnitFunctions), createHashMapFromArray [
        ["driver", { driver _this }],
        ["gunner", { gunner _this }],
        ["commander", { commander _this }],
        ["turret", { params ["_vehicle", "_turretPath"]; _vehicle turretUnit _turretPath }]
    ]]
];

CREATE_AND_REGISTER_COMPONENT(_declaration);

COB call [F(initServer)];
COB call [F(initClient)];