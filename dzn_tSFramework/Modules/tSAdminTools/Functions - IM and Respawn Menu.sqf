#include "script_component.hpp"

/*
 *	F7 Force Respawn Menu
 */

#define OPTION_COLOR_ALL [0.78, 0.92, 0, 1]
#define OPTION_COLOR_SPECTATORS [0.92, 0.52, 0.52, 1]
#define OPTION_COLOR_GROUP [0.92, 0.81, 0, 1]
#define OPTION_COLOR_RIGHT [0.7,0.7,0.7,1]

tSF_fnc_adminTools_getPlayersGroups = {
	params ["_players"];

	private _groupsMap = createHashMap;
	private ["_groupName", "_playersInGroup"];
	{ 
		_groupName = groupId group _x;
		_playersInGroup = _groupsMap getOrDefault [_groupName, []];
		_playersInGroup pushBack (name _x);
		_groupsMap set [_groupName, _playersInGroup];
	} forEach _players;

	_groupsMap
};

tSF_fnc_adminTools_ForceRespawn_showMenu = {
	if !(call tSF_fnc_adminTools_checkIsAdmin) exitWith {};

	private _menu = [
		["HEADER", "GSO - Мессенджер / Респаун"]
	];

	private _messengerMenu = [] call tSF_fnc_adminTools_IM_composeGSOMenu;
	_menu append _messengerMenu;

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
	private _deadPlayersNamesStr = ", " joinString _deadPlayersNames;
	if (count _deadPlayersNamesStr > 104) then { 
		_deadPlayersNamesStr = format ["%1...", _deadPlayersNamesStr select [0, 101]]
	};
	private _menu = [
		["br"],
		["HEADER", "Управление Респаунами"],
		["LABEL", format ["<t color='#FFD000'>Ожидают возрождения:</t> %1", count _deadPlayersNames]],
		["BR"],
		["LABEL", format ["<t size='0.85'>%1</t>", _deadPlayersNamesStr]],
		["BR"],
		["LABEL", "", [["w",0.75]]],
		["BUTTON", "Возродить всех", {
			closeDialog 2;
			hint "Respawn in 5 seconds";
			{
				[] remoteExec ["tSF_fnc_adminTools_ForceRespawn_RespawnPlayer", _x];
			} forEach (call BIS_fnc_listPlayers select { !alive _x });
		}, [], [["w",0.25]]]
	];

	_menu
};

tSF_fnc_adminTools_ForceRespawn_composeRespawnMenu = {
	/*
		Compose menu if Respawn module is enabled.
	*/
	// Who options 
	private _deadPlayers = (call BIS_fnc_listPlayers) select { !alive _x };
	_deadPlayers sort true;
	private _groupsMap = [_deadPlayers] call tSF_fnc_adminTools_getPlayersGroups;

	private _groupsOptions = keys _groupsMap;
	_groupsOptions sort true;
	_groupsOptions = _groupsOptions apply { 
		[
			_x,
			_x,
			[
				["color", OPTION_COLOR_GROUP],
				["textRight", format ["%1 чел.", count (_groupsMap get _x)]],
				["textRightColor", OPTION_COLOR_RIGHT]
			]
		]
	};

	private _deadPlayersOptions = _deadPlayers apply {
		[
			name _x,
			_x,
			[
				["textRight", groupId group _x],
				["textRightColor", OPTION_COLOR_RIGHT]
			]
		]
	};

	private _whoOptions = [
		["Всех", objNull, [["color", OPTION_COLOR_ALL]]]
	] + _groupsOptions + _deadPlayersOptions;

	// Where options 
	private _spawnLocations = (ECOB(Respawn) call [F(getSpawnLocationsNames)]) apply {
		[
			_x # 0,
			_x # 1,
			[
				["tooltip", _x # 2]
			]
		]
	};
	(_spawnLocations select 0 select 2) append [
		["textRight", "Респаун по умолчанию"],
		["textRightColor", OPTION_COLOR_RIGHT]
	];

	private _whereOptions = [
		["Позиция согласно настройкам миссии", nil, [
			["color", OPTION_COLOR_ALL],
			["tooltip", "В соответствии с конфигурацией респаунов для каждой группы, указанной в модуле"]
		]]
	] + _spawnLocations;

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
		["br"],
		["HEADER", "Управление Респаунами", [["closeButton", false]]],
		["DROPDOWN", _whoOptions, 0, [["w", 0.75],["tag","respawnWho"]]],
		["BR"],
		["DROPDOWN", _whereOptions, 0, [["w", 0.75],["tag","respawnWhere"]]],
		["BR"],
		["DROPDOWN", _whenOptions, 0, [["w", 0.75],["tag","respawnWhen"]]],
		["BUTTON", "Возродить", {
			params ["_cob"];
			private _who = (_cob call ["GetValueByTag", "respawnWho"]) # 2;
			private _where = (_cob call ["GetValueByTag", "respawnWhere"]) # 2;
			private _when = (_cob call ["GetValueByTag", "respawnWhen"]) # 2;
			[_who, _where, _when] call tSF_fnc_adminTools_ForceRespawn_scheduleRespawns;
			closeDialog 2;
		}, [], [["w",0.25]]],
		["BR"],
		["LABEL", format ["Ожидают респауна: %1", count _deadPlayers], [["bg", [0.4,0.4,0.1,1]]]],
		["BR"]
	];

	// Groups and it's dead members
	#define MAX_LINE_LENGTH 96
	{
		//private _lineText = format ["[%1] %2 (%3)", count _y, _x, _y joinString ", " ];
		_menu append [
			["LABEL", format ["%1 чел. из", count _y], [["w", 0.12]]],
			["LABEL", _x, [["color", OPTION_COLOR_GROUP]]],
			["br"]
		];

		private _namesLine = format ["   %1", _y joinString ", "];

		// More then 1 line - cut into 2 at char MAX_LINE_LENGTH
		private ["_cutLineAtIndex", "_part1", "_part2"];
		if (count _namesLine > MAX_LINE_LENGTH) then {
			_cutLineAtIndex = MAX_LINE_LENGTH;
			for "_i" from MAX_LINE_LENGTH to 0 step -1 do {
				if (_namesLine select [_i, 1] == ",") then {
					_cutLineAtIndex = _i;
					break;
				};
			};
			
			_part1 = _namesLine select [0, _cutLineAtIndex+1];
			_part2 = _namesLine select [_cutLineAtIndex+2, count _namesLine];

			_menu pushBack ["LABEL", _part1, [["color", OPTION_COLOR_RIGHT]]];
			_menu pushBack ["BR"];
			_menu pushBack [
				"LABEL",  format ["   %1", _part2], [["color", OPTION_COLOR_RIGHT]]
			];
			_menu pushBack ["BR"];
			continue;
		};

		_menu pushBack ["LABEL", _namesLine, [["color", OPTION_COLOR_RIGHT]]];
		_menu pushBack ["BR"];
	} forEach _groupsMap;

	_menu
};

tSF_fnc_adminTools_ForceRespawn_scheduleRespawns = {
	params ["_unitIdentifier", "_forcedLocation", "_timeout"];

	private _unitsToRespawn = [];
	if (_unitIdentifier isEqualType "") then {
		// Case: Units of group (by group name)
		_unitsToRespawn = (call BIS_fnc_listPlayers) select { !alive _x && groupId group _x == _unitIdentifier };
	} else {
		if (isNull _unitIdentifier) then {
			// Case: All dead players
			_unitsToRespawn = (call BIS_fnc_listPlayers) select { !alive _x };
		} else {
			// Case: Player
			_unitsToRespawn = [_unitIdentifier];
		};
	};

	{
		ECOB(Core) call [
			F(remoteExecComponent),
			[Q(Respawn), F(scheduleRespawn), [_forcedLocation, _timeout], _x]
		];
	} forEach _unitsToRespawn;
};

tSF_fnc_adminTools_ForceRespawn_RespawnPlayer = {	
	["GSO", "GSO", "Respawning in 5 seconds"] call tSF_fnc_adminTools_IM_Notify;
	
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
				["color", OPTION_COLOR_GROUP],
				["textRight", format ["%1 чел.", count (_groupsMap get _x)]],
				["textRightColor", OPTION_COLOR_RIGHT]
			]
		]
	};

	private _receivers = [
		["Всем", IM_RECEIVERS_ALL, [["color", OPTION_COLOR_ALL]]], 
		["Spectators", IM_RECEIVERS_DEAD, [
			["color", OPTION_COLOR_SPECTATORS],
			["textRight", format ["%1 чел.", {!alive _x} count _players]],
			["textRightColor", OPTION_COLOR_RIGHT]
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
				["textRightColor", OPTION_COLOR_RIGHT]
			]
		] 
	});

	[
		["br"],
		["INPUT", "", [["tag", "chatMessageText"], ["h", 0.07]]],
		["br"],
		["DROPDOWN", _receivers, -1, [["tag", "chatReceiver"],["w", 0.5]]],
		["LABEL", "", [["w", 0.25]]],
		["BUTTON", "Отправить", {
			params ["_cob"];
			private _message = _cob call ["GetValueByTag", "chatMessageText"];
			private _receivers = (_cob call ["GetValueByTag", "chatReceiver"]) # 2;

			[_message, _receivers] call tSF_fnc_adminTools_IM_sendByGSO;
			closeDialog 2;
		}, [], [["w", 0.25],["size",0.06]]]
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
		[0,"HEADER","GSO Instant Messenger"]
		, [1, "LABEL","Write your message to GSO (Admin)"]
		, [2, "INPUT"]
		, [3, "LABEL", ""]
		, [4, "LABEL", ""]		
		, [4, "LABEL", ""]		
		, [4, "BUTTON", "SEND MESSAGE", {
			closeDialog 2;
			[
				name player
				, format ["%1 [<t color='#FFFFFF'>%2 -- %3</t>]", name player, groupId group player, roleDescription player]
				, _this select 0 select 0
			] remoteExec ["tSF_fnc_adminTools_IM_Notify", tSF_Admin];

			if (player == tSF_Admin) exitWith {};
			[name player, name tSF_admin, _this select 0 select 0] call tSF_fnc_adminTools_IM_SaveMsgToDiary;
			/*
			hintC format [
				"%1 (%2 - %3): %4"
				, name player
				, groupId group player
				, roleDescription player
				, (_this select 0 select 0)
			];
			*/
		}]

	] call dzn_fnc_ShowAdvDialog;
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

	{
		["GSO", "GSO", _message] remoteExec ["tSF_fnc_adminTools_IM_Notify", _x];
	} forEach _receiverUnits;
};

tSF_fnc_adminTools_IM_Notify = {
	params ["_sender", "_title", "_text"];

	private _drawText = _text;
	if (["execute expression=", _text] call dzn_fnc_inString) then {
		_drawText = "(Execute Expression attempt)" + _text;
	};
	
	[
		[
			format ["<t color='#FFD000'>Сообщение от %1</t>", _title]
			, format ["<t align='center'>%1</t>", _drawText]
		]
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

	if (["execute expression=", _msg] call dzn_fnc_inString) then {
		_msg = " -- Illegal hack was deteceted (execute expression=). Admin is reported about u, h4x0r --"
	};

	player createDiaryRecord [tSF_AdminTools_IM_Topic, [
		_receiver
		, format [
			"<font color='#12C4FF' size='14'>%1 -- from %2:</font><br />%3"
			, [] call BIS_fnc_timeToString
			, _sender
			, _msg
		]
	]];
};
