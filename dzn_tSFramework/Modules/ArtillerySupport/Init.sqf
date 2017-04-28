// call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\ArtillerySupport\Init.sqf";

call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\ArtillerySupport\Settings.sqf";
call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\ArtillerySupport\Functions.sqf";


if (hasInterface) then {
	[] spawn {
		waitUntil { !(tSF_ArtillerySupport_Batteries isEqualTo []) };
		waitUntil { !isNil "tSF_fnc_ACEActions_addAction" };
		waitUntil { sleep 2; player call tSF_fnc_ArtillerySupport_isAuthorizedUser };
		
		tSF_ArtillerySupport_ACEActions = [
			["SELF", "Radio (Support)", "tsf_radio_support", "", {}, { true }]		
		];
		
		{
			tSF_ArtillerySupport_ACEActions pushBack [
				"SELF"
				, format ["%1 (%2)", _x select 1, (typeof (_x select 0 select 0)) call dzn_fnc_getVehicleDisplayName]
				, format ["tsf_radio_ArtillerySupport_%1", _forEachIndex]
				, "tsf_radio_support"
				, compile format ["'%1' call tSF_fnc_ArtillerySupport_ShowMenu;", _x select 1]
				, { player call tSF_fnc_ArtillerySupport_isAuthorizedUser }			
			];
		} forEach tSF_ArtillerySupport_Batteries;
		
		tSF_ArtillerySupport_ACEActions call tSF_fnc_ACEActions_processActionList;
	};
};

if (isServer) then {
	waitUntil { time > tSF_ArtillerySupport_initTimeout };
	
	// tSF_ArtillerySupport_Guns = [];
	tSF_ArtillerySupport_Batteries = [];
	
	call tSF_ArtillerySupport_processLogics;

	
};
