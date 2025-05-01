#include "script_component.hpp"

/*
    Changes view distance with given step.
    (_self)

    Params:
        0: _view (NUMBER) - view distance to add.
        1: _objectView (NUMBER) - object view distance to add.
    Returns:
        nothing
*/

params ["_view", "_objectView"];

DEBUG_1("[ChangeViewDistance] Params: %1", _this);

setViewDistance (((viewDistance + _view) max MIN_VIEW_DISTANCE) min MAX_VIEW_DISTANCE);
setObjectViewDistance ((((getObjectViewDistance # 0) + _objectView) max MIN_OBJ_VIEW_DISTANCE) min MAX_OBJ_VIEW_DISTANCE);

[{
    hintSilent parseText format [
        "<t color='#86CC5E'>Дальность прорисовки:</t><br/>%1 (%2) <t color='#86CC5E'>м</t>",
        viewDistance,
        getObjectViewDistance # 0
    ];
 }, nil, UPDATE_TIMEOUT] call CBA_fnc_waitAndExecute;
