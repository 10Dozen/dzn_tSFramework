dzn_fnc_missionConditions_prepareConditions = {
	if !(typename PlayersBaseTrigger == "STRING") then { 
		BaseLoc = [baseTrg, false] call dzn_fnc_convertTriggerToLocation;
		fnc_CheckPlayersReturned = {
			private _result = true;
			{ 
				if (alive _x && !(_x getVariable [“ACE_isUnconscious”, false])) then {
					if !((getPosATL _x) in BaseLoc) exitWith { _result = false; };
				};
			} forEach (call BIS_fnc_listPlayers);
	
			_result
		};
	};
		
	for "_i" from 0 to 20 do {
		if !(isNil (format ["MissionCondition%1", _i])) then {
			(compile format ["MissionCondition%1", _i]) spawn {
				private _ending = _this select 0;
				private _condition = _this select 1;
				private _sleepTime = if (isNil {_this select 2}) then {
					tSF_MissionCondition_DefaultCheckTimer
				} else {
					_this select 2
				};
			
				waitUntil {
					sleep _sleepTime;
					call compile _condition
				};
				
				MissionFinished = _ending;
				publicVariable "MissionFinished";
			};
		};
	};
	
	true
};


dzn_fnc_missionConditions_startClienListener = {
	waitUntil {sleep 1; !isNil "MissionFinished"};
	[MissionFinished, true, 2] call BIS_fnc_endMission;
};
