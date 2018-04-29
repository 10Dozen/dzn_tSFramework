/*
 *	F5 GSO Main Screen
 */
tSF_fnc_adminTools_showGSOScreen = {
	#define ADD_GSO_POS(X,Y) 	tSF_AdminTools_GSO_TeleportPositions pushBack (X); tSF_AdminTools_GSO_TeleportSelections pushBack (Y)
	#define	ADD_PLR_POS(X,Y)	tSF_AdminTools_PLR_TeleportPositions pushBack (X); tSF_AdminTools_PLR_TeleportSelections pushBack (Y)

	if !(call tSF_fnc_adminTools_checkIsAdmin) exitWith {};	
	
	if (tSF_AdminTools_TeleportListNeedUpdate) then {
		tSF_AdminTools_GSO_TeleportPositions = [];
		tSF_AdminTools_GSO_TeleportSelections = [];
		tSF_AdminTools_PLR_TeleportPositions = [player];
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
			ADD_GSO_POS(_pl select 0,"PL");
			ADD_PLR_POS(_pl select 0,"PL");
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
	private _gatList = if (!isNil "tSF_GATList") then { tSF_GATList } else { [] };

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
			( (_this select 1 select 2) select (_this select 1 select 0) ) spawn tSF_fnc_adminTools_callEndings;
		}]

		, [7, "LABEL", ""]

		, [8, "HEADER", "<t align='center'>PLAYERS</t>"]

		, [9, "LABEL", "Select player"]
		, [9, "DROPDOWN", _listPLayers apply { name _x }, _listPLayers]
		, [9, "LABEL", ""]

		, [10, "LABEL", "Kit"]
		, [10, "DROPDOWN", _gatList, _gatList]
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

tSF_fnc_adminTools_teleportTo = {
	params["_pos","_u"];
	
	if (typename _pos == "OBJECT") then {
		_pos = getPosATL _pos;
	};
	
	if !(local _u) exitWith {
		[_pos, _u] remoteExec ["tSF_fnc_adminTools_teleportTo", _u];
	};
	
	0 cutText ["", "WHITE OUT", 0.1];
	player allowDamage false;
	sleep 1;

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
