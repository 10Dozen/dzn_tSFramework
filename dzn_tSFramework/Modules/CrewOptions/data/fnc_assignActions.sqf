#include "script_component.hpp"

#define ACTION_TITLE_MENU Q(<t color=COLOR_HEX_LIGHT_BLUE>Экипаж</t>)
#define ACTION_TITLE_ENGINE Q(<t color=COLOR_HEX_LIGHT_BLUE>Выключить двигатель</t>)
#define ACTION_TITLE_LIGHTS Q(<t color=COLOR_HEX_LIGHT_BLUE>Фары/габаритные огни</t>)

#define ACE_ACTION_TITLE_MENU Q(Экипаж)
#define ACE_ACTION_TITLE_ENGINE Q(Выключить двигатель)
#define ACE_ACTION_TITLE_LIGHTS Q(Фары/габаритные огни)

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

private _addAction = SETTING(_self,AddActions);
private _addAceAction = SETTING(_self,AddACEActions);

private ["_cfgName", "_vehicles", "_vehicle"];
{
    _cfgName = _x;
    _vehicles = _y;
    {
        _vehicle = _x;
        _vehicle setVariable [GAMELOGIC_FLAG, _cfgName];

        _vehicle disableAI "LIGHTS";
        _vehicle allowCrewInImmobile [true, true];

        if (_addAction) then {
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
                0, // priority
                false,
                true,
                "",
                [{ ECOB(CrewOptions) call [F(actionCondition), [_target]] }] call dzn_fnc_stringify, // condition
                15   // radius, hope there won't be gigantic vehicles
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
                15   // radius, hope there won't be gigantic vehicles
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
                15   // radius, hope there won't be gigantic vehicles
            ];
        };

        if (_addAceAction) then {
            LOG_1("(assignActions) Adding ACE actions to vehicle %1", _vehicle);
            // TBD

            [
                _vehicle, "CrewMenu", "CrewMenu", "",  { ECOB(CrewOptions) call [F(openCrewMenu), [_target]]; },
                { ECOB(CrewOptions) call [F(actionCondition), [_target]] }
            ] call tSF_fnc_ACEActions_addAction;

            private _actionMenu = [
                "Menu",
                ACE_ACTION_TITLE_MENU,
                "",
                { ECOB(CrewOptions) call [F(openCrewMenu), [_target]]; },
                { true }
            ] call ace_interact_menu_fnc_createAction;

            private _actionEngine = [
                "EngineOff",
                ACE_ACTION_TITLE_ENGINE,"",
                { ECOB(CrewOptions) call [F(engineAction), [_target]]; },
                { ECOB(CrewOptions) call [F(actionCondition), [_target]] },
                {},
                [], 
                [0,0,0],
                15,
                [false, true, false, false, true]
            ] call ace_interact_menu_fnc_createAction;

            private _actionLights = [
                "LightsCycle",
                ACE_ACTION_TITLE_LIGHTS,"",
                { ECOB(CrewOptions) call [F(lightsAction), [_target]]; },
                { true /*ECOB(CrewOptions) call [F(actionCondition), [_target]]*/ },
                {},
                [], 
                [0,0,0],
                15,
                [false, true, false, false, true]
            ] call ace_interact_menu_fnc_createAction;

            {
                LOG_1("(assignActions) Adding ACE actions=%1", _x);            
                [_vehicle, 0, ["ACE_MainActions"], _x] call ace_interact_menu_fnc_addActionToObject;
            } forEach [_actionMenu, _actionEngine, _actionLights];
        };
    } forEach _vehicles;
} forEach _vehiclesMap;
