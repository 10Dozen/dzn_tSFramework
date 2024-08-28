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

private _configName = _vehicle getVariable GAMELOGIC_FLAG;
if (isNil "_configName") exitWith {
	TSF_ERROR_1(TSF_ERROR_TYPE__NO_CONFIG, "(AddCrew) У машины %1 не задан конфиг опций экипажа", _vehicle);
	objNull
};
if !(_configName in SETTING(_self,Configs)) exitWith {
	TSF_ERROR_2(TSF_ERROR_TYPE__NO_CONFIG, "(AddCrew) Конфиг опций экипажа %1 для машины %2 не найден в настройках модуля", _configName, _vehicle);
	objNull
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
};

// --- Creating new unit
// 

private _unitSide = side player;
private _unitClass = _seatCfg getOrDefault [
	Q(class), 
	SETTING_2(_self,Configs,_configName) getOrDefault [
		Q(class), 
		SETTING_2(_self,Defaults,class)
	]
];
private _unitKit = _seatCfg getOrDefault [
	Q(kit), 
	SETTING_2(_self,Configs,_configName) getOrDefault [
		Q(kit), 
		SETTING_2(_self,Defaults,kit)
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

private _unit = _unitGroup createUnit [_unitClass, getPosATL _vehicle, [], 0, "NONE"];
[_unit, _unitKit] call dzn_fnc_gear_assignKit;

private _seatFncName = _seat;
private _seatFncParams = [_unit, _vehicle];
if (_seat isEqualType []) then {
    _seatFncName = "turret";
    _seatFncParams pushBack _seat;
};
private _seatFnc = _self get Q(MoveToSeatFunctions) get _seatFncName;
_seatFncParams call _seatFnc;

_unit setSkill 1;
_unit setSkill ["courage", 1];
_unit allowFleeing 0;
_unit disableAI "LIGHTS";
_unit disableAI "AUTOTARGET";
_unit disableAI "AUTOCOMBAT";
_unit disableAI "CHECKVISIBLE";
_unit disableAI "FSM";
_unit disableAI "RADIOPROTOCOL";

_unit