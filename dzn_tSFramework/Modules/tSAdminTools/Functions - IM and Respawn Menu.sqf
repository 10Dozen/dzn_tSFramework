/*
 *	F7 Force Respwn Zeus Menu
 */
tSF_fnc_adminTools_ForceRespawn_showMenu = {
	if !(call tSF_fnc_adminTools_checkIsAdmin) exitWith {};
	
	private _players = (call BIS_fnc_listPlayers) select { !alive _x };
	private _playersStr = (_players apply { name _x }) joinString ", ";
	
	if (count _playersStr > 104) then { _playersStr = format ["%1...", _playersStr select [0,101]]; };
	tSF_adminTools_ForceRespawn_List = _players;

 	/*
 	[ Players pending									            ]
 	[ (label with player's names with comma)						]
 	[ Instant messenger	][					][ V List of players	]
 	[ (input)														]
	[					][ Send Message		][						]
 	[ Cancel			][					][ Respawn All			]
 	*/

	[
		[0, "HEADER", "GSO Zeus Screen - Force Respawn"]
		, [1, "LABEL", format ["Players pending respawn: %1", count _players]]
		, [2, "LABEL",  format ["<t color='#FFD000' size='0.85'>%1</t>", _playersStr]]
		
		, [3, "LABEL", "Instant Messenger"]
		, [3, "LABEL", "<t align='right'>send to</t>"]
		, [3, "DROPDOWN", ["All", "Spectators"] + ((call BIS_fnc_listPlayers) apply { name _x }), [objNull, tSF_adminTools_ForceRespawn_List] + (call BIS_fnc_listPlayers)]
		
		, [4, "INPUT"]
		
		
		, [5, "LABEL", ""]
		, [5, "BUTTON", "SEND MESSAGE", {
			closeDialog 2;
			params["_receiverParams","_msgParams"];

			private _msg = _msgParams select 0;
			private _receiversList = switch (_receiverParams select 0) do {
				case 0: {
					// All players
					(call BIS_fnc_listPlayers)
				};
				case 1: {
					// Spectators
					tSF_adminTools_ForceRespawn_List
				};
				default {
					// Specific player
					[_receiverParams select 3]
				};
			};

			{
				["GSO","GSO",_msg] remoteExec ["tSF_fnc_adminTools_IM_Notify", _x];
			} forEach _receiversList;

		}]
		, [5, "LABEL", ""]
		
		, [6, "BUTTON", "CLOSE", { closeDialog 2; }]
		, [6, "LABEL", ""]
		, [6, "BUTTON", "RESPAWN ALL", {
			closeDialog 2;
			
			hint "Respawn in 5 seconds";
			{
				[] remoteExec ["tSF_fnc_adminTools_ForceRespawn_RespawnPlayer", _x];
			} forEach tSF_adminTools_ForceRespawn_List;
		}]
	] call dzn_fnc_ShowAdvDialog;
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
