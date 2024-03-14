#include "script_component.hpp"


#define COMPONENT_FNC_PATH(FILE) MAINPREFIX\SUBPREFIX\COMPONENT\data\fnc_##FILE##.sqf
#define PREP_COMPONENT_FUNCTION(NAME) \
    [Q(NAME), compileScript [QUOTE(COMPONENT_FNC_PATH(NAME))]]

private _declaration = [
    ["#create", {
        LOG("Component creation started. Reading settings...");
        private _settings = [Q(COMPONENT_PATH(Settings.yaml))] call dzn_fnc_parseSFML;
        if ((_settings get "#ERRORS") isNotEqualTo []) exitWith {
            LOG("Error on component creation!");
            ["%1 - Failed to parse Settings.sfml", Q(COMPONENT)] call BIS_fnc_error;
        };

        private _cfgs = (_settings get Q(Configs));
        {
            // _x - config name, _y - config body

            private _inheritFrom = _y get Q(use);
            if (isNil "_inheritFrom") then { continue; };
            _inheritFrom = +_inheritFrom;
            _y deleteAt Q(use);
            _inheritFrom merge [_y, true];
            _cfgs set [_x, _inheritFrom];
        } forEach _cfgs;

        _self set [QUOTE(Settings), _settings];
        LOG("Component created!");
    }],
    ["#type", { format ["%1_ComponentObject", Q(COMPONENT)] }],
   /* ["#str", { format ["%1_ComponentObject", QUOTE(COMPONENT)] }],*/

    PREP_COMPONENT_FUNCTION(init),
    PREP_COMPONENT_FUNCTION(processLogics),
    PREP_COMPONENT_FUNCTION(assignCrew)
];

GVAR(ComponentObject) = createHashMapObject [_declaration];
