
tSF_fnc_CCP_drawAllowedAreaMarkers = {
	// @Markers = call tSF_fnc_CCP_drawAllowedAreaMarkers
	private _mrk = ["mrk_CCP_default", getPosATL tsf_CCP, "mil_box", "ColorKhaki", format ["(%1)", tSF_CCP_STR_ShortName], true] call dzn_fnc_createMarkerIcon;
	_mrk setMarkerAlpha 0.5;
	
	private _markers = [];
	{
		private _trgArea = triggerArea _x;
		private _mrk = createMarker [format ["mrk_CCP_allowed_%1", _forEachIndex], getPosATL _x];

		_mrk setMarkerShape (if (_trgArea select 3) then {"RECTANGLE"} else {"ELLIPSE"});
		_mrk setMarkerSize [_trgArea select 0, _trgArea select 1];
		_mrk setMarkerDir (_trgArea select 2);

		_mrk setMarkerBrush "SolidBorder";
		_mrk setMarkerColor "ColorKhaki";
		_mrk setMarkerAlpha 0.5;

		_markers pushBack _mrk;
	} forEach (synchronizedObjects tsf_CCP);
	
	_markers
};

tSF_fnc_CCP_removeAllowedAreaMarkers = {
	// @Markers call dzn_fnc_tsf_CCP_removeAllowedAreaMarkers
	{deleteMarker _x;} forEach _this;
};

tSF_fnc_CCP_findAndUpdateMarker = {
	// call tSF_fnc_CCP_findAndUpdateMarker
	private _markerPos = getPosASL tsf_CCP;
	private _useDefault = true;
	
	{
		if (toLower(markerText _x) == "ccp") then {		 	
			_x setMarkerText tSF_CCP_STR_ShortName;
		 	_x setMarkerType "mil_flag";
		 	_x setMarkerColor "ColorKhaki";
			deleteMarker "mrk_CCP_default";
			_markerPos = markerPos _x;
			
			_useDefault = false;
		};
	} forEach allMapMarkers;
	
	if (_useDefault) then {
		[] spawn {
			"mrk_CCP_default" setMarkerText tSF_CCP_STR_ShortName;
			"mrk_CCP_default" setMarkerType "mil_flag";
			"mrk_CCP_default" setMarkerColor "ColorKhaki";
			"mrk_CCP_default" setMarkerAlpha 1;
		};
	};
	
	_markerPos
};


tSF_fnc_CCP_createCCP_Server = {
	params["_pos","_composition"];	
	
	private _dir = 0;
	if !(typename _pos == "ARRAY") then {
		_dir = getDir _pos;
		_pos = getPosATL _pos;
	};

	tSF_CCP_Objects = [[_pos, _dir], _composition] call dzn_fnc_setComposition;
	{
		_x lock true;
	} forEach tSF_CCP_Objects;

	private _stretcherPositions = [];
	{
		private _o = (tSF_CCP_Objects select 0);
		private _pos = _o modelToWorld (_x select 0);
		_pos set [2,0];

		private _dir = (getDir _o) + (_x select 1);

		_stretcherPositions pushBack [_forEachIndex, [_pos, _dir]];
	} forEach [
		[[4, -3, 0], 90]
		,[[4, -1, 0], 90]
		,[[4, 1, 0], 90]
		,[[4, 3, 0], 90]
		,[[-4, -3, 0], -90]
		,[[-4, -1, 0], -90]
		,[[-4, 1, 0], -90]
		,[[-4, 3, 0], -90]
	];

	(tSF_CCP_Objects select 0) setVariable ["tSF_CCP_StretcherPositions",_stretcherPositions,true];
	(tSF_CCP_Objects select 0) setVariable ["tSF_CCP_UsedStretcherPositions",[],true];
	publicVariable "tSF_CCP_Objects";

	// Add helipad position
	private _hpadPos = _pos findEmptyPosition [20, 50, "B_Heli_Transport_01_camo_F"];
	if (_hpadPos isEqualTo []) then { _hpadPos = _pos; };
	private _hpad = tSF_CCP_HelipadClass createVehicle _hpadPos;
};

tSF_fnc_CCP_createCCP_Client = {
	waitUntil {!isNil "tSF_CCP_Position"};
	waitUntil {!isNil "tSF_CCP_Objects"};
	{
		[
			_x
			, "<t color='#9bbc2f' size='1.2'>Get Medical Care</t>"
			, {[] spawn tSF_fnc_CCP_doMedicateAction;	}
			, 5
			, "!(player getVariable ['tSF_CCP_isHealing',false])"
			, 6
		] call dzn_fnc_addAction;

		[
			_x
			, "<t color='#9bbc2f' size='1'>Provide first aid to uncon. patients</t>"
			, {[] spawn tSF_fnc_CCP_healUnconcious; }
			, 5
			, "!(player getVariable ['tSF_CCP_isHealing',false])"
			, 6
		] call dzn_fnc_addAction;

	} forEach tSF_CCP_Objects;

	player setVariable ["tSF_CCP_forceHealing", false];

	tSF_CCP_CanCheck = true;
	tSF_fnc_CCP_wait = {tSF_CCP_CanCheck = false; sleep 10; tSF_CCP_CanCheck = true;};
	addMissionEventHandler ["EachFrame", {
		if !(tSF_CCP_CanCheck) exitWith {};
		[] spawn tSF_fnc_CCP_wait;

		if (player getVariable "tSF_CCP_forceHealing" && !(player getVariable ["tSF_CCP_isHealing", false])) then {
			[] spawn tSF_fnc_CCP_doMedicateAction
		};
	}];
};

tSF_fnc_CCP_doMedicateAction = {
	private _ccp = tSF_CCP_Objects select 0;
	private _usedPoses = _ccp getVariable "tSF_CCP_UsedStretcherPositions";
	private _allPoses = _ccp getVariable "tSF_CCP_StretcherPositions";

	if (count _allPoses == count _usedPoses) exitWith { hint "Medical Care is not available right now!" };
	private _notUsed = [_allPoses, { !((_x select 0) in _usedPoses) }] call BIS_fnc_conditionalSelect;
	private _playerPos = _notUsed select 0;

	_ccp setVariable [
		"tSF_CCP_UsedStretcherPositions"
		, _usedPoses + [_playerPos select 0]
		, true
	];

	private _pos = _playerPos select 1 select 0;
	private _dir = _playerPos select 1 select 1;

	player setVariable ["tSF_CCP_isHealing", true, true];

	0 cutText ["", "WHITE OUT", 0.5];
	sleep 1;

	private _stretcher = "cwa_Stretcher" createVehicle _pos;
	_stretcher setPosATL _pos;
	_stretcher setDir _dir;

	player attachTo [_stretcher,[0,0,0.05]];
	[
		player
		, (selectRandom [
			"Acts_InjuredAngryRifle01"
			,"Acts_InjuredCoughRifle02"
			,"Acts_InjuredLookingRifle01"
			,"Acts_InjuredLookingRifle02"
			,"Acts_InjuredLookingRifle03"
			,"Acts_InjuredLookingRifle04"
			,"Acts_InjuredLookingRifle05"

			,"Acts_InjuredLyingRifle01"
			,"Acts_InjuredLyingRifle02"

			,"Acts_LyingWounded_loop"
			,"Acts_LyingWounded_loop1"
			,"Acts_LyingWounded_loop2"
			,"Acts_LyingWounded_loop3"
		])
		, "_this getVariable 'tSF_CCP_isHealing'"
		, true
	] spawn dzn_fnc_playAnimLoop;
	
	[
		"<t align='center' shadow='2' font='PuristaMedium'>MEDICAL AID</t>"
		, [1,18.5,74,0.04], [0,0,0,0]
		, "!(player getVariable 'tSF_CCP_isHealing')"
	] call dzn_fnc_ShowMessage;
	
	[1, (tSF_CCP_TimeToHeal + tSF_CCP_TimeToHold), 1, "BOTTOM", {}, 10] spawn dzn_fnc_ShowProgressBar;
	
	
	0 cutText ["", "WHITE IN", 1];
	sleep tSF_CCP_TimeToHeal;

	[player,player] call ace_medical_fnc_treatmentAdvanced_fullHealLocal;
	player setDamage 0;

	sleep tSF_CCP_TimeToHold;

	player setVariable ["tSF_CCP_isHealing",false,true];
	player setVariable ["tSF_CCP_forceHealing",false,true];

	0 cutText ["", "WHITE OUT", 0.1];
	sleep 2;
	
	detach player;
	deleteVehicle _stretcher;
	0 cutText ["", "WHITE IN", 1];

	_ccp setVariable [
		"tSF_CCP_UsedStretcherPositions"
		, (_ccp getVariable "tSF_CCP_UsedStretcherPositions") - [_playerPos select 0]
		, true
	];
};

tSF_fnc_CCP_healUnconcious = {
	private _units = (call BIS_fnc_listPlayers) select {
		alive _x
		
		&& !(_x getVariable ["tSF_CCP_forceHealing", false])
		&& !(_x getVariable ["tSF_CCP_isHealing", false])
		
		&& _x getVariable ["ACE_isUnconscious", false]
		&& (_x distance2d tSF_CCP_Position < 15)
	};

	{
		_x setVariable ["tSF_CCP_forceHealing", true, true];
	} forEach _units;
};
