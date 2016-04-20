// ********************
// FUNCTIONS
// ********************

dzn_fnc_tsf_initThinLineMarkers = {
	if !(tSF_noteSettings_enableThinLineMarkers) exitWith {};
	
	
	tSF_thinLineMarkersEnabled = false;		
	tSF_thinLineMarkers_checkStep = true;
	tSF_thinLineMarkers_sleeper = { tSF_thinLineMarkers_checkStep = false; sleep 1; tSF_thinLineMarkers_checkStep = true; };
	
	["tSF_ThinLineMarkers", "onEachFrame", {
		if !(time > 0) then {
			// Each Frame on Briefing			
			allMapMarkers call dzn_fnc_tsf_processLineMarkers;
		} else {
			// Each Second on Game start
			if (tSF_thinLineMarkers_checkStep) then {
				[] spawn tSF_thinLineMarkers_sleeper;
				allMapMarkers call dzn_fnc_tsf_processLineMarkers;
			};			
		};
	}] call BIS_fnc_addStackedEventHandler;
};

dzn_fnc_tsf_processLineMarkers = {
	private _mrks = _this;
	
	{
		private _mrk = _x;
		if (
			(markerSize _mrk select 0) == 5
			&& markerType _mrk == ""		
			&& markerShape _mrk == "RECTANGLE"
			&& markerBrush _mrk == "Solid"
			&& markerText _mrk == ""
		) then {
			if (tSF_thinLineMarkersEnabled) then {
				_mrk setMarkerSize [tSF_noteSettings_thinLineMarkers_lineSize, (markerSize _mrk select 1)];	
			} else {
				_mrk setMarkerSize [5.01, (markerSize _mrk select 1)];	
			};		
		};	
	} forEach _mrks;
};

dzn_fnc_tsf_toggleThinLineMarkers = {
	if (tSF_thinLineMarkersEnabled) then {
		tSF_thinLineMarkersEnabled = false;
		systemChat "|||| CQB Line Markers - OFF";
	} else {
		tSF_thinLineMarkersEnabled = true;
		systemChat "|||| CQB Line Markers - ON";
	};
	publicVariable "tSF_thinLineMarkersEnabled";
	publicVariable "tSF_noteSettings_thinLineMarkers_lineSize";
};

dzn_fnc_tsf_changeThinLineMarkersSize = {
	private _size = tSF_noteSettings_thinLineMarkers_lineSize + _this;
	if (_size > 15) then { 
		_size = 15; 
	} else {
		if (_size < 0.1) then { _size = 0.1; };		
	};
	tSF_noteSettings_thinLineMarkers_lineSize = _size;	
	systemChat format ["|||| CQB Line Markers - Size - %1", tSF_noteSettings_thinLineMarkers_lineSize];
	publicVariable "tSF_noteSettings_thinLineMarkers_lineSize";
};
