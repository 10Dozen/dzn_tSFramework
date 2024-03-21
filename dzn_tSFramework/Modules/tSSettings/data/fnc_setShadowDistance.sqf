#include "script_component.hpp"

/*
    Changes shadows view distance.
    (_self)

    Params:
        _this - shadows view disatnce.
    Returns:
        nothing
*/

setObjectViewDistance [
    getObjectViewDistance # 0,
    _this
];

[{
    hintSilent parseText format [
        "<t color='#86CC5E'>Дальность прорисовки теней:</t><br/>%1 <t color='#86CC5E'>м</t>",
        getObjectViewDistance # 1
    ];
 }, nil, UPDATE_TIMEOUT] call CBA_fnc_waitAndExecute;
