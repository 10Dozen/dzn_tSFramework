#include "script_component.hpp"

/* TBD
    Checks that player is admin or have whitelisted role name to access 
	crew menu for particular vehicle (and it's config).

    (_self)

    Params:
        _vehicle (OBJECT) - vehicle to check against
    Returns:
        none

    _self call ["fnc_actionCondition", [_vehicle]];
*/
[_vehicle, _seat, true]

params ["_vehicle", "_seatCfg", ["_joinPlayer", false]];

private _seat = _seatCfg get Q(seat);
private _seatName = _seatCfg getOrDefault [Q(name), _seat];

private _currentSeatUnit = _self call [F(getUnitOnSeat), [_vehicle, _seat]];
if (!isNull _currentSeatUnit) then {
	if (alive _currentSeatUnit) exitWith {
		hint format ["Место %1 уже занято!", _seatName];
	};

	moveOut _currentSeatUnit;
};

// Creating new unit
private _configName = _vehicle getVariable GAMELOGIC_FLAG;

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
private _unitGroup = if (_joinPlayer) then {
	group player
} else {
	createGroup _unitSide
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
