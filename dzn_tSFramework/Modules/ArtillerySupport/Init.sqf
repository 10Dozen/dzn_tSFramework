

call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\ArtillerySupport\Settings.sqf";
call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\ArtillerySupport\Functions.sqf";
call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\ArtillerySupport\Functions Request.sqf";

if (hasInterface) then {
	[] spawn {
		private _actionList = [ ["SELF", "Radio (Artillery)", "tsf_radio_artillery_support", "", { }, { player call tSF_fnc_ArtillerySupport_isAuthorizedUser }] ];
		
		waitUntil { !isNil "tSF_fnc_ACEActions_processActionList" };
		waitUntil { !isNil "tSF_ArtillerySupport_Batteries" && { !(tSF_ArtillerySupport_Batteries isEqualTo []) } };
		
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
	tSF_ArtillerySupport_TRPs = [];
	
	call tSF_fnc_ArtillerySupport_processLogics;
	
	publicVariable "tSF_ArtillerySupport_Batteries";
};


/*
	[TO DO]
	
	[+] Rearm guns on shooting
	[+] Handle TRP gathering
	[+] Firemissions on TRP position
	[+] Add firemission spreading temlpate:
	[+] Crew caching
	[+] Hints for actions
	[+] Spawn crew before InRange calculation
	[+] Mission start timeout + hint
	[+] MP Compatibility (e.g. now other user can request FM during FM in progress)
	[ ] Remove debugging info