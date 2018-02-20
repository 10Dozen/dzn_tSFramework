tSF_fnc_adminTools_handleKey = {
	if (tSF_adminTools_isKeyPressed) exitWith {};
	switch (_this select 1) do {
		// F5
		case 63: {
			tSF_adminTools_isKeyPressed = true;
			[] spawn { sleep 1; tSF_adminTools_isKeyPressed = false; };
			[] spawn tSF_fnc_adminTools_showGSOScreen;
		};
		// F6
		case 64: {
			tSF_adminTools_isKeyPressed = true;
			[] spawn { sleep 1; tSF_adminTools_isKeyPressed = false; };
			[] spawn tSF_fnc_adminTools_RapidArtillery_showZeusSceen;
		};
		// F7
		case 65: {
			tSF_adminTools_isKeyPressed = true;
			[] spawn { sleep 1; tSF_adminTools_isKeyPressed = false; };
			[] spawn tSF_fnc_adminTools_ForceRespawn_showMenu;
		};
	};
	
	false
};

dzn_fnc_adminTools_checkIsAdmin = {
	(serverCommandAvailable "#logout") || !(isMultiplayer) || isServer
};

dzn_fnc_adminTools_addTopic = {	
	tSF_AdminTools_Topic = "tSF_AdminTools";
	player createDiarySubject [tSF_AdminTools_Topic,tSF_AdminTools_TopicName];
};

tSF_fnc_adminTools_handleGSOMenuOverZeusDisplay = {
	if (isNull (findDisplay 312)) then {
		tSF_adminTools_MenuAddedToZeus = false;
	} else {
		if (isNil "tSF_adminTools_MenuAddedToZeus" || {!tSF_adminTools_MenuAddedToZeus}) then {
			(findDisplay 312) displayAddEventHandler ["KeyUp", {call tSF_fnc_adminTools_handleKey}];
			tSF_adminTools_MenuAddedToZeus = true;
		}
	};
	
	sleep 5;
	[] spawn tSF_fnc_adminTools_handleGSOMenuOverZeusDisplay;
};


/*
	Mission Endings
*/
dzn_fnc_adminTools_addMissionEndsControls = {
	waitUntil { sleep 5; time > 5 && !isNil {tSF_Ends} };
	
	// Mission Notes
	private _topic = format [
		"<font color='#12C4FF' size='14'>Завершение миссии</font>%1%2<br />----"
		, "<br /><font color='#A0DB65'><execute expression='""end1"" spawn dzn_fnc_adminTools_callEndings;'>Generic WIN</execute></font>"
		, "<br /><font color='#A0DB65'><execute expression='""loser"" spawn dzn_fnc_adminTools_callEndings;'>Generic LOSE</execute></font>"
	];
	{		
		_topic = format [
			"%1<br /><font color='#A0DB65'><execute expression='""%2"" spawn dzn_fnc_adminTools_callEndings;'>%2</execute></font>%3"
			, _topic
			, _x select 0
			, if (_x select 1 != "") then { " (" + (_x select 1) + ")" } else { "" }
		];
		
	} forEach tSF_Ends;

	player createDiaryRecord [tSF_AdminTools_Topic, ["Mission End", _topic]];
};

tSF_End = {
	if !(call dzn_fnc_adminTools_checkIsAdmin) exitWith { hint "You are not an admin!"; };

	[] spawn {
		sleep 5;
		private _ends = [];
		{
			private _endOption = format ["%1 (%2)", _x select 0, _x select 1];
			_ends pushBack _endOption;
		} forEach tSF_Ends;

		private _Result = [];
		_Result = ["End Mission",[["Ending", _ends]]] call dzn_fnc_ShowChooseDialog;

		if (count _Result == 0) exitWith {};
		( (tSF_Ends select (_Result select 0)) select 0 ) spawn dzn_fnc_adminTools_callEndings;
	};
};

/*
    GAT Tools
*/

dzn_fnc_adminTools_addGATControls = {
	waitUntil {sleep 10; time > 10 && !isNil "dzn_gear_initDone" && !isNil "dzn_gear_gat_table" && !isNil "dzn_fnc_ShowChooseDialog"};
	player createDiaryRecord [tSF_AdminTools_Topic, [
		"GAT Tool"
		, format [
			"<font color='#12C4FF' size='14'>Gear Assignment Table Tool</font><br />%1"
			, "<font color='#A0DB65'><execute expression='[] spawn dzn_fnc_adminTools_showGATTool;'>Open GAT Tool</execute></font>"
		]
	]];
};

dzn_fnc_adminTools_showGATTool = {
	private _PlayerList = call BIS_fnc_listPlayers;
	private _PlayerNamesList = [];
	{ _PlayerNamesList pushBack (name _x); } forEach _PlayerList;

	tSF_GATList = (allVariables missionNamespace) select {  ["kit_", _x, false] call BIS_fnc_inString &&  !(["lkit_", _x, false] call BIS_fnc_inString) };
	tSF_GATList pushBack "";
	
	private _Result = [];
	_Result = [
		"GAT Tool"
		,[
			["Player", _PlayerNamesList]
			, ["GAT Kit", tSF_GATList]
			, ["or Kitname", []]
		]
	] call dzn_fnc_ShowChooseDialog;

	if (count _Result == 0) exitWith {};

	private _player = _PlayerList select (_Result select 0);
	private _kitname = if ( typename (_Result select 2) != "STRING") then {
		tSF_GATList select (_Result select 1);
	} else {
		_Result select 2;		
	};

	if (isNil {call compile _kitname}) exitWith {
		hint parseText format [
			"<t size='1' color='#FFD000' shadow='1'>GAT Tools:</t>
			<br />There is no kit named '%1'"
			, _kitname
		];
	};
	
	[_player, _kitname] remoteExec ["dzn_fnc_gear_assignKit", _player];
	hint parseText format [
		"<t size='1' color='#FFD000' shadow='1'>GAT Tools:</t>
		<br /> Kit '%1' was assigned to %2"
		, _kitname
		, _PlayerNamesList select (_Result select 0)
	];
};

/*
 *	GSO Menu
 */
tSF_fnc_adminTools_teleportTo = {
	params["_pos","_u"];
	
	if !(local _u) exitWith {
		[_pos, _u] remoteExec ["tSF_fnc_adminTools_teleportTo", _u];
	};
	
	0 cutText ["", "WHITE OUT", 0.1];
	player allowDamage false;
	sleep 1;

	//_pos set [2,0];
	moveOut player;
	player setVelocity [0,0,0];
	player setPosATL _pos;

	0 cutText ["", "WHITE IN", 1];
	sleep 3;
	player allowDamage true;
};

tSF_fnc_adminTools_heal = {
	if !(local _this) exitWith {
		_this remoteExec ["tSF_fnc_adminTools_heal",_this];
	};
	
	[_this,_this] call ace_medical_fnc_treatmentAdvanced_fullHealLocal;
};

dzn_fnc_adminTools_callEndings = {
	params["_ending"];
	if !(call dzn_fnc_adminTools_checkIsAdmin) exitWith { hint "You are not an admin!"; };
	
	private _Result = false;
	if !(isNil "dzn_fnc_ShowBasicDialog") then {
		_Result = [
			[format ["Do you want to finish the mission with ending <t color='#A0DB65'>""%1""</t>?", _ending]]
			, ["End", [1, .37, .17, .5]]
			, ["Cancel"]
		] call dzn_fnc_ShowBasicDialog;
	} else {
		_Result = true;
	};
	
	if !(_Result) exitWith {};
	
	MissionFinished = _ending;
	publicVariable "MissionFinished";
};

tSF_fnc_adminTools_addWaterPipeAction = {
	_this addAction [
		"Use Pipe"
		, {			
			PP_eff = ppEffectCreate ["WetDistortion",300];
			PP_eff ppEffectEnable true;
			PP_eff ppEffectForceInNVG true;
			PP_eff ppEffectAdjust [5,0,2,0,0,0,0,0,0,0,0,0,0,0,0];
			PP_eff ppEffectCommit 30;
			
			sleep 45;
			
			PP_eff ppEffectAdjust [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
			PP_eff ppEffectCommit 15;
			
			sleep 20;
			
			ppEffectDestroy PP_eff;
		}				
	];
};

tSF_fnc_adminTools_createTeleportRP = {
	uiSleep 0.05;
	[
		[0, "HEADER", "ADD RALLYPOINT"]
		, [1, "LABEL", "SHORTCUT"]
		, [1, "INPUT"]
		, [2, "LABEL", "<t align='center'><t color='#ffaa00'>Note:</t> Type name of existing RP to update it</t>"]
		, [3, "BUTTON", "CANCEL", { closeDialog 2; }]
		, [3, "LABEL", ""]
		, [3, "BUTTON", "ADD", {
			closeDialog 2;
			private _text = _this select 0 select 0;

			// Exit if empty string
			if ((_text splitString " " joinString "") == "") exitWith {};

			// Check if shortcut already exist
			private _toUpdate = tSF_AdminTools_Rallypoints select { _x select 0 == _text };
			private _pos = getPosATL player;

			if (_toUpdate isEqualTo []) then {
				// Add new Rallypoint
				tSF_AdminTools_Rallypoints pushBack [_text, _pos];
				hint parseText format ["<t size='1' color='#FFD000' shadow='1'>Rallypoint Added</t><br />'%1' at %2", _text, _pos];
			} else {
				// Update existing Rallypoint
				(_toUpdate select 0) set [1, _pos];
				hint parseText format [ "<t size='1' color='#FFD000' shadow='1'>Rallypoint Updated</t><br />'%1' at %2", _text, _pos];
			};

			tSF_AdminTools_TeleportListNeedUpdate = true;
			publicVariable "tSF_AdminTools_Rallypoints";
		}]
	] call dzn_fnc_ShowAdvDialog;
};

/*
 *	F5 GSO Main Screen
 */
tSF_fnc_adminTools_showGSOScreen = {
	#define ADD_GSO_POS(X,Y) 	tSF_AdminTools_GSO_TeleportPositions pushBack (X); tSF_AdminTools_GSO_TeleportSelections pushBack (Y)
	#define	ADD_PLR_POS(X,Y)	tSF_AdminTools_PLR_TeleportPositions pushBack (X); tSF_AdminTools_PLR_TeleportSelections pushBack (Y)

	if (tSF_AdminTools_TeleportListNeedUpdate) then {
		tSF_AdminTools_GSO_TeleportPositions = [];
		tSF_AdminTools_GSO_TeleportSelections = [];
		tSF_AdminTools_PLR_TeleportPositions = [getPosATL player];
		tSF_AdminTools_PLR_TeleportSelections = ["GSO"];

		{
			private _mrkPos = (getMarkerPos format["respawn%1", _x]);
			if !(_mrkPos isEqualTo [0,0,0]) then {
				ADD_GSO_POS(_mrkPos, "Base");
			};
		} forEach ["", "_west","_east","_guerrila","_civilian"];
	
		private _pl = (call BIS_fnc_listPlayers) select {
			["1'6 ", roleDescription _x] call dzn_fnc_inString
			|| ["platoon leader", roleDescription _x] call dzn_fnc_inString
			|| ["командир взвода", roleDescription _x] call dzn_fnc_inString
		};
		if !(_pl isEqualTo []) then {
			ADD_GSO_POS(getPosATL (_pl select 0),"PL");
			ADD_PLR_POS(getPosATL (_pl select 0),"PL");
		};

		if (tSF_module_CCP && {!isNil "tSF_CCP_Position"}) then {
			ADD_GSO_POS(ASLtoATL tSF_CCP_Position, "CCP");
			ADD_PLR_POS(ASLtoATL tSF_CCP_Position, "CCP");
		};

		if (tSF_module_FARP && {!isNil "tSF_FARP_Position"}) then {
			ADD_GSO_POS(ASLtoATL tSF_FARP_Position, "FARP");
			ADD_PLR_POS(ASLtoATL tSF_FARP_Position, "FARP");
		};

		{
			ADD_GSO_POS(_x select 1, _x select 0);
			ADD_PLR_POS(_x select 1, _x select 0);
		} forEach tSF_AdminTools_Rallypoints;

		tSF_AdminTools_TeleportListNeedUpdate = false;
	};

	private _endsNames = [];
	private _ends = [];
	{
		_ends pushBack (_x select 0);
		_endsNames pushBack (format ["%1 (%2)", _x select 0, _x select 1]);	
	} forEach tSF_Ends;
	
	private _listPLayers = call BIS_fnc_listPlayers;
	
	[
		[0, "HEADER", "GSO Screen"]
		
		, [1, "LABEL", "Teleport GSO"]
		, [1, "LISTBOX", tSF_AdminTools_GSO_TeleportSelections, tSF_AdminTools_GSO_TeleportPositions]
		, [1, "BUTTON", "TELEPORT", {
			closeDialog 2;
			[
				((_this select 0 select 2) select (_this select 0 select 0))
				, player
			] spawn tSF_fnc_adminTools_teleportTo;
		}]
		
		, [2, "LABEL", ""]
		, [2, "LABEL", ""]
		, [2, "BUTTON", "ADD RALLYPOINT", {
			closeDialog 2;
			[] spawn tSF_fnc_adminTools_createTeleportRP;
		}]
		
		, [3, "HEADER","<t align='center'>MISSION</t>"]
		
		, [4, "LABEL", format ["<t align='right'>AI Units: %1</t>", count allUnits - (count (call BIS_fnc_listPlayers))]]
		, [4, "LABEL", format ["<t align='left'>Players: %1</t>", count (call BIS_fnc_listPlayers)]]
		
		, [5, "LABEL", format ["<t align='right'>FPS: %1</t>", round(diag_fps)]]
		, [5, "LABEL", format ["<t align='left'>Server FPS: %1</t>", if (!isNil "tSF_adminTools_serverFPS") then { tSF_adminTools_serverFPS } else { "--" }]]
		
		, [6, "DROPDOWN", _endsNames, _ends]
		, [6, "BUTTON", "FINISH", {
			closeDialog 2;
			( (_this select 1 select 2) select (_this select 1 select 0) ) spawn dzn_fnc_adminTools_callEndings;
		}]
		
		, [7, "LABEL", ""]
		
		, [8, "HEADER", "<t align='center'>PLAYERS</t>"]
		
		, [9, "LABEL", "Select player"]
		, [9, "DROPDOWN", _listPLayers apply { name _x }, _listPLayers]
		, [9, "LABEL", ""]
		
		, [10, "LABEL", "Kit"]
		, [10, "DROPDOWN", tSF_GATList, tSF_GATList]
		, [10, "INPUT"]
		
		, [11, "LABEL", ""]
		, [11, "LABEL", ""]
		, [11, "BUTTON", "ASSIGN KIT", {
			private _u = (_this select 2 select 2) select (_this select 2 select 0);			
			private _kit = if ((_this select 4 select 0) != "") then { (_this select 4 select 0) } else { _this select 3 select 1 };
	
			if (isNil { call compile _kit }) exitWith {
				hint parseText format [
					"<t size='1' color='#FFD000' shadow='1'>GAT Tools:</t>
					<br /> There is no '%1' kit"
					, _kit
				];
			};
			
			closeDialog 2;
			
			[_u, _kit] spawn {
				params["_u","_kit"];
				
				private _DialogResult = [
					[format [
						"Do you want to assign <t color='#FFD000'>%1</t> to <t color='#FFD000'>%2</t>?"
						, _kit
						, name _u
					]]
					, ["Yes"]
					, ["No"]
				] call dzn_fnc_ShowBasicDialog;
				
				waitUntil {!dialog};
				
				if !(_DialogResult) exitWith {};
				[_u, _kit] remoteExec ["dzn_fnc_gear_assignKit", _u];
				hint parseText format [
					"<t size='1' color='#FFD000' shadow='1'>GAT Tools:</t>
					<br /> Kit '%1' was assigned to %2"
					, _kit
					, name _u
				];
			};
		}]
		
		, [12, "LABEL", "Teleport"]
		, [12, "LISTBOX", tSF_AdminTools_PLR_TeleportSelections, tSF_AdminTools_PLR_TeleportPositions]
		, [12, "BUTTON", "TELEPORT", {
			closeDialog 2;
			private _u = (_this select 2 select 2) select (_this select 2 select 0);
			private _pos = (_this select 5 select 2) select (_this select 5 select 0);
			[_pos, _u] spawn tSF_fnc_adminTools_teleportTo;
			hint format ["%1 teleported", name _u];
		}]
		
		, [13, "LABEL", "ACE Healing"]
		, [13, "LABEL", ""]
		, [13, "BUTTON", "HEAL", {
			private _u = (_this select 2 select 2) select (_this select 2 select 0);
			_u spawn tSF_fnc_adminTools_heal;
			hint format ["%1 healed", name _u];
		}]
		
		, [14, "BUTTON", "DEPLOY TACTICAL PIPE", {
			if (!isNil "tSF_WaterPipe") then {
				{ deleteVehicle _x; } forEach tSF_WaterPipe;
			};
			private _h = getPosATL player select 2;
			tSF_WaterPipe = [ player, [
				["Land_Water_pipe_EP1",73.3514,1.536,0,_h,false,{},true]
				,["Land_ChairPlastic_F",116.533,1.172,274.331,_h + 0.024,false,{},true]
				,["Land_ChairPlastic_F",79.6645,2.365,195.455,_h + 0.024,false,{},true]
				,["Land_Carpet_2_EP1",29.6481,1.748,62.135,_h,false,{},true]
			]] call dzn_fnc_setComposition;
			
			publicVariable "tSF_WaterPipe";
			{
				(tSF_WaterPipe select 0) call tSF_fnc_adminTools_addWaterPipeAction			
			} remoteExec ["bis_fnc_call", 0];
		}]
		, [14, "BUTTON", "NVG TO ALL PLAYERS", {
			[] spawn {
				hint "All players NVG assignment started";
				{
					[_x, "NVGoggles_OPFOR"] remoteExec ["addWeapon",_x];
					sleep 0.2;
				} forEach (call BIS_fnc_listPlayers);
				hint "All players NVG assignment  done";	
			};
		}]
		, [14, "BUTTON", "HEAL ALL PLAYERS", {
			[] spawn {
				hint "All players healing started";
				{
					_x spawn tSF_fnc_adminTools_heal;
					sleep 0.1;
				} forEach (call BIS_fnc_listPlayers);
				hint "All players healing done";			
			};
		}]
	] call dzn_fnc_ShowAdvDialog;
};

/*
 *	F6 Rapid Artillery Zeus Screen
 */
tSF_fnc_adminTools_RapidArtillery_showZeusSceen = {
	if !(tSF_AdminTools_RapidArtillery_Enabled) exitWith {};
	
	private _tgtNames = (entities tSF_AdminTools_RapidArtillery_TargetClass) apply { name _x };
	private _tgtPos = (entities tSF_AdminTools_RapidArtillery_TargetClass) apply { getPosATL _x };
	
	private _gunType = tSF_AdminTools_RapidArtillery_ArtillerySettings apply { _x select 0 };
	
	private _countValues = [1,3,6,9];
	private _countTitles = _countValues apply { format ["%1 times", _x] };
	
	
	private _etaValues = [40,50,60,5,10,15,20,30];
	private _etaTitles = _etaValues apply { format ["%1 sec", _x] };

	private _delayValues = [2,5,10,15,20,30,40,50,60,90,120];
	private _delayTitles = _delayValues apply { format ["%1 sec", _x] };
 
 	[
 		[0, "HEADER", "GSO Zeus Screen - Rapid Artillery Support"]
 		, [1, "DROPDOWN", _tgtNames, _tgtPos]
 		, [1, "LABEL", "TGT<t align='center'>or</t><t align='right'>8-GRID</t>"]
 		, [1, "INPUT"]
		
 		, [2, "LABEL", "Gun"]
 		, [2, "LABEL", "Round"]
 		, [2, "LABEL", "Quantity"]
		
		, [3, "DROPDOWN", _gunType, [0,1,2]]
		, [3, "DROPDOWN", tSF_AdminTools_RapidArtillery_AllowedRounds, [0,1,2]]
		, [3, "DROPDOWN", _countTitles, _countValues]
		
		, [4, "DROPDOWN", _etaTitles, _etaValues]
		, [4, "LABEL", "ETA <t align='right'>Delay</t>"]
		, [4, "DROPDOWN", _delayTitles, _delayValues]
		
		, [5, "LABEL", ""]
		, [6, "BUTTON", "CANCEL", { closeDialog 2 }]
		, [6, "LABEL", ""]
		, [6, "BUTTON", "CREATE FIREMISSION", {
			closeDialog 2;
			AC1 = _this;
			params ["_tgt", "_grid", "_gun", "_round", "_times", "_eta", "_delay"];
			// [@Pos, @TargetName], @GunID, @RoundID, @Times, @ETA, @Delay
			
			if (count (_grid select 0) > 0 && count (_grid select 0) < 8) exitWith {};
			
			private _selectedTarget = [];
			if ((_grid select 0) == "") then {
				_selectedTarget = [_tgt select 2 select (_tgt select 0), _tgt select 1];
			} else {
				_selectedTarget = [
					((_grid select 0) splitString " " joinString "") call dzn_fnc_getPosOnMapGrid
					, "Target"
				];
			};
			
			[
				_selectedTarget
				, _gun select 0
				, _round select 0
				, _times select 2 select (_times select 0)
				, _eta select 2 select (_eta select 0)
				, _delay select 2 select (_delay select 0)	
			] spawn tSF_fnc_adminTools_RapidArtillery_createFiremission;		
		}]
	] call dzn_fnc_ShowAdvDialog;
};

tSF_fnc_adminTools_RapidArtillery_createFiremission = {
	// params["_pos","_tgtName","_gun","_type","_times","_eta","_delay"];
	params ["_posAttr", "_gunID", "_typeID", "_times", "_eta", "_delay"];
	
	tSF_AdminTools_RapidArtillery_FiremissionCount = tSF_AdminTools_RapidArtillery_FiremissionCount + 1;
	private _firemissionNumber = tSF_AdminTools_RapidArtillery_FiremissionCount;
	
	private _pos 		= _posAttr select 0;
	private _tgtName 	= _posAttr select 1;
	private _gunName 	= tSF_AdminTools_RapidArtillery_ArtillerySettings select _gunID select 0;
	private _typeName	= tSF_AdminTools_RapidArtillery_AllowedRounds select _typeID;
	private _type		= ((tSF_AdminTools_RapidArtillery_ArtillerySettings select _gunID) select 1) select _typeID;
	
	// Hint
	hint parseText format [
		"<t size='1' color='#FFD000' shadow='1'>Rapid Artillery Firemission #%1:</t>
		<br /><br />%2 at %3
		<br />%4, %5, %6
		<br /><t color='#FFD000'>ETA %7 sec</t> with %8 sec delay between shots"
		, _firemissionNumber
		, _tgtName, _pos call dzn_fnc_getMapGrid
		, _gunName, _typeName, _times
		, _eta, _delay		
	];
	player createDiaryRecord [tSF_AdminTools_Topic, [
		"Rapid Artillery Missions"
		, format [
			"<font color='#12C4FF' size='14'>Firemission #%1</font><br />%2 at %3, %4, %5 %6 times"
			, _firemissionNumber, _tgtName, _pos call dzn_fnc_getMapGrid, _gunName, _typeName, _times
		]
	]];
	
	// Firemission
	sleep (_eta - 1);
	hint parseText format [
		"<t size='1' color='#FFD000' shadow='1'>Rapid Artillery Firemission #%1:</t>
		<br /><br /><t size='1.25'>Splash!</t>"
		, _firemissionNumber
	];
	sleep 1;
	
	for "_i" from 1 to _times do {
		[
			_pos
			, _type
			, random (switch (true) do {
				case (_times == 1): { 5 };
				case (_times == 3): { 25 };
				case (_times == 6): { 40 };
				case (_times == 9): { 50 };
			})
			, ["mortar", _gunName, false] call bis_fnc_InString
		] call tSF_fnc_adminTools_RapidArtillery_spawnShell;
	
		sleep _delay;	
	};
	
	hint parseText format [
		"<t size='1' color='#FFD000' shadow='1'>Rapid Artillery Firemission #%1:</t>
		<br /><br />%2 at %3, %4, %5
		<br />Rounds complete!"
		, _firemissionNumber
		, _tgtName, _pos call dzn_fnc_getMapGrid, _typeName, _times
	];
};

tSF_fnc_adminTools_RapidArtillery_spawnShell = {
	params ["_pos","_type","_disp","_isMortar", ["_h", 500],["_v", -100]];
	
	_pos = _pos getPos [_disp, random 360];
	_pos set [2, _h];
	
	private _shell = _type createVehicle _pos;
	_shell setVectorDirandUp [[0,0,-1],[0.1,0.1,1]];
	
	if (_type isKindOf "FlareCore") then {
		private _flare = objNull;
		
		for "_i" from 1 to (if (_isMortar) then { 1 } else { 2 }) do {
			_flare = "F_40mm_White" createVehicle [0,0,0];
			_flare attachTo [_shell, [0,0,0]];
		};
		
		if (isNil "dzn_fnc_flares_setFlareEffectGlobal") exitWith { deleteVehicle _shell; objNull };
		
		_shell setPosATL [_pos select 0, _pos select 1, 280];		
		[[0,0,0,0,0,_shell], if (_isMortar) then { "mortar" } else { "howitzer" }] call dzn_fnc_flares_setFlareEffectGlobal;
		
		_shell setVelocity [0,0,0.1];
		_shell spawn {			
			while { (getPosATL _this select 2) > 1 } do {
				_this setVelocity [0,0,-4];	
			};
		};
	} else {	
		_shell setVelocity [0,0,_v];
	};
	
	_shell
};

/*
 *	F7 Force Respwn Zeus Menu
 */
/*
 *	F7 Force Respwn Zeus Menu
 */
tSF_fnc_adminTools_ForceRespawn_showMenu = {
	private _players = (call BIS_fnc_listPlayers) select { !alive _x };
	private _playersStr = (_players apply { name _x }) joinString ", ";
	
	if (count _playersStr > 104) then { _playersStr = format ["%1...", _playersStr select [0,101]]; };
	tSF_adminTools_ForceRespawn_List = _players;
	
	[
		[0, "HEADER", "GSO Zeus Screen - Force Respawn"]
		, [1, "LABEL", format ["Players pending respawn: %1", count _players]]
		, [2, "LABEL",  format ["<t color='#FFD000' size='0.85'>%1</t>", _playersStr]]
		, [3, "INPUT"]
		
		, [4, "LABEL", ""]		
		, [4, "BUTTON", "SEND MESSAGE", {
			closeDialog 2;
			{
				(_this select 0 select 0) remoteExec ["tSF_fnc_adminTools_ForceRespawn_NotifySpectator", _x];
			} forEach tSF_adminTools_ForceRespawn_List;
		}]
		, [4, "LABEL", ""]
		
		, [5, "BUTTON", "CLOSE", { closeDialog 2; }]
		, [5, "LABEL", ""]
		, [5, "BUTTON", "RESPAWN ALL", {
			closeDialog 2;
			
			hint "Respawn in 5 seconds";
			{
				[] remoteExec ["tSF_fnc_adminTools_ForceRespawn_RespawnPlayer", _x];
			} forEach tSF_adminTools_ForceRespawn_List;
		}]
	] call dzn_fnc_ShowAdvDialog;
};

tSF_fnc_adminTools_ForceRespawn_RespawnPlayer = {	
	"Respawning in 5 seconds" call tSF_fnc_adminTools_ForceRespawn_NotifySpectator;
	
	setPlayerRespawnTime 5;
	sleep 7;
	setPlayerRespawnTime 9999999;
	
	[player, player getVariable "dzn_gear", false] spawn dzn_fnc_gear_assignKit;
};
publicVariable "tSF_fnc_adminTools_ForceRespawn_RespawnPlayer";

tSF_fnc_adminTools_ForceRespawn_NotifySpectator = {
	[
		[
			"<t color='#FFD000'>Сообщение от GSO</t>"
			, format ["<t align='center'>%1</t>", _this]
		]
		, "TOP"
		, [0,0,0,.75]
		, 30	
	] call dzn_fnc_ShowMessage;
};
publicVariable "tSF_fnc_adminTools_ForceRespawn_NotifySpectator";

