#include "script_component.hpp"

/*
    Saves view distance settings to be reused in another mission.
    (_self)

    Params:
        none
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
