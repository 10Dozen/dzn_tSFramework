#include "script_component.hpp"

/*
 *	F7 Force Respawn Menu
 */

tSF_fnc_adminTools_ForceRespawn_showMenu = {
	if !(call tSF_fnc_adminTools_checkIsAdmin) exitWith {};

	private _menu = [
		["HEADER", Q(RESPAWN_MENU_TITLE)]
	];

	private _messengerMenu = [] call tSF_fnc_adminTools_IM_composeGSOMenu;
	_menu append _messengerMenu;
	_menu append [["br"], ["LABEL"], ["br"]];

	// Respawn part
	private _respawnMenu = if (TSF_MODULE_ENABLED(Respawn)) then {
		[] call tSF_fnc_adminTools_ForceRespawn_composeRespawnMenu
	} else {
		[] call tSF_fnc_adminTools_ForceRespawn_composeDefaultRespawnMenu
	};

	_menu append _respawnMenu;

	_menu call dzn_fnc_showAdvDialog2;
};

// --- Respawn menu
tSF_fnc_adminTools_ForceRespawn_composeDefaultRespawnMenu = {
 	/*
 	[ Players pending									            ]
 	[ (label with player's names with comma)						]
 	[                                     ][ Respawn All			]
 	*/
	private _deadPlayersNames = (call BIS_fnc_listPlayers select { !alive _x }) apply { name _x };
	private _deadPlayersNamesStr = _deadPlayersNames joinString ", ";
	if (count _deadPlayersNamesStr > 96) then {
		_deadPlayersNamesStr = format ["%1...", _deadPlayersNamesStr select [0, 96]]
	};
	private _menu = [
		["LABEL", Q(RESPAWN_MENU_SECTION_HEADER), [["bg",COLOR_RGBA_BY_UI]]],
		["BR"],
		["LABEL", format [Q(RESPAWN_OLD_MENU_WAITING_FOR_RESPAWN_HEADER), count _deadPlayersNames]],
		["BR"],
		["LABEL", format [Q(RESPAWN_OLD_MENU_WAITING_FOR_RESPAWN_PLAYER_LIST), _deadPlayersNamesStr]],
		["BR"],
		["LABEL", "", [["w",0.75]]],
		["BUTTON", "Возродить всех", {
			hint "Respawn in 5 seconds";
			[] remoteExec [
				"tSF_fnc_adminTools_ForceRespawn_RespawnPlayer",
				(call BIS_fnc_listPlayers) select { !alive _x }
			];
			_cob call ["Close"];
		}, [], [["w",0.25]]]
	];

	_menu
};


#define RESPAWN_MODE_SCHEDULE 100
#define RESPAWN_MODE_CANCEL 0
tSF_fnc_adminTools_ForceRespawn_composeRespawnMenu = {
	/*
		Compose menu if Respawn module is enabled.
	*/
	// Who options

	([
		{ !alive _x },
		{
			params ["_plr"];
			private _respawnScheduled = _plr getVariable [QEGVAR(Respawn,Scheduled), false];
            [
				[
                    "color", 
                    [
						[1,1,1,1], 
						COLOR_RGBA_LIGHT_BLUE
					] select _respawnScheduled
                ],
				["textRightColor", COLOR_RGBA_GRAY],
				["tooltip", roleDescription _plr]
			]
		}
	] call tSF_fnc_adminTools_getPlayersAndGroupsOptions) params [
		"_deadPlayerOptions",
		"_groupOptions",
		"",
		"_groups"
	];

	private _whoOptions = [
		["Всех", objNull, [["color", COLOR_RGBA_LIGHT_GREEN]]]
	] + _groupOptions + _deadPlayerOptions;

	// Where options
	private _whereOptions = [{
		params ["_units", "_poi", "_rallypoints", "_respawn"];
        [[
			"Позиция согласно настройкам миссии", "", 
			[
				["color", COLOR_RGBA_LIGHT_GREEN],
				["tooltip", "В соответствии с конфигурацией респаунов для каждой группы, указанной в модуле"]
			]
		]] + _respawn + _rallypoints + _poi + _units
	}] call tSF_fnc_adminTools_getLocationOptions;
	
	// When options
	private _whenOptions = [
		["Сейчас", 0],
		["+30 сек", 30],
		["+1 мин", 1 * 60],
		["+5 мин", 5 * 60]
	];

	//Menu declaration
	/*
	----------------------------------------------------------
	Респун
	----------------------------------------------------------
	[ Who                               v]
	[ Where                             v]
	[ When (Now)                        v][ Респаун        ]
	---------------------------------------------------------
	Ожидают респауна: 3
	---------------------------------------------------------
	Razor 1`1 (Player1, Player2, Player3)                       < 1.2
	Razor 1`2 (Player4, Player5)
	*/
	private _menu = [
		["LABEL", Q(RESPAWN_MENU_SECTION_HEADER), [["bg", COLOR_RGBA_BY_UI]]],
		["BR"],
		["DROPDOWN", _whoOptions, 0, [["w", 0.75],["tag","respawnWho"],["bg", [0,0,0,1]]]],
		["BUTTON", "Возродить", {
			params ["_cob"];
			[
				_cob call ["GetValueByTag", "respawnWho"],
				_cob call ["GetValueByTag", "respawnWhere"],
				_cob call ["GetValueByTag", "respawnWhen"],
				RESPAWN_MODE_SCHEDULE
			] call tSF_fnc_adminTools_ForceRespawn_handleRespawns;
			_cob call ["Close"];
		}, [], [["w",0.25],["tooltip", "Планирует возрождение выбранных игроков/групп\nв выбранной локации."]]],
		["BR"],
		["DROPDOWN", _whereOptions, 0, [["w", 0.75],["tag","respawnWhere"],["bg", [0,0,0,1]]]],
		["BR"],
		["DROPDOWN", _whenOptions, 0, [["w", 0.75],["tag","respawnWhen"],["bg", [0,0,0,1]]]],
		["BUTTON", "Отменить", {
			params ["_cob"];
			[
				_cob call ["GetValueByTag", "respawnWho"],
				_cob call ["GetValueByTag", "respawnWhere"],
				_cob call ["GetValueByTag", "respawnWhen"],
				RESPAWN_MODE_CANCEL
			] call tSF_fnc_adminTools_ForceRespawn_handleRespawns;
			_cob call ["Close"];
		}, [], [["w",0.25],["tooltip","Отменяет возрождение для выбранных игроков/групп"]]],
		["BR"],
		[
			"LABEL",
			format [Q(RESPAWN_MENU_WAITING_FOR_RESPAWN_HEADER), count _deadPlayerOptions],
			[
				["bg", [COLOR_RGBA_DIMMED_RED, COLOR_RGBA_DIMMED_GREEN] select (_deadPlayerOptions isEqualTo [])]
			]
		],
		["BR"]
	];

	// Groups and it's dead members
	#define MAX_LINE_LENGTH 87
	#define PLAYER_NAMES_FONT_SIZE 0.034
	{
		private _names = (units _x) select { !alive _x } apply {
			[
				name _x,
				format ["<t color='%2'>%1</t>", name _x, COLOR_HEX_LIGHT_BLUE]
			] select (_x getVariable [QEGVAR(Respawn,Scheduled), false])
		};

		_menu append [
			["LABEL", format ["%1 чел. из", count _names], [["w", 0.12]]],
			["LABEL", groupId _x, [["color", COLOR_RGBA_YELLOW]]],
			["br"]
		];

		private _namesLine = format ["   %1", _names joinString ", "];
		([
			_namesLine,
			MAX_LINE_LENGTH,
			","
		] call tSF_fnc_adminTools_cutLongLine) params ["_part1", "_cutAt"];
		private _part2 = _namesLine select [_cutAt, 1 + count _namesLine];

		if (_part2 == "") then {
			_menu append [
				["LABEL", _namesLine, [["color", COLOR_RGBA_GRAY],["size", PLAYER_NAMES_FONT_SIZE]]],
				["BR"]
			];
		} else {
			_menu append [
				["LABEL", _part1, [["color", COLOR_RGBA_GRAY],["size", PLAYER_NAMES_FONT_SIZE]]],
				["BR"],
				["LABEL",  format ["   %1", _part2], [["color", COLOR_RGBA_GRAY],["size", PLAYER_NAMES_FONT_SIZE]]],
				["BR"]
			];
		};
	} forEach _groups;

	_menu
};


tSF_fnc_adminTools_ForceRespawn_handleRespawns = {
	params ["_who", "_where", "_when", "_mode"];

	_who params ["", "_whoName", "_unitIdentifier"];
	_where params ["", "_whereName", "_position"];
	_when params ["", "_whenName", "_timeout"];

	private _unitsToRespawn = [];
	if (_unitIdentifier isEqualType grpNull) then {
		// Case: Units of group (by group name)
		_unitsToRespawn = (units _unitIdentifier) select { !alive _x };
	} else {
		if (isNull _unitIdentifier) then {
			// Case: All dead players
			_unitsToRespawn = (call BIS_fnc_listPlayers) select { !alive _x };
		} else {
			// Case: Player
			_unitsToRespawn = [_unitIdentifier];
		};
	};

	private "_positionInfo";

	// -- Detect config-based respawn location by it's name
	private _isConfigBasedLocation = STARTS_WITH(_whereName," ");
	if (_isConfigBasedLocation) then {
		_positionInfo = trim _whereName;
		{
			if (_y get Q(name) == _positionInfo) exitWith {
				_positionInfo = _x;
			};
		} forEach SETTING(ECOB(Respawn),Locations);
	} else {
		if !(_position isEqualType "") then {
			// -- Default position
			_positionInfo = [_whereName, _position];
		};
	};

	private _hintMsg = format [
		Q(HINT_RESPAWN_MENU_ON_SCHEDULED),
		_whoName,
		_whereName,
		_whenName
	];

	private _reParams = [
		Q(Respawn),
		F(scheduleRespawn),
		[
			_positionInfo,
			_timeout
		],
		_unitsToRespawn
	];

	if (_mode == RESPAWN_MODE_CANCEL) then {
		_hintMsg = format [
			Q(HINT_RESPAWN_MENU_ON_UNSCHEDULED),
			_whoName
		];
		_reParams = [Q(Respawn), F(unscheduleRespawn), [], _unitsToRespawn]
	};

	_reParams call dzn_fnc_RCE;
	hint parseText _hintMsg;
};

tSF_fnc_adminTools_ForceRespawn_RespawnPlayer = {
	["GSO", "GSO", ["Respawning in 5 seconds"]] call tSF_fnc_adminTools_IM_Notify;

	setPlayerRespawnTime 5;
	sleep 7;
	setPlayerRespawnTime 9999999;

	if (!isNil { player getVariable "dzn_gear" }) then {
		[player, player getVariable "dzn_gear", false] spawn dzn_fnc_gear_assignKit;
	};
};

/*
 *	Instant Messenger
 */

#define IM_RECEIVERS_ALL "_ALL_"
#define IM_RECEIVERS_DEAD "_DEAD_"

tSF_fnc_adminTools_IM_composeGSOMenu = {
	private _players = call BIS_fnc_listPlayers;
	_players sort true;
	private _groupsMap = [_players] call tSF_fnc_adminTools_getPlayersGroups;
	private _groups = keys _groupsMap;
	_groups sort true;
	_groups = _groups apply {
		[
			_x,
			_x,
			[
				["color", COLOR_RGBA_YELLOW],
				["textRight", format ["%1 чел.", count (_groupsMap get _x)]],
				["textRightColor", COLOR_RGBA_GRAY],
				["tooltip", ((_groupsMap get _x) apply { name _x }) joinString ", "]
			]
		]
	};

	private _receivers = [
		["Всем", IM_RECEIVERS_ALL, [["color", COLOR_RGBA_LIGHT_GREEN]]],
		["Spectators", IM_RECEIVERS_DEAD, [
			["color", COLOR_RGBA_LIGHT_RED],
			["textRight", format ["%1 чел.", {!alive _x} count _players]],
			["textRightColor", COLOR_RGBA_GRAY],
			["tooltip", (_players select {!alive _x} apply { name _x }) joinString ", "]
		]]
	]
	+ _groups
	+ (_players apply {
		[
			name _x,
			_x,
			[
				["color", [1,1,1, [0.5, 1] select (alive _x)]],
				["textRight",  (groupId group _x) + " "],
				["textRightColor", COLOR_RGBA_GRAY],
				["tooltip", ["Мертв",""] select (alive _x)]
			]
		]
	});

	[
		["br"],
		["LABEL", "Введите сообщение (Shift + Enter для переноса строки)."],
		["br"],
		["INPUT_AREA", "", [["tag", "chatMessageText"], ["h", 0.15]]],
		["br"],
		["DROPDOWN", _receivers, -1, [["tag", "chatReceiver"],["w", 0.75],["h",0.06],["bg", [0,0,0,1]]]],
		//["LABEL", "", [["w", 0.25]]],
		["BUTTON", "Отправить", {
			params ["_cob"];
			private _message = (_cob call ["GetValueByTag", "chatMessageText"]) splitString toString[10];
			private _receivers = _cob call ["GetValueByTag", "chatReceiver"];

			if (_message isEqualTo []) exitWith {};

			hint format ["Сообщение отправлено %1", _receivers # 1];
			[_message, _receivers # 2] call tSF_fnc_adminTools_IM_sendByGSO;
			_cob call ["Close"];
		}, [], [["size",0.06]]]
	]
};

tSF_fnc_adminTools_IM_showMenu = {
	// if (call tSF_fnc_adminTools_checkIsAdmin) exitWith {};

 	/*
 	[ Write your message to GSO (Admin)					            ]
 	[ (input)										]
 	[ 																]
 	[					][					][ Send Message			]
 	*/
	[
		["HEADER", "Мессенджер"],
		["LABEL", "Напишите ваше сообщение для GSO (Админа)."],
		["br"],
		["INPUT_AREA", "", [["tag", "chatMessageText"], ["h", 0.2]]],
		["br"],
		["LABEL", "<t align='right'>* Shift + Enter для переноса строки.</t>"],
		["br"],
		/*["LABEL", "", [["w", 0.75]]],*/
		["BUTTON", "<t align='center'>Отправить</t>", {
			params ["_cob"];
			private _message = (_cob call ["GetValueByTag", "chatMessageText"]) splitString toString[10];
			if (_message isEqualTo []) exitWith {};
			[_message] call tSF_fnc_adminTools_IM_sendByPlayer;
			_cob call ["Close"];
		}, [], [["size",0.1]]]
	] call dzn_fnc_ShowAdvDialog2;
};

tSF_fnc_adminTools_IM_sendByGSO = {
	params ["_message", "_receiverID"];

	private _receiverUnits = [_receiverID]; // by player
	if (_receiverID isEqualType "") then {
		switch _receiverID do {
			case IM_RECEIVERS_ALL: {
				_receiverUnits = call BIS_fnc_listPlayers;
			};
			case IM_RECEIVERS_DEAD: {
				_receiverUnits = (call BIS_fnc_listPlayers) select { !alive _x };
			};
			default {
				// By Group name
				_receiverUnits = (call BIS_fnc_listPlayers) select { groupId group _x == _receiverID };
			};
		};
	};

	["GSO", "GSO", _message] remoteExec ["tSF_fnc_adminTools_IM_Notify", _receiverUnits];
};

tSF_fnc_adminTools_IM_sendByPlayer = {
	params ["_message"];

	_params = [
		name player,
		format [
			"<t color='%5'>%1%2</t> из <t color='%6'>%3 (%4)</t>",
			name player,
			[" (мертв)", ""] select (alive player),
			groupId group player,
			roleDescription player,
			COLOR_HEX_WHITE,
			COLOR_HEX_GRAY
		],
		_message
	] remoteExec ["tSF_fnc_adminTools_IM_Notify", tSF_Admin];

	hint "Сообщение отправлено!";
	if (player == tSF_Admin) exitWith {};
	[name player, name tSF_admin, _message] call tSF_fnc_adminTools_IM_SaveMsgToDiary;
};

tSF_fnc_adminTools_IM_Notify = {
	params ["_sender", "_title", "_text"];

	private _content = [
		format [Q(TEMPLATE_IM_MESSAGE_HEADER), _title]
	] + _text apply {
		format [Q(TEMPLATE_IM_MESSAGE_LINE), _x]
	};

	[
		_content
		, "TOP"
		, [0,0,0,.75]
		, 30
	] call dzn_fnc_ShowMessage;

	[_sender, name player, _text] call tSF_fnc_adminTools_IM_SaveMsgToDiary;
};

tSF_fnc_adminTools_IM_SaveMsgToDiary = {
	params["_sender", "_receiver", "_msg"];

	if (isNil "tSF_AdminTools_IM_Topic") then {
		tSF_AdminTools_IM_Topic = "tSF Instant Messenger";
		player createDiarySubject [tSF_AdminTools_IM_Topic, tSF_AdminTools_IM_Topic];
	};

	/*
		Case1: GSO to 10Dozen:
			For GSO: 		- "tSF Instant Messenger" -> 10Dozen -> GSO Text
			For 10Dozne:	- "tSF Instant Messenger" -> GSO -> GSO text
		Case2: 10Dozen to GSO:
			For GSO: 		- "tSF Instant Messenger" -> 10Dozen -> 10Dozen text
			For 10Dozne:	- "tSF Instant Messenger" -> GSO -> 10Dozen text
	*/

	_msg = _msg joinString "<br/>";
	if (["execute expression=", _msg] call dzn_fnc_inString) then {
		_msg = " -- Illegal hack was deteceted (execute expression=). Admin is reported about u, h4x0r --"
	};

	player createDiaryRecord [tSF_AdminTools_IM_Topic, [
		_receiver,
		format [
			Q(NOTE_IM_LOG),
			[] call BIS_fnc_timeToString,
			_sender,
			_msg
		]
	]];
};
