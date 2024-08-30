#include "script_component.hpp"

/*
    Adds crew member to selected vehicle and selected seat.
    If seat is occupied by alive unit - nothing happens.
    Otherwise - new unit will be added to vehicle's group or player's group, depending on flag.

    (_self)

    Params:
        _vehicle (OBJECT) - target vehicle
        _seatCfg (HASHMAP) - seat configuration
        _joinPlayer (BOOL) - optional, flag to join created unit to player's group. Defaults to false.
    Returns:
        _unit (OBJECT) - created unit or objNull it error occured.

    _self call ["fnc_addCrew", [_vehicle, _cfg, false]];
*/

params ["_vehicle", "_seatCfg", ["_joinPlayer", false]];

LOG_1("(addCrew) Params: %1", _this);

private _configName = _vehicle getVariable GAMELOGIC_FLAG;
if (isNil "_configName") exitWith {
    TSF_ERROR_1(TSF_ERROR_TYPE__NO_CONFIG, "(AddCrew) У машины %1 не задан конфиг опций экипажа", _vehicle);
    objNull
};
if !(_configName in SETTING(_self,Configs)) exitWith {
    TSF_ERROR_2(TSF_ERROR_TYPE__NO_CONFIG, "(AddCrew) Конфиг опций экипажа %1 для машины %2 не найден в настройках модуля", _configName, _vehicle);
    objNull
};


LOG_1("(addCrew) ConfigName=%1", _configName);

private _seat = _seatCfg get Q(seat);
private _seatName = _seatCfg getOrDefault [Q(name), _seat];

LOG_1("(addCrew) _seatName=%1", _seatName);
LOG_1("(addCrew) _seat=%1", _seat);

private _currentSeatUnit = _self call [F(getUnitOnSeat), [_vehicle, _seat]];

LOG_1("(addCrew) _currentSeatUnit=%1", _currentSeatUnit);

if (!isNull _currentSeatUnit) then {
    if (alive _currentSeatUnit) exitWith {
        hint format ["Место %1 уже занято!", _seatName];
    };
    // Remove dead unit from vehicle
    moveOut _currentSeatUnit;

    LOG_1("(addCrew) Removed dead unit form vehicle =%1", _currentSeatUnit);
};

// --- Creating new unit
//
private _vehicleCfg = SETTING(_self,Configs) get _configName;

private _unitSide = side player;
private _unitClass = _seatCfg getOrDefault [
    Q(class),
    _vehicleCfg getOrDefault [
        Q(class),
        SETTING(_self,Defaults) getOrDefaults [
            Q(class),
            switch _unitSide do {
                case west: { "B_crew_F" };
                case east: { "O_crew_F" };
                case resistance: { "I_crew_F" };
                case civilian: { "C_man_1" };
            }
        ]
    ]
];

private _unitKit = _seatCfg getOrDefault [
    Q(kit),
    _vehicleCfg getOrDefault [
        Q(kit),
        SETTING(_self,Defaults) getOrDefaults [Q(kit), ""]
    ]
];

private _combatAllowed = _seatCfg getOrDefault [
    Q(allowCombat),
    _vehicleCfg getOrDefault [
        Q(allowCombat),
        SETTING(_self,Defaults) getOrDefaults [Q(allowCombat), false]
    ]
];

private _unitGroup = group player;
if !(_joinPlayer) then {
    _unitGroup = _vehicle getVariable [QGVAR(Group), grpNull];
    if (isNull _unitGroup) then {
        _unitGroup = createGroup _unitSide;
        _vehicle setVariable [QGVAR(Group), _unitGroup, true];
    };
};

LOG_4("(addCrew) Creating new unit: _side=%1, _unitClass=%2, _unitKit=%3, _unitGroup=%4", _unitSide, _unitClass, _unitKit, _unitGroup);

private _unit = _unitGroup createUnit [_unitClass, getPosATL _vehicle, [], 0, "NONE"];
if (_unitKit != "") then { [_unit, _unitKit] call dzn_fnc_gear_assignKit; };

private _seatFncName = _seat;
private _seatFncParams = [_unit, _vehicle];
if (_seat isEqualType []) then {
    _seatFncName = "turret";
    _seatFncParams pushBack _seat;
};
private _seatFnc = _self get Q(MoveToSeatFunctions) get _seatFncName;

LOG_3("(addCrew) Assigning unit: _seatFncName=%1, _seatFncParams=%2, _seatFnc=%3", _seatFncName, _seatFncParams, _seatFnc);

_seatFncParams call _seatFnc;

_unit setSkill 1;
_unit setSkill ["courage", 1];

_unit allowFleeing 0;
_unit disableAI "LIGHTS";
_unit disableAI "RADIOPROTOCOL";

if (!_combatAllowed) then {
    _unit disableAI "AUTOTARGET";
    _unit disableAI "AUTOCOMBAT";
    _unit disableAI "CHECKVISIBLE";
    _unit disableAI "FSM";
};

hintSilent parseText format [
    Q(CREW_OPTIONS_HINT_MEMBER_ADDED),
    _seatName
];

_unit