/*
 *
 *	Playable Units
 *
 */

dzn_fnc_tSF_3DEN_AddSquad = {

	disableSerialization;
	private _types = "list names" call dzn_fnc_tSF_3DEN_getSquadAttributes;
	private _result = [
		"Add Squad"
		, [
			["Callsign (e.g. Razor 1'1)", []]
			,["Side", ["BLUFOR","OPFOR","INDEPENDENT","CIVILIANS"]]
			,["Doctrine", _types]
		]
	] call dzn_fnc_3DEN_ShowChooseDialog;
	if (_result isEqualTo []) exitWith { dzn_tSF_3DEN_toolDisplayed = false };

	collect3DENHistory {	
		[
			if (typename (_result select 0) == "STRING") then { _result select 0 } else { "" }
			, _result select 1
			, _result select 2
			, screenToWorld [0.5, 0.5]
		] call dzn_fnc_tSF_3DEN_AddSquadUnits;
	
		"tSF Tools - New Squad was Added" call dzn_fnc_tSF_3DEN_ShowNotif;
	};
};

dzn_fnc_tSF_3DEN_AddPlatoon = {
	disableSerialization;
	private _platoons = "list names" call dzn_fnc_tSF_3DEN_getPlatoonAttributes;
	private _result = [
		"Add Platoon"
		, [
			["Callsign (e.g. Razor)", []]
			,["Platoon # ", ["1","2","3","4","5", ""]]
			,["Side", ["BLUFOR","OPFOR","INDEPENDENT","CIVILIANS"]]
			,["Doctrine", _platoons]		
		]		
	] call dzn_fnc_3DEN_ShowChooseDialog;
	if (_result isEqualTo []) exitWith { dzn_tSF_3DEN_toolDisplayed = false };
	
	private _platoonName = if (typename (_result select 0) == "STRING") then { format ["%1 ", _result select 0] } else { "" };
	private _platoonNumber = 1 + (_result select 1);
	private _side = _result select 2;
	private _squadTypes = (_result select 3) call dzn_fnc_tSF_3DEN_getPlatoonAttributes;
	
	private _basicPoint = screenToWorld [0.5, 0.5];
	private _subCallsign = _squadTypes select 0;
	
	collect3DENHistory {		
		{		
			// _x = [1, "US Squad"]	
			private _sqNo = format [_subCallsign, _platoonNumber, _x select 0];	// ["%1'%2", 1, 1]
			
			[
				format ["%1%2", _platoonName, _sqNo]
				, _side
				, _x select 1
				, [ (_basicPoint select 0) + 12*_forEachIndex, (_basicPoint select 1), 0]
			] call dzn_fnc_tSF_3DEN_AddSquadUnits;
		} forEach (_squadTypes - [_subCallsign]);
		
		"tSF Tools - New Platoon was Added" call dzn_fnc_tSF_3DEN_ShowNotif;	
	};
};

dzn_fnc_tSF_3DEN_AddSquadUnits = {
	// [ "Raven 1'1", 0 (west), "US Squad"]
	params["_callsign", "_side", "_type", "_basicPos"];
	
	if (_callsign != "") then { _callsign = format["%1 ", _callsign] };
	private _infantryClass = switch (_side) do {
		case 0: { "B_Soldier_F" };
		case 1: { "O_Soldier_F" };
		case 2: { "I_soldier_F" };
		case 3: { "C_man_1" };
	};
	
	private _squadSettings = _type call dzn_fnc_tSF_3DEN_getSquadAttributes;		
	private _squadRelativePoses = [
		[0,0,0]
		, [2,-1,0]	, [4,-1,0]	, [6,-1,0]	, [8,-1,0]
		, [2,-5,0]	, [4,-5,0]	, [6,-5,0]	, [8,-5,0]
	];
	
	private _unit = create3DENEntity ["Object", _infantryClass, _basicPos];	
	private _grp = group _unit;
	call dzn_fnc_tSF_3DEN_createUnitLayer;
	
	{
		// _x = ["RED - FTL","Corporal"]
		if (_forEachIndex > 0) then {
			_unit = _grp create3DENEntity [
				"Object"
				, _infantryClass
				, [
					(_basicPos select 0) + ((_squadRelativePoses select _forEachIndex) select 0)
					, (_basicPos select 1) + ((_squadRelativePoses select _forEachIndex) select 1)		
					, 0
				]
			];
		};
		
		set3DENAttributes [
			[[_unit], 	"description", 	format [_x select 0, _callsign]]
			,[[_unit], 	"rank", 		_x select 1]
			,[[_unit], 	"ControlMP",	 	true]
		];
	} forEach _squadSettings;
	
	set3DENAttributes [
		[[_grp], "behaviour", "Safe"]
		,[[_grp], "speedMode", "Limited"]
		,[[_grp], "groupID", if (_callsign == "") then { nil } else { _callsign splitString " " joinString " " }]
	];
	_grp set3DENLayer dzn_tSF_3DEN_UnitsLayer;
	
	_grp
};
