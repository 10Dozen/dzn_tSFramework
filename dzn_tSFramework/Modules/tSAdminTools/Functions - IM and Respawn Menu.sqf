#include "script_component.hpp"

/*
 *	F7 Force Respwn Zeus Menu
 */

tSF_fnc_adminTools_ForceRespawn_showMenu = {
	if !(call tSF_fnc_adminTools_checkIsAdmin) exitWith {};

	

	// Instant messenger 
	private _players = call BIS_fnc_listPlayers;
	private _receivers = [
		["Всем", _players], 
		["Spectators", _players select { !alive _x }]
	] + (_players apply { [format ["%1 (%2)", name _x, groupId group _x], _x] });

	
	private _menu = [
		["HEADER", "GSO - Мессенджер / Респаун"],
		["INPUT", "", [["tag", "chatMessageText"], ["h", 0.07]]],
		["br"],
		//["DROPDOWN", _receivers, -1, [["tag", "chatReceiver"],["w", 0.5]]],
		["LABEL", "", [["w", 0.25]]]
	];
	/*
	_menu pushBack ["BUTTON", "Отправить", {
		params ["_cob"];
		private _message = _cob call ["GetValueByTag", "chatMessageText"];
		private _receivers = _cob call ["GetValueByTag", "chatReceiver"];

		[_message, _receivers] call tSF_fnc_adminTools_IM_sendByGSO;
	}, [], [["w", 0.25]]];
	*/

	// Respawn part 
	/*
	private _respawnMenu = if (TSF_MODULE_ENABLED(Respawn)) then {
		[] call tSF_fnc_adminTools_ForceRespawn_composeRespawnMenu
	} else {
		[] call tSF_fnc_adminTools_ForceRespawn_composeDefaultRespawnMenu
	};
	_menu append _respawnMenu;
	*/

	_menu call dzn_fnc_showAdvDialog2;
};

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

	private _groupsMap = createHashMap;
	private ["_groupName", "_playersInGroup"];
	{ 
		_groupName = groupId group _x;
		_playersInGroup = _groupsMap getOrDefault [_groupName, []];
		_playersInGroup pushBack (name _x);
		_groupsMap set [_groupName, _playersInGroup];
	} forEach _deadPlayers;

	private _groupsOptions = keys _groupsMap;
	_groupsOptions sort true;
	_groupsOptions = _groupsOptions apply { [_x] };

	private _deadPlayersOptions = _deadPlayers apply {
		[format ["%1 (%2)", name _x, groupId group _x], _x]
	};
	_deadPlayersOptions sort true;

	private _whoOptions = [["Всех", objNull]] + _groupsOptions + _deadPlayersOptions;

	// Where options 
	private _spawnLocations = ECOB(Respawn) call [F(getSpawnLocationsNames)];
	private _whereOptions = [["Назначенная", nil]] + _spawnLocations;

	// When options 
	private _whenOptions = [
		["Сейчас", 0],
		["30 сек", 30],
		["1 мин", 1 * 60],
		["5 мин", 5 * 60]
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
		["HEADER", "Управление Респаунами"],
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
		}, [], [["w",0.25]]],
		["BR"],
		["HEADER", format ["Ожидают респауна: %1", count _deadPlayers]],
		["BR"]
	];

	// Groups and it's dead members
	{
		private _lineText = format ["[%1] %2 (%3)", count _y, _x, ", " joinString _y];

		// More then 1 line - cut into 2 at char #104
		if (count _lineText > 104) then {
			private _cutLineAtIndex = 104;
			for "_i" from 104 to 0 do {
				if (_lineText select _i == ",") then {
					_cutLineAtIndex = _i;
					break;
				};
			};
			_menu pushBack ["LABEL", _lineText select [0, _cutLineAtIndex+1]];
			_menu pushBack ["BR"];
			_menu pushBack [
				"LABEL", 
				format ["    %1", _lineText select [_cutLineAtIndex+1, count _lineText]]
			];
			_menu pushBack ["BR"];
			continue;
		};

		_menu pushBack ["LABEL",_lineText];
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
	params ["_message", "_receivers"];

	if !(_receivers isEqualType []) then {
		_receivers = [_receivers];
	};

	{
		["GSO", "GSO", _message] remoteExec ["tSF_fnc_adminTools_IM_Notify", _x];
	} forEach _receivers;
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
