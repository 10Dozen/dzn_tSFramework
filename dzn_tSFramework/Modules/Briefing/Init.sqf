// ********************
// INITIALIZATION
// ********************

waitUntil { !isNull findDisplay 52 || getClientState == "BRIEFING SHOWN" || time > 0 };
[] execVM "dzn_tSFramework\Modules\Briefing\tSF_Briefing.sqf";
call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\Briefing\Settings.sqf";

if (tSF_Briefing_ShowRoster) then {
	dzn_fnc_getBriefingRoster = {
		private _roster = "";	
		private _groups = [];
		{
			private _grp = group _x;
			if !(_grp in _groups) then {
				_groups pushBack _grp; [groupId _grp, leader _grp, count(units _grp) - 1];
				
				_roster = format [
					"%1<br /><font color='#12C4FF'>%2</font> - <font color='#9E9E9E'>%3</font> %4 <font color='#9E9E9E'>(+%5 чел.)</font>"
					, _roster
					, groupId _grp
					, roleDescription (leader _grp)
					, name (leader _grp)
					, (count (units _grp)) - 1
				]
			};		
		} forEach (call BIS_fnc_listPlayers);
		
		_roster
	};

	waitUntil { time > tSF_Briefing_RosterTimeout};
	player createDiaryRecord ["Diary", [ "Участники:", call dzn_fnc_getBriefingRoster]];
	
	if (tSF_Briefing_UpdateRosterOnJIP) then {
		tSF_Briefing_UpdateRoster = false;
		
		if (didJIP) then {
			tSF_Briefing_UpdateRoster = true;
			publicVariable "tSF_Briefing_UpdateRoster";
		};
		
		"tSF_Briefing_UpdateRoster" addPublicVariableEventHandler {
			tSF_Briefing_UpdateRoster = false;
			player createDiaryRecord ["Diary", [ "Участники:", call dzn_fnc_getBriefingRoster]];
		};	
	};
};
