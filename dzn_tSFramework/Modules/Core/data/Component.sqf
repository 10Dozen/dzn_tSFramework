#include "script_component.hpp"

/*
    Core component contains common functions used by other modules.
*/

private _declaration = [
    COMPONENT_TYPE,

    [Q(Settings), ["dzn_tSFramework\Settings.yaml"] call dzn_fnc_parseSFML],

    PREP_COMPONENT_FUNCTION(init),
    PREP_COMPONENT_FUNCTION(reportError),
    PREP_COMPONENT_FUNCTION(isModuleEnabled),

    [Q(ReportedErrors), createHashMap],
    [Q(LegacyModules), [ LEGACY_MODULES ]]
];

COB = createHashMapObject [_declaration];
COB call [F(init)];
