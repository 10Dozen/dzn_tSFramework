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
