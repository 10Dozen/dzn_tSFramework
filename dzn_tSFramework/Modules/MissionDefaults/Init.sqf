call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\MissionDefaults\Settings.sqf";

// ********************
// INITIALIZATION
// ********************
enableSaving [false,false];
if (tSF_MissionDefaults_AddPlayerRating) then { player addRating 1000000; };

if (hasInterface && tSF_MissionDefaults_DisableInputOnStart) then {
	[] spawn {
		if (!isNil "tSF_DEBUG" && { tSF_DEBUG }) exitWith {};
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
		
		tSF_MissionDefaults_Calculator_MarkersLast = [];
		tSF_MissionDefaults_CalculatorCanCheck = true;
		tSF_MissionDefaults_CalculatorCheck = { tSF_MissionDefaults_CalculatorCanCheck = false; sleep 1; tSF_MissionDefaults_CalculatorCanCheck = true; };
		
		tSF_CutieCalc_EH = addMissionEventHandler ["EachFrame", {
			if !(tSF_MissionDefaults_CalculatorCanCheck) exitWith {};
			[] spawn tSF_MissionDefaults_CalculatorCheck;
			
			if (tSF_MissionDefaults_Calculator_MarkersLast isEqualTo allMapMarkers) exitWith {};
			private _diff = allMapMarkers - tSF_MissionDefaults_Calculator_MarkersLast;
			
			{
				private _mrkUserID = parseNumber ( (_x select [15,10]) splitString "/" select 0 );
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
						
						hint str(_this);
						private _result = call compile (_line select [1,count _line]); 
						
						systemChat format ["@Calc: %1", _result];
						[format ["<t size='0.8'>@Calc: %1", _result], [26,43,33,.027], [0,0,0,.5]] call dzn_fnc_ShowMessage;
						deleteMarker _x;
				};
				
				};
			} forEach _diff;
			
			tSF_MissionDefaults_Calculator_MarkersLast = allMapMarkers;			
		}];
		
		waitUntil { sleep 30; !alive player };
		removeMissionEventHandler ["EachFrame", tSF_CutieCalc_EH];
	};
};

