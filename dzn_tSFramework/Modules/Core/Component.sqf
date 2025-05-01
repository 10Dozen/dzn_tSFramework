#include "script_component.hpp"

/*
    Core component contains common functions used by other modules.
*/

params ["_gearEditMode"];

private _declaration = [
    COMPONENT_TYPE,

    [Q(Settings), ["Config\_Modules.yaml"] call dzn_fnc_parseSFML],
    [Q(Components), createHashMap],

    PREP_COMPONENT_FUNCTION(init),
    PREP_COMPONENT_FUNCTION(reportError),

    PREP_COMPONENT_FUNCTION(isModuleEnabled),

    PREP_COMPONENT_FUNCTION(registerComponent),
    PREP_COMPONENT_FUNCTION(getComponent),

    // -- Shared functions
    PREP_COMPONENT_FUNCTION(getGroupORBAT),
    PREP_COMPONENT_FUNCTION(getUnitGearInfo),

    [Q(ReportedErrors), createHashMap],
    [Q(LegacyModules), [ LEGACY_MODULES ]]
];

COB = createHashMapObject [_declaration];
COB call [F(init), [_gearEditMode]];
