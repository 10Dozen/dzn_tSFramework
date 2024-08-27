#include "script_component.hpp"


/*
    Opens Crew menu for given vehicle.

    (_self)

    Params:
        _vehicle (OBJECT) - vehicle to check against
    Returns:
        none

    _self call ["fnc_actionCondition", [_vehicle]];
*/

params["_vehicle"];

private _cfg = SETTING_OR_DEFAULT_3(_self,Configs,_vehicle getVariable GAMELOGIC_FLAG);

private _slotsControls = [];
private _seats = _cfg get Q(crew);

{
	private _seat = _x get Q(seat);
	private _seatName = _x getOrDefault [Q(name), _seat];
	private _seatCurrentUnit = _self call [F(getUnitOnSeat), [_vehicle, _seat]];

	// Format name -- white if seat is empty, gray if occupied by player, light green if occupied by AI
	_slotsControls pushBack [
		"LABEL", 
		format [
			"<t color='%1'>%2</t>",
			[
				[COLOR_HEX_LIGHT_GREEN, COLOR_HEX_GRAY] select (isPlayer _seatCurrentUnit),
				COLOR_HEX_WHITE
			] select (isNull _seatCurrentUnit),
			_seatName
		]
	];

	// Added Add or Remove actions
	if (isNull _seatCurrentUnit) then {
		_slotsControls append [
			["BUTTON", "+", {
				params ["","_args"];
				_args params ["_crewOptionsCOB", "_vehicle", "_seat"];
				_crewOptionsCOB call [F(AddCrew), [_vehicle, _seat, false]];
			}, [_self, _vehicle, _seat], [["w", 0.25],["tooltip","Добавить AI-юнита на место в экипаже"]]],
			["BUTTON", "++", {
				params ["","_args"];
				_args params ["_crewOptionsCOB", "_vehicle", "_seat"];
				_crewOptionsCOB call [F(AddCrew), [_vehicle, _seat, true]];
			}, [_self, _vehicle, _seat], [["w", 0.25],["tooltip","Добавить AI-юнита на место в экипаже и присоединить к группе"]]],
			["BR"]
		];
		continue;
	};

	_slotsControls append [
		["BUTTON", "-", {
			params ["","_args"];
			_args params ["_crewOptionsCOB", "_vehicle", "_seat"];
			_crewOptionsCOB call [F(RemoveCrew), [_vehicle, _seat, true]];
		}, [_self, _vehicle, _seat], [
			["w", 0.25],
			["tooltip","Удалить AI-юнита на выбранном месте."],
			["enabled", !(isPlayer _seatCurrentUnit)]
		]],
		["BR"]
	];	
} forEach _seats;



private _menu = [
	["HEADER", "Управление экипажем"],
	["LABEL"],
	["BR"]
];
_menu append _slotsControls;
_menu append [
	["BR"],
	["LABEL", "", [["w", 0.6]]], 
	["BUTTON", "Закрыть", { params ["_cob"]; _cob call ["Close"]; }]
];

_menu call dzn_fnc_ShowAdvDialog2;