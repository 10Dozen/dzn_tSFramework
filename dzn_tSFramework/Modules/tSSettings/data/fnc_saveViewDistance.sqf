#include "script_component.hpp"

/*
    Adds pre-defined topics according to settings.
    (_self)

    Params:
        0: _view (NUMBER) - view distance.
        1: _objectView (NUMBER) - object view distance.
    Returns:
        nothing
*/

profileNamespace setVariable [
    PROFILE_VD_VAR,
    [viewDistance, getObjectViewDistance]
];

hintSilent parseText format [
    "<t color='#86CC5E'>Дальность прорисовки сохранена:</t><br/> %1 (%2) <t color='#86CC5E'>м</t>"
    , viewDistance
    , getObjectViewDistance select 0
];
