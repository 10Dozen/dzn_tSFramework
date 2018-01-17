call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\ArtillerySupport\Settings.sqf";
call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\ArtillerySupport\Functions.sqf";
call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\ArtillerySupport\Functions Request.sqf";

if (hasInterface) then {
	[] spawn {		
		waitUntil { !isNil "tSF_fnc_ACEActions_processActionList" };
		waitUntil { !isNil "tSF_ArtillerySupport_Batteries" && { !(tSF_ArtillerySupport_Batteries isEqualTo []) } };
		
		private _actionList = [ ["SELF", "Radio (Artillery)", "tsf_radio_artillery_support", "", { }, { player call tSF_fnc_ArtillerySupport_isAuthorizedUser }] ];
		{
			// [ @Logic, @Callsign, @VehicleDisplayName, @Vehicles ]
			_actionList pushBack [
				"SELF"
				, format ["%1 (%2)", _x select 1, _x select 2]
				, format ["tsf_radio_artillery_support_%1", _forEachIndex]
				, "tsf_radio_artillery_support"
				, compile format ["'%1' call tSF_fnc_ArtillerySupport_ShowMenu;", _x select 1]
				, { player call tSF_fnc_ArtillerySupport_isAuthorizedUser }			
			];
		} forEach tSF_ArtillerySupport_Batteries;
	
		_actionList call tSF_fnc_ACEActions_processActionList;
	};
};

if (isServer) then {
	waitUntil { time > tSF_ArtillerySupport_initTimeout };
	
	tSF_ArtillerySupport_Batteries = [];
	
	call tSF_fnc_ArtillerySupport_processLogics;
	
	publicVariable "tSF_ArtillerySupport_Batteries";
};
