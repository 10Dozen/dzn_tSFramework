
dzn_fnc_tSF_3DEN_ShowArtilleryCompositionMenu = {
	dzn_tSF_3DEN_toolDisplayed = true;
	private _mortarOptions = [
		["Mk6"					, "B_Mortar_01_F"]
		, ["2B14 Podnos (CUP)"		, "CUP_O_2b14_82mm_RU"]
		, ["M252 (CUP)"			, "CUP_B_M252_US"]
		, ["2B14 Podnos (RHS)"		, "rhs_2b14_82mm_msv"]
		, ["M252 (RHS)"			, "RHS_M252_D"]
		, ["Virtual Battery"		, ""]
	];
	private _compositions = dzn_tSF_3DEN_Compositions_Artillery apply { _x select 0 };

	private _toolResult = [
		"tSF Tool - Artillery Composition"
		, [
			["Mortar type", _mortarOptions apply { _x select 0 }]
			, ["Composition", _compositions]
			, ["Callsign (e.g. Steel rain-1-1)", []]
			, ["Condition (optional)", []]
		]
	] call dzn_fnc_3DEN_ShowChooseDialog;

	if (count _toolResult == 0) exitWith { dzn_tSF_3DEN_toolDisplayed = false };
	_toolResult params ["_typeId", "_assetId", "_callsign","_condition"];

	private _label = "";
	if ((_mortarOptions # _typeId) # 1 == "") then {
		private _virtualArtilleryLabels = ["82mm Mortar", "105mm Howitzer", "155mm Howitzer"];
		private _toolResult2 = [
			"tSF Tool - Virtual Artillery name"
			, [
				["Mortar name", _virtualArtilleryLabels]
				, ["... or custom name", []]
			]
		] call dzn_fnc_3DEN_ShowChooseDialog;

		_label = if (typename (_toolResult2 # 1) == "STRING" && { (_toolResult2 # 1) != "" }) then {
			_toolResult2 # 1
		} else {
			_virtualArtilleryLabels # (_toolResult2 # 0)
		};
	};

	[
		screenToWorld [0.5,0.5]
		, (_mortarOptions select _typeId) select 1
		, _compositions select _assetId
		, if (typename _callsign == "SCALAR") then { "Steel Rain-1-1" } else { _callsign }
		, _label
		, _condition
	] call dzn_fnc_tSF_3DEN_SetArtilleryComposition;

	dzn_tSF_3DEN_toolDisplayed = false;
};

dzn_fnc_tSF_3DEN_SetArtilleryComposition = {
	params ["_pos", "_mortarClass", "_compositionName", "_callsign","_label", "_condition"];
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
		private _initCode = format [
			"this setVariable ['tSF_ArtillerySupport', '%1']; this setVariable ['tSF_ArtillerySupport_Label', '%2'];"
			, _callsign
			, _label
		];

		if (typename _condition == "STRING" && {_condition != ""}) then {
			_initCode = _initCode + " this setVariable ['tSF_ArtillerySupport_Condition', '" + _condition + "'];";
		};

		_logic set3DENAttribute ["Init", _initCode];
		_unit set3DENAttribute ["description", _callsign];
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
