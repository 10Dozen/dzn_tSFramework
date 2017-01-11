call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\Support\Settings.sqf";
call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\Support\Functions.sqf";
call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\Support\Functions RTB.sqf";
call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\Support\Functions PickUp.sqf";
call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\Support\Functions CallIn.sqf";

if (hasInterface) then {
	[] spawn {
		waitUntil { !isNil "tSF_Support_Vehicles" && { !(tSF_Support_Vehicles isEqualTo []) } };
		waitUntil { !isNil "tSF_IACE_addAction" };
		
		{ _x call tSF_fnc_Support_processVehicleClient } forEach tSF_Support_Vehicles;
	
		if (
			/* player call tSF_fnc_Support_isAuthorizedUser */
			true
		) then {
			tSF_Support_ACEActions = [
				["SELF", "Radio (Support)", "tsf_radio_support", "", {}, { true }]		
			];
			
			{
				private _callsign = _x select 1;
				private _veh = _x select 0;
				
				tSF_Support_ACEActions pushBack [
					"SELF"
					, format ["%1 (%2)", _callsign,  (typeof _veh) call tSF_fnc_Support_getVehicleDisplayName]
					, format ["tsf_radio_support_%1", _forEachIndex]
					, "tsf_radio_support"
					, compile format ["'%1' call tSF_fnc_Support_ShowMenu;", _callsign]
					, { player call tSF_fnc_Support_isAuthorizedUser }				
				];
			} forEach tSF_Support_Vehicles;
			
			if (tSF_Support_Teleport) then {
				tSF_Support_ACEActions pushBack [
					"SELF", "Re-Deploy"
					, "tsf_radio_support_teleport"
					, "tsf_radio_support"
					, { player call tSF_fnc_Support_showTeleportMenu }
					, { player call tSF_fnc_Support_isAuthorizedUser }
				];
			};
			
			tSF_Support_ACEActions call tSF_IACE_processActionList;
		};
	};
};

if (isServer) then {
	waitUntil { time > tSF_Support_initTimeout };
	
	tSF_Support_Vehicles = [];
	tSF_Support_ReturnPoints = [];
	tSF_Support_ReturnPointsList = [];
	
	call tSF_fnc_Support_processLogics;
	{ _x call tSF_fnc_Support_processVehicleServer } forEach tSF_Support_Vehicles;
	
	call tSF_fnc_Support_StartRequestHandler;
	
	publicVariable "tSF_Support_Vehicles";
	publicVariable "tSF_Support_ReturnPoints";
	publicVariable "tSF_Support_ReturnPointsList";
};
