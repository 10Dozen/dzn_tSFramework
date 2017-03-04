/*
 *
 *	ACTIONS
 *
 */

dzn_fnc_tSF_3DEN_AddSquad = {

	disableSerialization;
	private _types = "list names" call dzn_tSF_3DEN_getSquadAttributes;
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
	private _platoons = "list names" call dzn_tSF_3DEN_getPlatoonAttributes;
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
	private _squadTypes = (_result select 3) call dzn_tSF_3DEN_getPlatoonAttributes;
	
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
	
	private _squadSettings = _type call dzn_tSF_3DEN_getSquadAttributes;		
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
		private _unit = _grp create3DENEntity [
			"Object"
			, _infantryClass
			, [
				(_basicPos select 0) + ((_squadRelativePoses select _forEachIndex) select 0)
				, (_basicPos select 1) + ((_squadRelativePoses select _forEachIndex) select 1)		
				, 0
			]
		];
		
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
	
	delete3DENEntities [(units _grp select 0)];
	
	_grp
};

/*
 *	Dynai Assets
 */
dzn_fnc_tSF_3DEN_AddDynaiCore = {
	collect3DENHistory {
		dzn_tSF_3DEN_DynaiCore = create3DENEntity ["Logic","Logic",screenToWorld [0.3,0.5]];
		dzn_tSF_3DEN_DynaiCore set3DENAttribute ["Name", "dzn_dynai_core"];
		
		call dzn_fnc_tSF_3DEN_createDynaiLayer;
		dzn_tSF_3DEN_DynaiCore set3DENLayer dzn_tSF_3DEN_DynaiLayer;
		
		"tSF Tools - DynAI Core was created" call dzn_fnc_tSF_3DEN_ShowNotif;
	};
}; 

dzn_fnc_tSF_3DEN_AddDynaiZone = {	
	if (isNull dzn_tSF_3DEN_DynaiCore) then { call dzn_fnc_tSF_3DEN_AddDynaiCore; };	
	
	disableSerialization;
	private _name = ["Add Dynai Zone", ["Zone name", []]] call dzn_fnc_3DEN_ShowChooseDialog;
	if (count _name == 0) exitWith { dzn_tSF_3DEN_toolDisplayed = false };
	
	dzn_tSF_3DEN_Parameter = _name;
	
	collect3DENHistory {
		private _name = dzn_tSF_3DEN_Parameter;
		
		private _pos = screenToWorld [0.5,0.5];
		private _dynaiZone = create3DENEntity ["Logic","Logic", _pos];
		private _dynaiArea = create3DENEntity [
			"Trigger"
			,"EmptyDetectorAreaR250"
			, [ (_pos select 0) + 50, _pos select 1, 0 ]
		];
		
		if (_name select 0 == "") then { 
			dzn_tSF_3DEN_DynaiZoneId = dzn_tSF_3DEN_DynaiZoneId + 1;
			_name = format ["Zone%1", dzn_tSF_3DEN_DynaiZoneId];		
		} else { 
			_name = _name select 0;
		};	
		
		_dynaiZone set3DENAttribute ["Name", _name];	
		
		call dzn_fnc_tSF_3DEN_createDynaiLayer;
		_dynaiZone set3DENLayer dzn_tSF_3DEN_DynaiLayer;
		_dynaiArea set3DENLayer dzn_tSF_3DEN_DynaiLayer;
		
		add3DENConnection ["Sync", [_dynaiZone], dzn_tSF_3DEN_DynaiCore];
		add3DENConnection ["Sync", [_dynaiZone], _dynaiArea];
		
		do3DENAction "ToggleMap";
		
		(format ["tSF Tools - ""%1"" DynAI Zone was created", _name]) call dzn_fnc_tSF_3DEN_ShowNotif;	
	};
};

dzn_fnc_tSF_3DEN_AddDynaiZoneAssets = {
	if (dzn_tSF_3DEN_SelectedUnits isEqualTo []) exitWith { "tSF Tools - Dynai: Assets - No zone selected" call dzn_fnc_tSF_3DEN_ShowWarn;};
	
	disableSerialization;
	private _modes = ["Area", "Keypoints", "Vehicle Points", ""];
	private _result = [
		"Add Zone Asset"
		,[
			["Asset", _modes]
		]
	] call dzn_fnc_3DEN_ShowChooseDialog;
	if (_result isEqualTo []) exitWith { dzn_tSF_3DEN_toolDisplayed = false };
	dzn_tSF_3DEN_Parameter = _result;
	
	collect3DENHistory {
		private _zone = dzn_tSF_3DEN_SelectedUnits select 0;
		private _assetsToAdd = [];
		private _assetsAttributes = [];
		private _mode = "";
		
		switch (dzn_tSF_3DEN_Parameter) do {
			/* Area */ case 0: {
				_assets pushBack (create3DENEntity ["Trigger","EmptyDetectorAreaR250", screenToWorld [0.5, 0.5]]);
			};
			/* Keypoints */ case 1: {				
				for "_i" from 0 to 2 do {
					_assets pushBack (create3DENEntity ["Logic","LocationArea_F", screenToWorld [0.5 + _i*.2, 0.5 + _i*.2]]);
				};
			};
			/* Vehicle Points */ case 2: {
				for "_i" from 0 to 2 do {
					_assets pushBack (create3DENEntity ["Logic","LocationOutpost_F", screenToWorld [0.5 + _i*.2, 0.5 + _i*.2]]);
				};				
			};
		};
		
		add3DENConnection ["Sync", _assets, _zone];
		(format ["tSF Tools - Dyani: %1 asset was added", _modes select dzn_tSF_3DEN_Parameter]) call dzn_fnc_tSF_3DEN_ShowNotif;
	};
};

/*
 * Gear / tSF Assets
 */

dzn_fnc_tSF_3DEN_AddGearLogic = {
	private _units = dzn_tSF_3DEN_SelectedUnits;
	if (_units isEqualTo []) exitWith {
		"tSF Tools - Gear: Kit logic - No units selected" call dzn_fnc_tSF_3DEN_ShowWarn;
	};
	
	disableSerialization;
	private _result = [
		"Set Kit logic"
		,[
			["Kit type", ["Gear kit","Cargo kit"]]
			, ["Kit name",[]]
		]
	] call dzn_fnc_3DEN_ShowChooseDialog;
	if (count _result == 0) exitWith { dzn_tSF_3DEN_toolDisplayed = false };
	
	dzn_tSF_3DEN_Parameter = _result;
	
	collect3DENHistory {
		private _result = dzn_tSF_3DEN_Parameter;
		private _type = if (_result select 0 == 0) then { "dzn_gear" } else { "dzn_gear_cargo" };
		private _kit = if (typename (_result select 1) == "STRING") then { _result select 1 } else { "KitName" };
		
		private _logic = create3DENEntity ["Logic","Logic", screenToWorld [0.5,0.5]];
		_logic set3DENAttribute [
			"Init"
			, format [
				"this setVariable ['%1', '%2'];"
				, _type
				, _kit
			]
		];
		
		call dzn_fnc_tSF_3DEN_createGearLayer;
		_logic set3DENLayer dzn_tSF_3DEN_GearLayer;
		
		add3DENConnection ["Sync", _units, _logic];	
		(format ["tSF Tools - Gear: ""%1"" Kit logic was assigned", _kit]) call dzn_fnc_tSF_3DEN_ShowNotif;
	};
};

dzn_fnc_tSF_3DEN_ResolveUnitBehavior = {
	private _units = dzn_tSF_3DEN_SelectedUnits;
	if (_units isEqualTo []) exitWith {
		"tSF Tools - Unit Behavior: No units selected" call dzn_fnc_tSF_3DEN_ShowWarn;
	};
	
	disableSerialization;
	private _result = [
		"Set Unit Behavior"
		,[
			[
				"Unit Behavior"
				, [
					"DynAI CQB"
					,"DynAI Response"
					,"tSF Surrender"
					,"DynAI Vehicle Hold (All Aspects)"
					,"DynAI Vehicle Hold (45 frontal)"
					,"DynAI Vehicle Hold (90 frontal)"
				]
			]
		]
	] call dzn_fnc_3DEN_ShowChooseDialog;
	
	if (count _result == 0) exitWith { dzn_tSF_3DEN_toolDisplayed = false };
	
	switch (_result select 0) do {
		case 0: {
			/* DYNAI CQB */
			call dzn_fnc_tSF_3DEN_AddCQBLogic;
		};
		case 1: {
			/* DYNAI CQB */
			call dzn_fnc_tSF_3DEN_AddGroupResponseLogic;
		};
		case 2: {
			/* EUB Surrender*/
			call dzn_fnc_tSF_3DEN_Add_EUBSurrender_Logic;
		};
		case 3: {
			"vehicle hold" call dzn_fnc_tSF_3DEN_AddVehicleHoldLogic;
		};
		case 4: {
			"vehicle 45 hold" call dzn_fnc_tSF_3DEN_AddVehicleHoldLogic;
		};
		case 5: {
			"vehicle 90 hold" call dzn_fnc_tSF_3DEN_AddVehicleHoldLogic;
		};		
	};
};

dzn_fnc_tSF_3DEN_AddCQBLogic = {
	collect3DENHistory {
		private _units = dzn_tSF_3DEN_SelectedUnits;
		if (_units isEqualTo []) exitWith {
			"tSF Tools - DynAI: CQB - No units selected" call dzn_fnc_tSF_3DEN_ShowWarn;
		};
		
		private _logic = create3DENEntity ["Logic","Logic", screenToWorld [0.5,0.5]];
		_logic set3DENAttribute ["Init", "this setVariable ['dzn_dynai_setBehavior', 'indoor'];"];	
		
		call dzn_fnc_tSF_3DEN_createDynaiLayer;
		_logic set3DENLayer dzn_tSF_3DEN_DynaiLayer;
		add3DENConnection ["Sync", _units, _logic];
		
		"tSF Tools - DynAI: CQB behaviour was assigned" call dzn_fnc_tSF_3DEN_ShowNotif;
	};
};

dzn_fnc_tSF_3DEN_AddVehicleHoldLogic = {
	dzn_tSF_3DEN_Parameter = _this;
	collect3DENHistory {
		private _units = dzn_tSF_3DEN_SelectedUnits;
		if (_units isEqualTo []) exitWith {
			"tSF Tools - DynAI: Vehicle Hold - No units selected" call dzn_fnc_tSF_3DEN_ShowWarn;
		};
		
		private _logic = create3DENEntity ["Logic","Logic", screenToWorld [0.5,0.5]];
		_logic set3DENAttribute [
			"Init"
			, format [
				"this setVariable ['dzn_dynai_setBehavior', '%1'];"
				, dzn_tSF_3DEN_Parameter
			]
		];	
		
		call dzn_fnc_tSF_3DEN_createDynaiLayer;
		_logic set3DENLayer dzn_tSF_3DEN_DynaiLayer;
		add3DENConnection ["Sync", _units, _logic];
		
		"tSF Tools - DynAI: Vehicle Hold behaviour was assigned" call dzn_fnc_tSF_3DEN_ShowNotif;
	};
};

dzn_fnc_tSF_3DEN_AddGroupResponseLogic = {
	collect3DENHistory {		
		private _units = dzn_tSF_3DEN_SelectedUnits;
		if (_units isEqualTo []) exitWith {
			"tSF Tools - DynAI: Response - No units selected" call dzn_fnc_tSF_3DEN_ShowWarn;
		};
		
		private _logic = create3DENEntity ["Logic","Logic", screenToWorld [0.5,0.5]];
		_logic set3DENAttribute ["Init", "this setVariable ['dzn_dynai_canSupport', true];"];	
		
		call dzn_fnc_tSF_3DEN_createDynaiLayer;
		_logic set3DENLayer dzn_tSF_3DEN_DynaiLayer;		
		add3DENConnection ["Sync", _units, _logic];
		
		"tSF Tools - DynAI: Response behaviour was assigned" call dzn_fnc_tSF_3DEN_ShowNotif;
	};
};

dzn_fnc_tSF_3DEN_Add_EUBSurrender_Logic = {
	collect3DENHistory {	
		private _units = dzn_tSF_3DEN_SelectedUnits;
		if (_units isEqualTo []) exitWith {
			"tSF Tools - Unit Behavior: Surrender - No units selected" call dzn_fnc_tSF_3DEN_ShowWarn;
		};
		
		private _logic = create3DENEntity ["Logic","Logic", screenToWorld [0.5,0.5]];
		_logic set3DENAttribute ["Init", "this setVariable ['tSF_EUB', 'Surrender'];"];	
		
		call dzn_fnc_tSF_3DEN_createMiscLayer;
		_logic set3DENLayer dzn_tSF_3DEN_MiscLayer;		
		add3DENConnection ["Sync", _units, _logic];
		
		"tSF Tools - Unit Behavior: Surrender behaviour was assigned" call dzn_fnc_tSF_3DEN_ShowNotif;
	};
};

dzn_fnc_tSF_3DEN_AddEVCLogic = {
	private _units = dzn_tSF_3DEN_SelectedUnits;
	if (_units isEqualTo []) exitWith {
		"tSF Tools - Vehicle Crew: No units selected" call dzn_fnc_tSF_3DEN_ShowWarn;
	};
	
	disableSerialization;
	private _result = [
		"Set Crew Logic"
		,[
			["Crew Config Name", [
				"OPFOR - 3 - VC, GNR, DRV"
				,"OPFOR - 2 - VC, DRV"	
				,"OPFOR - 2 - GNR, DRV"
				,"OPFOR - 2 - VC, GNR"		
				,"OPFOR - 1 - VC"
				,"OPFOR - 1 - GNR"
				,"OPFOR - 1 - DRV"
			]]
			,["Custom Config Name", []]
		]
	] call dzn_fnc_3DEN_ShowChooseDialog;
	
	if (count _result == 0) exitWith { dzn_tSF_3DEN_toolDisplayed = false };
	
	dzn_tSF_3DEN_Parameter = _result;
	
	collect3DENHistory {
		private _units = dzn_tSF_3DEN_SelectedUnits;
		private _result = dzn_tSF_3DEN_Parameter;
		private _configName = "";
		
		if (typename (_result select 1) == "STRING") then {
			_configName = _result select 1;	
		} else {
			_configName = switch (_result select 0) do {
				case 0: { "OPFOR VC, GNR, DRV" };
				case 1: { "OPFOR VC, DRV" };
				case 2: { "OPFOR GNR, DRV" };
				case 3: { "OPFOR VC, GNR" };
				case 4: { "OPFOR VC" };
				case 5: { "OPFOR GNR" };
				case 6: { "OPFOR DRV" };
			};
		};
		
		private _logic = create3DENEntity ["Logic","Logic", screenToWorld [0.5,0.5]];
		_logic set3DENAttribute [
			"Init"
			, format [
				"this setVariable ['tSF_EVC', '%1'];"
				, _configName
			]
		];
		
		call dzn_fnc_tSF_3DEN_createMiscLayer;
		_logic set3DENLayer dzn_tSF_3DEN_MiscLayer;
		
		add3DENConnection ["Sync", _units, _logic];	
		(format ["tSF Tools - Vehicle Crew: ""%1"" config was assigned", _configName]) call dzn_fnc_tSF_3DEN_ShowNotif;
	};
};

dzn_fnc_tSF_3DEN_AddERSLogic = {
	private _units = dzn_tSF_3DEN_SelectedUnits;
	if (_units isEqualTo []) exitWith {
		"tSF Tools - Vehicle Radio: No units selected" call dzn_fnc_tSF_3DEN_ShowWarn;
	};
	
	disableSerialization;
	private _result = [
		"Set LR Radio Logic"
		,[
			["Radio Config Name", ["BLUFOR","OPFOR","INDEP"]]
			,["Radio Custom Config", []]
		]
	] call dzn_fnc_3DEN_ShowChooseDialog;
	
	if (count _result == 0) exitWith { dzn_tSF_3DEN_toolDisplayed = false };
	
	dzn_tSF_3DEN_Parameter = _result;
	
	collect3DENHistory {
		private _units = dzn_tSF_3DEN_SelectedUnits;
		private _result = dzn_tSF_3DEN_Parameter;
		
		private _configName = "";
		if (typename (_result select 1) == "STRING") then {
			_configName = _result select 1;	
		} else {
			switch (_result select 0) do {
				case 0: { _configName = "BLUFOR" };
				case 1: { _configName = "OPFOR" };
				case 2: { _configName = "INDEP" };
			};
		};
		
		private _logic = create3DENEntity ["Logic","Logic", screenToWorld [0.5,0.5]];
		_logic set3DENAttribute [
			"Init"
			, format [
				"this setVariable ['tSF_ERS_Config', '%1'];"
				, _configName
			]
		];
		
		call dzn_fnc_tSF_3DEN_createMiscLayer;
		_logic set3DENLayer dzn_tSF_3DEN_MiscLayer;
		
		add3DENConnection ["Sync", _units, _logic];	
		(format ["tSF Tools - Vehicle Radio: ""%1"" config logic was assigned", _configName]) call dzn_fnc_tSF_3DEN_ShowNotif;
	};
};

dzn_fnc_tSF_3DEN_AddAsSupporter = {
	private _units = dzn_tSF_3DEN_SelectedUnits;
	
	if (_units isEqualTo []) exitWith {
		"tSF Tools - Support: No units selected" call dzn_fnc_tSF_3DEN_ShowWarn;
	};
	if (count _units > 1) exitWith {
		"tSF Tools - Support: Only 1 unit should be selected!" call dzn_fnc_tSF_3DEN_ShowWarn;
	};
	
	disableSerialization;
	private _result = [
		"Assign Vehicle as Support"
		,[
			["Callsign", []]
		]
	] call dzn_fnc_3DEN_ShowChooseDialog;
	
	if (count _result == 0) exitWith { dzn_tSF_3DEN_toolDisplayed = false };
	
	dzn_tSF_3DEN_Parameter = _result;
	
	collect3DENHistory {
		private _unit = dzn_tSF_3DEN_SelectedUnits select 0;
		private _result = dzn_tSF_3DEN_Parameter;		
		private _callsign = _result select 0;		
		
		private _logic = create3DENEntity ["Logic","Logic", screenToWorld [0.5,0.5]];
		_logic set3DENAttribute [
			"Init"
			, format [
				"this setVariable ['tSF_AirborneSupport', '%1'];"
				, _callsign
			]
		];
		_unit set3DENAttribute ["description",  _callsign];
		
		call dzn_fnc_tSF_3DEN_createSupporterLayer;		
		_unit set3DENLayer dzn_tSF_3DEN_SupporterLayer;
		_logic set3DENLayer dzn_tSF_3DEN_SupporterLayer;
		
		add3DENConnection ["Sync", [_unit], _logic];	
		(format ["tSF Tools - Support: ""%1"" config logic was assigned", _callsign]) call dzn_fnc_tSF_3DEN_ShowNotif;
	};
};

dzn_fnc_tSF_3DEN_AddSupportReturnPointCore = {
	collect3DENHistory {
		dzn_tSF_3DEN_SupportReturnPointCore = create3DENEntity ["Logic","Logic",screenToWorld [0.25,0.5]];
		
		dzn_tSF_3DEN_SupportReturnPointCore set3DENAttribute ["name", "tSF_AirborneSupport_ReturnPointCore"];
		dzn_tSF_3DEN_SupportReturnPointCore set3DENAttribute [
			"Init"
			, "this setVariable ['tSF_AirborneSupport_ReturnPoint', 'true'];"
		];
		
		call dzn_fnc_tSF_3DEN_createMiscLayer;
		dzn_tSF_3DEN_SupportReturnPointCore set3DENLayer dzn_tSF_3DEN_MiscLayer;
	};
}; 

dzn_fnc_tSF_3DEN_AddSupportReturnPoint = {
	disableSerialization;
	
	if (isNull dzn_tSF_3DEN_SupportReturnPointCore) then {
		call dzn_fnc_tSF_3DEN_AddSupportReturnPointCore;
	};
	
	private _result = [
		"Add Support Return point"
		,[
			["Type", 
				[
					"Helipad (Invisible)"
					, "Helipad"
					, "Helipad (Square)"
					, "Helipad (Civil)"
				]
			]
		]
	] call dzn_fnc_3DEN_ShowChooseDialog;
	
	if (count _result == 0) exitWith { dzn_tSF_3DEN_toolDisplayed = false };	
	dzn_tSF_3DEN_Parameter = _result;
		
	collect3DENHistory {
		private _result = dzn_tSF_3DEN_Parameter;

		private _objectClass = [
			"Land_HelipadEmpty_F"
			, "Land_HelipadCircle_F"
			, "Land_HelipadSquare_F"
			, "Land_HelipadCivil_F"
		] select (_result select 0);
		
		private _point = create3DENEntity ["Object",_objectClass, screenToWorld [0.5,0.5]];
	
		call dzn_fnc_tSF_3DEN_createMiscLayer;
		_point set3DENLayer dzn_tSF_3DEN_MiscLayer;
		
		add3DENConnection ["Sync", [_point], dzn_tSF_3DEN_SupportReturnPointCore];	
		"tSF Tools - Support: Return point was added" call dzn_fnc_tSF_3DEN_ShowNotif;
	};
};


/*
 * Scenario Assets
 */
dzn_fnc_tSF_3DEN_AddZeus = {
	collect3DENHistory {
		if !(isNull dzn_tSF_3DEN_Zeus) exitWith {
			// "tSF Tools - Zeus Module already exists" call dzn_fnc_tSF_3DEN_ShowWarn;
		};
		
		dzn_tSF_3DEN_Zeus = create3DENEntity ["Logic","ModuleCurator_F",screenToWorld [0.3,0.3]];
		dzn_tSF_3DEN_Zeus set3DENAttribute ["Name", "tSF_Zeus"];		
		
		dzn_tSF_3DEN_Zeus set3DENAttribute [
			"Init"
			, "this setVariable ['addons',3,true];this setVariable ['owner','#adminLogged',true];"
		];
		
		call dzn_fnc_tSF_3DEN_createTSFLayer;
		dzn_tSF_3DEN_Zeus set3DENLayer dzn_tSF_3DEN_tSFLayer;
		
		"tSF Tools - Zeus Module was created" call dzn_fnc_tSF_3DEN_ShowNotif;	
	};
};

dzn_fnc_tSF_3DEN_AddBaseTrg = {
	collect3DENHistory {	
		if !(isNull dzn_tSF_3DEN_BaseTrg) exitWith {
			"tSF Tools - BaseTrg already exists" call dzn_fnc_tSF_3DEN_ShowWarn;
		};
		
		dzn_tSF_3DEN_BaseTrg = create3DENEntity ["Trigger","EmptyDetectorAreaR250", screenToWorld [0.5,0.5]];
		dzn_tSF_3DEN_BaseTrg set3DENAttribute ["Name", "baseTrg"];

		call dzn_fnc_tSF_3DEN_createTSFLayer;
		dzn_tSF_3DEN_BaseTrg set3DENLayer dzn_tSF_3DEN_tSFLayer;
		
		do3DENAction "ToggleMap";
		"tSF Tools - BaseTrg was created" call dzn_fnc_tSF_3DEN_ShowNotif;
	};
};

dzn_fnc_tSF_3DEN_AddCCP = {
	collect3DENHistory {	
		if !(isNull dzn_tSF_3DEN_CCP) exitWith { 
			"tSF Tools - CCP already exists" call dzn_fnc_tSF_3DEN_ShowWarn;
		};
		
		private _pos = screenToWorld [0.5,0.5];
		dzn_tSF_3DEN_CCP = create3DENEntity ["Logic","Logic", _pos];
		private _ccpZone = create3DENEntity [
			"Trigger"
			,"EmptyDetectorAreaR250"
			, [ (_pos select 0) + 50, _pos select 1, 0 ]
		];
		
		dzn_tSF_3DEN_CCP set3DENAttribute ["Name", "tSF_CCP"];
		
		call dzn_fnc_tSF_3DEN_createTSFLayer;
		dzn_tSF_3DEN_CCP set3DENLayer dzn_tSF_3DEN_tSFLayer;
		_ccpZone set3DENLayer dzn_tSF_3DEN_tSFLayer;
		
		add3DENConnection ["Sync", [dzn_tSF_3DEN_CCP],_ccpZone];
		do3DENAction "ToggleMap";
		"tSF Tools - CCP was created" call dzn_fnc_tSF_3DEN_ShowNotif;
	};
};

dzn_fnc_tSF_3DEN_ConfigureScenario = {
	disableSerialization;
	
	private _form = [
		["Title", []]			
		, ["Summary", []]
		, ["Author (def: TS)",[]]
		, ["Picture (def: overview.jpg)",[]]			
		, ["Max Players", []]
	];
	private _scenarioData = ["", "", "Tactical Shift", "overview.jpg", ""];
	
	if !(isNull dzn_tSF_3DEN_ScnearioLogic) then {
		_scenarioData = [
			"Scenario" get3DENMissionAttribute "IntelBriefingName"
			, "Multiplayer" get3DENMissionAttribute "IntelOverviewText"
			, if ("Scenario" get3DENMissionAttribute "Author" == "") then { _scenarioData select 2 } else { "Scenario" get3DENMissionAttribute "Author" }
			, if ("Scenario" get3DENMissionAttribute "OverviewPicture"== "") then { _scenarioData select 3 } else { "Scenario" get3DENMissionAttribute "OverviewPicture" }
			, str("Multiplayer" get3DENMissionAttribute "MaxPlayers")
		];
		
		for "_i" from 0 to 4 do {
			(_form select _i) set [1, _scenarioData select _i];
		};
	};
	
	tsd = _scenarioData;
	private _result = [
		"Scenario Settings"
		, _form
	] call dzn_fnc_3DEN_ShowChooseDialog;
	if (count _result == 0) exitWith { dzn_tSF_3DEN_toolDisplayed = false };
	
	dzn_tSF_3DEN_Parameter = _result;
	
	collect3DENHistory {
		private _result = dzn_tSF_3DEN_Parameter;
		
		#define	RESOLVE_IF_NONE(X)	if (typename (_result select X) == "SCALAR") then { _scenarioData select X } else { _result select X }
		private _title = RESOLVE_IF_NONE(0);
		private _summary = RESOLVE_IF_NONE(1);
		private _author = RESOLVE_IF_NONE(2);
		private _picture = RESOLVE_IF_NONE(3);
		private _maxPlayers = RESOLVE_IF_NONE(4);
		
		tSF_3DEN_SummaryText = _summary;
		call dzn_fnc_tSF_3DEN_AddScenarioLogic;
		call dzn_fnc_tSF_3DEN_CoverMap;
		
		set3DENMissionAttributes [
			["Scenario","IntelBriefingName", _title]
			, ["Scenario","OverviewText", _summary]	
			, ["Scenario","OnLoadMission", _summary]			
			, ["Scenario","OverviewPicture", _picture]
			, ["Scenario","LoadScreen", _picture]
			, ["Scenario","OverviewPictureLocked", _picture]
			, ["Scenario","Author", _author]			
			, ["Scenario","Saving", false]
			, ["Scenario","EnableDebugConsole", 1]
			, ["Scenario","SaveBinarized", false]			
			
			, ["Multiplayer","MinPlayers", 1]
			, ["Multiplayer","MaxPlayers", parseNumber(_maxPlayers)]
			, ["Multiplayer","GameType","Coop"]
			, ["Multiplayer","IntelOverviewText", _summary]	
			, ["Multiplayer","DisabledAI", true]
			, ["Multiplayer","respawn",3]
			, ["Multiplayer","RespawnDialog", false]
			, ["Multiplayer","RespawnButton", 0]
			, ["Multiplayer","RespawnTemplates", ["ace_spectator","EndMission"]]
		];
	
		private _respawnMrk = create3DENEntity ["Marker","mil_start", screenToWorld [0.5,0.5]];
		_respawnMrk set3DENAttribute ["name", "respawn_west"];
		_respawnMrk set3DENAttribute ["text", "Rename me to 'respawn_west'"];
		do3DENAction "ToggleMap";
		
		"tSF Tools - Scenario was configured" call dzn_fnc_tSF_3DEN_ShowNotif;
	};
	
	call dzn_fnc_tSF_3DEN_AddZeus;
};

dzn_fnc_tSF_3DEN_AddScenarioLogic = {
	if !(isNull dzn_tSF_3DEN_ScnearioLogic) exitWith {
		dzn_tSF_3DEN_ScnearioLogic set3DENAttribute [
			"Init"
			, format ["tSF_SummaryText = '%1'", tSF_3DEN_SummaryText]
		];	
	};
	
	collect3DENHistory {
		dzn_tSF_3DEN_ScnearioLogic = create3DENEntity ["Logic","Logic",screenToWorld [0.3,0.5]];
		dzn_tSF_3DEN_ScnearioLogic set3DENAttribute ["Name", "tSF_Scenario_Logic"];
		dzn_tSF_3DEN_ScnearioLogic set3DENAttribute [
			"Init"
			, format ["tSF_SummaryText = '%1'", tSF_3DEN_SummaryText]
		];
		
		call dzn_fnc_tSF_3DEN_createMiscLayer;
		dzn_tSF_3DEN_ScnearioLogic set3DENLayer dzn_tSF_3DEN_MiscLayer;
	};
}; 

dzn_fnc_tSF_3DEN_CoverMap = {
	if !(isNull dzn_tSF_3DEN_CoverMap) exitWith {};
	
	collect3DENHistory {
		dzn_tSF_3DEN_CoverMap = create3DENEntity ["Logic","ModuleCoverMap_F",screenToWorld [0.7,0.5]];
		dzn_tSF_3DEN_CoverMap set3DENAttribute ["Name", "tSF_CoverMap"];
		dzn_tSF_3DEN_CoverMap set3DENAttribute ["size2", [2000,2000]];
		
		call dzn_fnc_tSF_3DEN_createMiscLayer;
		dzn_tSF_3DEN_CoverMap set3DENLayer dzn_tSF_3DEN_MiscLayer;
	};

};
