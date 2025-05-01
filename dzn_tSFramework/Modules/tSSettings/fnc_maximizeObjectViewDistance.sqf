#include "script_component.hpp"

/*
    Maximizes object view distance to be equal to view distance.
    (_self)

    Params:
        _this - shadows view disatnce.
    Returns:
        nothing
*/

setObjectViewDistance [
    viewDistance,
    getObjectViewDistance # 1
];

[{
    hintSilent parseText format [
        "<t color='#86CC5E'>Дальность прорисовки объектов:</t><br/>%1 <t color='#86CC5E'>м</t>",
        getObjectViewDistance # 0
    ];
 }, nil, UPDATE_TIMEOUT] call CBA_fnc_waitAndExecute;
