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

params ["_view", "_objectView"];

setViewDistance _view;
setObjectViewDistance _objectView;

[{
    hintSilent parseText format [
        "<t color='#86CC5E'>Дальность прорисовки:</t><br/>%1 (%2) <t color='#86CC5E'>м</t>",
        viewDistance,
        getObjectViewDistance # 0
    ];
}, nil, UPDATE_TIMEOUT] call CBA_fnc_waitAndExecute;
