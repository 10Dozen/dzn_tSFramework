#include "script_component.hpp"

/*
    Core component contains common functions used by other modules.
*/

private _declaration = [
    ["#base", COMPONENT_IFACE],
    ["#name", Q(thisMODULE)],
    ["#type", Q(COMPONENT_VARNAME)],
    ["#str", { Q(COMPONENT_VARNAME) }],

    [Q(Settings), ["Config\_Modules.yaml"] call dzn_fnc_parseSFML],
    [Q(Components), createHashMap],
    [Q(RCE_Queue), []],

    PREP_COMPONENT_FUNCTION(init),
    PREP_COMPONENT_FUNCTION(reportError),

    PREP_COMPONENT_FUNCTION(startComponent),
    PREP_COMPONENT_FUNCTION(registerComponent),

    PREP_COMPONENT_FUNCTION(getComponent),
    PREP_COMPONENT_FUNCTION(getComponentState),

    // -- Shared functions
    // PREP_COMPONENT_FUNCTION(getGroupORBAT),
    // PREP_COMPONENT_FUNCTION(getUnitGearInfo),

    [Q(ReportedErrors), createHashMap],
    [Q(LegacyModules), [ LEGACY_MODULES ]]
];

createHashMapObject [_declaration]
