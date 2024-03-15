#include "script_component.hpp"

/*
    Core component contains common functions used by other modules.
*/

private _declaration = [
    COMPONENT_TYPE,
    PREP_COMPONENT_FUNCTION(init),
    PREP_COMPONENT_FUNCTION(reportError),

    [Q(ReportedErrors), createHashMap]
];

COB = createHashMapObject [_declaration];
COB call [F(init)];
