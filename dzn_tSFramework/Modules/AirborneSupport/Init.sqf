
[{ !isNil "tSF_Authorization_Initialized" }, {
	diag_log "tSF: AirborneSupport: Initialization started";
	call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\AirborneSupport\Settings.sqf";
	call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\AirborneSupport\Functions.sqf";
	call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\AirborneSupport\Functions Request.sqf";

	if (hasInterface) then {
		[
			{
				!isNil "tSF_fnc_ACEActions_addAction"
				&& !isNil "tSF_AirborneSupport_Vehicles"
				&& { !(tSF_AirborneSupport_Vehicles isEqualTo []) }
			}
			,{
				diag_log "tSF: AirborneSupport: Client init started";
				private _condition = { true };
				if (tSF_AirborneSupport_RequiredLRRadio) then {
					// Check for LR; if functions are not defined - return true
					_condition = { 
						(!isNil "TFAR_fnc_haveLRRadio" && !isNil "TFAR_fnc_hasVehicleRadio" 
						&& {call TFAR_fnc_haveLRRadio || (vehicle player) call TFAR_fnc_hasVehicleRadio})
						|| isNil "TFAR_fnc_haveLRRadio"
					};
				};

				private _actionList = [["SELF", "Radio (Airborne)", "tsf_radio_airborneSupport", "", {}, _condition]];
				{
					_x params ["_veh","_callsign"];
					_actionList pushBack [
						"SELF"
						, format ["%1 (%2)", _callsign, (typeof _veh) call dzn_fnc_getVehicleDisplayName]
						, format ["tsf_radio_AirborneSupport_%1", _forEachIndex]
						, "tsf_radio_airborneSupport"
						, compile format ["'%1' call tSF_fnc_AirborneSupport_ShowMenu;", _callsign]
						, { player call tSF_fnc_AirborneSupport_isAuthorizedUser }
					];
				} forEach tSF_AirborneSupport_Vehicles;

				if (tSF_AirborneSupport_AllowTeleport) then {
					_actionList pushBack [
						"SELF", "Re-Deploy"
						, "tsf_radio_AirborneSupport_teleport"
						, "tsf_radio_airborneSupport"
						, { player call tSF_fnc_AirborneSupport_showTeleportMenu }
						, { player call tSF_fnc_AirborneSupport_isAuthorizedUser }
					];
				};

				_actionList call tSF_fnc_ACEActions_processActionList;
				diag_log "tSF: AirborneSupport: Client initialized";
			}
			, []
			, 2
		] call CBA_fnc_waitUntilAndExecute;
	};

	if (isServer) then {
		[tSF_AirborneSupport_initCondition, {
			diag_log "tSF: AirborneSupport: Server init started";
			tSF_AirborneSupport_Vehicles = []; // [@Vehicle, @Name]
			tSF_AirborneSupport_ReturnPoints = [];

			[] call tSF_fnc_AirborneSupport_processLogics;
			publicVariable "tSF_AirborneSupport_Vehicles";
			publicVariable "tSF_AirborneSupport_ReturnPoints";

			diag_log "tSF: AirborneSupport: Server initialized";
		}, [], tSF_AirborneSupport_initTimeout] call CBA_fnc_waitUntilAndExecute;
	};
}] call CBA_fnc_waitUntilAndExecute;