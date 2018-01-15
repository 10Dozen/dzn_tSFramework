/*
 *	General
 */

tSF_fnc_AirborneSupport_isAuthorizedUser = {
	// Player call tSF_fnc_AirborneSupport_isAuthorizedUser
	private _role = toLower(roleDescription _this);
	private _listOfAuthorizedUsers = tSF_AirborneSupport_AuthorizedUsers apply { toLower(_x) };

	if ("any" in _listOfAuthorizedUsers) exitWith { true };
	
	if ("admin" in _listOfAuthorizedUsers && ((serverCommandAvailable "#logout") || !(isMultiplayer) || isServer)) exitWith {
		true
	};
	
	( { [_x, _role, false] call BIS_fnc_inString } count _listOfAuthorizedUsers ) > 0	
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
		case "CALLSIGN": 		{ _veh setVariable ["tSF_AirborneSupport_Callsign", _value, true]; };
		case "NAME": 			{ _veh setVariable ["tSF_AirborneSupport_Name", _value, true]; };
		case "STATE": 		{ _veh setVariable ["tSF_AirborneSupport_State", _value, true]; };
		case "REQUESTER": 		{ _veh setVariable ["tSF_AirborneSupport_Requester", _value, true]; };
		case "CREW": 			{ _veh setVariable ["tSF_AirborneSupport_Crew", _value, true]; };
		case "RTB POINT": 		{ _veh setVariable ["tSF_AirborneSupport_RTBPoint", _value, true]; };
		case "IN PROGRESS":		{ _veh setVariable ["tSF_AirborneSupport_InProgress", _value, true]; };
		case "SIDE": 			{ _veh setVariable ["tSF_AirborneSupport_Side", _value, true]; };
		case "LANDING POINT": 	{ _veh setVariable ["tSF_AirborneSupport_LandingPoint", _value, true]; };
		case "INGRESS POINT": 	{ _veh setVariable ["tSF_AirborneSupport_IngressPoint", _value, true]; };
		case "EGRESS POINT": 	{ _veh setVariable ["tSF_AirborneSupport_EgressPoint", _value, true]; };
		case "LANDING PAD": 		{ _veh setVariable ["tSF_AirborneSupport_LandingPad", _value, true ]; };
	}
};

tSF_fnc_AirborneSupport_GetStatus = {
	// [@Battery/@Callsign, @State] call tSF_fnc_AirborneSupport_GetStatus
	params["_callsign","_state"];

	private _veh = if (typename _callsign == "OBJECT") then { _callsign } else { (_callsign call tSF_fnc_AirborneSupport_GetProvider) select 0 };
	
	switch (toUpper(_state)) do {
		case "CALLSIGN": 		{ _veh getVariable ["tSF_AirborneSupport_Callsign", "Undefined"]; };
		case "NAME": 			{ _veh getVariable ["tSF_AirborneSupport_Name", "Undefined"]; };
		case "STATE": 		{ _veh getVariable ["tSF_AirborneSupport_State", "Undefined"]; };
		case "REQUESTER": 		{ _veh getVariable ["tSF_AirborneSupport_Requester", objNull]; };
		case "CREW": 			{ _veh getVariable ["tSF_AirborneSupport_Crew", grpNull]; };
		case "RTB POINT": 		{ _veh getVariable ["tSF_AirborneSupport_RTBPoint", [0,0,0]]; };
		case "IN PROGRESS": 		{ _veh getVariable ["tSF_AirborneSupport_InProgress", false]; };
		case "SIDE":			{ _veh getVariable ["tSF_AirborneSupport_Side", CIVILIAN]; };
		case "LANDING POINT": 	{ _veh getVariable ["tSF_AirborneSupport_LandingPoint", [0,0,0] ]; };
		case "INGRESS POINT": 	{ _veh getVariable ["tSF_AirborneSupport_IngressPoint", [0,0,0] ]; };
		case "EGRESS POINT": 	{ _veh getVariable ["tSF_AirborneSupport_EgressPoint", [0,0,0] ]; };
		case "LANDING PAD": 		{ _veh getVariable ["tSF_AirborneSupport_LandingPad", objNull ]; };
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
	{
		private _logic = _x;
			
		if !(isNil {_logic getVariable "tSF_AirborneSupport"}) then {
			tSF_AirborneSupport_Vehicles pushBack [
				(synchronizedObjects _logic) select 0
				, _logic getVariable "tSF_AirborneSupport"
			];
		};
		
		if !(isNil {_logic getVariable "tSF_AirborneSupport_ReturnPoint"}) then {
			{
				tSF_AirborneSupport_ReturnPoints pushBack (getPosATL _x);			
			} forEach (synchronizedObjects _logic);			
		};	
	} forEach (entities "Logic");
	
	if (count tSF_AirborneSupport_Vehicles > count tSF_AirborneSupport_ReturnPoints) then {
		diag_log "tSF :: Support :: There are not enough Return points for vehicles";
		["tSF :: Support :: There are not enough Return points for vehicles"] call BIS_fnc_error;
	};
	
	tSF_AirborneSupport_ReturnPointsList = [] + tSF_AirborneSupport_ReturnPoints;
};

tSF_fnc_AirborneSupport_processVehicleServer = {
	params ["_veh","_name"];
	
	[_veh, "CALLSIGN", _name] call tSF_fnc_AirborneSupport_SetStatus;
	private _type = (typeOf _veh) call dzn_fnc_getVehicleDisplayName;
	[_veh, "NAME", if (_name == "") then { _type } else { format ["%1 (%2)", _name, _type] }] call tSF_fnc_AirborneSupport_SetStatus;
	
	private _pos = getPosATL _veh;
	private _point = [0,0,0];
	{
		if (_pos distance _x < _pos distance _point) then { _point = _x; };
	} forEach tSF_AirborneSupport_ReturnPoints;	
	tSF_AirborneSupport_ReturnPoints = tSF_AirborneSupport_ReturnPoints - _point;
	
	[_veh, "RTB POINT", _point] call tSF_fnc_AirborneSupport_SetStatus;
	[_veh, "IN PROGRESS", false] call tSF_fnc_AirborneSupport_SetStatus;
	[_veh, "STATE", "Waiting"] call tSF_fnc_AirborneSupport_SetStatus;
	
	_veh allowDamage false;
	_veh setPosATL _point;
	_veh allowDamage true;
	
	[_veh, false] execFSM "dzn_tSFramework\Modules\AirborneSupport\Support.fsm";
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
	
	(group _aiPilot) setBehaviour "CARELESS";
	(group _aiPilot) setCombatMode "BLUE";
	{ _aiPilot disableAI _x; } forEach ["TARGET","AUTOTARGET","SUPPRESSION","AIMINGERROR","COVER","AUTOCOMBAT"];
	_aiPilot setSkill 1;
	
	_veh engineOn true;	
	_aiPilot
};

tSF_fnc_AirborneSupport_SetLandingPad = {
	params ["_veh", "_pos", "_dir"];
	
	private _pad = [_veh, "LANDING PAD"] call tSF_fnc_AirborneSupport_GetStatus;
	if (isNull _pad) then {
		_pad = [[_pos, _dir], "Land_HelipadEmpty_F" ] call dzn_fnc_createVehicle;
		[_veh, "LANDING PAD", _pad] call tSF_fnc_AirborneSupport_SetStatus;
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
	params ["_veh","_mode"];
	
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
		_veh land "GET IN";
		
		waitUntil { (getPosATL _veh select 2) < 10 };
		_veh spawn {
			private _veh = _this;
			private _landingPad = [_veh, "LANDING PAD"] call tSF_fnc_AirborneSupport_GetStatus;
			
			waitUntil { [_veh, "STATE", "WAITING"] call  tSF_fnc_AirborneSupport_AssertStatus };
			
			while {  [_veh, "STATE", "WAITING"] call  tSF_fnc_AirborneSupport_AssertStatus && (getPosATL _veh select 2) > .5 } do {
				_veh setVelocity [0,0,-2];
			};
			
			_veh setVelocity [0,0,0];		
		};
	};	
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
    private "_o";
    _o = _this select 0;
    _o setVelocity (
        _o modelToWorldVisual (_this select 1) vectorDiff (
            _o modelToWorldVisual [0,0,0]
        )
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
		selectRandom tSF_AirborneSupport_ReturnPointsList		
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
