dzn_fnc_tsf_CCP_drawAllowedAreaMarkers = {
	// @Markers = call dzn_fnc_tsf_CCP_drawAllowedAreaMarkers
	private _markers = [];
	{
		private _trgArea = triggerArea _x;
		private _mrk = createMarker [format ["mrk_CCP_allowed_%1", _forEachIndex], getPosATL _x];
		
		_mrk setMarkerShape (if (_trgArea select 3) then {"RECTANGLE"} else {"ELLIPSE"});
		_mrk setMarkerSize [_trgArea select 0, _trgArea select 1];
		_mrk setMarkerDir (_trgArea select 2);
		
		_mrk setMarkerBrush "FDiagonal";
		_mrk setMarkerColor "ColorKhaki";
		_mrk setMarkerAlpha 0.8;
		
		_markers pushBack _mrk;
	} forEach (synchronizedObjects tsf_CCP);
	
	_markers
};

dzn_fnc_tsf_CCP_removeAllowedAreaMarkers = {
	// @Markers call dzn_fnc_tsf_CCP_removeAllowedAreaMarkers
	{
		deleteMarker _x;
	} forEach _this;
};

dzn_fnc_tsf_CCP_findMarker = {
	// call dzn_fnc_tsf_CCP_findMarker
	private _markerPos = getPosASL tsf_CCP;
	{
		if (toLower(markerText _x) == "ccp") then { _markerPos = markerPos _x; };
	} forEach allMapMarkers;
	
	_markerPos
};


dzn_fnc_tsf_CCP_createCCP = {
	// [timeToHeal, radius, preventDeath, Pos3d or Object, Composition]  spawn dzn_fnc_tsf_CCP_createCCP
	params["_healTime","_radius","_preventDeath","_pos","_composition"];

	private _dir = 0;
	if !(typename _pos == "ARRAY") then {
		_dir = getDir _pos;
		_pos = getPosATL _pos;
	};

	dzn_tsf_CCP_HealTime		= _healTime;
	dzn_tsf_CCP_Radius		= _radius;
	dzn_tsf_CCP_PreventPlayerDeath	= _preventDeath;
	
	// If server - create composition
	if (isServer && !(_composition isEqualTo [])) then {		
		private _spawnedObjects = [[_pos, _dir], _composition] call dzn_fnc_setComposition;
		{ _x lock true } forEach _spawnedObjects;
	};
	
	if (hasInterface) then {
		if ((getPosASL tsf_CCP) isEqualTo _pos) then {
			["mrk_auto_ccp", _pos, "mil_flag", "ColorKhaki", "CCP", true] call dzn_fnc_createMarkerIcon;		
		};
		
		// Create location
		dzn_tsf_CCP_Location = createLocation ["Name", _pos, _radius, _radius];
		
		// Add Event Handler to player
		dzn_tsf_CCP_TimeSpentAtCCP = 0;
		dzn_tsf_CCP_Handler_CheckStep = true;
		
		dzn_fnc_tsf_CCP_waitUntilStep = {
			dzn_tsf_CCP_Handler_CheckStep = false; 
			sleep 15; 
			dzn_tsf_CCP_Handler_CheckStep = true; 
		};
	
		["dzn_tsf_CCP_Handler", "onEachFrame", {
			if !(dzn_tsf_CCP_Handler_CheckStep) exitWith {};
			[] spawn dzn_fnc_tsf_CCP_waitUntilStep;
			
			// Checks if player at CCP - then add 15second to timer. If he is not at CCP - nil the timer.
			if ((getPosATL player) in dzn_tsf_CCP_Location) then {
				if (isNil "dzn_tsf_CCP_TimeSpentAtCCP") then {
					dzn_tsf_CCP_TimeSpentAtCCP = 15;
					if (dzn_tsf_CCP_PreventPlayerDeath) then { player allowDamage false; };
					hint format [dzn_tsf_CCP_STR_Hint, round(dzn_tsf_CCP_HealTime/60)];
				} else {
					dzn_tsf_CCP_TimeSpentAtCCP = dzn_tsf_CCP_TimeSpentAtCCP + 15;
					if (dzn_tsf_CCP_PreventPlayerDeath) then { player allowDamage false; };
				};
				
				// Spent required time at CCP
				if (dzn_tsf_CCP_TimeSpentAtCCP >= dzn_tsf_CCP_HealTime) then {
					[player,player] call ace_medical_fnc_treatmentAdvanced_fullHealLocal;
					player setDamage 0;
					player allowDamage true;
				};
			} else {
				dzn_tsf_CCP_TimeSpentAtCCP = nil;
				player allowDamage true;
			}
		}] call BIS_fnc_addStackedEventHandler;
	}
};
