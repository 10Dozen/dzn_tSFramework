call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\MissionDefaults\Settings.sqf";

// ********************
// INITIALIZATION
// ********************
enableSaving [false,false];
if (tSF_MissionDefaults_AddPlayerRating) then { player addRating 1000000; };

if (hasInterface && tSF_MissionDefaults_DisableInputOnStart) then {
	[] spawn {
		// Exit if admin or singleplayer
		if (serverCommandAvailable "#logout" || !(isMultiplayer) || isServer ) exitWith {};
		waitUntil { time > 0 };
		
		player enableSimulation false;
		disableUserInput true;
		
		for "_i" from 0 to tSF_MissionDefaults_DisableInputTimer do {
			hintSilent parseText format [
				"<t color='#FFE240' font='PuristaLight'>Начало через %1 сек</t>%2"
				, tSF_MissionDefaults_DisableInputTimer - _i
				, "<br /><t color='#AAAAAA' font='PuristaLight' size='0.8'>" + tSF_MissionDefaults_SubtitleText + "</t>"
			];
			sleep 1;			
		};
		
		player enableSimulation true;
		disableUserInput false;
		hintSilent parseText "<t color='#FFE240' font='PuristaLight'>Удачной Игры!</t>";		
	};

	[] spawn {
		if !(tSF_MissionDefaults_PutEarplugsOn) exitWith {};
		waitUntil {!isNull player};
		player call ace_hearing_fnc_putInEarplugs;
	};

	[] spawn {
		if !(tSF_MissionDefaults_PutWeaponSafe) exitWith {};
		waitUntil {!isNull player && time > 1};		
		[ACE_player, currentWeapon ACE_player, currentMuzzle ACE_player] call ace_safemode_fnc_lockSafety;
		
		private _curWp = currentWeapon player;
		sleep 6;
		
		if (_curWp != currentWeapon player) then {
			[ACE_player, currentWeapon ACE_player, currentMuzzle ACE_player] call ace_safemode_fnc_lockSafety;		
		};
	};
	
	[] spawn {
		if !(tSF_MissionDefaults_EnableCutieCalc) exitWith {};
		
		private _markersLast = [];
		while { alive player } do {
			if (time > 0) then { sleep 1; };
			
			if !(_markersLast isEqualTo allMapMarkers) then {
				private _diff = allMapMarkers - _markersLast;
				_markersLast = allMapMarkers;
				
				{
					private _mrkUserID = parseNumber ( (_x select [15,10]) splitString "/" select 0 );
					if (isNil "_mrkUserID") exitWith {};
					
					private _userIDs = PlayerConnectedData select { _x select 1 == getPlayerUID player && _x select 2 == name player };
					
					private _isOwned = false;
					{
						if ( [str(_mrkUserID), str(_x select 0)] call dzn_fnc_inString ) exitWith { _isOwned = true };
					} forEach _userIDs;
					
					if (_isOwned) then {
						private _line = markerText _x;
						if ( _line select [0,1] == "@" ) then {
							if !( ((toArray _line) - [
								64,49,50,51,52,53,54,55,56,57,48,43,45,47,42,46,94
								,115,105,110,32,99,111,116,97
							]) isEqualTo [] ) exitWith {
								systemChat "@Calc: Don't cheat, sweetie! Only math allowed >_<'";
							};
							
							private _result = call compile (_line select [1,count _line]); 
							
							systemChat format ["@Calc: %1", _result];
							deleteMarker _x;
							[format ["<t size='0.8'>@Calc: %1", _result], [26,43,33,.027], [0,0,0,.5]] call dzn_fnc_ShowMessage;						
						};
					
					};
				} forEach _diff;
			};
		};
	};
	
	[] spawn {
		if !(tSF_MissionDefaults_EnableMarkerPhoneticAutocompletion) exitWith {};	
		
		private _markersLast = [];
		while { alive player } do {
			if (time > 0) then { sleep 2; };
			
			if !(_markersLast isEqualTo allMapMarkers) then {
				private _diff = allMapMarkers - _markersLast;			
				_markersLast = allMapMarkers;
				
				{
					private _sign = switch (true) do {
						case (["_", markerText _x] call dzn_fnc_inString): { "_" };
						case (["!", markerText _x] call dzn_fnc_inString): { "!" };
						default { "" };						
					};
					
					if (_sign != "") then {
						
						
						private _parts = (markerText _x) splitString _sign;
						private _count = count(_parts select 0);
						
						private _letter = toUpper (
							if (toArray ((_parts select 0) select [_count - 1,1]) isEqualTo [65533]) then {
								(_parts select 0) select [_count - 2,2]
							} else {
								(_parts select 0) select [_count - 1,1]
							}
						);
						
						BBB = _letter;
						
						private _phonetic = tSF_MissionDefaults_PhoneticAlphabet select { 
							if (toArray (_x select [0,1]) isEqualTo [65533]) then {
								_x select [0,2] == _letter 
							} else {
								_x select [0,1] == _letter 
							}
						} select 0;
						if (isNil "_phonetic") exitWith {};					
						
						_x setMarkerText format [
							"%1%2%3"
							, (_parts select 0) select [0, _count - 1]
							, _phonetic
							, if (!isNil {_parts select 1}) then { _parts select 1 } else { "" }
						];
					};			
				} forEach _diff;
			};
		};
	};
};

