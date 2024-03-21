#include "script_component.hpp"

/*
    Adds pre-defined topics according to settings.
    (_self)

    Params:
        _this (NUMBER) - terrain grid id.
    Returns:
        nothing
*/

(_self get Q(TerrainGridModes) get _this) params ["_displayName","_gridLevel"];

hintSilent parseText format [
    "<t color='#86CC5E'>Детализация ландшафта:</t><br/>%1",
    _displayName
];

setTerrainGrid _gridLevel;
