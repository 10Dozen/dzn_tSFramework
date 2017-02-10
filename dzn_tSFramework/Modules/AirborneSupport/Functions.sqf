/*
 * Process vehicles
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
	
	
tSF_fnc_AirborneSupport_processVehicleClient = {
	// [@Vehicle, @Name]
	params ["_veh","_name"];
	
	_veh setVariable ["tSF_AirborneSupport_Callsign", _name];
	
	_name = if (_name == "") then {(typeOf _veh) call dzn_fnc_getVehicleDisplayName} else {format ["%1 (%2)", _name, typeOf _veh]};
	_veh setVariable ["tSF_AirborneSupport_Name", _name];
};

tSF_fnc_AirborneSupport_processVehicleServer = {
	params ["_veh","_name"];
	
	_veh setVariable ["tSF_AirborneSupport_Callsign", _name];
	
	_name = if (_name == "") then {(typeOf _veh) call dzn_fnc_getVehicleDisplayName} else {format ["%1 (%2)", _name, typeOf _veh]};
	_veh setVariable ["tSF_AirborneSupport_Name", _name];
	
	private _pos = getPosATL _veh;
	private _point = [0,0,0];
	{
		if (_pos distance _x < _pos distance _point) then { _point = _x; };
	} forEach tSF_AirborneSupport_ReturnPoints;	
	tSF_AirborneSupport_ReturnPoints = tSF_AirborneSupport_ReturnPoints - _point;
	
	_veh setVariable ["tSF_AirborneSupport_RTBPoint", _point, true];
	_veh setVariable ["tSF_AirborneSupport_InProgress", false, true];
	_veh setVariable ["tSF_AirborneSupport_Status", "Waiting", true];
	
	_veh allowDamage false;
	_veh setPosATL (_veh getVariable "tSF_AirborneSupport_RTBPoint");
	_veh allowDamage true;
};


/*
 *	MENU
 */
 
tSF_fnc_AirborneSupport_ShowMenu = {
	params["_callsign"];
	
	if !(player call tSF_fnc_AirborneSupport_isAuthorizedUser) exitWith {};
	
	private _veh = _callsign call tSF_fnc_AirborneSupport_getByCallsign;
	if !(_veh call tSF_fnc_AirborneSupport_checkVehicleAvailable) exitWith {	
		[_veh, "IS NOT AVAILABLE", ""] call tSF_fnc_AirborneSupport_showHint;
	};
	
	private _inProgress = !((_veh getVariable "tSF_AirborneSupport_Status") in ["Waiting"]) && (_veh getVariable "tSF_AirborneSupport_InProgress");
	private _canRTB = [_veh, "rtb"] call tSF_fnc_AirborneSupport_checkVehicleFree;
	private _canCallin = [_veh, "callin"] call tSF_fnc_AirborneSupport_checkVehicleFree;
	private _canPickup = [_veh, "pickup"] call tSF_fnc_AirborneSupport_checkVehicleFree;

	tSF_AirborneSupport_SupporterMenu = [[format ["%1 (%2)", _callsign, (typeof _veh) call dzn_fnc_getVehicleDisplayName],false]];

	if (_inProgress) then {
		[_veh, "IS ON MISSION", ""] call tSF_fnc_AirborneSupport_showHint;
		tSF_AirborneSupport_SupporterMenu pushBack [
			"Abort Current Mission"
			,[(count tSF_AirborneSupport_SupporterMenu) + 1]
			,""
			,-5
			,[["expression", format ["'%1' call tSF_fnc_AirborneSupport_AbortMission",_callsign]]]
			,"1"
			,"1"
		];
	} else {
		[_veh, "READY FOR MISSION", ""] call tSF_fnc_AirborneSupport_showHint;

		if (tSF_AirborneSupport_ReturnToBase && _canRTB) then {
			tSF_AirborneSupport_SupporterMenu pushBack [
				"Return To Base"
				,[(count tSF_AirborneSupport_SupporterMenu) + 1]
				,""
				,-5
				,[["expression", format ["'%1' call tSF_fnc_AirborneSupport_RTB_Action",_callsign]]]
				,"1"
				,"1"
			];
		};

		if (tSF_AirborneSupport_RequestPickup && _canPickup) then {
			tSF_AirborneSupport_SupporterMenu pushBack [
				"Request Pickup"
				,[(count tSF_AirborneSupport_SupporterMenu) + 1]
				,""
				,-5
				,[["expression", format ["'%1' call tSF_fnc_AirborneSupport_Pickup_Action",_callsign]]]
				,"1"
				,"1"
			];
		};

		if (tSF_AirborneSupport_CallIn && _canCallin) then {
			tSF_AirborneSupport_SupporterMenu pushBack [
				"Call in"
				,[(count tSF_AirborneSupport_SupporterMenu) + 1]
				,""
				,-5
				,[["expression", format ["'%1' call tSF_fnc_AirborneSupport_CallIn_Action",_callsign]]]
				,"1"
				,"1"
			];
		};
	};
	showCommandingMenu "#USER:tSF_AirborneSupport_SupporterMenu";
};


/*
 *	Teleport
 */
 
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




/*
 *	General
 */	
 
tSF_fnc_AirborneSupport_isAuthorizedUser = {
	// Player call tSF_fnc_AirborneSupport_isAuthorizedUser
	private _unit = _this;	
	private _result = false;
	
	private _listOfAuthorizedUsers = [];
	{_listOfAuthorizedUsers pushBack toLower(_x);} forEach tSF_AirborneSupport_AuthorizedUsers;
	
	if (
		"any" in _listOfAuthorizedUsers
		|| toLower(roleDescription _unit) in  _listOfAuthorizedUsers
	) exitWith { true };
	
	if ("admin" in _listOfAuthorizedUsers) exitWith {
		(serverCommandAvailable "#logout") || !(isMultiplayer) || isServer	
	};
	
	_result
};

tSF_fnc_AirborneSupport_getByCallsign = {
	private _result = objNull;
	{
		if (_x select 1 == _this) exitWith { _result = _x select 0; };
	} forEach tSF_AirborneSupport_Vehicles;
	
	_result
};

tSF_fnc_AirborneSupport_showHint = {
	params["_veh","_title","_subtitle"];
	
	private _callsign = _veh getVariable "tSF_AirborneSupport_Callsign";
	private _type = (typeof _veh) call dzn_fnc_getVehicleDisplayName;
	
	hint parseText format [
		"<t color='#EDB81A' size='1.5' align='center' font='PuristaBold'>%1</t>
		<br/><t color='#EDB81A' font='PuristaBold'>%2</t>
		<br/><t font='PuristaBold'>%3</t>
		<br/><br/>%4"
		, _callsign
		, _type
		, _title
		, _subtitle
	];
};

tSF_fnc_AirborneSupport_showMsg = {
	params["_veh","_msg"];
	
	private _callsign = _veh getVariable "tSF_AirborneSupport_Callsign";
	private _type = (typeof _veh) call dzn_fnc_getVehicleDisplayName;
	
	systemChat format ["> %1 (%2): ""%3""", _callsign, _type, _msg];
};

tSF_fnc_AirborneSupport_checkVehicleAvailable = {
	params["_veh",["_type", "all"]];
	
	/*
		"all"		- check both damage and fuel
		"fuel"		- check fuel capacity
	*/
	if !(alive _veh) exitWith { false };
	
	private _result = true;	
	
	if ("all" == toLower(_type)) then {
		_result = (canMove _veh) && ((damage _veh) <= tSF_AirborneSupport_DamageLimit);
	};	
	_result = _result && ((fuel _veh) >= tSF_AirborneSupport_FuelLimit);	
	
	_result
};

tSF_fnc_AirborneSupport_checkVehicleFree = {
	params["_veh", "_type"];
	
	if !((_veh getVariable "tSF_AirborneSupport_Status") in ["Waiting"]) exitWith { false };
	
	private _result = true;
	
	switch toLower(_type) do {
		case "rtb": {
			_result = (_veh distance2d (_veh getVariable "tSF_AirborneSupport_RTBPoint") > 200);
		};
		case "callin": {
			_result = true;
		};
		case "pickup": {
			_result = true;
		};
	};
	
	_result
};

tSF_fnc_AirborneSupport_SetInProgress = {
	_this setVariable ["tSF_AirborneSupport_InProgress", true, true];
};

tSF_fnc_AirborneSupport_StartRequestHandler = {
	tSF_fnc_AirborneSupport_Handler_CanCheck = true;
	tSF_fnc_AirborneSupport_Handler_waitAndCheck = { 
		tSF_fnc_AirborneSupport_Handler_CanCheck = false; 
		sleep tSF_AirborneSupport_Handler_CheckTimeout; 
		tSF_fnc_AirborneSupport_Handler_CanCheck = true;
	};

	["tSF_AirborneSupport_RequestsHandler", "onEachFrame", {
		if !(tSF_fnc_AirborneSupport_Handler_CanCheck) exitWith {};
		[] spawn tSF_fnc_AirborneSupport_Handler_waitAndCheck;
		
		{
			private _veh = _x select 0;			
			if !(_veh getVariable "tSF_AirborneSupport_InProgress") then {				
				switch toLower(_veh getVariable "tSF_AirborneSupport_Status") do {
					case "rtb": {
						private _script = _veh spawn tSF_fnc_AirborneSupport_RTB_Do;
						_veh setVariable ["tSF_AirborneSupport_CurrentScript", _script];
						_veh call tSF_fnc_AirborneSupport_SetInProgress;
					};
					case "pickup": {
						private _script = _veh spawn tSF_fnc_AirborneSupport_Pickup_Do;
						_veh setVariable ["tSF_AirborneSupport_CurrentScript", _script];
						_veh call tSF_fnc_AirborneSupport_SetInProgress;
					};
					case "callin": {
						_veh spawn tSF_fnc_AirborneSupport_CallIn_Do;
						_veh call tSF_fnc_AirborneSupport_SetInProgress;
					};
				};
			};
		} forEach tSF_AirborneSupport_Vehicles;
	}] call BIS_fnc_addStackedEventHandler;
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
		_aiPilot = units ([_veh, _veh getVariable "tSF_AirborneSupport_Side", ["driver"], tSF_AirborneSupport_PilotKit, 0] call dzn_fnc_createVehicleCrew) select 0;
	};
	
	(group _aiPilot) setBehaviour "CARELESS";
	(group _aiPilot) setCombatMode "BLUE";
	{
		_aiPilot disableAI _x;
	} forEach ["TARGET","AUTOTARGET","SUPPRESSION","AIMINGERROR","COVER","AUTOCOMBAT"];
	
	_veh engineOn true;	
	_aiPilot
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
};

tSF_fnc_AirborneSupport_Land = {
	params ["_veh","_mode"];
	
	_veh land _mode;	
	if (toLower(_mode) == "land") then {
		private _landingPoint = _veh getVariable "tSF_AirborneSupport_RTBPoint";
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
	};
	
	waitUntil { sleep 5; (getPosATL _veh) select 2 < 10 };
	_veh call tSF_fnc_AirborneSupport_ResetVehicleVars;	
	_veh allowDamage true;
};

tSF_fnc_AirborneSupport_ResetVehicleVars = {
	params["_veh"];	
	
	_veh setVariable ["tSF_AirborneSupport_InProgress", false, true];
	_veh setVariable ["tSF_AirborneSupport_Status", "Waiting", true];
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

/*
 *	Abort action
 */
tSF_fnc_AirborneSupport_AbortMission = {
	private _veh = _this call tSF_fnc_AirborneSupport_getByCallsign;
	if (_veh getVariable ["tSF_AirborneSupport_Status","Waiting"] == "CallIn") exitWith {
		systemChat format ["Not possible to abort Call In mission of %1", _veh getVariable "tSF_AirborneSupport_Callsign"];
	};
	[
		_veh
		, "Mission Aborted"
		, "Waiting for orders!"
	] call tSF_fnc_AirborneSupport_showHint;

	(_veh) remoteExec ["tSF_fnc_AirborneSupport_AbortMissionRemote", _veh];
};

tSF_fnc_AirborneSupport_AbortMissionRemote = {
	private _veh = _this;
	
	if (scriptDone (_veh getVariable ["tSF_AirborneSupport_CurrentScript", scriptNull]))  exitWith {};
	terminate (_veh getVariable "tSF_AirborneSupport_CurrentScript");
	_veh call tSF_fnc_AirborneSupport_ResetVehicleVars;
};
