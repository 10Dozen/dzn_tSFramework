tSF_fnc_CCP_drawAllowedAreaMarkers = {
	// @Markers = call tSF_fnc_CCP_drawAllowedAreaMarkers
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

tSF_fnc_CCP_removeAllowedAreaMarkers = {
	// @Markers call dzn_fnc_tsf_CCP_removeAllowedAreaMarkers
	{deleteMarker _x;} forEach _this;
};

tSF_fnc_CCP_findMarker = {
	// call dzn_fnc_tsf_CCP_findMarker
	private _markerPos = getPosASL tsf_CCP;
	{
		if (toLower(markerText _x) == "ccp") then { _markerPos = markerPos _x; };
	} forEach allMapMarkers;
	
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
};

tSF_fnc_CCP_createCCP_Client = {
	waitUntil { !isNil "tSF_CCP_Position" };	
	["mrk_auto_ccp", tSF_CCP_Position, "mil_flag", "ColorKhaki", "CCP", true] call dzn_fnc_createMarkerIcon;	

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
	} forEach tSF_CCP_Objects;		
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
	
	player setVariable ["tSF_CCP_isHealing",true];
	
	0 cutText ["", "WHITE OUT", 0.5];
	sleep 1;	
	
	private _stretcher = "cwa_Stretcher" createVehicle _pos;
	_stretcher setPosATL _pos;
	_stretcher setDir _dir;
	
	player attachTo [_stretcher,[0,0,0.05]];	
	(selectRandom [
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
	]) spawn tSF_CCP_LoopAnimation;
	[] spawn tSF_CCP_HandleProgressBar;
	
	0 cutText ["", "WHITE IN", 1];
	
	sleep tSF_CCP_TimeToHeal;
	
	[player,player] call ace_medical_fnc_treatmentAdvanced_fullHealLocal;
	player setDamage 0;
	
	sleep tSF_CCP_TimeToHold;
	
	player setVariable ["tSF_CCP_isHealing",false];
	
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


tSF_CCP_LoopAnimation = {
	private _animation = _this;
	
	while {player getVariable 'tSF_CCP_isHealing'} do {
		if (animationState player != _animation ) then {
			player switchMove _animation ;
			player playMoveNow _animation;
		};
	};

	player switchMove "" ;
};

tSF_CCP_HandleProgressBar = {
	CCP_bar_progress = 0;
	CCP_bar_max = tSF_CCP_TimeToHeal + tSF_CCP_TimeToHold;
	CCP_bar_step = 1/CCP_bar_max;
	
	with uiNamespace do { 
		CCP_bar = findDisplay 46 ctrlCreate ["RscProgress", -1];  
		CCP_bar ctrlSetPosition [0,.8,1,0.05];
		
		CCP_bar progressSetPosition 0.0;  
		CCP_bar ctrlCommit 0;
	};
	
	["<t align='center'>Medical Aid</t>", [16,22.5, 16, 0.033], [0,0,0,0],  "!(player getVariable 'tSF_CCP_isHealing')"] call dzn_fnc_ShowMessage;
	
	for "_i" from 0 to CCP_bar_max do {
		(uiNamespace getVariable "CCP_bar") progressSetPosition CCP_bar_progress;
		(uiNamespace getVariable "CCP_bar") ctrlCommit 0;
		sleep 1;
		CCP_bar_progress = CCP_bar_progress + CCP_bar_step;	
	};
	
	ctrlDelete (uiNamespace getVariable "CCP_bar");
};
