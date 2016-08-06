dzn_fnc_missionConditions_prepareConditions = {
	if !(typename PlayersBaseTrigger == "STRING") then { 
		BaseLoc = [PlayersBaseTrigger, false] call dzn_fnc_convertTriggerToLocation;
		fnc_CheckPlayersReturned = {
			private _result = true;
			{ 
				if (alive _x && !(_x getVariable ["ACE_isUnconscious", false])) then {
					if !((getPosATL _x) in BaseLoc) exitWith { _result = false; };
				};
			} forEach (call BIS_fnc_listPlayers);
	
			_result
		};
	};
		
	for "_i" from 1 to 20 do {
		if !(isNil (format ["MissionCondition%1", _i])) then {
			(call compile format ["MissionCondition%1", _i]) spawn {
				params[
					"_ending"
					,"_condition"
					,["_desc", ""]
					,["_sleepTime", tSF_MissionCondition_DefaultCheckTimer]
				];
			
				tSF_Ends pushBack [_ending,_desc];
			
				waitUntil {
					sleep _sleepTime;
					call compile _condition
				};
				
				MissionFinished = _ending;
				publicVariable "MissionFinished";
				
				sleep 20;
				[MissionFinished, true, 2] call BIS_fnc_endMission;
			};
		};
	};
	
	publicVariable "tSF_Ends";
	
	true
};

dzn_fnc_missionConditions_startClienListener = {
	waitUntil {sleep 1; !isNil "MissionFinished"};
	[MissionFinished, true, 2] call BIS_fnc_endMission;
};











dzn_fnc_missionConditions_checkIsAdmin = {
	(serverCommandAvailable "#logout") || !(isMultiplayer)
};

dzn_fnc_missionConditions_addMissionEndsControls = {
	waitUntil { time > 5 && !isNil {tSF_Ends} };
	
	// Mission Notes
	private _topic = "<font color='#12C4FF' size='14'>Завершение миссии</font>";
	{
		_topic = format [
			"%1<br /><font color='#A0DB65'><execute expression='""%2"" call dzn_fnc_missionConditions_callEndings;'>%2</execute></font>"
			, _topic
			, _x
		];
		
	} forEach tSF_Ends;
	player createDiarySubject ["tSF End Mission","tSF End Mission"];
	player createDiaryRecord ["tSF End Mission", _topic];
};

dzn_fnc_missionConditions_callEndings = {
	params["_ending"];
	if !(call dzn_fnc_missionConditions_checkIsAdmin) exitWith { hint "You are not an admin!"; };
	
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

// Shortcut for dzn_fnc_missionConditions_callEndings; should be Spawned
tSF_End = dzn_fnc_missionConditions_callEndings;
