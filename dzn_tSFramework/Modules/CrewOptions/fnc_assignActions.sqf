#include "script_component.hpp"

#define ACTION_TITLE_MENU Q(<t color=COLOR_HEX_LIGHT_BLUE>Экипаж</t>)
#define ACTION_TITLE_ENGINE Q(<t color=COLOR_HEX_LIGHT_BLUE>Выключить двигатель</t>)
#define ACTION_TITLE_LIGHTS Q(<t color=COLOR_HEX_LIGHT_BLUE>Фары/габаритные огни</t>)

/*
    Assigns actions to given vehicle, based on given radio config. If some config
    values are missing - settings from Defaults section will be used instead.

    (_self)

    Params:
        _vehiclesMap (HASHMAP) - map of configs vs vehicles assigned to it.
    Returns:
        none

    _self call ["fnc_assignActions", [_vehiclesMap]];
*/

params["_vehiclesMap"];

DEBUG_1("(assignActions) Params: %1", _this);

private ["_cfgName", "_vehicles", "_vehicle", "_externalUseAllowed", "_vehicleSize"];
{
    _cfgName = _x;
    _externalUseAllowed = SETTING(_self,Configs) get _cfgName getOrDefault [Q(allowExternal), false];
    _vehicles = _y;
    {
        _vehicle = _x;
        _vehicleSize = sizeOf typeOf _vehicle;
        _vehicle setVariable [GAMELOGIC_FLAG, _cfgName];

        _vehicle disableAI "LIGHTS";
        _vehicle allowCrewInImmobile [true, true];

        // Menu action
        _vehicle addAction [
            ACTION_TITLE_MENU,
            {
                params ["_target"];
                [{
                    ECOB(CrewOptions) call [F(openCrewMenu), [_this]];
                }, _target] call CBA_fnc_execNextFrame;
            },
            [],
            0, // lowest priority
            false,
            true,
            "",
            // condition
            [
                [
                    { ECOB(CrewOptions) call [F(menuActionCondition), [_target]] }, 
                    { ECOB(CrewOptions) call [F(menuActionConditionExternal), [_target]] }
                ] select _externalUseAllowed
            ] call dzn_fnc_stringify,
            _vehicleSize
        ];

        // Engine action
        _vehicle addAction [
            ACTION_TITLE_ENGINE,
            {
                params ["_target", "_caller", "_actionId", "_arguments"];
                ECOB(CrewOptions) call [F(engineAction), [_target]];
            },
            [],
            0,
            false,
            true,
            "",
            [{ ECOB(CrewOptions) call [F(actionCondition), [_target]] }] call dzn_fnc_stringify, // condition
            _vehicleSize
        ];

        // Light action
        _vehicle addAction [
            ACTION_TITLE_LIGHTS,
            {
                params ["_target", "_caller", "_actionId", "_arguments"];
                ECOB(CrewOptions) call [F(lightsAction), [_target]];
            },
            [],
            0,
            false,
            true,
            "",
            [{ ECOB(CrewOptions) call [F(actionCondition), [_target]] }] call dzn_fnc_stringify, // condition
            _vehicleSize
        ];
    } forEach _vehicles;
} forEach _vehiclesMap;
