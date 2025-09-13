#include "script_component.hpp"

#define ACTION_TITLE Q(<t color=COLOR_HEX_LIGHT_BLUE>Экипаж</t>)

/*
    Checks that EngineOn/Lights action is available:
    - driver seat is occupied by alive AI unit

    (_self)

    Params:
        _vehicle (OBJECT) - vehicle to check against
    Returns:
        none

    _self call ["fnc_actionConditionExternal", [_vehicle]];
*/

params["_vehicle"];

private _driver = _self call [F(getUnitOnSeat), [_vehicle, "driver"]];
!(isNull _driver) && (alive _driver) && !(isPlayer _driver)