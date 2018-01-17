call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\AirborneSupport\Settings.sqf";
call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\AirborneSupport\Functions.sqf";
call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\AirborneSupport\Functions Request.sqf";

if (hasInterface) then {
	[] spawn {
		waitUntil { !isNil "tSF_AirborneSupport_Vehicles" && { !(tSF_AirborneSupport_Vehicles isEqualTo []) } };
		waitUntil { !isNil "tSF_fnc_ACEActions_addAction" };
		
		private _actionList = [["SELF", "Radio (Support)", "tsf_radio_support", "", {}, { true }]];
		{
			private _callsign = _x select 1;
			private _veh = _x select 0;
			
			_actionList pushBack [
				"SELF"
				, format ["%1 (%2)", _callsign, (typeof _veh) call dzn_fnc_getVehicleDisplayName]
				, format ["tsf_radio_AirborneSupport_%1", _forEachIndex]
				, "tsf_radio_support"
				, compile format ["'%1' call tSF_fnc_AirborneSupport_ShowMenu;", _callsign]
				, { player call tSF_fnc_AirborneSupport_isAuthorizedUser }				
			];
		} forEach tSF_AirborneSupport_Vehicles;
		
		if (tSF_AirborneSupport_Teleport) then {
			_actionList pushBack [
				"SELF", "Re-Deploy"
				, "tsf_radio_AirborneSupport_teleport"
				, "tsf_radio_support"
				, { player call tSF_fnc_AirborneSupport_showTeleportMenu }
				, { player call tSF_fnc_AirborneSupport_isAuthorizedUser }
			];
		};
			
		_actionList call tSF_fnc_ACEActions_processActionList;
	};
};

if (isServer) then {
	waitUntil { time > tSF_AirborneSupport_initTimeout };
	
	tSF_AirborneSupport_Vehicles = [];	// [@Vehicle, @Name]
	tSF_AirborneSupport_ReturnPoints = [];
	tSF_AirborneSupport_ReturnPointsList = [];
	
	call tSF_fnc_AirborneSupport_processLogics;
	{ _x call tSF_fnc_AirborneSupport_processVehicleServer } forEach tSF_AirborneSupport_Vehicles;
	
	publicVariable "tSF_AirborneSupport_Vehicles";
	publicVariable "tSF_AirborneSupport_ReturnPoints";
	publicVariable "tSF_AirborneSupport_ReturnPointsList";
};
