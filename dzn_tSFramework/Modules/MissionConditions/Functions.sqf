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
			
				if (typename _condition == "CODE") then {
					_condition = ((str(_condition) splitString "") select [1, count str(_condition) - 2]) joinString "";
				};
				
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
	
	[] spawn {
		waitUntil { time > 10 };
		publicVariable "tSF_Ends";
	};
	
	true
};

dzn_fnc_missionConditions_startClienListener = {
	waitUntil {sleep 1; !isNil "MissionFinished"};
	[MissionFinished, true, 2] call BIS_fnc_endMission;
};
