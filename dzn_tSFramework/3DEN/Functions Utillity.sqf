dzn_tSF_3DEN_onKeyPress = {
	if (dzn_tSF_3DEN_keyIsDown) exitWith {};
	
	private _key = _this select 1; 
	private _ctrl = _this select 3; 
	private _handled = false;

	switch _key do {
		// Space
		case 57: {
			dzn_tSF_3DEN_keyIsDown = true;			
			if (_ctrl) then { [] spawn dzn_fnc_tSF_3DEN_ShowTool; };
			_handled = true;
		};
	};
	
	[] spawn { sleep 1; dzn_tSF_3DEN_keyIsDown = false; };
	_handled
};

dzn_fnc_tSF_3DEN_ShowTool = {
	if (dzn_tSF_3DEN_toolDisplayed) exitWith {};
	dzn_tSF_3DEN_toolDisplayed = true;
	
	dzn_tSF_3DEN_SelectedUnits = get3DENSelected "object";
	
	private _resolveOption = {};
	private _options = [
		["Add Playable Squad"			, { [] spawn dzn_fnc_tSF_3DEN_AddSquad }]	
		,["[DynAI] Add Zone"			, { [] spawn { call dzn_fnc_tSF_3DEN_AddDynaiZone } }]		
		,["[Gear] Add Kit Logic"		, { [] spawn { call dzn_fnc_tSF_3DEN_AddGearLogic } }]
		
		,["[Unit] Add Unit Behavior"		, { [] spawn { call dzn_fnc_tSF_3DEN_ResolveUnitBehavior } }]	
		,["[Vehicle] Add Vehicle Crew"		, { [] spawn { call dzn_fnc_tSF_3DEN_AddEVCLogic } }]
		,["[Vehicle] Add TFAR LR Radio"		, { [] spawn { call dzn_fnc_tSF_3DEN_AddERSLogic } }]
		
		,["[Support] Assign Vehicle as Supporter"		, { [] spawn { call dzn_fnc_tSF_3DEN_AddAsSupporter } }]
		,["[Support] Add Return point"		, { [] spawn { call dzn_fnc_tSF_3DEN_AddSupportReturnPoint } }]		
		
		,["[tSF] Configure Scenario"		, { [] spawn { call dzn_fnc_tSF_3DEN_ConfigureScenario } }]
		,["[tSF] Add Zeus"			, { call dzn_fnc_tSF_3DEN_AddZeus }]
		,["[tSF] Add Base Trigger"		, { call dzn_fnc_tSF_3DEN_AddBaseTrg }]
		,["[tSF] Add CCP"				, { call dzn_fnc_tSF_3DEN_AddCCP }]	
		,[" "						, { }]	
		
	];
	
	private _optionList = [];
	{ _optionList pushBack (_x select 0); } forEach _options;
	
	
	call dzn_fnc_tSF_3DEN_ResetVariables;
	private _toolResult = [
		"tSF Tool"
		, [["Select action", _optionList]]
	] call dzn_fnc_3DEN_ShowChooseDialog;
	Result = _toolResult;
	if (count _toolResult == 0) exitWith { dzn_tSF_3DEN_toolDisplayed = false };
	
	call ((_options select (_toolResult select 0)) select 1);	
	dzn_tSF_3DEN_toolDisplayed = false;
};


/*
 *	LAYERS & UTILITIES
 *
 */
dzn_fnc_tSF_3DEN_ShowNotif = {
	[_this, 0, 15, true] call BIS_fnc_3DENNotification;
};

dzn_fnc_tSF_3DEN_ShowWarn = {
	[_this, 1, 15, true] call BIS_fnc_3DENNotification;
};


dzn_fnc_tSF_3DEN_createTSFLayer = {
	if (typename dzn_tSF_3DEN_tSFLayer != "SCALAR") then { dzn_tSF_3DEN_tSFLayer = -1 add3DENLayer "tSF Layer"; };
};
dzn_fnc_tSF_3DEN_createDynaiLayer = {
	if (typename dzn_tSF_3DEN_DynaiLayer != "SCALAR") then { dzn_tSF_3DEN_DynaiLayer = -1 add3DENLayer "DynAI Layer"; };
};
dzn_fnc_tSF_3DEN_createGearLayer = {
	if (typename dzn_tSF_3DEN_GearLayer != "SCALAR") then { dzn_tSF_3DEN_GearLayer = -1 add3DENLayer "dzn_Gear Layer"; };
};

dzn_fnc_tSF_3DEN_createMiscLayer = {
	if (typename dzn_tSF_3DEN_MiscLayer != "SCALAR") then { dzn_tSF_3DEN_MiscLayer = -1 add3DENLayer "3DEN Tools Layer"; };
};
dzn_fnc_tSF_3DEN_createUnitLayer = {
	if (typename dzn_tSF_3DEN_UnitsLayer != "SCALAR") then { dzn_tSF_3DEN_UnitsLayer = -1 add3DENLayer "Playable Units"; };
};
dzn_fnc_tSF_3DEN_createSupporterLayer = {
	if (typename dzn_tSF_3DEN_SupporterLayer != "SCALAR") then { dzn_tSF_3DEN_SupporterLayer = -1 add3DENLayer "tSF Supporters"; };
};

dzn_fnc_tSF_3DEN_ResetVariables = {
	/*
		get3DENEntityID dzn_tSF_3DEN_SupportReturnPointCore
		
		{
			B=0;
			A = all3DENEntities select B select 0;
			C = A get3DENAttribute "name"
		} forEach all3DENEntities;
	*/
	{
		call compile format ["if (get3DENEntityID %1 == -1) then { %1 = objNull; };" , _x];	
	} forEach [
		"dzn_tSF_3DEN_DynaiCore"
		, "dzn_tSF_3DEN_Zeus"
		, "dzn_tSF_3DEN_BaseTrg"
		, "dzn_tSF_3DEN_CCP"
		, "dzn_tSF_3DEN_SupportReturnPointCore"
		
		, "dzn_tSF_3DEN_UnitsLayer"
		, "dzn_tSF_3DEN_tSFLayer"
		, "dzn_tSF_3DEN_GearLayer"
		, "dzn_tSF_3DEN_DynaiLayer"
		, "dzn_tSF_3DEN_MiscLayer"
		, "dzn_tSF_3DEN_SupporterLayer"
	];
	
	{	
		{
			private _entity = _x;
			{			
				if ((_entity get3DENAttribute "name") select 0 == (_x select 1)) then {
					call compile format ["%1 = _entity;", _x select 0];
				};			
			} forEach [
				["dzn_tSF_3DEN_DynaiCore"			, "dzn_dynai_core" ]
				,["dzn_tSF_3DEN_BaseTrg"			, "baseTrg" ]
				,["dzn_tSF_3DEN_CCP"				, "tsf_CCP" ]
				,["dzn_tSF_3DEN_SupportReturnPointCore"	, "tSF_Support_ReturnPointCore" ]				
				,["dzn_tSF_3DEN_tSFLayer"			, "tSF Layer" ]
				,["dzn_tSF_3DEN_DynaiLayer"			, "DynAI Layer" ]
				,["dzn_tSF_3DEN_GearLayer"			, "dzn_Gear Layer" ]
				,["dzn_tSF_3DEN_MiscLayer"			, "3DEN Tools Layer" ]
				,["dzn_tSF_3DEN_UnitsLayer"			, "Playable Units" ]
				,["dzn_tSF_3DEN_SupporterLayer"		, "tSF Supporters" ]
			];			
		} forEach (_x);
	} forEach all3DENEntities;
};


dzn_fnc_tSF_3DEN_GetDynaiZoneNames = {
	private _dynaiZones = [
		get3DENLayerEntities dzn_tSF_3DEN_DynaiLayer
		, {
			typeOf _x == "Logic" 
			&& (_x get3DENAttribute "name") select 0 != ""
			&& (_x get3DENAttribute "name") select 0 != "dzn_dynai_core"
		}
	] call BIS_fnc_conditionalSelect;
	
	private _names = "Dynai zones:

";
	{
		_names = format["%1%2%3", _names, if (_forEachIndex > 0) then { ", " } else { "" }, (_x get3DENAttribute "name") select 0];
	} forEach _dynaiZones;
	
	[parseText "<t shadow='2'color='#e6c300' align='center' font='PuristaBold' size='1.1'>Dynai zone names were copied!</t>", [0,.7,1,1], nil, 7, 0.2, 0] spawn BIS_fnc_textTiles;
	copyToClipboard _names;
};

dzn_fnc_tSF_3DEN_GetUnitNames = {
	private _playableUnits = [
		get3DENLayerEntities dzn_tSF_3DEN_UnitsLayer
		, {
			groupId _x != ""
		}
	] call BIS_fnc_conditionalSelect;
	
	private _supporters = [
		get3DENLayerEntities dzn_tSF_3DEN_SupporterLayer
		, {
			(_x get3DENAttribute "description") select 0 != ""
		}	
	] call BIS_fnc_conditionalSelect;
	
	private _names = "Groups:

";
	{
		_names = format["%1%2%3", _names, if (_forEachIndex > 0) then { "
" } else { "" }, groupId _x];
	} forEach _playableUnits;
	
	private _names = _names + "
	
Supporters:

";
	{
		_names = format["%1%2%3", _names, if (_forEachIndex > 0) then { "
" } else { "" }, (_x get3DENAttribute "description") select 0];
	} forEach _supporters;
	
	[parseText "<t shadow='2'color='#e6c300' align='center' font='PuristaBold' size='1.1'>Unit names were copied!</t>", [0,.7,1,1], nil, 7, 0.2, 0] spawn BIS_fnc_textTiles;
	copyToClipboard _names;
};


/*
 *	Dialog Function
 */
 
dzn_fnc_3DEN_ShowChooseDialog = {
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
		_labelControl ctrlSetFont "PuristaBold";
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
		_choiceLabel ctrlSetFont "PuristaLight";
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
			_choiceEdit ctrlSetFont "PuristaLight";
			// _choiceEdit ctrlSetText _choices;
			_choiceEdit ctrlCommit 0;
			_choiceEdit ctrlSetEventHandler ["KeyUp", "missionNamespace setVariable [format['dzn_ChooseDialog_ReturnValue_%1'," + str (_forEachIndex) + "], ctrlText (_this select 0)];"];
			_choiceEdit ctrlCommit 0;
		}
		else {
			// Create the combo box for this entry and populate it.		
			_choiceCombo = _dialog ctrlCreate ["RscCombo", _comboBoxIdc];
			_choiceCombo ctrlSetPosition [COMBO_COLUMN_X, _yCoord, COMBO_WIDTH, COMBO_HEIGHT];
			_choiceCombo ctrlSetFont "PuristaLight";
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
	
	
	// Here some function to obtain dynai zone names
	_dynaiButton = _dialog ctrlCreate ["RscButtonMenuOK", BASE_IDC + _controlCount];
	_dynaiButton ctrlSetStructuredText parseText "<t size='0.75' color='#999999'>[Dynai] Copy zones names</t>";
	_dynaiButton ctrlSetPosition [OK_BUTTON_X - 0.7, _yCoord + 0.1, 2.5*OK_BUTTON_WIDTH, (1 * GUI_GRID_H)];
	_dynaiButton ctrlCommit 0;	
	_dynaiButton  ctrlSetEventHandler ["ButtonClick", "[] spawn dzn_fnc_tSF_3DEN_GetDynaiZoneNames;"];

	_unitsButton = _dialog ctrlCreate ["RscButtonMenuOK", BASE_IDC + _controlCount];
	_unitsButton ctrlSetStructuredText parseText "<t size='0.75' color='#999999'>Copy Callsigns</t>";
	_unitsButton ctrlSetPosition [OK_BUTTON_X - 0.4, _yCoord + 0.1, 2.5*OK_BUTTON_WIDTH, (1 * GUI_GRID_H)];
	_unitsButton ctrlCommit 0;	
	_unitsButton  ctrlSetEventHandler ["ButtonClick", "[] spawn dzn_fnc_tSF_3DEN_GetUnitNames;"];	
	
	_controlCount = _controlCount + 1;

	// Resize the background to fit all the controls we've created.
	// controlCount, and 2 for the OK/Cancel buttons. +2 for padding on top and bottom.
	_backgroundHeight = (TOTAL_ROW_HEIGHT * (count _choicesArray))
						+ _titleRowHeight
						+ 2*OK_BUTTON_HEIGHT
						+ (1.5 * GUI_GRID_H); // We want some padding on the top and bottom
	_background ctrlSetPosition [BG_X, BG_Y, BG_WIDTH, _backgroundHeight];
	_background ctrlSetBackgroundColor [0,0,0, .6];
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