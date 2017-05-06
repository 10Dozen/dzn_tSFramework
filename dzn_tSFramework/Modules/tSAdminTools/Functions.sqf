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
		if !(tSF_adminTools_MenuAddedToZeus) then {
			(findDisplay 312) displayAddEventHandler ["KeyUp", {
				if (tSF_adminTools_isKeyPressed) exitWith {};				
				private _key = _this select 1;
				if (_key == 63) then {
					tSF_adminTools_isKeyPressed = true;
					[] spawn { sleep 1; tSF_adminTools_isKeyPressed = false; };					
					[] spawn tSF_fnc_adminTools_showGSOScreen;
				};				
				false
			}];
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
tSF_fnc_admintTools_teleportTo = {
	params["_pos","_u"];
	AX = _pos;
	
	if !(local _u) exitWith {
		[_pos, _u] remoteExec ["tSF_fnc_admintTools_teleportTo", _u];
	};
	
	0 cutText ["", "WHITE OUT", 0.1];
	player allowDamage false;
	sleep 1;

	_pos set [2,0];
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


/*
 *
 */
tSF_fnc_adminTools_showGSOScreen = {
	
	private _gsoTeleportSelections = [];
	private _gsoTeleportPositions = [];
	private _playerTeleportSelections = ["GSO"];
	private _playerTeleportPositions = [getPosATL player];
	
	if !((getMarkerPos "respawn_west") isEqualTo [0,0,0]) then { 
		_gsoTeleportPositions pushBack (getMarkerPos "respawn_west");
		_gsoTeleportSelections pushBack "Base";
	};
	
	private _pl = (call BIS_fnc_listPlayers) select { 
		["1'6 ", roleDescription _x] call dzn_fnc_inString 
		|| ["platoon leader", roleDescription _x] call dzn_fnc_inString 
		|| ["командир взвода", roleDescription _x] call dzn_fnc_inString 
	};
	if !(_pl isEqualTo []) then {
		_gsoTeleportPositions pushBack (getPosATL (_pl select 0));
		_gsoTeleportSelections pushBack "PL";		
		_playerTeleportPositions pushBack (getPosATL (_pl select 0));
		_playerTeleportSelections pushBack "PL";
	};
	
	if (tSF_module_CCP && {!isNil "tSF_CCP_Position"}) then {
		_gsoTeleportPositions pushBack tSF_CCP_Position;
		_gsoTeleportSelections pushBack "CCP";		
		_playerTeleportPositions pushBack tSF_CCP_Position;
		_playerTeleportSelections pushBack "CCP";
	};
	
	if (tSF_module_FARP && {!isNil "tSF_FARP_Position"}) then {
		_gsoTeleportPositions pushBack tSF_FARP_Position;
		_gsoTeleportSelections pushBack "FARP";		
		_playerTeleportPositions pushBack tSF_FARP_Position;
		_playerTeleportSelections pushBack "FARP";
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
		, [1, "LISTBOX", _gsoTeleportSelections, _gsoTeleportPositions]
		, [1, "BUTTON", "TELEPORT", {
			closeDialog 2;
			[
				((_this select 0 select 2) select (_this select 0 select 0))
				, player
			] spawn tSF_fnc_admintTools_teleportTo;
		}]
		
		, [2, "LABEL", ""]
		
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
			
			[_u, _kit] remoteExec ["dzn_fnc_gear_assignKit", _u];
			hint parseText format [
				"<t size='1' color='#FFD000' shadow='1'>GAT Tools:</t>
				<br /> Kit '%1' was assigned to %2"
				, _kit
				, name _u
			];		
		}]
		
		, [12, "LABEL", "Teleport"]
		, [12, "LISTBOX", _playerTeleportSelections, _playerTeleportPositions]
		, [12, "BUTTON", "TELEPORT", {
			closeDialog 2;
			private _u = (_this select 2 select 2) select (_this select 2 select 0);
			private _pos = (_this select 5 select 2) select (_this select 5 select 0);
			[_pos, _u] spawn tSF_fnc_admintTools_teleportTo;
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
			
			tSF_WaterPipe = [ player, [
				["Land_Water_pipe_EP1",73.3514,1.536,0,0,false,{},true]
				,["Land_ChairPlastic_F",116.533,1.172,274.331,0.024,false,{},true]
				,["Land_ChairPlastic_F",79.6645,2.365,195.455,0.024,false,{},true]
				,["Land_Carpet_2_EP1",29.6481,1.748,62.135,0,false,{},true]
			]] call dzn_fnc_setComposition;
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
