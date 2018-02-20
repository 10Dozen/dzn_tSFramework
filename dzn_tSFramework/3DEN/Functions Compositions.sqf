
dzn_fnc_tSF_3DEN_ShowArtilleryCompositionMenu = {
	dzn_tSF_3DEN_toolDisplayed = true;
	private _mortarOptions = [
		["Mk6"					, "B_Mortar_01_F"]
		, ["2B14 Podnos (CUP)"		, "CUP_O_2b14_82mm_RU"]
		, ["M252 (CUP)"			, "CUP_B_M252_US"]	
		, ["2B14 Podnos (RHS)"		, "rhs_2b14_82mm_msv"]
		, ["M252 (RHS)"			, "RHS_M252_D"]		
	];
	private _compositions = dzn_tSF_3DEN_Compositions_Artillery apply { _x select 0 };

	private _toolResult = [
		"tSF Tool - Artillery Composition"
		, [
			["Mortar type"	, _mortarOptions apply { _x select 0 }]
			, ["Composition"	, _compositions]
			, ["Callsign (e.g. Steel rain-1-1)", []]
		]
	] call dzn_fnc_3DEN_ShowChooseDialog;
	
	Result = _toolResult;
	if (count _toolResult == 0) exitWith { dzn_tSF_3DEN_toolDisplayed = false };
	
	[
		screenToWorld [0.5,0.5]
		, (_mortarOptions select (_toolResult select 0)) select 1
		, _compositions select (_toolResult select 1)
		, _toolResult select 2
	] call dzn_fnc_tSF_3DEN_SetArtilleryComposition;
	
	dzn_tSF_3DEN_toolDisplayed = false;
};

dzn_fnc_tSF_3DEN_SetArtilleryComposition = {
	params ["_pos", "_mortarClass", "_compositionName", "_callsign"];
	call compile preProcessFileLineNumbers "dzn_tSFramework\3DEN\Compositions.sqf";
	
	private _artyUnits = [];
	private _composition = ((dzn_tSF_3DEN_Compositions_Artillery select { _x select 0 == _compositionName }) select 0 select 1) apply {		
		if !((_x select 0) in ["MORTAR_CLASS","ACE_Box_82mm_Mo_Combo","ACE_Box_82mm_Mo_HE","ACE_Box_82mm_Mo_Smoke","ACE_Box_82mm_Mo_Illum"]) then {
			_x set [5, false];
		};
		if ((_x select 0) == "MORTAR_CLASS") then { _x set [0, _mortarClass]; };
		
		_x
	};
	
	collect3DENHistory {
		private _logic = create3DENEntity ["Logic","Logic", screenToWorld [0.5,0.5]];
		_logic set3DENAttribute [
			"Init"
			, format [
				"this setVariable ['tSF_ArtillerySupport', '%1'];"
				, _callsign
			]
		];
		_unit set3DENAttribute ["description",  _callsign];
		call dzn_fnc_tSF_3DEN_createSupporterLayer;
		_logic set3DENLayer dzn_tSF_3DEN_SupporterLayer;
	
		private _guns = [];
		{
			private _objPos = [_pos, _x select 2, _x select 1] call BIS_fnc_relPos;
			private _o = create3DENEntity ["Object", _x select 0, _objPos, true];
			set3DENAttributes [
				[[_o]		, "enableSimulation"		, _x select 5]
				,[[_o]		, "rotation"			, [0,0,_x select 3]]
				,[[_o]		, "position"			, _objPos]
			];
			
			if ((_x select 0) == _mortarClass) then {
				_guns pushBack _o;
				_o set3DENLayer dzn_tSF_3DEN_SupporterLayer;
			};
		} forEach _composition;
		
		add3DENConnection ["Sync", _guns, _logic];
	};
	
	(format ["Artillery Composition created - %1", _callsign]) call dzn_fnc_tSF_3DEN_ShowNotif;
};
