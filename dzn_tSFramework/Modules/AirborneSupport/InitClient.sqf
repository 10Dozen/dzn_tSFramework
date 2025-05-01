#include "script_component.hpp"

LOG("Client pre-init started");
[
	{
		local player
		&& time > GVAR(initTimeout)
		&& GVAR(initCondition)
		&& !isNil QGVAR(Vehicles) && {
			!(GVAR(Vehicles) isEqualTo [])
			&& !isNil "tSF_fnc_ACEActions_addAction"
		}
	}
	,{
		LOG("Client init started");

		GVAR(TeleportMenu) = [];

		private _condition = { true };
		if (GVAR(RequiredLRRadio)) then {
			// Check for LR; if functions are not defined - return true
			_condition = {
				(!isNil "TFAR_fnc_haveLRRadio" && !isNil "TFAR_fnc_hasVehicleRadio"
				&& {call TFAR_fnc_haveLRRadio || (vehicle player) call TFAR_fnc_hasVehicleRadio})
				|| isNil "TFAR_fnc_haveLRRadio"
			};
		};

		private _actionList = [["SELF", "Radio (Airborne)", QGVAR(RadioNode), "", { [] call FUNC(showInfo) }, _condition]];
		{
			_x params ["_veh","_callsign"];

			private _statement = compile format ["'%1' call %2;", _callsign, QFUNC(ShowRequestMenu)];

			_actionList pushBack [
				"SELF"
				, format ["%1 (%2)", _callsign, (typeof _veh) call dzn_fnc_getVehicleDisplayName]
				, format ["%1_%2", QGVAR(RadioNode), _forEachIndex]
				, QGVAR(RadioNode)
				, _statement
				, { player call FUNC(isAuthorizedUser) }
			];

			// -- Action outside vehicle
			[[_veh], format ["Support (%1)", _callsign], QGVAR(SupportNode), "", _statement, { true }] call tSF_fnc_ACEActions_addAction;

			// -- Action inside vehicle
			[_veh,1,["ACE_SelfActions"],
				[QGVAR(SupportNode), format ["Support (%1)", _callsign], "", _statement, { true }] call ace_interact_menu_fnc_createAction
			] call ace_interact_menu_fnc_addActionToObject
		} forEach GVAR(Vehicles);

		if (GVAR(AllowTeleport)) then {
			_actionList pushBack [
				"SELF", "Re-Deploy"
				, QGVAR(TeleportNode)
				, QGVAR(RadioNode)
				, { player call FUNC(showTeleportMenu) }
				, { player call FUNC(isAuthorizedUser) }
			];
		};

		_actionList call tSF_fnc_ACEActions_processActionList;
		LOG("Client initialized");
	}
] call CBA_fnc_waitUntilAndExecute;
