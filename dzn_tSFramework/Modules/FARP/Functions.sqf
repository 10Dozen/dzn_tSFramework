
tSF_fnc_FARP_drawAllowedAreaMarkers = {
	// @Markers = call tSF_fnc_FARP_drawAllowedAreaMarkers
	private _markers = [];
	{
		private _trgArea = triggerArea _x;
		private _mrk = createMarker [format ["mrk_FARP_allowed_%1", _forEachIndex], getPosATL _x];

		_mrk setMarkerShape (if (_trgArea select 3) then {"RECTANGLE"} else {"ELLIPSE"});
		_mrk setMarkerSize [_trgArea select 0, _trgArea select 1];
		_mrk setMarkerDir (_trgArea select 2);

		_mrk setMarkerBrush "SolidBorder";
		_mrk setMarkerColor "ColorOrange";
		_mrk setMarkerAlpha 0.8;

		_markers pushBack _mrk;
	} forEach (synchronizedObjects tsf_FARP);

	_markers
};

tSF_fnc_FARP_removeAllowedAreaMarkers = {
	// @Markers call tSF_fnc_FARP_removeAllowedAreaMarkers
	{deleteMarker _x;} forEach _this;
};

tSF_fnc_FARP_findMarker = {
	// call tSF_fnc_tsf_FARP_findMarker
	private _markerPos = getPosASL tsf_FARP;
	{
		if (toLower(markerText _x) == "farp") then { _markerPos = markerPos _x; };
	} forEach allMapMarkers;

	_markerPos
};


tSF_fnc_FARP_createFARP_Server = {
	params["_pos","_composition"];

	private _dir = 0;
	if !(typename _pos == "ARRAY") then {
		_dir = getDir _pos;
		_pos = getPosATL _pos;
	};

	tSF_FARP_Objects = [[_pos, _dir], _composition] call dzn_fnc_setComposition;
	tSF_FARP_Objects apply { _x lock true };

	publicVariable "tSF_CCP_Objects";
};


tSF_fnc_FARP_createFARP_Client = {
	waitUntil { !isNil "tSF_FARP_Position" };
	["mrk_auto_farp", tSF_FARP_Position, "mil_flag", "ColorOrange", "FARP", true] call dzn_fnc_createMarkerIcon;

	waitUntil {!isNil "tSF_FARP_Objects"};
	{
		/*
		[
			_x
			, "<t color='#9bbc2f' size='1.2'>Get Medical Care</t>"
			, {[] spawn tSF_fnc_CCP_doMedicateAction;	}
			, 5
			, "!(player getVariable ['tSF_CCP_isHealing',false])"
			, 6
		] call dzn_fnc_addAction;
		*/
	} forEach tSF_FARP_Objects;

	player setVariable ["tSF_CCP_forceHealing", false];

	/*
	tSF_FARP_CanCheck = true;
	tSF_fnc_FARP_wait = {tSF_FARP_CanCheck = false; sleep 10; tSF_FARP_CanCheck = true;};
	addMissionEventHandler ["EachFrame", {
		if !(tSF_FARP_CanCheck) exitWith {};
		[] spawn tSF_fnc_FARP_wait;

	
	}];
	
	*/
};
