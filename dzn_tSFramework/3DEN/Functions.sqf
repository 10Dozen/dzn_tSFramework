dzn_tsf_3DEN_onKeyPress = {
	if (dzn_tsf_3DEN_keyIsDown) exitWith {};
	
	private _key = _this select 1; 
	private _ctrl = _this select 3; 
	private _handled = false;

	switch _key do {
		// Space
		case 57: {
			dzn_tsf_3DEN_keyIsDown = true;			
			if (_ctrl) then { [] spawn dzn_fnc_tsf_3DEN_ShowTool; };
			_handled = true;
		};
	};
	
	[] spawn { sleep 1; dzn_tsf_3DEN_keyIsDown = false; };
	_handled
};


dzn_fnc_tsf_3DEN_ShowTool = {
	if (dzn_tsf_3DEN_toolDisplayed) exitWith {};
	dzn_tsf_3DEN_toolDisplayed = true;
	
	dzn_tsf_3DEN_SelectedUnits = get3DENSelected "object";
	
	private _resolveOption = {};
	private _options = [
		["Units: Add Playable Squad"		, { [] spawn dzn_fnc_tsf_3DEN_AddSquad }]	
		,["DynAI: Add Zone"			, { [] spawn { call dzn_fnc_tsf_3DEN_AddDynaiZone } }]
		,["DynAI: Add CQB Behavior"		, { call dzn_fnc_tsf_3DEN_AddCQBLogic }]
		,["DynAI: Add Response Behavior"	, { call dzn_fnc_tsf_3DEN_AddGroupResponseLogic }]
		,["Gear: Add Kit Logic"			, { [] spawn { call dzn_fnc_tsf_3DEN_AddGearLogic } }]
		,["tSF: Configure Scenario"		, { [] spawn { call dzn_fnc_tsf_3DEN_ConfigureScenario } }]
		,["tSF: Add Zeus"				, { call dzn_fnc_tsf_3DEN_AddZeus }]
		,["tSF: Add Base Trigger"		, { call dzn_fnc_tsf_3DEN_AddBaseTrg }]
		,["tSF: Add CCP"				, { call dzn_fnc_tsf_3DEN_AddCCP }]	
	];
	
	private _optionList = [];
	{ _optionList pushBack (_x select 0); } forEach _options;
	
	
	call dzn_fnc_tsf_3DEN_ResetVariables;
	private _toolResult = [
		"tSF Tool"
		, [["Select action", _optionList]]
	] call dzn_fnc_ShowChooseDialog;
	Result = _toolResult;
	if (count _toolResult == 0) exitWith { dzn_tsf_3DEN_toolDisplayed = false };
	
	call ((_options select (_toolResult select 0)) select 1);	
	dzn_tsf_3DEN_toolDisplayed = false;
};


dzn_fnc_tsf_3DEN_createTSFLayer = {
	if (typename dzn_tsf_3DEN_tSFLayer != "SCALAR") then { dzn_tsf_3DEN_tSFLayer = -1 add3DENLayer "tSF Layer"; };
};
dzn_fnc_tsf_3DEN_createDynaiLayer = {
	if (typename dzn_tsf_3DEN_DynaiLayer != "SCALAR") then { dzn_tsf_3DEN_DynaiLayer = -1 add3DENLayer "DynAI Layer"; };
};
dzn_fnc_tsf_3DEN_createGearLayer = {
	if (typename dzn_tsf_3DEN_GearLayer != "SCALAR") then { dzn_tsf_3DEN_GearLayer = -1 add3DENLayer "dzn_Gear Layer"; };
};

dzn_fnc_tsf_3DEN_AddSquad = {
	/*
	 * @Typa call dzn_fnc_tsf_3DEN_AddSquad
	 * Type = "NATO", "RUAF"
	 */
	
	
	dzn_tsf_3DEN_SquadLastNumber = dzn_tsf_3DEN_SquadLastNumber + 1;
	private _squadSettings = [];
	private _infantryClass = "";
	
	disableSerialization;
	// Return [ 0, 1 ] or something like this
	private _squadType = [
		"Add Squad"
		, [
			["Side", ["BLUFOR","OPFOR","INDEPENDENT","CIVILIANS"]]
			,["Doctrine", ["NATO 1-4-4", "UK 4-4", "Ru MSO 1-2-3-3", "Ru VV 4-3"]]
		]
	] call dzn_fnc_ShowChooseDialog;
	if (count _squadType == 0) exitWith { dzn_tsf_3DEN_toolDisplayed = false };
	
	_infantryClass = switch (_squadType select 0) do {
		case 0: { "B_Soldier_F" };
		case 1: { "O_Soldier_F" };
		case 2: { "I_soldier_F" };
		case 3: { "C_man_1" };
	};
	_squadSettings = switch (_squadType select 1) do {
		/* NATO 1-4-4 */ 	case 0: {
			[
				[format ["1'%1 Squad Leader", dzn_tsf_3DEN_SquadLastNumber],"Sergeant"]
				,["RED - FTL"		,"Corporal"]
				,["Automatic Rifleman"	,"Private"]
				,["Grenadier"		,"Private"]
				,["Rifleman"		,"Private"]
				,["BLUE - FTL"		,"Corporal"]
				,["Automatic Rifleman"	,"Private"]
				,["Grenadier"		,"Private"]
				,["Rifleman"		,"Private"]
			]		
		};
		/* UK 4-4*/ 		case 1: {
			[
				[format ["1'%1 Section Leader", dzn_tsf_3DEN_SquadLastNumber],"Sergeant"]
				,["Automatic Rifleman"	,"Private"]
				,["Grenadier"			,"Private"]				
				,["Rifleman"			,"Private"]				
				,["BLUE - 2IC"			,"Corporal"]
				,["Automatic Rifleman"	,"Private"]
				,["Grenadier"			,"Private"]				
				,["Rifleman"			,"Private"]
			]	
		
		};
		/* RuMSO 1-2-3-3 */	case 2: {
			[
				[format ["1'%1 Командир отделения", dzn_tsf_3DEN_SquadLastNumber]	,"Sergeant"]
				,["Наводчик-оператор"					,"Corporal"]
				,["Механик-водитель"					,"Private"]
				,["Пулеметчик"					,"Private"]
				,["Стрелок-Гранатометчик"				,"Private"]
				,["Стрелок, помощник гранатометчика"	,"Private"]				
				,["BLUE - Старший стрелок"				,"Corporal"]
				,["Стрелок"						,"Private"]
				,["Стрелок"						,"Private"]
				
			]
		};
		/* Ru VV 4-3 */ 	case 3: {
			[
				[format ["1'%1 Командир отделения", dzn_tsf_3DEN_SquadLastNumber]	,"Sergeant"]
				,["Пулеметчик"							,"Private"]
				,["Стрелок-Гранатометчик"				,"Private"]
				,["Стрелок, помощник гранатометчика"	,"Private"]				
				,["BLUE - Старший стрелок"				,"Corporal"]
				,["Стрелок (ГП)"					,"Private"]
				,["Снайпер"						,"Private"]
			]
		};
	};
	
	private _squadRelativePoses = [
		[0,0,0]
		, [2,-1,0]	, [4,-1,0]	, [6,-1,0]	, [8,-1,0]
		, [2,-5,0]	, [4,-5,0]	, [6,-5,0]	, [8,-5,0]
	];
	
	collect3DENHistory {
	
	if (typename dzn_tsf_3DEN_UnitsLayer != "SCALAR") then {
		dzn_tsf_3DEN_UnitsLayer = -1 add3DENLayer "Playable Units";
	};
	
	private _basicPos = screenToWorld [0.5,0.5];
	
	private _unit = create3DENEntity ["Object", _infantryClass, _basicPos];	
	private _grp = group _unit;
	
	for "_i" from 0 to (count(_squadSettings) - 1) do {	
		private _unit = _grp create3DENEntity [
			"Object"
			, _infantryClass
			, [
				(_basicPos select 0) + ((_squadRelativePoses select _i) select 0)
				, (_basicPos select 1) + ((_squadRelativePoses select _i) select 1)		
				, 0
			]
		];
		
		set3DENAttributes [
			[[_unit], "description", (_squadSettings select _i) select 0]
			,[[_unit], "rank", (_squadSettings select _i) select 1]			
			,[[_unit], "ControlMP", true]
		];	
	};
	set3DENAttributes [
		[[_grp], "behaviour", "Safe"]
		,[[_grp], "speedMode", "Limited"]
	];
	
	delete3DENEntities [(units _grp select 0)];
	
	{
		_x set3DENLayer dzn_tsf_3DEN_UnitsLayer;
	} forEach (units _grp);
	
	["tSF Tools - New Squad was Added", 0, 15, true] call BIS_fnc_3DENNotification;
	};
};


dzn_fnc_tsf_3DEN_AddDynaiCore = {
	dzn_tsf_3DEN_DynaiCore = create3DENEntity ["Logic","Logic",screenToWorld [0.5,0.5]];
	dzn_tsf_3DEN_DynaiCore set3DENAttribute ["Name", "dzn_dynai_core"];
	
	call dzn_fnc_tsf_3DEN_createDynaiLayer;
	dzn_tsf_3DEN_DynaiCore set3DENLayer dzn_tsf_3DEN_DynaiLayer;
	
	["tSF Tools - DynAI Core was created", 0, 15, true] call BIS_fnc_3DENNotification;
}; 

dzn_fnc_tsf_3DEN_AddDynaiZone = {	
	if (isNull dzn_tsf_3DEN_DynaiCore) then { call dzn_fnc_tsf_3DEN_AddDynaiCore; };	
	
	disableSerialization;
	private _name = ["Add Dynai Zone", ["Zone name", []]] call dzn_fnc_ShowChooseDialog;
	if (count _name == 0) exitWith { dzn_tsf_3DEN_toolDisplayed = false };
	
	private _pos = screenToWorld [0.5,0.5];
	private _dynaiZone = create3DENEntity ["Logic","Logic", _pos];
	private _dynaiArea = create3DENEntity [
		"Trigger"
		,"EmptyDetectorAreaR250"
		, [ (_pos select 0) + 50, _pos select 1, 0 ]
	];
	
	if (_name select 0 == "") then { 
		dzn_tsf_3DEN_DynaiZoneId = dzn_tsf_3DEN_DynaiZoneId + 1;
		_name = format ["Zone%1", dzn_tsf_3DEN_DynaiZoneId];		
	} else { 
		_name = _name select 0;
	};	
	
	_dynaiZone set3DENAttribute ["Name", _name];	
	
	call dzn_fnc_tsf_3DEN_createDynaiLayer;
	_dynaiZone set3DENLayer dzn_tsf_3DEN_DynaiLayer;
	_dynaiArea set3DENLayer dzn_tsf_3DEN_DynaiLayer;
	
	add3DENConnection ["Sync", [_dynaiZone],dzn_tsf_3DEN_DynaiCore];
	add3DENConnection ["Sync", [_dynaiZone],_dynaiArea];
	
	do3DENAction "ToggleMap";
	
	[
		format ["tSF Tools - '%1' DynAI Zone was created", _name]
		, 0, 15, true
	] call BIS_fnc_3DENNotification;
};

dzn_fnc_tsf_3DEN_AddZeus = {
	collect3DENHistory {
	
	if !(isNull dzn_tsf_3DEN_Zeus) exitWith {
		["tSF Tools - Zeus Module already exists", 1, 15, true] call BIS_fnc_3DENNotification;
	};
	
	dzn_tsf_3DEN_Zeus = create3DENEntity ["Logic","ModuleCurator_F",screenToWorld [0.5,0.5]];
	dzn_tsf_3DEN_Zeus set3DENAttribute [
		"Init"
		, "this setVariable ['addons',3,true];this setVariable ['owner','#adminLogged',true];"
	];
	
	call dzn_fnc_tsf_3DEN_createTSFLayer;
	dzn_tsf_3DEN_Zeus set3DENLayer dzn_tsf_3DEN_tSFLayer;
	
	["tSF Tools - Zeus Module was created", 0, 15, true] call BIS_fnc_3DENNotification;
	
	};
};

dzn_fnc_tsf_3DEN_AddBaseTrg = {
	collect3DENHistory {
	
	if !(isNull dzn_tsf_3DEN_BaseTrg) exitWith {
		["tSF Tools - BaseTrg already exists", 1, 15, true] call BIS_fnc_3DENNotification;
	};
	
	dzn_tsf_3DEN_BaseTrg = create3DENEntity ["Trigger","EmptyDetectorAreaR250", screenToWorld [0.5,0.5]];
	dzn_tsf_3DEN_BaseTrg set3DENAttribute ["Name", "baseTrg"];

	call dzn_fnc_tsf_3DEN_createTSFLayer;
	dzn_tsf_3DEN_BaseTrg set3DENLayer dzn_tsf_3DEN_tSFLayer;
	
	do3DENAction "ToggleMap";
	["tSF Tools - BaseTrg was created", 0, 15, true] call BIS_fnc_3DENNotification;
	
	};
};

dzn_fnc_tsf_3DEN_AddCCP = {
	collect3DENHistory {
	
	if !(isNull dzn_tsf_3DEN_CCP) exitWith { 
		["tSF Tools - CCP already exists", 1, 15, true] call BIS_fnc_3DENNotification;
	};
	
	private _pos = screenToWorld [0.5,0.5];
	dzn_tsf_3DEN_CCP = create3DENEntity ["Logic","Logic", _pos];
	private _ccpZone = create3DENEntity [
		"Trigger"
		,"EmptyDetectorAreaR250"
		, [ (_pos select 0) + 50, _pos select 1, 0 ]
	];
	
	
	dzn_tsf_3DEN_CCP set3DENAttribute ["Name", "tsf_CCP"];
	
	call dzn_fnc_tsf_3DEN_createTSFLayer;
	dzn_tsf_3DEN_CCP set3DENLayer dzn_tsf_3DEN_tSFLayer;
	_ccpZone set3DENLayer dzn_tsf_3DEN_tSFLayer;
	
	add3DENConnection ["Sync", [dzn_tsf_3DEN_CCP],_ccpZone];
	do3DENAction "ToggleMap";
	["tSF Tools - CCP was created", 0, 15, true] call BIS_fnc_3DENNotification;

	};
};

dzn_fnc_tsf_3DEN_AddCQBLogic = {
	collect3DENHistory {

	private _units = dzn_tsf_3DEN_SelectedUnits;
	if (_units isEqualTo []) exitWith {
		["tSF Tools - DynAI: CQB - No units selected", 1, 15, true] call BIS_fnc_3DENNotification;
	};
	
	private _logic = create3DENEntity ["Logic","Logic", screenToWorld [0.5,0.5]];
	_logic set3DENAttribute ["Init", "this setVariable ['dzn_dynai_setBehavior', 'indoor'];"];	
	
	call dzn_fnc_tsf_3DEN_createDynaiLayer;
	_logic set3DENLayer dzn_tsf_3DEN_DynaiLayer;
	
	add3DENConnection ["Sync", _units, _logic];
	
	["tSF Tools - DynAI: CQB behaviour was assigned", 0, 15, true] call BIS_fnc_3DENNotification;
	
	};
};

dzn_fnc_tsf_3DEN_AddGroupResponseLogic = {
	collect3DENHistory {
	
	private _units = dzn_tsf_3DEN_SelectedUnits;
	if (_units isEqualTo []) exitWith {
		["tSF Tools - DynAI: Response - No units selected", 1, 15, true] call BIS_fnc_3DENNotification;
	};
	
	private _logic = create3DENEntity ["Logic","Logic", screenToWorld [0.5,0.5]];
	_logic set3DENAttribute ["Init", "this setVariable ['dzn_dynai_canSupport', true];"];	
	
	call dzn_fnc_tsf_3DEN_createDynaiLayer;
	_logic set3DENLayer dzn_tsf_3DEN_DynaiLayer;
	
	add3DENConnection ["Sync", _units, _logic];
	
	["tSF Tools - DynAI: Response behaviour was assigned", 0, 15, true] call BIS_fnc_3DENNotification;

	};
};

dzn_fnc_tsf_3DEN_AddGearLogic = {
	private _units = dzn_tsf_3DEN_SelectedUnits;
	if (_units isEqualTo []) exitWith {
		["tSF Tools - Gear: Kit logic - No units selected", 1, 15, true] call BIS_fnc_3DENNotification;
	};
	
	disableSerialization;
	private _result = [
		"Set Kit logic"
		,[
			["Kit type", ["Gear kit","Cargo kit"]]
			, ["Kit name",[]]
		]
	] call dzn_fnc_ShowChooseDialog;
	if (count _result == 0) exitWith { dzn_tsf_3DEN_toolDisplayed = false };
	
	private _type = if (_result select 0 == 0) then { "dzn_gear" } else { "dzn_gear_cargo" };
	private _kit = if (_result select 1 == "") then { "KitName" } else { _result select 1 };
	
	private _logic = create3DENEntity ["Logic","Logic", screenToWorld [0.5,0.5]];
	_logic set3DENAttribute [
		"Init"
		, format [
			"this setVariable ['%1', '%2'];"
			, _type
			, _kit
		]
	];
	
	call dzn_fnc_tsf_3DEN_createGearLayer;
	_logic set3DENLayer dzn_tsf_3DEN_GearLayer;
	
	add3DENConnection ["Sync", _units, _logic];	
	["tSF Tools - Gear: Kit logic was assigned", 0, 15, true] call BIS_fnc_3DENNotification;
};

dzn_fnc_tsf_3DEN_ConfigureScenario = {
	disableSerialization;
	private _result = [
		"Scenario Settings"
		,[
			["Title", []]
			, ["Overview",[]]			
			, ["Summary", []]
			, ["Author",[]]
			, ["Loading Screen text", []]
			, ["Max Players", []]
		]
	] call dzn_fnc_ShowChooseDialog;
	if (count _result == 0) exitWith { dzn_tsf_3DEN_toolDisplayed = false };
	
	private _overview  = if (typename (_result select 1) == "SCALAR") then { "" } else { _result select 1 };
	private _summary = if (typename (_result select 2) == "SCALAR") then { "" } else { _result select 2 };
	private _author = if (typename (_result select 3) == "SCALAR") then { "Tactical Shift" } else { _result select 3 };
	private _loadingScreen = if (typename (_result select 4) == "SCALAR") then { "" } else { _result select 4 };
	private _maxPlayers = if (typename (_result select 5) == "SCALAR") then { "1" } else { _result select 5 };
	private _title = if (typename (_result select 0) == "SCALAR") then { format ["CO%1 Scenario Name", _maxPlayers] } else { _result select 0 };
	
	set3DENMissionAttributes [
		["Scenario","IntelBriefingName", _title]
		, ["Scenario","OverviewText", _overview]		
		, ["Scenario","Author", _author]
		, ["Scenario","Saving", false]
		, ["Scenario","EnableDebugConsole", 1]
		, ["Scenario", "OnLoadMission", _loadingScreen]
		
		, ["Multiplayer","MaxPlayers", parseNumber(_maxPlayers)]
		, ["Multiplayer","IntelOverviewText", _summary]		
		, ["Multiplayer","GameType","Coop"]
		, ["Multiplayer","MinPlayers", 1]
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
	["tSF Tools - Scenario was configured", 0, 15, true] call BIS_fnc_3DENNotification;
};




dzn_fnc_tsf_3DEN_ResetVariables = {
	{
		call compile format [
			"if (get3DENEntityID %1 == -1) then { %1 = objNull; };"
			, _x
		];
	} forEach [
		"dzn_tsf_3DEN_DynaiCore"
		, "dzn_tsf_3DEN_Zeus"
		, "dzn_tsf_3DEN_BaseTrg"
		, "dzn_tsf_3DEN_CCP"
		
		, "dzn_tsf_3DEN_UnitsLayer"
		, "dzn_tsf_3DEN_tSFLayer"
		, "dzn_tsf_3DEN_GearLayer"
		, "dzn_tsf_3DEN_DynaiLayer"
	];
	
	{
		private _entity = _x select 0;
		
		if (!(isNil {_entity}) && {get3DENEntityID _entity > -1}) then {
			// Search for DynAI_core
			if (
				(_entity get3DENAttribute "name") select 0 == "dzn_dynai_core" 
			) then {
				dzn_tsf_3DEN_DynaiCore = _entity;
			};
			
			// Search for BaseTrg
			if ( 
				(_entity get3DENAttribute "name") select 0 == "baseTrg" 
			) then {
				dzn_tsf_3DEN_BaseTrg = _entity;
			};
			
			// Search for CCP
			if ( 
				(_entity get3DENAttribute "name") select 0 == "tsf_CCP" 
			) then {
				dzn_tsf_3DEN_CCP = _entity;
			};
		};
	} forEach all3DENEntities;

};

/*
 *	Dialog Function
 */

dzn_fnc_ShowChooseDialog = {
	/*
		Displays a dialog that prompts the user to choose an option from a set of combo boxes. 
		If the dialog has a title then the default values provided will be used the FIRST time a dialog is displayed, and the selected values remembered for the next time it is displayed.
		
		Params:
			0 - String - The title to display for the combo box. Do not use non-standard characters (e.g. %&$*()!@#*%^&) that cannot appear in variable names
			1 - Array of Arrays - The set of choices to display to the user. Each element in the array should be an array in the following format: ["Choice Description", ["Choice1", "Choice2", etc...]] optionally the last element can be a number that indicates which element to select. For example: ["Choose A Pie", ["Apple", "Pumpkin"], 1] will have "Pumpkin" selected by default. If you replace the choices with a string then a textbox (with the string as default) will be displayed instead.

		Alternate Params:
			0 - String - The title to display for the combo box.
			1 - Array of Arrays - A single entry in the format of the first version of the function. That is: ["Choice Description", ["Choice1", "Choice2", etc...]]. If you replace the choices with a string then a textbox (with the string as default) will be displayed instead.
		Returns:
			An array containing the indices of each of the values chosen, or a null object if nothing was selected.
	*/
	disableSerialization;

	_titleText = [_this, 0] call BIS_fnc_param;
	_choicesArray = _this select 1;
	if ((count _this) == 2 && typeName (_choicesArray select 0) == typeName "") then
	{
		// Person is using the 'short' alternate syntax. Automatically wrap in another array.
		_choicesArray = [_this select 1];
	};

	// Define some constants for us to use when laying things out.
	#define GUI_GRID_X		(0)
	#define GUI_GRID_Y		(0)
	#define GUI_GRID_W		(0.025)
	#define GUI_GRID_H		(0.04)
	#define GUI_GRID_WAbs	(1)
	#define GUI_GRID_HAbs	(1)

	#define BG_X					(1 * GUI_GRID_W + GUI_GRID_X)
	#define BG_Y					(1 * GUI_GRID_H + GUI_GRID_Y)
	#define BG_WIDTH				(38.5 * GUI_GRID_W)
	#define TITLE_WIDTH				(14 * GUI_GRID_W)
	#define TITLE_HEIGHT			(1.5 * GUI_GRID_H)
	#define LABEL_COLUMN_X			(2 * GUI_GRID_W + GUI_GRID_X)
	#define LABEL_WIDTH				(14 * GUI_GRID_W)
	#define LABEL_HEIGHT			(1.5 * GUI_GRID_H)
	#define COMBO_COLUMN_X			(17.5 * GUI_GRID_W + GUI_GRID_X)
	#define COMBO_WIDTH				(21 * GUI_GRID_W)
	#define COMBO_HEIGHT			(1.5 * GUI_GRID_H)
	#define OK_BUTTON_X				(29.5 * GUI_GRID_W + GUI_GRID_X)
	#define OK_BUTTON_WIDTH			(4 * GUI_GRID_W)
	#define OK_BUTTON_HEIGHT		(1.5 * GUI_GRID_H)
	#define CANCEL_BUTTON_X			(34 * GUI_GRID_W + GUI_GRID_X)
	#define CANCEL_BUTTON_WIDTH		(4.5 * GUI_GRID_W)
	#define CANCEL_BUTTON_HEIGHT	(1.5 * GUI_GRID_H)
	#define TOTAL_ROW_HEIGHT		(2 * GUI_GRID_H)
	#define BASE_IDC				(9000)

	// Bring up the dialog frame we are going to add things to.
	_createdDialogOk = createDialog "dzn_Dynamic_Dialog";
	_dialog = findDisplay 133798;

	// Create the BG and Frame
	_background = _dialog ctrlCreate ["IGUIBack", BASE_IDC];
	_background ctrlSetPosition [BG_X, BG_Y, BG_WIDTH, 10 * GUI_GRID_H];
	_background ctrlCommit 0;

	// Start placing controls 1 units down in the window.
	_yCoord = BG_Y + (0.5 * GUI_GRID_H);
	_controlCount = 2;

	_titleRowHeight = 0;
	if (_titleText != "") then
	{
		// Create the label
		_labelControl = _dialog ctrlCreate ["RscText", BASE_IDC + _controlCount];
		_labelControl ctrlSetPosition [LABEL_COLUMN_X, _yCoord, TITLE_WIDTH, TITLE_HEIGHT];
		_labelControl ctrlCommit 0;
		_labelControl ctrlSetText _titleText;
		_yCoord = _yCoord + TOTAL_ROW_HEIGHT;
		_controlCount = _controlCount + 1;
		_titleRowHeight = TITLE_HEIGHT;
	};

	// TODO move these to seperate functions...
	KRON_StrToArray = {
		private["_in","_i","_arr","_out"];
		_in=_this select 0;
		_arr = toArray(_in);
		_out=[];
		for "_i" from 0 to (count _arr)-1 do {
			_out set [count _out, toString([_arr select _i])];
		};
		_out
	};

	KRON_StrLen = {
		private["_in","_arr","_len"];
		_in=_this select 0;
		_arr=[_in] call KRON_StrToArray;
		_len=count (_arr);
		_len
	};

	KRON_Replace = {
		private["_str","_old","_new","_out","_tmp","_jm","_la","_lo","_ln","_i"];
		_str=_this select 0;
		_arr=toArray(_str);
		_la=count _arr;
		_old=_this select 1;
		_new=_this select 2;
		_na=[_new] call KRON_StrToArray;
		_lo=[_old] call KRON_StrLen;
		_ln=[_new] call KRON_StrLen;
		_out="";
		for "_i" from 0 to (count _arr)-1 do {
			_tmp="";
			if (_i <= _la-_lo) then {
				for "_j" from _i to (_i+_lo-1) do {
					_tmp=_tmp + toString([_arr select _j]);
				};
			};
			if (_tmp==_old) then {
				_out=_out+_new;
				_i=_i+_lo-1;
			} else {
				_out=_out+toString([_arr select _i]);
			};
		};
		_out
	};

	// Get the ID for use when looking up previously selected values.
	_titleVariableIdentifier = format ["dzn_ChooseDialog_DefaultValues_%1", [_titleText, " ", "_"] call KRON_Replace];
	{
		_choiceName = _x select 0;
		_choices = _x select 1;
		_defaultChoice = 0;
		if (count _x > 2) then
		{
			_defaultChoice = _x select 2;
		};
		
		// If this dialog is named, attmept to get the default value from a previously displayed version
		if (_titleText != "") then
		{
			_defaultVariableId = format["%1_%2", _titleVariableIdentifier, _forEachIndex];
			_tempDefault = missionNamespace getVariable [_defaultVariableId, -1];
			_isSelect = typeName _tempDefault == typeName 0;
			_isText = typeName _tempDefault == typeName "";
			
			// This really sucks but SQF does not seem to like complex ifs...
			if (_isSelect) then
			{
				if (_tempDefault != -1) then {
				_defaultChoice = _tempDefault;
				}
			};
			if (_isText) then {
				if (_tempDefault != "") then {
					_defaultChoice = _tempDefault;
				};
			};
		};

		// Create the label for this entry
		_choiceLabel = _dialog ctrlCreate ["RscText", BASE_IDC + _controlCount];
		_choiceLabel ctrlSetPosition [LABEL_COLUMN_X, _yCoord, LABEL_WIDTH, LABEL_HEIGHT];
		_choiceLabel ctrlSetText _choiceName;
		_choiceLabel ctrlCommit 0;
		_controlCount = _controlCount + 1;
		
		_comboBoxIdc = BASE_IDC + _controlCount;
		if (count _choices == 0) then 
		{
			// no choice given. Create a textbox instead.
			_defaultChoice = -1;
			
			_choiceEdit = _dialog ctrlCreate ["RscEdit", _comboBoxIdc];
			
			cmbProps = [COMBO_COLUMN_X, _yCoord, COMBO_WIDTH, COMBO_HEIGHT];
			
			_choiceEdit ctrlSetPosition cmbProps;
			_choiceEdit ctrlSetBackgroundColor [0, 0, 0, 1];
			// _choiceEdit ctrlSetText _choices;
			_choiceEdit ctrlCommit 0;
			_choiceEdit ctrlSetEventHandler ["KeyUp", "missionNamespace setVariable [format['dzn_ChooseDialog_ReturnValue_%1'," + str (_forEachIndex) + "], ctrlText (_this select 0)];"];
			_choiceEdit ctrlCommit 0;
		}
		else {
			// Create the combo box for this entry and populate it.		
			_choiceCombo = _dialog ctrlCreate ["RscCombo", _comboBoxIdc];
			_choiceCombo ctrlSetPosition [COMBO_COLUMN_X, _yCoord, COMBO_WIDTH, COMBO_HEIGHT];
			_choiceCombo ctrlCommit 0;
			{
				_choiceCombo lbAdd _x;
			} forEach _choices;
			
			// Set the current choice, record it in the global variable, and setup the event handler to update it.
			_choiceCombo lbSetCurSel _defaultChoice;
			_choiceCombo ctrlSetEventHandler ["LBSelChanged", "missionNamespace setVariable [format['dzn_ChooseDialog_ReturnValue_%1'," + str (_forEachIndex) + "], _this select 1];"];
		};
		missionNamespace setVariable [format["dzn_ChooseDialog_ReturnValue_%1",_forEachIndex], _defaultChoice];
		
		_controlCount = _controlCount + 1;

		// Move onto the next row
		_yCoord = _yCoord + TOTAL_ROW_HEIGHT;
	} forEach _choicesArray;

	missionNamespace setVariable ["dzn_ChooseDialog_Result", -1];

	// Create the Ok and Cancel buttons
	_okButton = _dialog ctrlCreate ["RscButtonMenuOK", BASE_IDC + _controlCount];
	_okButton ctrlSetPosition [OK_BUTTON_X, _yCoord, OK_BUTTON_WIDTH, OK_BUTTON_HEIGHT];
	_okButton ctrlCommit 0;
	_okButton ctrlSetEventHandler ["ButtonClick", "missionNamespace setVariable ['dzn_ChooseDialog_Result', 1]; closeDialog 1;"];
	_controlCount = _controlCount + 1;

	_cancelButton = _dialog ctrlCreate ["RscButtonMenuCancel", BASE_IDC + _controlCount];
	_cancelButton ctrlSetPosition [CANCEL_BUTTON_X, _yCoord, CANCEL_BUTTON_WIDTH, CANCEL_BUTTON_HEIGHT];
	_cancelButton ctrlSetEventHandler ["ButtonClick", "missionNamespace setVariable ['dzn_ChooseDialog_Result', -1]; closeDialog 2;"];
	_cancelButton ctrlCommit 0;
	_controlCount = _controlCount + 1;

	// Resize the background to fit all the controls we've created.
	// controlCount, and 2 for the OK/Cancel buttons. +2 for padding on top and bottom.
	_backgroundHeight = (TOTAL_ROW_HEIGHT * (count _choicesArray))
						+ _titleRowHeight
						+ OK_BUTTON_HEIGHT
						+ (1.5 * GUI_GRID_H); // We want some padding on the top and bottom
	_background ctrlSetPosition [BG_X, BG_Y, BG_WIDTH, _backgroundHeight];
	_background ctrlCommit 0;

	waitUntil { !dialog };

	// Check whether the user confirmed the selection or not, and return the appropriate values.
	if (missionNamespace getVariable "dzn_ChooseDialog_Result" == 1) then
	{
		_returnValue = [];
		{
			_returnValue set [_forEachIndex, missionNamespace getVariable (format["dzn_ChooseDialog_ReturnValue_%1",_forEachIndex])];
		}forEach _choicesArray;
		
		// Save the selections as defaults for next time
		if (_titleText != "") then
		{
			{
				_defaultVariableId = format["%1_%2", _titleVariableIdentifier, _forEachIndex];
				missionNamespace setVariable [_defaultVariableId, _x];
			} forEach _returnValue;
		};
		
		_returnValue;
	}
	else
	{
		[];
	};

};
