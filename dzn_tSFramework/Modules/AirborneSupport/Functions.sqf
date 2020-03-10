/*
 *	General
 */

tSF_fnc_AirborneSupport_isAuthorizedUser = {
	// Player call tSF_fnc_AirborneSupport_isAuthorizedUser

	[_this, "AIRBORNE"] call tSF_fnc_Authorization_checkPlayerAuthorized
};

tSF_fnc_AirborneSupport_GetProvider = {
	//@Callsign call tSF_fnc_AirborneSupport_GetProvider

	(tSF_AirborneSupport_Vehicles select { _x select 1 == _this }) select 0
};

tSF_fnc_AirborneSupport_AssertStatus = {
	// [@Battery/@Callsign, @State, @AssertValue] call tSF_fnc_ArtillerySupport_CheckStatus
	params["_callsign","_state","_assertValue"];

	private _veh = if (typename _callsign == "OBJECT") then { _callsign } else { (_callsign call tSF_fnc_AirborneSupport_GetProvider) select 0 };

	switch (toUpper(_state)) do {
		case "STATE":			{ toUpper(_veh getVariable ["tSF_AirborneSupport_State", "Undefined"]) == toUpper(_assertValue) };
		case "REQUESTER": 		{ (_veh getVariable ["tSF_AirborneSupport_Requester", objNull]) == _assertValue };
		case "CREW": 			{ (_veh getVariable ["tSF_AirborneSupport_Crew", grpNull]) == _assertValue };
		case "RTB POINT": 		{ (_veh getVariable ["tSF_AirborneSupport_RTBPoint", [0,0,0]]) isEqualTo _assertValue };
		case "CALLSIGN": 		{ toUpper(_veh getVariable ["tSF_AirborneSupport_Callsign", "Undefined"]) == toUpper(_assertValue)	 };
		case "NAME": 			{ toUpper(_veh getVariable ["tSF_AirborneSupport_Name", "Undefined"]) == toUpper(_assertValue) };
	}
};

tSF_fnc_AirborneSupport_SetStatus = {
	// [@Veh/@Callsign, @State, @NewValue] call tSF_fnc_AirborneSupport_SetStatus
	// [@Veh/@Callsign, [ [@State1, @Value1], [@State2, @Value2] ... ]]

	private _veh = if (typename (_this select 0) == "OBJECT") then {
		(_this select 0)
	} else {
		((_this select 0) call tSF_fnc_AirborneSupport_GetProvider) select 0
	};

	if (typename (_this select 1) == "ARRAY") exitWith {
		{ [_veh, _x select 0, _x select 1] call tSF_fnc_AirborneSupport_SetStatus; } forEach (_this select 1);
	};

	params["_callsign","_state","_value"];

	switch (toUpper(_state)) do {
		case "CALLSIGN":          { _veh setVariable ["tSF_AirborneSupport_Callsign", _value, true]; };
		case "NAME":              { _veh setVariable ["tSF_AirborneSupport_Name", _value, true]; };
		case "STATE":             { _veh setVariable ["tSF_AirborneSupport_State", _value, true]; };
		case "REQUESTER":         { _veh setVariable ["tSF_AirborneSupport_Requester", _value, true]; };
		case "CREW":              { _veh setVariable ["tSF_AirborneSupport_Crew", _value, true]; };
		case "RTB POINT":         { _veh setVariable ["tSF_AirborneSupport_RTBPoint", _value, true]; };
		case "IN PROGRESS":       { _veh setVariable ["tSF_AirborneSupport_InProgress", _value, true]; };
		case "SIDE":              { _veh setVariable ["tSF_AirborneSupport_Side", _value, true]; };
		case "LANDING POINT":     { _veh setVariable ["tSF_AirborneSupport_LandingPoint", _value, true]; };
		case "INGRESS POINT":     { _veh setVariable ["tSF_AirborneSupport_IngressPoint", _value, true]; };
		case "EGRESS POINT":      { _veh setVariable ["tSF_AirborneSupport_EgressPoint", _value, true]; };
		case "LANDING PAD":       { _veh setVariable ["tSF_AirborneSupport_LandingPad", _value, true ]; };
	}
};

tSF_fnc_AirborneSupport_GetStatus = {
	// [@Battery/@Callsign, @State] call tSF_fnc_AirborneSupport_GetStatus
	params["_callsign","_state"];

	private _veh = if (typename _callsign == "OBJECT") then { _callsign } else { (_callsign call tSF_fnc_AirborneSupport_GetProvider) select 0 };

	switch (toUpper(_state)) do {
		case "CALLSIGN":          { _veh getVariable ["tSF_AirborneSupport_Callsign", "Undefined"]; };
		case "NAME":              { _veh getVariable ["tSF_AirborneSupport_Name", "Undefined"]; };
		case "STATE":             { _veh getVariable ["tSF_AirborneSupport_State", "Undefined"]; };
		case "REQUESTER":         { _veh getVariable ["tSF_AirborneSupport_Requester", objNull]; };
		case "CREW":              { _veh getVariable ["tSF_AirborneSupport_Crew", grpNull]; };
		case "RTB POINT":         { _veh getVariable ["tSF_AirborneSupport_RTBPoint", [0,0,0]]; };
		case "IN PROGRESS":       { _veh getVariable ["tSF_AirborneSupport_InProgress", false]; };
		case "SIDE":              { _veh getVariable ["tSF_AirborneSupport_Side", CIVILIAN]; };
		case "LANDING POINT":     { _veh getVariable ["tSF_AirborneSupport_LandingPoint", [0,0,0]]; };
		case "INGRESS POINT":     { _veh getVariable ["tSF_AirborneSupport_IngressPoint", [0,0,0]]; };
		case "EGRESS POINT":      { _veh getVariable ["tSF_AirborneSupport_EgressPoint", [0,0,0]]; };
		case "LANDING PAD":       { _veh getVariable ["tSF_AirborneSupport_LandingPad", objNull]; };
	}
};

tSF_fnc_AirborneSupport_Diag = {
	private _txt = [];
	{
		_txt pushBack (format ["%1: %2", _x select 0, _this getVariable (_x select 1)]);
	} forEach [
		["Callsign", "tSF_AirborneSupport_Callsign"]
		, ["Name", "tSF_AirborneSupport_Name"]
		, ["State", "tSF_AirborneSupport_State"]
		, ["Requster", "tSF_AirborneSupport_Requester"]
		, ["Crew", "tSF_AirborneSupport_Crew"]
		, ["RTB Point", "tSF_AirborneSupport_RTBPoint"]
		, ["InProgress", "tSF_AirborneSupport_InProgress"]
		, ["Side", "tSF_AirborneSupport_Side"]
		, ["Landing", "tSF_AirborneSupport_LandingPoint"]
		, ["Ingress", "tSF_AirborneSupport_IngressPoint"]
		, ["Egress", "tSF_AirborneSupport_EgressPoint"]
	];

	hint  (_txt joinString "\n");

	_txt joinString " | "
};

/*
 *	Initialization
 */

tSF_fnc_AirborneSupport_processLogics = {
	private _vehicles = [];
	private _returnPoints = [];
	{
		private _logic = _x;
		if (!isNil {_logic getVariable "tSF_AirborneSupport_ReturnPoint"}) then {
			{ _returnPoints pushBack (getPosATL _x); } forEach (synchronizedObjects _logic);
		};
		if (!isNil {_logic getVariable "tSF_AirborneSupport"}) then {
			_vehicles pushBack [(synchronizedObjects _logic) # 0, _logic getVariable "tSF_AirborneSupport"];
		};
	} forEach (entities "Logic");

	tSF_AirborneSupport_ReturnPoints = _returnPoints;
	tSF_AirborneSupport_Vehicles = _vehicles;
	
	if (count _vehicles > count _returnPoints) then {
		diag_log "tSF :: Support :: There is not enough Return points for vehicles";
		["tSF :: Support :: There is not enough Return points for vehicles"] call BIS_fnc_error;
	};

	[_vehicles, +_returnPoints] call tSF_fnc_AirborneSupport_processVehicleServer;
};

tSF_fnc_AirborneSupport_processVehicleServer = {
	params ["_vehicles","_points"];
	{
		_x params ["_veh","_callsign"];

		private _type = (typeOf _veh) call dzn_fnc_getVehicleDisplayName;
		private _name = if (_callsign == "") then { _type } else { format ["%1 (%2)", _callsign, _type] };
		private _pos = getPosATL _veh;
		
		private _point = [0,0,0];
		private _max = -log 0;
		private _idx = -1;
		{
			if (_pos distanceSqr _x < _max) then {
				_point = _x;
				_idx = _forEachIndex;
			};
		} forEach _points;
		_points deleteAt _idx;
		
		_veh allowDamage false;
		_veh setPosATL _point;
		_veh allowDamage true;

		[_veh, [
			["CALLSIGN", _callsign]
			,["NAME", _name]
			, ["IN PROGRESS", false]
			, ["STATE", "Waiting"]
			, ["RTB POINT", _point]
		]] call tSF_fnc_AirborneSupport_SetStatus;
		
		[_veh, false] execFSM "dzn_tSFramework\Modules\AirborneSupport\Support.fsm";
	} forEach _vehicles;
};

/*
 *	Control functions
 */

tSF_fnc_AirborneSupport_ResetVehicleVars = {
	params["_veh"];

	[_veh, [
		["IN PROGRESS", false]
		, ["STATE", "Waiting"]
		, ["SIDE", CIVILIAN]
		, ["LANDING POINT", [0,0,0]]
		, ["INGRESS POINT", [0,0,0]]
		, ["EGRESS POINT", [0,0,0]]
	]] call tSF_fnc_AirborneSupport_SetStatus;
};

tSF_fnc_AirborneSupport_AddPilot = {
	params["_veh"];

	private _aiPilotExists = false;
	private _aiPilot = objNull;

	if !(isNull (driver _veh)) then {
		if (isPlayer (driver _veh)) then {
			moveOut (driver _veh);
		} else {
			_aiPilotExists = true;
			_aiPilot = driver _veh;
		};
	};

	if !(_aiPilotExists) then {
		_aiPilot = units ([
			_veh
			, [_veh, "SIDE"] call tSF_fnc_AirborneSupport_GetStatus
			, ["driver"]
			, tSF_AirborneSupport_PilotKit
			, 0
		] call dzn_fnc_createVehicleCrew) select 0;
	};

	// (group _aiPilot) setBehaviour "CARELESS";
	(group _aiPilot) setCombatMode "BLUE";
	{ _aiPilot disableAI _x; } forEach ["TARGET","AUTOTARGET","SUPPRESSION","AIMINGERROR","COVER","AUTOCOMBAT"];
	_aiPilot setSkill 1;
	_aiPilot setSkill ["courage", 1];

	_veh engineOn true;
	_aiPilot
};

tSF_fnc_AirborneSupport_SetLandingPad = {
	params ["_veh", "_pos", "_dir"];

	private _pad = [_veh, "LANDING PAD"] call tSF_fnc_AirborneSupport_GetStatus;
	if (isNull _pad) then {
		_pad = [[_pos, _dir], "Land_HelipadEmpty_F" ] call dzn_fnc_createVehicle;
		[_veh, "LANDING PAD", _pad] call tSF_fnc_AirborneSupport_SetStatus;
	} else {
		_pad setPos _pos;
		_pad setDir _dir;
	};

	_pad setPos _pos;

	_pad
};

tSF_fnc_AirborneSupport_MoveToPosition = {
	params["_pilot","_pos",["_radius",200]];

	private _grp = group _pilot;

	while {(count (waypoints _grp)) > 0} do {
		deleteWaypoint ((waypoints _grp) select 0);
	};

	private _wp = _grp addWaypoint [_pos, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointCompletionRadius _radius;
	(vehicle _pilot) flyInHeight 40;
};

tSF_fnc_AirborneSupport_Land = {
	params ["_veh","_mode","_helipad", "_approachDirection"];

	if (toLower(_mode) == "land") then {
		_veh land _mode;
		private _landingPoint = [_veh, "RTB POINT"] call tSF_fnc_AirborneSupport_GetStatus;
		waitUntil {
			sleep 5;
			((getPosATL _veh) select 2) - (_landingPoint select 2) < 10
		};
		_veh allowDamage false;

		private _pilot = driver _veh;
		private _grp = group _pilot;
		moveOut _pilot;
		deleteVehicle _pilot;
		deleteGroup _grp;

		_veh engineOn false;
		_veh setVelocity [0,0,0];
		_veh setPos _landingPoint;

		waitUntil { sleep 5; (getPosATL _veh) select 2 < 10 };
		_veh allowDamage true;
	} else {
		[_veh, _helipad, _approachDirection] call tSF_fnc_AirborneSupport_PreciseLanding;
	};
};

tSF_fnc_AirborneSupport_PreciseLanding = {
	params ["_veh","_pad", "_approachDirection",["_time",7]];

	private _fromPos = getPosASL _veh;
	private _toPos = AGLtoASL (_pad getPos [10, _approachDirection - 180]);
	_toPos set [2, (_toPos # 2) + 35];

	private _timeFrom = time;
	private _timeTo = _timeFrom + (_time min (_fromPos distance2d _toPos)/2);

	[
		{
			params ["_args","_handle"];
			_args params ["_veh","_pad","_fromPos","_toPos","_timeFrom","_timeTo"];

			private _interval = linearConversion [_timeFrom, _timeTo, time, 0, 1];
			if (_interval > 0.5) then {
				_veh land "GET IN";
				_veh flyInHeight 0;
			};

			if (_interval > 0.99) exitWith {
				[_handle] call CBA_fnc_removePerFrameHandler;


			};

			private _dir = _veh getDir _toPos;
			private _vectorDir = [sin _dir, cos _dir, 0];

			_veh setVelocityTransformation [
				_fromPos, _toPos,
				[0,0,0], [0,0,0],
				vectorDirVisual _veh, _vectorDir,
				vectorUpVisual _veh, [0,0,1],
				_interval
			];
		},
		0,
		[_veh, _pad, _fromPos, _toPos, _timeFrom, _timeTo]
	] call CBA_fnc_addPerFrameHandler;
};


tSF_fnc_AirborneSupport_displayCloseAreaMarker = {
	if (toLower(_this) == "show") then {
		createMarkerLocal [
			"tSF_AirborneSupport_CloseAreaMarker"
			, [getPosASL player select 0, getPosASL player select 1]
		];
		"tSF_AirborneSupport_CloseAreaMarker" setMarkerShapeLocal "ELLIPSE";
		"tSF_AirborneSupport_CloseAreaMarker" setMarkerSizeLocal [tSF_AirborneSupport_CallIn_MinDistance, tSF_AirborneSupport_CallIn_MinDistance];
		"tSF_AirborneSupport_CloseAreaMarker" setMarkerColorLocal "ColorRed";
		"tSF_AirborneSupport_CloseAreaMarker" setMarkerAlphaLocal 0.5;
	} else {
		deleteMarkerLocal "tSF_AirborneSupport_CloseAreaMarker";
	};
};

KK_fnc_setVelocityModelSpaceVisual = {
	private _o = _this select 0;
	_o setVelocity (
		_o modelToWorldVisual (_this select 1) vectorDiff (_o modelToWorldVisual [0,0,0])
	);
};


tSF_fnc_AirborneSupport_showTeleportMenu = {
	tSF_AirborneSupport_TeleportMenu = [
		["Re-deploy",false]
		, ["Deploy to Squad",[2],"",-5,[["expression", "[player,'squad'] spawn tSF_fnc_AirborneSupport_doTeleport"]],"1","1"]
		, ["Deploy to Base",[3],"",-5,[["expression", "[player,'base'] spawn tSF_fnc_AirborneSupport_doTeleport"]],"1","1"]
	];
	showCommandingMenu "#USER:tSF_AirborneSupport_TeleportMenu";
};

tSF_fnc_AirborneSupport_doTeleport = {
	params["_unit","_dest"];

	private _pos = if ("base" == toLower(_dest)) then {
		selectRandom tSF_AirborneSupport_ReturnPoints
	} else {
		getPosATL ( selectRandom (units (group _unit)) )
	};

	_pos = [(_pos select 0) + 10, (_pos select 1) - 10,0];


	0 cutText ["", "WHITE OUT", 0.1];
	_unit allowDamage false;
	sleep 1;
	moveOut _unit;
	_unit setPosATL _pos;
	sleep 1;
	_unit allowDamage true;

	0 cutText ["", "WHITE IN", 1];
};
