#include "script_component.hpp"

/*
    IntroText component is able to draw stylized mission intro title.
*/

private _declaration = [
    COMPONENT_TYPE,
    PREP_COMPONENT_SETTINGS,

    PREP_COMPONENT_FUNCTION(init),
    PREP_COMPONENT_FUNCTION(showMissionTitles),
    PREP_COMPONENT_FUNCTION(showTitles)
];

COB = createHashMapObject [_declaration];
COB call [F(init)];
