/*
 * Process vehicles
 */
tSF_fnc_Support_processLogics = {
	{
		private _logic = _x;
			
		if !(isNil {_logic getVariable "tSF_Support"}) then {
			tSF_Support_Vehicles pushBack [
				(synchronizedObjects _logic) select 0
				, _logic getVariable "tSF_Support"
			];
		};
		
		if !(isNil {_logic getVariable "tSF_Support_ReturnPoint"}) then {
			{
				tSF_Support_ReturnPoints pushBack (getPosATL _x);			
			} forEach (synchronizedObjects _logic);			
		};	
	} forEach (entities "Logic");
	
	if (count tSF_Support_Vehicles > count tSF_Support_ReturnPoints) then {
		diag_log "tSF :: Support :: There are not enough Return points for vehicles";
		["tSF :: Support :: There are not enough Return points for vehicles"] call BIS_fnc_error;
	};
	
	tSF_Support_ReturnPointsList = [] + tSF_Support_ReturnPoints;
};
	
	
tSF_fnc_Support_processVehicleClient = {
	// [@Vehicle, @Name]
	params ["_veh","_name"];
	
	_veh setVariable ["tSF_Support_Callsign", _name];
	
	_name = if (_name == "") then {(typeOf _veh) call tSF_fnc_Support_getVehicleDisplayName} else {format ["%1 (%2)", _name, typeOf _veh]};
	_veh setVariable ["tSF_Support_Name", _name];
	
	if (tSF_Support_ReturnToBase && player call tSF_fnc_Support_isAuthorizedUser) then {
	
	};
};

tSF_fnc_Support_processVehicleServer = {
	params ["_veh","_name"];
	
	_veh setVariable ["tSF_Support_Callsign", _name];
	
	_name = if (_name == "") then {(typeOf _veh) call tSF_fnc_Support_getVehicleDisplayName} else {format ["%1 (%2)", _name, typeOf _veh]};
	_veh setVariable ["tSF_Support_Name", _name];
	
	private _pos = getPosATL _veh;
	private _point = [0,0,0];
	{
		if (_pos distance _x < _pos distance _point) then { _point = _x; };
	} forEach tSF_Support_ReturnPoints;	
	tSF_Support_ReturnPoints = tSF_Support_ReturnPoints - _point;
	
	_veh setVariable ["tSF_Support_RTBPoint", _point, true];
	_veh setVariable ["tSF_Support_InProgress", false, true];
	_veh setVariable ["tSF_Support_Status", "Waiting", true];
	
	_veh allowDamage false;
	_veh setPosATL (_veh getVariable "tSF_Support_RTBPoint");
	_veh allowDamage true;
};


/*
 *	MENU
 */
 
tSF_fnc_Support_ShowMenu = {
	params["_callsign"];
	
	private _veh = _callsign call tSF_fnc_Support_getByCallsign;
	if !(_veh call tSF_fnc_Support_checkVehicleAvailable) exitWith {	
		[_veh, "IS NOT AVAILABLE", ""] call tSF_fnc_Support_showHint;
	};	
	
	tSF_Support_SupporterMenu = [[format ["%1 (%2)", _callsign, (typeof _veh) call tSF_fnc_Support_getVehicleDisplayName],false]];	
	if (
		[_veh, "rtb"] call tSF_fnc_Support_checkVehicleFree
	) then {
		tSF_Support_SupporterMenu pushBack [
			"Return To Base"
			,[(count tSF_Support_SupporterMenu) + 1]
			,""
			,-5
			,[["expression", format ["'%1' call tSF_fnc_Support_RTB_Action",_callsign]]]
			,"1"
			,"1"
		];	
	};
	
	if (
		!(isNil "tSF_Support_RequestPickup") 
		&& {
			[_veh, "pickup"] call tSF_fnc_Support_checkVehicleFree
		}
	) then {
		tSF_Support_SupporterMenu pushBack [
			"Request Pickup"
			,[(count tSF_Support_SupporterMenu) + 1]
			,""
			,-5
			,[["expression", format ["'%1' call tSF_fnc_Support_Pickup_Action",_callsign]]]
			,"1"
			,"1"
		];	
	};
	
	if (
		!(isNil "tSF_fnc_Support_CallIn_Available") 
		&& {
			[_veh, "callin"] call tSF_fnc_Support_checkVehicleFree
		}
	) then {
		tSF_Support_SupporterMenu pushBack [
			"Call in"
			,[(count tSF_Support_SupporterMenu) + 1]
			,""
			,-5
			,[["expression", format ["'%1' call tSF_fnc_Support_CallIn_Action",_callsign]]]
			,"1"
			,"1"
		];	
	};
	
	showCommandingMenu "#USER:tSF_Support_SupporterMenu";
};


/*
 *	Teleport
 */
 
tSF_fnc_Support_showTeleportMenu = {
	tSF_Support_TeleportMenu = [
		["Re-deploy",false]		
		, ["Deploy to Squad",[2],"",-5,[["expression", "[player,'squad'] spawn tSF_fnc_Support_doTeleport"]],"1","1"]
		, ["Deploy to Base",[3],"",-5,[["expression", "[player,'base'] spawn tSF_fnc_Support_doTeleport"]],"1","1"]
	];
	showCommandingMenu "#USER:tSF_Support_TeleportMenu";
};

tSF_fnc_Support_doTeleport = {
	params["_unit","_dest"];
	
	private _pos = if ("base" == toLower(_dest)) then {
		selectRandom tSF_Support_ReturnPointsList		
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
 
tSF_fnc_Support_isAuthorizedUser = {
	// Player call tSF_fnc_Support_isAuthorizedUser
	private _unit = _this;	
	private _result = false;
	
	private _listOfAuthorizedUsers = [];
	{_listOfAuthorizedUsers pushBack toLower(_x);} forEach tSF_Support_AuthorizedUsers;
	
	if (
		"any" in _listOfAuthorizedUsers
		|| toLower(roleDescription _unit) in  _listOfAuthorizedUsers
	) exitWith { true };
	
	if ("admin" in _listOfAuthorizedUsers) exitWith {
		(serverCommandAvailable "#logout") || !(isMultiplayer) || isServer	
	};
	
	_result
};
 
tSF_fnc_Support_getVehicleDisplayName = {
	private _item = (( "configName(_x) == _this") configClasses (configFile >> "CfgVehicles")) select 0;
	
	( getText(configFile >> "CfgVehicles" >> configName(_item) >> "displayName") )
};

tSF_fnc_Support_getByCallsign = {
	private _result = objNull;
	{
		if (_x select 1 == _this) exitWith { _result = _x select 0; };
	} forEach tSF_Support_Vehicles;
	
	_result
};

tSF_fnc_Support_showHint = {
	params["_veh","_title","_subtitle"];
	
	private _callsign = _veh getVariable "tSF_Support_Callsign";
	private _type = (typeof _veh) call tSF_fnc_Support_getVehicleDisplayName;
	
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

tSF_fnc_Support_showMsg = {
	params["_veh","_msg"];
	
	private _callsign = _veh getVariable "tSF_Support_Callsign";
	private _type = (typeof _veh) call tSF_fnc_Support_getVehicleDisplayName;
	
	systemChat format ["> %1 (%2): ""%3""", _callsign, _type, _msg];
};

tSF_fnc_Support_checkVehicleAvailable = {
	params["_veh",["_type", "all"]];
	
	/*
		"all"		- check both damage and fuel
		"fuel"		- check fuel capacity
	*/
	if !(alive _veh) exitWith { false };
	
	private _result = true;	
	
	if ("all" == toLower(_type)) then {
		_result = (canMove _veh) && ((damage _veh) <= tSF_Support_DamageLimit);
	};	
	_result = _result && ((fuel _veh) >= tSF_Support_FuelLimit);	
	
	_result
};

tSF_fnc_Support_checkVehicleFree = {
	params["_veh", "_type"];
	
	if !((_veh getVariable "tSF_Support_Status") in ["Waiting"]) exitWith { false };
	
	private _result = true;
	
	switch toLower(_type) do {
		case "rtb": {
			_result = (_veh distance2d (_veh getVariable "tSF_Support_RTBPoint") > 200);
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

tSF_fnc_Support_SetInProgress = {
	_this setVariable ["tSF_Support_InProgress", true, true];
};

tSF_fnc_Support_StartRequestHandler = {
	tSF_fnc_Support_Handler_CanCheck = true;
	tSF_fnc_Support_Handler_waitAndCheck = { 
		tSF_fnc_Support_Handler_CanCheck = false; 
		sleep tSF_Support_Handler_CheckTimeout; 
		tSF_fnc_Support_Handler_CanCheck = true;
	};

	["tSF_Support_RequestsHandler", "onEachFrame", {
		if !(tSF_fnc_Support_Handler_CanCheck) exitWith {};
		[] spawn tSF_fnc_Support_Handler_waitAndCheck;
		
		{
			private _veh = _x select 0;			
			if !(_veh getVariable "tSF_Support_InProgress") then {				
				switch toLower(_veh getVariable "tSF_Support_Status") do {
					case "rtb": {
						_veh spawn tSF_fnc_Support_RTB_Do;
						_veh call tSF_fnc_Support_SetInProgress;
					};
					case "pickup": {
						_veh spawn tSF_fnc_Support_Pickup_Do;
						_veh call tSF_fnc_Support_SetInProgress;
					};
					case "callin": {
						_veh spawn tSF_fnc_Support_CallIn_Do;
						_veh call tSF_fnc_Support_SetInProgress;
					};
				};
				
			};
		} forEach tSF_Support_Vehicles;
	}] call BIS_fnc_addStackedEventHandler;
};

tSF_fnc_Support_AddPilot = {
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
		_aiPilot = units ([_veh, _veh getVariable "tSF_Support_Side", ["driver"], tSF_Support_PilotKit, 0] call dzn_fnc_createVehicleCrew) select 0;
	};
	
	{
		_aiPilot disableAI _x;
	} forEach ["TARGET","AUTOTARGET","SUPPRESSION","AIMINGERROR","COVER","AUTOCOMBAT"];
	
	_veh engineOn true;	
	_aiPilot
};

tSF_fnc_Support_MoveToPosition = {
	params["_pilot","_pos",["_radius",200]];
	
	private _grp = group _pilot;
	
	while {(count (waypoints _grp)) > 0} do {
		deleteWaypoint ((waypoints _grp) select 0);
	};
	
	private _wp = _grp addWaypoint [_pos, 0];
	_wp setWaypointType "MOVE";
	_wp setWaypointCompletionRadius _radius;
};

tSF_fnc_Support_Land = {
	params ["_veh","_mode"];
	
	_veh land _mode;
	
	waitUntil { sleep 5; (getPosATL _veh) select 2 < 10 };
	if (toLower(_mode) == "land") then {
		_veh allowDamage false;
		
		private _pilot = driver _veh;
		private _grp = group _pilot;
		moveOut _pilot;
		deleteVehicle _pilot;
		deleteGroup _grp;
		
		_veh engineOn false;
		_veh setVelocity [0,0,0];
		_veh setPos (_veh getVariable "tSF_Support_RTBPoint");		
	};
	
	_veh call tSF_fnc_Support_ResetVehicleVars;	
	_veh allowDamage true;
};

tSF_fnc_Support_ResetVehicleVars = {
	params["_veh"];	
	
	_veh setVariable ["tSF_Support_InProgress", false, true];
	_veh setVariable ["tSF_Support_Status", "Waiting", true];
};
 