dzn_fnc_adminTools_checkIsAdmin = {
	(serverCommandAvailable "#logout") || !(isMultiplayer) || isServer
};

dzn_fnc_adminTools_addTopic = {	
	tSF_AdminTools_Topic = "tSF_AdminTools";
	player createDiarySubject [tSF_AdminTools_Topic,tSF_AdminTools_TopicName];
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
		_Result = [
			"End Mission"
     		,[
   				["Ending", _ends]
     		]
		] call dzn_fnc_ShowChooseDialog;

		if (count _Result == 0) exitWith {};
		( (tSF_Ends select (_Result select 0)) select 0) spawn dzn_fnc_adminTools_callEndings;
	};
};

/*
    GAT Tools
*/

dzn_fnc_adminTools_addGATControls = {
    waitUntil {
		sleep 10;
		time > 10
		&& !isNil "dzn_gear_initDone"
		&& !isNil "dzn_gear_gat_table"
		&& !isNil "dzn_fnc_ShowChooseDialog"
    };

	// Mission Notes
	private _topic = format [
		"<font color='#12C4FF' size='14'>Gear Assignment Table Tool</font><br />%1"
		, "<font color='#A0DB65'><execute expression='[] spawn dzn_fnc_adminTools_showGATTool;'>Open GAT Tool</execute></font>"
	];
	player createDiaryRecord [tSF_AdminTools_Topic, ["GAT Tool",_topic]];
};

dzn_fnc_adminTools_showGATTool = {
	private _PlayerList = call BIS_fnc_listPlayers;
	private _PlayerNamesList = [];
	{ _PlayerNamesList pushBack (name _x);	} forEach _PlayerList;

	private _GATList = (allVariables missionNamespace)  select {  ["kit_", _x, false] call BIS_fnc_inString &&  !(["lkit_", _x, false] call BIS_fnc_inString) };
	_GATList pushBack "";
	/*
	{ 
		if !((_x select 1) in _GATList) then {
			_GATList pushBack (_x select 1);
		}
	} forEach dzn_gear_gat_table;
	*/
	private _Result = [];
	_Result = [
		"GAT Tool"
		,[
			["Player", _PlayerNamesList]
			, ["GAT Kit", _GATList]
			, ["or Kitname", []]
		]
	] call dzn_fnc_ShowChooseDialog;

	if (count _Result == 0) exitWith {};

	// Resolve results
	private _player = _PlayerList select (_Result select 0);
	private _kitname = if ( typename (_Result select 2) != "STRING") then {
		_GATList select (_Result select 1);
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

	// Send assign kit command via network
	[_player, _kitname] remoteExec ["dzn_fnc_gear_assignKit", _player];
	hint parseText format [
		"<t size='1' color='#FFD000' shadow='1'>GAT Tools:</t>
		<br /> Kit '%1' was assigned to %2"
		, _kitname
		, _PlayerNamesList select (_Result select 0)
	];
};
