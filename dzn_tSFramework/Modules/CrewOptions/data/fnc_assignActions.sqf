#include "script_component.hpp"

#define ACTION_TITLE Q(<t color=COLOR_HEX_LIGHT_BLUE>Экипаж</t>)

/*
    Assigns actions to given vehicle, based on given radio config. If some config
    values are missing - settings from Defaults section will be used instead.

    (_self)

    Params:
        _vehiclesMap (HASHMAP) - map of configs vs vehicles assigned with it.
    Returns:
        none

    _self call ["fnc_assignActions", [_vehiclesMap]];
*/

params["_vehiclesMap"];

#define Value(CFG,NAME) (CFG get Q(NAME))
#define ValueOrDefault(CFG,NAME) (CFG getOrDefault [Q(NAME), SETTING_2(_self,Defaults,NAME)])

private _addAction = SETTING(_self,AddActions);
private _addAceAction = SETTING(_self,AddACEActions);

{
    private _cfgName = _x;
    _vehicle setVariable [GAMELOGIC_FLAG, _cfgName];
    {
        if (_addAction) then {
            _x addAction [
                ACTION_TITLE,
                {
                    params ["_target", "_caller", "_actionId", "_arguments"];
                    ECOB(CrewOptions) call [F(openCrewMenu), [_target]];
                },
                [],
                6,
                false,
                true,
                "",
                [{ ECOB(CrewOptions) call [F(actionCondition), [_target]] }] call dzn_fnc_stringify, // condition
                5   // radius
            ];
        };


        if (_addAceAction) then {
            // TBD
        };
    } forEach _y;
} forEach _vehiclesMap;
