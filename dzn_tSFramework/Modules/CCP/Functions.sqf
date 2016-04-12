dzn_fnc_tsf_CCP_findMarker = {
	// call dzn_fnc_tsf_CCP_findMarker
	private _markerPos = [];
	{
		if (toLower(markerText _x) == "ccp") then { _markerPos = markerPos _x; };
	} forEach allMapMarkers;
	
	_markerPos
};

dzn_fnc_tsf_CCP_createCCP = {
	// [timeToHeal, radius, preventDeath, Pos3d or Object, Composition]  spawn dzn_fnc_tsf_CCP_createCCP
	params["_healTime","_radius","_preventDeath","_pos",["_composition", []]];
	_pos = if (typename _pos == "ARRAY") then { _pos } else { getPosATL _pos };
	
	dzn_tsf_CCP_HealTime		= _healTime;
	dzn_tsf_CCP_Radius		= _radius;
	dzn_tsf_CCP_PreventPlayerDeath	= _preventDeath;
	
	// If server - create composition
	if (isServer && !(_composition isEqualTo {})) then {
		
	
	};
	
	
	if (hasInterface) then {
		// Create location
		dzn_tsf_CCP_Location = createLocation ["Name", _pos, _radius, _radius];
		
		// Add Event Handler to player
		dzn_tsf_CCP_TimeSpentAtCCP = 0;
		dzn_tsf_CCP_Handler_CheckStep = false;
		dzn_fnc_tsf_CCP_waitUntilStep = { dzn_tsf_CCP_Handler_CheckStep = false; sleep 15; dzn_tsf_CCP_Handler_CheckStep = true; };
	
		["dzn_tsf_CCP_Handler", "onEachFrame", {
			if !(dzn_tsf_CCP_Handler_CheckStep) exitWith {};
			spawn dzn_fnc_tsf_CCP_waitUntilStep;
			
			// Checks if player at CCP - then add 15second to timer. If he is not at CCP - nil the timer.
			if (player in dzn_tsf_CCP_Location) then {
				if (isNil "dzn_tsf_CCP_TimeSpentAtCCP") then {
					dzn_tsf_CCP_TimeSpentAtCCP = 15;
					if (dzn_tsf_CCP_PreventPlayerDeath) then { player allowDamage false; };
				} else {
					dzn_tsf_CCP_TimeSpentAtCCP = dzn_tsf_CCP_TimeSpentAtCCP + 15;
				};
				
				if (dzn_tsf_CCP_TimeSpentAtCCP >= dzn_tsf_CCP_HealTime) then {
					// ACE Full Heal
					
					player allowDamage true;
				};
			} else {
				dzn_tsf_CCP_TimeSpentAtCCP = nil;
				player allowDamage true;
			}
		}] call BIS_fnc_addStackedEventHandler;
	}
	
	
};
