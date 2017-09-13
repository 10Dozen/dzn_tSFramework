call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\Conversations\Settings.sqf";

tSF_fnc_Conversations_processList = {
	{
		_x spawn {
			// [@Name, @Object, @Event1, ... @EventN]
			if (typename (_this select 1) == "OBJECT") then {
				waitUntil { !isNil {_this select 1} };			
				[_this select 1, _this select 0, false] call tSF_fnc_Conversations_AttachConversation;
			} else {
				{
					waitUntil { !isNil { _x } };					
					[_x, _this select 0, false] call tSF_fnc_Conversations_AttachConversation;
				} forEach (_this select 1);
			};
		};
	} forEach _this;
};

tSF_fnc_Conversations_Talk = {
	// @Object spawn tSF_fnc_Conversations_Talk;
	private _obj = _this;
	private _event = (_this getVariable "tSF_Conversations_Name") call tSF_fnc_Conversations_GetConversation;
	
	[
		_this
		, _this getVariable "tSF_Conversations_Name"
		, _obj getVariable ["tSF_Conversations_EventID", -1]		
	] call tSF_fnc_Conversations_ShowEvent;
};

tSF_fnc_Conversations_GetConversation = {
	(tSF_Conversations_List select {(_x select 0) == _this}) select 0
};

tSF_fnc_Conversations_GetEvent = {
	params["_conversation", "_id"];
	
	if (_id == -1) then {
		_conversation select 2
	} else {
		for "_i" from 2 to (count _conversation - 1) do {
			if ( (_conversation select _i) select 0 == _id ) exitWith {
				(_conversation select _i)
			};
		};
	};
};

tSF_fnc_Conversations_ShowEvent = {
	//	[ 0@Object, 1@ConversationName, 2@GoToID, 3@EventID ]	
	params ["_obj", "_conversationName", ["_targetEventID", -1], ["_fromEventID", -1]];
	
	private _event = [
		_conversationName call tSF_fnc_Conversations_GetConversation
		, _targetEventID
	] call tSF_fnc_Conversations_GetEvent;
	
	private _lines = (_event select 1) + [""];
	private _answers = _event select 2;
	private _title = if (_obj getVariable ["tSF_Conversation_Title", ""] == "") then {
		name _obj
	} else {
		_obj getVariable "tSF_Conversation_Title"
	};	

	private _dialog = [[0, "HEADER", _title]];
	private _index = 1;	
	private _hasCode = false;
	private _linesCount = (count _lines) - 2;
	
	{
		if (!_hasCode || (_hasCode && _forEachIndex != _linesCount) ) then {
			if (typename _x == "STRING") then {
				_dialog pushBack [ _index, "LABEL", _x ];
			} else {
				_dialog pushBack [ _index, "LABEL", (_lines select _linesCount) call _x ];
				_hasCode = true;
			};
			
			_index = _index + 1;
		};
	} forEach _lines;
	
	{
		// Answer:	[ 0@Text, 1@Code, 2@Arguments, 3@GoToID ]
		// _this:	[ 0@Object, 1@ConversationName, 2@GoToID, 3@EventID ]
		
		private _answerText = if (typename (_x select 0) == "STRING") then {
			_x select 0
		} else {
			(_x select 0 select 1) call (_x select 0 select 0)
		};
		
		private _code = "closeDialog 2; _args call { V = _this; ";
		if (_x select 3 > -1) then { _code = _code + "[_this select 0, _this select 1, _this select 2, _this select 3] spawn tSF_fnc_Conversations_ShowEvent;"; };
		_code = _code + ([_x select 1, ["CODE"]] call dzn_fnc_stringify) + "};";
		
		_dialog pushBack [ 
			_index
			, "BUTTON"
			, _answerText
			, compile _code
			, [_obj, _conversationName, _x select 3,_targetEventID, _x select 2]
		];
		_index = _index + 1;
	} forEach _answers;
	
	_dialog call dzn_fnc_ShowAdvDialog;
};

tSF_fnc_Conversations_AttachConversation = {
	// [@Object, @Conversation, @Override] call tSF_fnc_Conversations_AttachConversation
	params["_obj", "_conversation", ["_override", true]];	
	
	if (
		isNil { _obj getVariable "tSF_Conversations_Name" }
		|| _override
	) then {
		_obj setVariable ["tSF_Conversations_Name", _conversation, true];		
	};
	
	if (isNil { _obj getVariable "tSF_Conversations_ActionID" }) then {
		_obj setVariable [
			"tSF_Conversations_ActionID"
			, [_obj, "<t color='#EDB81A'>Talk To</t>", { (_this select 0) spawn tSF_fnc_Conversations_Talk; }, 5, "alive _target", 6] call dzn_fnc_addAction
		];
		_obj setVariable ["tSF_Conversations_EventID", -1];
	};
	
	true
};

tSF_fnc_Conversations_DetachConversation = {
	// @Object call tSF_fnc_Conversation_DetachConversation
	_this setVariable ["tSF_Conversations_Name", nil, true];
	if (!isNil {_this getVariable "tSF_Conversations_ActionID"}) then {
		_this removeAction (_this getVariable "tSF_Conversations_ActionID");	
		_this setVariable ["tSF_Conversations_ActionID", nil];
	};
	_obj setVariable ["tSF_Conversations_EventID", nil];
	
	true
};

tSF_fnc_Conversations_AttachConversationsPublic = {
	// [@Object, @Conversation, @Override] call tSF_fnc_Conversations_AttachConversationsPublic
	_this remoteExec ["tSF_fnc_Conversations_AttachConversation"];
};

tSF_fnc_Conversations_DetachConversationPublic = {
	// @Object call tSF_fnc_Conversation_DetachConversation
	_this remoteExec ["tSF_fnc_Conversation_DetachConversation"];
};

if (hasInterface) then {
	waitUntil {time > 0};
	
	tSF_Conversations_List spawn tSF_fnc_Conversations_processList;
};
