waitUntil { !isNil "tSF_Authorization_Initialized" };

call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\ArtillerySupport\Settings.sqf";
call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\ArtillerySupport\Functions.sqf";
call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\ArtillerySupport\Functions Request.sqf";

waitUntil tSF_ArtillerySupport_initCondition;

if (hasInterface) then {
	[] spawn {
		waitUntil { !isNil "tSF_fnc_ACEActions_processActionList" };
		waitUntil { !isNil "tSF_ArtillerySupport_Batteries" && { !(tSF_ArtillerySupport_Batteries isEqualTo []) } };

		private _actionList = [ ["SELF", "Radio (Artillery)", "tsf_radio_artillery_support", "", { }, { player call tSF_fnc_ArtillerySupport_isAuthorizedUser }] ];
		{
			_x params ["_logic","_callsign","_name","_gunsObjects","_isVirtual","_condition"];
			
			private _conditionCode = "player call tSF_fnc_ArtillerySupport_isAuthorizedUser";
			if (_condition != "") then {
				_conditionCode = _conditionCode + " && {" + _condition + "}";
			};
		
			// [ @Logic, @Callsign, @VehicleDisplayName, @Vehicles ]
			_actionList pushBack [
				"SELF"
				, format ["%1 (%2)", _callsign, _name]
				, format ["tsf_radio_artillery_support_%1", _forEachIndex]
				, "tsf_radio_artillery_support"
				, compile format ["'%1' call tSF_fnc_ArtillerySupport_ShowMenu;", _callsign]
				, compile _conditionCode
			];
		} forEach tSF_ArtillerySupport_Batteries;

		_actionList call tSF_fnc_ACEActions_processActionList;
	};
};

if (isServer) then {
	waitUntil { time > tSF_ArtillerySupport_initTimeout };

	tSF_ArtillerySupport_Batteries = [];
	tSF_ArtillerySupport_BatteriesRequestedReload = [];
	[] call tSF_fnc_ArtillerySupport_processLogics;
	publicVariable "tSF_ArtillerySupport_Batteries";
};
