#include "script_component.hpp"

/*
	Starts medicare actions on given unit:
	- place on stretchers
	- heal
	- return to normal state

	Params:
	_unit - (unit) unit to heal

	Return: none

	Example:
	[player] call tSF_CCP_fnc_doMedicare;
*/

params ["_unit"];

// Skip if already healing
if (_unit getVariable [QGVAR(isHealing), false]) exitWith {};

// Check for free stretcher and exit if there is none
private _stretcherPositions = CCP_LOGIC getVariable QGVAR(StretchersPositions);
private _usedStretchers = CCP_LOGIC getVariable QGVAR(StretchersInUse);

if (isPlayer _unit && count _stretcherPositions == count _usedStretchers) exitWith {
	hint parseText format [
		"<t color='#EDB81A' size='1.5' align='center' font='PuristaBold'>%1</t>
		<br/><t font='PuristaBold'>%2</t>"
		, QUOTE(STR_FULL_NAME)
		, "Medical Care is not available right now! Too many patients."
	];
};

// Unit is not local - pass execution to the owner
if (!local _unit) exitWith {
	[_unit] remoteExec [QFUNC(doMedicare), _unit];
};

// Exit if local unit is not local player (but it's AI or server's AI)
if (_unit != player) exitWith {
	// Simply heal AI unit
	if (!isNil "ace_medical_treatment_fnc_fullHealLocal") then { [_unit] call ace_medical_treatment_fnc_fullHealLocal; };
	_unit setDamage 0;
};

// Start medicare
player setVariable [QGVAR(isHealing), true, true];

// Select stretchers for unit
private _stretcherId = -1;
for "_i" from 0 to (count _stretcherPositions - 1) do {
	if !(_i in _usedStretchers) exitWith { _stretcherId = _i; };
};

// Update list of used stretchers to other clients
_usedStretchers pushBack _stretcherId;
CCP_LOGIC setVariable [QGVAR(StretchersInUse), _usedStretchers, true];

// Provide healing
0 cutText ["", "WHITE OUT", 0.5];
[{
	params ["_stretcherPosAndDir", "_stretcherId"];
	_stretcherPosAndDir params ["_pos", "_dir"];

	private _stretcher = STRETCHER_CLS createVehicle _pos;
	_stretcher setPosATL _pos;
	_stretcher setDir _dir;

	// PLay animation
	player attachTo [_stretcher, [0, 0, 0.2]];
	player setVectorUp (vectorUp _stretcher);
	[
		player
		, selectRandom HEALING_ANIMS
		, QUOTE(_this getVariable [ARR_2(QQGVAR(isHealing),false)])
		, true
	] spawn dzn_fnc_playAnimLoop;

	// Show progress bar with a title
	[
		"<t align='center' shadow='2' font='PuristaMedium'>MEDICAL AID</t>"
		, [1,18.5,74,0.04]
		, [0,0,0,0]
		, QUOTE(!(player getVariable [ARR_2(QQGVAR(isHealing),false)]))
	] call dzn_fnc_ShowMessage;
	[1, GVAR(TimeToHeal) + GVAR(TimeToHold), 1, "BOTTOM", {}, 10] spawn dzn_fnc_ShowProgressBar;

	0 cutText ["", "WHITE IN", 1];

	// Wait for TimeToHeal timer...
	[{
		// Heal player
		if (!isNil "ace_medical_treatment_fnc_fullHealLocal") then {
			[player] call ace_medical_treatment_fnc_fullHealLocal;
		};
		player setDamage 0;

		// Wait for TimeToHold timer...
		[{
			0 cutText ["", "WHITE OUT", 0.1];

			// Wait a bit and release player...
			[{
				params ["_stretcher", "_stretcherId"];
				player setVariable [QGVAR(isHealing), false, true];
				detach player;
				deleteVehicle _stretcher;

				// Free used stretchers position
				private _usedStretchers = CCP_LOGIC getVariable QGVAR(StretchersInUse);
				_usedStretchers deleteAt (_usedStretchers findIf { _x == _stretcherId });
				CCP_LOGIC setVariable [QGVAR(StretchersInUse), _usedStretchers, true];

				0 cutText ["", "WHITE IN", 2];
			}, _this, 2] call CBA_fnc_waitAndExecute;
		}, _this, GVAR(TimeToHold)] call CBA_fnc_waitAndExecute;
	}, [_stretcher, _stretcherId], GVAR(TimeToHeal)] call CBA_fnc_waitAndExecute;
}, [_stretcherPositions # _stretcherId, _stretcherId], 1] call CBA_fnc_waitAndExecute;
