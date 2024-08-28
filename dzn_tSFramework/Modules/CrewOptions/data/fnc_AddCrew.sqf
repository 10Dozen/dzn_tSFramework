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

/* -- Select group for unit:
    1) Use player group if function params is set to True
	2) Otherwise - check group related to vehicle 
		2.1) If group doesn't exists - create new group
		2.2) Otherwise - check existing group 
			2.2.1) If group is not controlled by player (e.g. player joined and became a leader):
                     - if some units are not in vehicle (disembarked), expel'em  to a new group
*/   
private _unitGroup = group player;
if !(_joinPlayer) then {
	_unitGroup = _vehicle getVariable [QGVAR(Group), grpNull];
	if (isNull _unitGroup) then {
		_unitGroup = createGroup _unitSide;
		_vehicle setVariable [QGVAR(Group), _unitGroup, true];
	} else {
		if (!isPlayer (leader _unitGroup)) then {
			private _expelGroup = nil;
			{
				if !(_x in _vehicle) then {
					if (isNil "_expelGroup") then { _expelGroup = createGroup _unitSide; };
					_x joinSilent _expelGroup;
				};
			} forEach (units _unitGroup);
		};
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
