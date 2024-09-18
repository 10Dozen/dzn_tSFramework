#include "script_component.hpp"

/*
 *	F5 GSO Main Screen
 */

tSF_fnc_adminTools_prepareGSOScreenData = {
	// -- Locations 
	private _locs = [] call tSF_fnc_adminTools_getLocationOptions;

	// -- Ends 
	private _endsList = [
		[""],
		["Победа", "WIN", [
			["textRight", "(стандартная)"],
			["textRightColor", COLOR_RGBA_GRAY]
		]],
		["Поражение", "LOSER", [
			["textRight", "(стандартная)"],
			["textRightColor", COLOR_RGBA_GRAY]
		]]
	];
	if (TSF_MODULE_ENABLED(MissionConditions)) then {
		if (!isNil QEGVAR(MissionConditions,Endings)) then {
			{
				_x params ["_name", "_desc"];
				_endsList pushBack [
					[_name, _desc] select (_desc != ""),
					_name,
					[
						["color", COLOR_RGBA_LIGHT_GREEN],
						["textRight", "(условие)"]
					]
				]
			} forEach EGVAR(MissionConditions,Endings);
		};
	};

	// -- Players
	([] call tSF_fnc_adminTools_getPlayersAndGroupsOptions) params [
        "_playerOptions",
        "_groupOptions",
        "_players",
        "_groups"
    ];
	private _playerOptionsTotal = [
		[""],
		["Все игроки", objNull, [
			["color", COLOR_RGBA_LIGHT_GREEN],
			["textRight", format ["%1 чел.", count _players]],
			["textRightColor", COLOR_RGBA_LIGHT_GREEN]
		]]
	] + _groupOptions + _playerOptions;

	// -- Kits 
	private _gatMap = createHashMap;
	{
		_x params ["_role", "_kit"];
		private _listOfRoles = _gatMap getOrDefaultCall [_kit, { [] }, true];
		_listOfRoles pushBack _role;
	} forEach dzn_gear_gat_table;

	private _kitsOptions = tSF_GATList apply {
		private _assosiatedRoles = ([
			(_gatMap getOrDefault [_x, []]) joinString ", ",
			100,
			",",
			" и т.д."
		] call tSF_fnc_adminTools_cutLongLine) # 0;
		[
			_x,
			_x,
			[
				["tooltip", _assosiatedRoles],
				["color", [COLOR_RGBA_WHITE, COLOR_RGBA_LIGHT_GREEN] select (_assosiatedRoles != "")]
			]
		]
	};

	createHashMapFromArray [
		["missionEndings", _endsList],
		["playersOptions", _playerOptionsTotal],
		["locations", _locs],
		["kits", _kitsOptions],
		["aiUnitsCount", count (allUnits - _players)],
		["playersCount", count _players],
		["fps", round diag_fps],
		["fpsServer", ["--", tSF_adminTools_serverFPS] select (!isNil "tSF_adminTools_serverFPS")],
		["missionTime", [CBA_missionTime, "HH:MM:SS"] call BIS_fnc_secondsToString]
	]
};

tSF_fnc_adminTools_showGSOScreen = {
	if !(call tSF_fnc_adminTools_checkIsAdmin) exitWith {};

    // -- Functions
	_onTeleport = {
		params ["_AD", "_args"];
		_args params ["_isForGSO"];

		private _targets = [player];
		private _msgArg = "GSO";
		(_AD call [
			"GetValueByTag", ["dp_playerLocations","dp_locations"] select _isForGSO
		]) params [
			"",
			"_selectedLocationName",
			"_selectedLocation"
		];

		if (_isForGSO) exitWith {
			[_selectedLocation, _selectedLocationName] call tSF_fnc_adminTools_teleportToLocal;
			hint format ["Вы были перемещены в локацию %1!", _selectedLocationName];
			_AD call ["Close"];
		};

		(_AD call ["GetValueByTag", "dp_player"]) params ["","","_selectedPlayers"];

		// objNull -- means ALL players 
		// object - means specific player 
		// group - means all players in group 
		if (_selectedPlayers isEqualType "" && { _selectedPlayers == "" }) exitWith {};
		if (isNull _selectedPlayers) then {
			_targets = call BIS_fnc_listPlayers;
			_msgArg = "всех игроков";
		} else {
			if (_selectedPlayers isEqualType grpNull) then {
				_targets = units _selectedPlayers;
				_msgArg = format ["всех игроков отряда %1", groupId _selectedPlayers];
			} else {
				_targets = [_selectedPlayers];
				_msgArg = format ["игрока %1",name _selectedPlayers];
			};
		};
		
		_AD call ["Close"];
		
		[_targets, _msgArg, _selectedLocation, _selectedLocationName] spawn {
			params ["_targets", "_msgArg", "_selectedLocation", "_selectedLocationName"];
			private _result = [
				format [
					"Переместить <t color='%2'>%1</t> в локацию <t color='%4'>%3</t>?",
					_msgArg,
					COLOR_HEX_GOLD,
					_selectedLocationName, 
					COLOR_HEX_LIME
				]
			] call tSF_fnc_adminTools_showGSOActionConfirmDialog;
			if !(_result) exitWith {};

			[
				_selectedLocation,
				_selectedLocationName				
			] remoteExec ["tSF_fnc_adminTools_teleportToLocal", _targets];

			hint format [
				"%1 перемещен(ы) в локацию %2",
				_msgArg,
				_selectedLocationName
			];
		};
	};
	_onAddLocation = {
		params ["_AD"];
		_AD call ["Close"];
		[{ [] call tSF_fnc_adminTools_createTeleportRP }] call CBA_fnc_execNextFrame;
	};
	_onMissionEnd = {
		params ["_AD"];
		(_AD call ["GetValueByTag", "dp_ends"]) params [
			"","","_selectedEnding"
		];
		if (_selectedEnding == "") exitWith {};

		_AD call ["Close"];
		[_selectedEnding] spawn tSF_fnc_adminTools_callEndings;
	};
	_onGearAssign = {
		params ["_AD"];
		(_AD call ["GetValueByTag", "dp_player"]) params [
			"","","_selectedPlayers"
		];
		(_AD call ["GetValueByTag", "dp_kits"]) params [
			"","","_selectedKit"
		];
		// objNull -- means ALL players 
		// object - means specific player 
		// group - means all players in group 
		if (_selectedPlayers isEqualType "" && { _selectedPlayers == "" }) exitWith {};
		private _targets = [];
		private _msgArg = "";		
		if (isNull _selectedPlayers) then {
			_targets = call BIS_fnc_listPlayers;
			_msgArg = "всем игрокам";
		} else {
			if (_selectedPlayers isEqualType grpNull) then {
				_targets = units _selectedPlayers;
				_msgArg = format ["всем игрокам отряда %1", groupId _selectedPlayers];
			} else {
				_targets = [_selectedPlayers];
				_msgArg = format ["игроку %1",name _selectedPlayers];
			};
		};
		_AD call ["Close"];

		[_targets, _msgArg, _selectedKit] spawn {
			params ["_targets", "_msgArg", "_kit"];
			private _result = [
				format [
					"Назначить набор <t color='%2'>%1</t> <t color='%4'>%3</t>?",
					_kit, 
					COLOR_HEX_LIME,
					_msgArg,
					COLOR_HEX_GOLD
				]
			] call tSF_fnc_adminTools_showGSOActionConfirmDialog;
			if !(_result) exitWith {};

			[_kit] remoteExec ["tSF_fnc_adminTools_assignKitLocal", _targets];
			hint format [
				"Набор %1 был назначен %2",
				_kit,
				_msgArg
			];
		};
	};
	_onHeal = {
		params ["_AD"];
		(_AD call ["GetValueByTag", "dp_player"]) params [
			"","","_selectedPlayers"
		];
		if (_selectedPlayers isEqualType "" && { _selectedPlayers == "" }) exitWith {};
		// objNull -- means ALL players 
		// object - means specific player 
		// group - means all players in group 
		private _targets = [];
		private _msg = "";
		if (isNull _selectedPlayers) then {
			_targets = call BIS_fnc_listPlayers;
			_msg = "Все игроки вылечены!";
		} else {
			if (_selectedPlayers isEqualType grpNull) then {
				_targets = units _selectedPlayers;
				_msg = format [
					"Все игроки отряда %1 вылечены!\n\n%2", 
					groupId _selectedPlayers,
					((units _selectedPlayers) apply { name _x }) joinString "\n"
				];
			} else {
				_targets = [_selectedPlayers];
				_msg = format ["Игрок %1 вылечен!",name _selectedPlayers];
			};
		};

		[] remoteExec ["tSF_fnc_adminTools_heal", _targets];
		hint _msg;
	};
	_onGiveNVG = {
		params ["_AD"];
		(_AD call ["GetValueByTag", "dp_player"]) params [
			"","","_selectedPlayers"
		];
		if (_selectedPlayers isEqualType "" && { _selectedPlayers == "" }) exitWith {};
		// objNull -- means ALL players 
		// object - means specific player 
		// group - means all players in group 
		private _targets = [];
		private _msg = "";
		if (isNull _selectedPlayers) then {
			_targets = call BIS_fnc_listPlayers;
			_msg = "ПНВ выдан всем игрокам!";
		} else {
			if (_selectedPlayers isEqualType grpNull) then {
				_targets = units _selectedPlayers;
				_msg = format [
					"ПНВ выдан всем игрокам отряда %1!\n\n%2", 
					groupId _selectedPlayers,
					((units _selectedPlayers) apply { name _x }) joinString "\n"
				];
			} else {
				_targets = [_selectedPlayers];
				_msg = format ["ПНВ выдан игроку %1!",name _selectedPlayers];
			};
		};

		{ _x addWeaponGlobal "NVGoggles_OPFOR"; } forEach _targets;
		hint _msg;
	};
	_onDeployTacticalPipe = {
		params ["_AD"];
		_AD call ["Close"];
		[] call tSF_fnc_adminTools_deployTacticalPipe; 
		hint "Тактический Дымогенератор установлен!";
	};

	_onUIUpdate = {
		if (!dialog) exitWith {};
        _thisArgs params ["_cob"];

		private _data = [] call tSF_fnc_adminTools_prepareGSOScreenData;
		{
			_x params ["_tag", "_formatData"];
			(
				_cob call ["GetByTag", _tag]
			) ctrlSetStructuredText parseText format _formatData;
		} forEach [
			["l_aiUnits", [Q(MENU_AI_COUNT), _data get "aiUnitsCount"]],
			["l_playableUnits", [Q(MENU_PLAYER_COUNT), _data get "playersCount"]],
			["l_fps", [Q(MENU_FPS), _data get "fps"]],
			["l_fpsServer", [Q(MENU_FPS_SERVER), _data get "fpsServer"]],
			["l_missionTime", [Q(MENU_LABEL_LEFT_ALIGN), _data get "missionTime"]]
		];
	};

	// -- Data 
	private _data = [] call tSF_fnc_adminTools_prepareGSOScreenData;

	private _menu = [
		["HEADER", "GSO Меню"],
		["onCBAEvent", "tSF_AdminTools_uiUpdate", _onUIUpdate],
		["LABEL", "Локации", [["w", 0.25]]],
		["DROPDOWN", _data get "locations", 0, [["tag", "dp_locations"], ["bg", COLOR_RGBA_BLACK]]],
		["BUTTON", "Телепорт", _onTeleport, [true], [
			["w", 0.25], 
			["tooltip", "Телепортировать GSO в выбранную локацию."]
		]],
		["BR"],
		["LABEL"],
		["BUTTON", "Добавить", _onAddLocation, [], [
			["w", 0.25], 
			["tooltip", "Сохранить текущее местоположение GSO как точку телепорта/респауна."]
		]],
		["BR"],

		["LABEL", "<t align='center'>МИССИЯ</t>", [["bg", COLOR_RGBA_BY_UI]]],
		["BR"],
		
		[
			"LABEL", 
			format [Q(MENU_AI_COUNT), _data get "aiUnitsCount"],
			[["tag", "l_aiUnits"]]
		],
		[
			"LABEL", 
			format [Q(MENU_PLAYER_COUNT), _data get "playersCount"],
			[["tag", "l_playableUnits"]]
		],
		["BR"],
		[
			"LABEL", 
			format [Q(MENU_FPS), _data get "fps"],
			[["tag", "l_fps"]]
		],
		[
			"LABEL", 
			format [Q(MENU_FPS_SERVER), _data get "fpsServer"],
			[["tag", "l_fpsServer"]]

		],
		["BR"],
		["LABEL", "<t align='right'>Время миссии:</t>"],
		["LABEL", format [Q(MENU_LABEL_LEFT_ALIGN), _data get "missionTime"], [["tag", "l_missionTime"]]],
		["BR"],

		["DROPDOWN", _data get "missionEndings", 0, [["tag", "dp_ends"], ["bg", COLOR_RGBA_BLACK]]],
		[
			"BUTTON", 
			"Завершить", 
			_onMissionEnd, 
			[], 
			[
				["tooltip", "Завершает миссию выбранной концовкой"]
			]
		],
		["BR"],

		["LABEL", "<t align='center'>ИГРОКИ</t>", [["bg", COLOR_RGBA_BY_UI]]],
		["BR"],
		["LABEL", "Игрок/Группа", [["w", 0.25]]],
		["DROPDOWN", _data get "playersOptions", 0, [["tag", "dp_player"], ["bg", COLOR_RGBA_BLACK]]],
		["BR"],

		["LABEL", "Снаряжение", [["w", 0.25]]],
		["DROPDOWN", _data get "kits", 0, [["tag", "dp_kits"], ["bg", COLOR_RGBA_BLACK]]],
		
		["BUTTON", "Выдать", _onGearAssign, [], [
			["tooltip", "Выдать выбранный набор снаряжения"],
			["w", 0.25]
		]],
		["BR"],

		["LABEL", ""],
		["BUTTON", "Выдать ПНВ", _onGiveNVG, [], [
			["tooltip", "Выдать Прибор ночного видения выбранному игроку"],
			["w", 0.25]
		]],
		["BR"],
		
		["LABEL", "Состояние"],
		["BUTTON", "Вылечить", _onHeal, [], [
			["tooltip", "Исцелить выбранного игрока"],
			["w", 0.25]
		]],
		["BR"],

		["LABEL", "Позиция", [["w", 0.25]]],
		["DROPDOWN", _data get "locations", 0, [["tag", "dp_playerLocations"], ["bg", COLOR_RGBA_BLACK]]],
		["BUTTON", "Телепорт", _onTeleport, [false], [
			["tooltip", "Переместить выбранного игрока или группу в выбранную локацию."],
			["w", 0.25]
		]],
		["BR"],

		["LABEL"],
		["BR"],

		["LABEL", "<t align='center'>ПРОЧЕЕ</t>", [["bg", COLOR_RGBA_BY_UI]]],
		["BR"],
		[
			"BUTTON", 
			"Tactical Pipe", 
			_onDeployTacticalPipe, [], 
			[
				[
					"tooltip", 
					"Устанавливает Тактический Парогенератор. Если вы находитесь в машине, то установит его прямо внутри!"
				],
				["w", 0.33]
			]
		]
	];

	_menu call dzn_fnc_ShowAdvDialog2;
};


tSF_fnc_adminTools_heal = {
	[player] call ace_medical_treatment_fnc_fullHealLocal;
};

tSF_fnc_adminTools_deployTacticalPipe = {
	if (!isNil {cursorTarget} && { cursorTarget isKindOf "LandVehicle" }) exitWith {
		cursorTarget remoteExec ["tSF_fnc_adminTools_addWaterPipeAction", 0];
		hint "Тактический Кальян развернут!";
	};

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
	(tSF_WaterPipe select 0) remoteExec ["tSF_fnc_adminTools_addWaterPipeAction", allPlayers];
};

tSF_fnc_adminTools_addWaterPipeAction = {
	[
		_this
		, "Пыхнуть"
		, {	1 spawn tSF_fnc_adminTools_doWaterPipeAction }
		, 8
	] call dzn_fnc_addAction;
	[
		_this
		, "Затянуться"
		, {	2 spawn tSF_fnc_adminTools_doWaterPipeAction }
		, 8
	] call dzn_fnc_addAction;
};

tSF_fnc_adminTools_doWaterPipeAction = {
	params ["_type"];
	private _time1 = 45;
	private _time2 = 20;

	if (_type == 2) then {
		_time1 = 240;
		_time2 = 60;
	};

	if (!isNil "tSF_Pipe_PP_eff") then {
		ppEffectDestroy tSF_Pipe_PP_eff;
		tSF_Pipe_PP_eff = nil;
		sleep 0.5;
	};

	for "_i" from 1 to 20 do {
		drop [
			["\A3\data_f\ParticleEffects\Universal\Universal", 16, 7, 48],
			"",	"Billboard",0, 9.5 + random 0.5,
			[0, 0.75,  -0.15 + (player modelToWorld (player selectionPosition "head")) # 2],
			[0,0,0.2], 1, 0.05, 0.04, 0, [0.25, 0.25 + random 1],
			[[1,1,1,0.1],[1,1,1,0.03],[1,1,1,0.01],[1,1,1,0.003],[1,1,1,0.001],[1,1,1,0.2]],
			[1],0.1,
			0.1, "", "", player,	random 360,	true, 0.1
		];
	};

	tSF_Pipe_PP_eff = ppEffectCreate ["WetDistortion",300];
	tSF_Pipe_PP_eff ppEffectEnable true;
	tSF_Pipe_PP_eff ppEffectForceInNVG true;
	tSF_Pipe_PP_eff ppEffectAdjust [5,0,2,0,0,0,0,0,0,0,0,0,0,0,0];
	tSF_Pipe_PP_eff ppEffectCommit 30;

	private _timer = time;
	waitUntil { (time - _timer) > _time1 || isNil "tSF_Pipe_PP_eff"};
	if (isNil "tSF_Pipe_PP_eff") exitWith {};

	tSF_Pipe_PP_eff ppEffectAdjust [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
	tSF_Pipe_PP_eff ppEffectCommit 15;

	private _timer = time;
	waitUntil { (time - _timer) > _time2 || isNil "tSF_Pipe_PP_eff"};
	if (isNil "tSF_Pipe_PP_eff") exitWith {};

	ppEffectDestroy tSF_Pipe_PP_eff;
};


tSF_fnc_adminTools_createTeleportRP = {
	private _pos = getPosASL player;
	private _onAdd = {
		params ["_AD", "_pos"];
		private _name = _AD call ["GetValueByTag", "i_name"];
		private _desc = _AD call ["GetValueByTag", "i_desc"];

		_AD call ["Close"];

		private _rp = tSF_AdminTools_Rallypoints getOrDefaultCall [
			_name,
			{ createHashMapFromArray [["pos", objNull], ["desc", ""]] },
			true
		];

		_rp set ["pos", _pos];
		_rp set ["desc", _desc];
		
		hint parseText format [
			"<t size='1' color='#FFD000' shadow='1'>Список локаций обновлен</t><br />'%1' на позиции %2", 
			_name,
			_pos
		];

		publicVariable "tSF_AdminTools_Rallypoints";
	};

	private _menu = [
		["HEADER", "Добавить локацию"],
		["LABEL", "Имя", [["w", 0.25]]],
		["INPUT", format ["%1", _pos call dzn_fnc_getMapGrid], [
			["tag", "i_name"],
			["tooltip", "При вводе уже существующего имени - позиция будет обновлена."]
		]],
		["BR"],

		["LABEL", "Описание", [["w", 0.25]]],
		["INPUT", "", [
			["tag", "i_desc"],
			["tooltip", "Описание может помочь отыскать нужную локацию!"]
		]],
		["BR"],

		["LABEL"],
		["BUTTON", "Добавить", _onAdd, _pos, [
			["w", 0.25]
		]]
	];

	_menu call dzn_fnc_ShowAdvDialog2;
};


tSF_fnc_adminTools_showGSOActionConfirmDialog = {
	// Should be SPAWNED or called in scheduled env
	params ["_message"];
	private _DialogResult = [
		[_message],
		["Yes"],
		["No"]
	] call dzn_fnc_ShowBasicDialog;

	waitUntil { !dialog };

	_DialogResult
};

tSF_fnc_adminTools_assignKitLocal = {
	params ["_kit"];
	[player, _kit] call dzn_fnc_gear_assignKit;
};

tSF_fnc_adminTools_teleportToLocal = {
	params["_pos", ["_description", ""]];

	if (_pos isEqualType objNull) then {
		_pos = [_pos, true, getPosASL _pos select 2] call dzn_fnc_getSurfacePos;
	} else {
		_pos = [_pos] call dzn_fnc_getSurfacePos;
	};

	0 cutText ["", "WHITE OUT", 0.1];
	player allowDamage false;
	
	[
		{
			params ["_pos"];

			moveOut player;
			player setVelocity [0,0,0];
			player setPosASL _pos;

			0 cutText ["", "WHITE IN", 1];
		}, 
		[_pos], 
		1
	] call CBA_fnc_waitAndExecute;
	
	[
		{ player allowDamage true; }, 
		[], 
		3
	] call CBA_fnc_waitAndExecute;

	if (_description == "") exitWith {
		hint "Вы были перемещны!";
	};
	hint format ["Вы были перемещны в локацию %1!", _description];
};

