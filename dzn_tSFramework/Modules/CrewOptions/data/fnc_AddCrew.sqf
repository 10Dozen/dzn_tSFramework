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
DEBUG_1("(addCrew) Params: %1", _this);

private _configName = _vehicle getVariable GAMELOGIC_FLAG;
if (isNil "_configName") exitWith {
    TSF_ERROR_1(TSF_ERROR_TYPE__NO_CONFIG, "(AddCrew) У машины %1 не задан конфиг опций экипажа", _vehicle);
    objNull
};
if !(_configName in SETTING(_self,Configs)) exitWith {
    TSF_ERROR_2(TSF_ERROR_TYPE__NO_CONFIG, "(AddCrew) Конфиг опций экипажа %1 для машины %2 не найден в настройках модуля", _configName, _vehicle);
    objNull
};

if !(player isEqualTo effectiveCommander _vehicle) exitWith {
    DEBUG_1("(addCrew) Current client is not an vehicle commander. RCE to: %1", effectiveCommander _vehicle);
    [
        Q(COMPONENT),
        F(addCrew),
        _this,
        effectiveCommander _vehicle
    ] call dzn_fnc_RCE;
};

private _seat = _seatCfg get Q(seat);
private _seatName = _seatCfg getOrDefault [Q(name), _seat];
private _currentSeatUnit = _self call [F(getUnitOnSeat), [_vehicle, _seat]];

if (!isNull _currentSeatUnit) then {
    if (alive _currentSeatUnit) exitWith {
        hint format ["Место %1 уже занято!", _seatName];
    };
    // Remove dead unit from vehicle
    moveOut _currentSeatUnit;
    DEBUG_2("(addCrew) Move out AI unit %1 from seat %2", _currentSeatUnit, _seatName);
};

// --- Creating new unit
//
private _vehicleCfg = SETTING(_self,Configs) get _configName;

private _unitClass = _seatCfg getOrDefault [
    Q(class),
    _vehicleCfg getOrDefault [
        Q(class),
        SETTING(_self,Defaults) getOrDefault [
            Q(class),
            switch (side player) do {
                case west: { "B_crew_F" };
                case east: { "O_crew_F" };
                case resistance: { "I_crew_F" };
                case civilian: { "C_man_1" };
            }
        ]
    ]
];

DEBUG_1("(addCrew) _seatCfg=%1", _seatCfg);
DEBUG_1("(addCrew) class _seatCfg=%1", _seatCfg get Q(class));
DEBUG_1("(addCrew) _vehicleCfg=%1", _vehicleCfg);
DEBUG_1("(addCrew) class _vehicleCfg=%1", _vehicleCfg get Q(class));
DEBUG_1("(addCrew) Defaults=%1", SETTING(_self,Defaults));
DEBUG_1("(addCrew) class Defaults=%1", SETTING(_self,Defaults) get Q(class));

private _unitKit = _seatCfg getOrDefault [
    Q(kit),
    _vehicleCfg getOrDefault [
        Q(kit),
        SETTING(_self,Defaults) getOrDefault [Q(kit), ""]
    ]
];

private _combatAllowed = _seatCfg getOrDefault [
    Q(allowCombat),
    _vehicleCfg getOrDefault [
        Q(allowCombat),
        SETTING(_self,Defaults) getOrDefault [Q(allowCombat), false]
    ]
];

private _unitGroup = group player;
if !(_joinPlayer) then {
    _unitGroup = _vehicle getVariable [QGVAR(Group), grpNull];
    if (isNull _unitGroup) then {
        _unitGroup = createGroup (side player);
        _vehicle setVariable [QGVAR(Group), _unitGroup, true];
        DEBUG_1("(addCrew) Creating vehicle's group %1", _unitGroup);
    };
    DEBUG_1("(addCrew) Using vehicle's group %1", _unitGroup);
};

DEBUG_4("(addCrew) Going to create unit - group=%1 class=%2 kit=%3 combatAllowed=%4", _unitGroup, _unitClass, _unitKit, _combatAllowed);
private _unit = _unitGroup createUnit [_unitClass, getPosATL _vehicle, [], 0, "NONE"];
_unit setVariable [Q(CrewOption), true, true];

(_self get Q(AddedCrew)) pushBack _unit;

DEBUG_1("(addCrew) Unit has been created %1", _unit);

// -- Move in seat 
private _seatFncName = _seat;
private _seatFncParams = [_unit, _vehicle];
if (_seat isEqualType []) then {
    _seatFncName = "turret";
    _seatFncParams pushBack _seat;
};
private _seatFnc = _self get Q(MoveToSeatFunctions) get _seatFncName;

_seatFncParams call _seatFnc;
DEBUG_1("(addCrew) Move unit in vehicle to seat %1",_seatFncName);

// -- Apply dzn_gear kit
if (_unitKit != "") then { [_unit, _unitKit] call dzn_fnc_gear_assignKit; };

// -- Set up behavior
_unit setSkill 1;
_unit setSkill ["courage", 1];

_unit allowFleeing 0;
_unit disableAI "LIGHTS";
_unit disableAI "RADIOPROTOCOL";

if (!_combatAllowed) then {
    DEBUG_1("(addCrew) Disable combat abilitites as not allowed",1);
    _unit disableAI "AUTOTARGET";
    _unit disableAI "AUTOCOMBAT";
    _unit disableAI "CHECKVISIBLE";
    _unit disableAI "FSM";
    
};

if (_unitGroup != group player) then {
    DEBUG_1("(addCrew) Disable combat behavior as not in player group",1);
    _unitGroup setCombatMode (["GREEN", "RED"] select _combatAllowed);
    _unitGroup setBehaviour (["AWARE", "COMBAT"] select _combatAllowed);
};

hintSilent parseText format [
    Q(CREW_OPTIONS_HINT_MEMBER_ADDED),
    _seatName
];

_unit