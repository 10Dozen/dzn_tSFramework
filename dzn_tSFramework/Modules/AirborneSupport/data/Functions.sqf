#include "script_component.hpp"
/*
 *	General
 */

FUNC(isAuthorizedUser) = {
	// Player call tSF_fnc_AirborneSupport_isAuthorizedUser

	[_this, "AIRBORNE"] call EFUNC(Authorization,checkPlayerAuthorized);
};

FUNC(getProvider) = {
	//@Callsign call tSF_AirborneSupport_fnc_GetProvider
	(GVAR(Vehicles) select { _x select 1 == _this }) select 0
};

FUNC(assertStatus) = {
	// [@Battery/@Callsign, @State, @AssertValue] call tSF_fnc_ArtillerySupport_CheckStatus
	params["_callsign","_state","_assertValue"];

	private _veh = if (typename _callsign == "OBJECT") then [{ _callsign }, { (_callsign call FUNC(GetProvider)) # 0 }];

	switch (toUpper(_state)) do {
		case "STATE":       { toUpper(_veh getVariable [QGVAR(State), "Undefined"]) == toUpper(_assertValue) };
		case "REQUESTER":   { (_veh getVariable [QGVAR(Requester), objNull]) == _assertValue };
		case "CREW":        { (_veh getVariable [QGVAR(Crew), grpNull]) == _assertValue };
		case "RTB POINT":   { (_veh getVariable [QGVAR(RTBPoint), [0,0,0]]) isEqualTo _assertValue };
		case "CALLSIGN":    { toUpper(_veh getVariable [QGVAR(Callsign), "Undefined"]) == toUpper(_assertValue) };
		case "NAME":        { toUpper(_veh getVariable [QGVAR(Name), "Undefined"]) == toUpper(_assertValue) };
		case "LAND MODE":   { toUpper(_veh getVariable [QGVAR(LandMode), "LAND"]) == toUpper(_assertValue) };
	}
};

FUNC(setStatus) = {
	// [@Veh/@Callsign, @State, @NewValue] call FUNC(SetStatus)
	// [@Veh/@Callsign, [ [@State1, @Value1], [@State2, @Value2] ... ]]

	private _veh = if (typename (_this select 0) == "OBJECT") then {
		(_this select 0)
	} else {
		((_this select 0) call FUNC(GetProvider)) select 0
	};

	if (typename (_this select 1) == "ARRAY") exitWith {
		{ [_veh, _x select 0, _x select 1] call FUNC(SetStatus); } forEach (_this select 1);
	};

	params["_callsign","_state","_value"];

	switch (toUpper(_state)) do {
		case "CALLSIGN":       { _veh setVariable [QGVAR(Callsign), _value, true]; };
		case "NAME":           { _veh setVariable [QGVAR(Name), _value, true]; };
		case "STATE":          { _veh setVariable [QGVAR(State), _value, true]; };
		case "REQUESTER":      { _veh setVariable [QGVAR(Requester), _value, true]; };
		case "CREW":           { _veh setVariable [QGVAR(Crew), _value, true]; };
		case "RTB POINT":      { _veh setVariable [QGVAR(RTBPoint), _value, true]; };
		case "IN PROGRESS":    { _veh setVariable [QGVAR(InProgress), _value, true]; };
		case "SIDE":           { _veh setVariable [QGVAR(Side), _value, true]; };
		case "LANDING POINT":  { _veh setVariable [QGVAR(LandingPoint), _value, true]; };
		case "INGRESS POINT":  { _veh setVariable [QGVAR(IngressPoint), _value, true]; };
		case "EGRESS POINT":   { _veh setVariable [QGVAR(EgressPoint), _value, true]; };
		case "LANDING PAD":    { _veh setVariable [QGVAR(LandingPad), _value, true ]; };
		case "LAND MODE":      { _veh setVariable [QGVAR(LandMode), _value, true ]; };
	}
};

FUNC(getStatus) = {
	// [@Battery/@Callsign, @State] call tSF_fnc_AirborneSupport_GetStatus
	params["_callsign","_state"];

	private _veh = if (typename _callsign == "OBJECT") then [{ _callsign }, { (_callsign call FUNC(GetProvider)) # 0 }];

	switch (toUpper(_state)) do {
		case "CALLSIGN":          { _veh getVariable [QGVAR(Callsign), "Undefined"]; };
		case "NAME":              { _veh getVariable [QGVAR(Name), "Undefined"]; };
		case "STATE":             { _veh getVariable [QGVAR(State), "Undefined"]; };
		case "REQUESTER":         { _veh getVariable [QGVAR(Requester), objNull]; };
		case "CREW":              { _veh getVariable [QGVAR(Crew), grpNull]; };
		case "RTB POINT":         { _veh getVariable [QGVAR(RTBPoint), [0,0,0]]; };
		case "IN PROGRESS":       { _veh getVariable [QGVAR(InProgress), false]; };
		case "SIDE":              { _veh getVariable [QGVAR(Side), CIVILIAN]; };
		case "LANDING POINT":     { _veh getVariable [QGVAR(LandingPoint), [0,0,0]]; };
		case "INGRESS POINT":     { _veh getVariable [QGVAR(IngressPoint), [0,0,0]]; };
		case "EGRESS POINT":      { _veh getVariable [QGVAR(EgressPoint), [0,0,0]]; };
		case "LANDING PAD":       { _veh getVariable [QGVAR(LandingPad), objNull]; };
		case "LAND MODE":         { _veh getVariable [QGVAR(LandMode), "LAND"]; };
	}
};

FUNC(diag) = {
	private _txt = [];
	{
		_txt pushBack (format ["%1: %2", _x # 0, _this getVariable (_x # 1)]);
	} forEach [
		["Callsign", QGVAR(Callsign)]
		, ["Name", QGVAR(Name)]
		, ["State", QGVAR(State)]
		, ["Requster", QGVAR(Requester)]
		, ["Crew", QGVAR(Crew)]
		, ["RTB Point", QGVAR(RTBPoint)]
		, ["InProgress", QGVAR(InProgress)]
		, ["Side", QGVAR(Side)]
		, ["Landing", QGVAR(LandingPoint)]
		, ["Ingress", QGVAR(IngressPoint)]
		, ["Egress", QGVAR(EgressPoint)]
	];
	hint (_txt joinString "\n");

	_txt joinString " | "
};

/*
 *	Initialization
 */

FUNC(processLogics) = {
	private _vehicles = [];
	private _returnPoints = [];
	{
		private _logic = _x;
		if (!isNil {_logic getVariable QGVAR(ReturnPoint)}) then {
			{ _returnPoints pushBack (getPosATL _x); } forEach (synchronizedObjects _logic);
		};
		if (!isNil {_logic getVariable QGVAR(Callsign)} || !isNil {_logic getVariable QUOTE(MODULE_COMPONENT)}) then {
			private _veh = (synchronizedObjects _logic) # 0;
			private _callsign = _logic getVariable [QGVAR(Callsign), _logic getVariable [QUOTE(MODULE_COMPONENT),""]];
			_vehicles pushBack [_veh, _callsign];

			if (!isNil {_logic getVariable QGVAR(Condition)}) then {
				_veh setVariable [QGVAR(Condition), compile (_logic getVariable QGVAR(Condition))];
			};
		};
		
	} forEach (entities "Logic");

	GVAR(ReturnPoints) = _returnPoints;
	GVAR(Vehicles) = _vehicles;

	if (count _vehicles > count _returnPoints) then {
		LOG("[ERROR] There is not enough Return points for vehicles");
		["tSF :: Support :: There is not enough Return points for vehicles"] call BIS_fnc_error;
	};

	[_vehicles, +_returnPoints] call FUNC(processVehicleServer);
};

FUNC(processVehicleServer) = {
	params ["_vehicles","_points"];
	{
		_x params ["_veh","_callsign"];

		private _type = (typeOf _veh) call dzn_fnc_getVehicleDisplayName;
		private _name = if (_callsign == "") then [{ _type }, { format ["%1 (%2)", _callsign, _type] }];
		private _pos = getPosATL _veh;

		private _point = [0,0,0];
		private _max = -log 0;
		private _idx = -1;
		{
			if (_pos distanceSqr _x < _max) then {
				_max = _pos distanceSqr _x;
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
		]] call FUNC(SetStatus);

		[_veh, false] execFSM QUOTE(COMPONENT_DATA_PATH(Support.fsm));
	} forEach _vehicles;
};

/*
 *	Control functions
 */

FUNC(resetVehicleVars) = {
	params["_veh"];

	[_veh, [
		["IN PROGRESS", false]
		, ["STATE", "Waiting"]
		, ["SIDE", CIVILIAN]
		, ["LANDING POINT", [0,0,0]]
		, ["INGRESS POINT", [0,0,0]]
		, ["EGRESS POINT", [0,0,0]]
	]] call FUNC(SetStatus);
};

FUNC(addPilot) = {
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
			_veh, [_veh, "SIDE"] call FUNC(GetStatus), ["driver"], GVAR(PilotKit), 0
		] call dzn_fnc_createVehicleCrew) # 0;
	};

	// (group _aiPilot) setBehaviour "CARELESS";
	(group _aiPilot) setCombatMode "BLUE";
	{ _aiPilot disableAI _x; } forEach ["TARGET","AUTOTARGET","SUPPRESSION","AIMINGERROR","COVER","AUTOCOMBAT"];
	_aiPilot setSkill 1;
	_aiPilot setSkill ["courage", 1];
	
	(group _aiPilot) setGroupId [[_veh, "CALLSIGN"] call FUNC(getStatus)];

	_veh engineOn true;
	_aiPilot
};

FUNC(removePilot) = {
	params ["_veh"];
	
	private _pilot = driver _veh;
	if (!isPlayer _pilot) then {
		moveOut _pilot;
		private _grp = group _pilot;
		deleteVehicle _pilot;
		deleteGroup _grp;
	};
};

FUNC(setLandingPad) = {
	params ["_veh", "_pos", "_dir"];

	private _pad = [_veh, "LANDING PAD"] call FUNC(GetStatus);
	if (isNull _pad) then {
		_pad = [[_pos, _dir], "Land_HelipadEmpty_F" ] call dzn_fnc_createVehicle;
		[_veh, "LANDING PAD", _pad] call FUNC(SetStatus);
	} else {
		_pad setPos _pos;
		_pad setDir _dir;
	};

	_pad setPos _pos;

	_pad
};

FUNC(moveToPosition) = {
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

FUNC(land) = {
	params ["_veh","_mode","_helipad", "_approachDirection"];

	switch (toUpper _mode) do {
		case "LAND": {
			_veh land _mode;
			private _landingPoint = [_veh, "RTB POINT"] call FUNC(GetStatus);

			[{ (_this # 0) distance (_this # 1) < 10 },{
				params ["_veh", "_point"];

				_veh allowDamage false;
				private _pilot = driver _veh;
				private _grp = group _pilot;
				moveOut _pilot;
				deleteVehicle _pilot;
				deleteGroup _grp;

				_veh engineOn false;
				_veh setVelocity [0,0,0];
				_veh setPos _landingPoint;

				[{ (getPosATL _this # 2) < 10}, {
					_this allowDamage true;
				}, _veh, 5] call CBA_fnc_waitUntilAndExecute;
			}, [_veh, _landingPoint], 5] call CBA_fnc_waitUntilAndExecute;
		};
		case "GET IN": {
			[_veh, _helipad, _approachDirection] call FUNC(PreciseLanding);
		};
		case "HOVER": {
			systemChat "HOVERING";
			[_veh, _helipad] call FUNC(preciseHovering);
		};
	}
};

FUNC(preciseLanding) = {
	params ["_veh","_pad", "_approachDirection",["_time",7]];
	if (!local _veh) exitWith {
		_this remoteExec [QFUNC(preciseLanding), _veh];
	};

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
			if (_interval > 0.99) exitWith { [_handle] call CBA_fnc_removePerFrameHandler; };

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

FUNC(preciseHovering) = {
	params ["_veh","_pad", ["_time",7]];
	if (!local _veh) exitWith {
		_this remoteExec [QFUNC(preciseHovering), _veh];
	};

	private _fromPos = getPosASL _veh;
	private _toPos = getPosASL _pad;
	_toPos set [2, (_toPos # 2) + 20];

	private _timeFrom = time;
	private _timeTo = _timeFrom + (_time min (_fromPos distance2d _toPos)/2);

	[
		{
			params ["_args","_handle"];
			_args params ["_veh","_fromPos","_toPos","_timeFrom","_timeTo"];

			private _interval = linearConversion [_timeFrom, _timeTo, time, 0, 1, true];
			private _dir = _veh getDir _toPos;
			private _vectorDir = [sin _dir, cos _dir, 0];

			if (_interval < 1) then {
				_veh setVelocityTransformation [
					_fromPos, _toPos,
					[0,0,0], [0,0,0],
					vectorDirVisual _veh, _vectorDir,
					vectorUpVisual _veh, [0,0,1],
					_interval
				];
			} else {
				if (getPosATL _veh # 2 > 25) then {
					_veh setVelocity [0,0,-0.5];
				} else {
					_veh setVelocity [0,0,0];
				};
			};

			if (!([_veh, "STATE", "Waiting"] call FUNC(assertStatus))) exitWith {
				[_handle] call CBA_fnc_removePerFrameHandler; 
			};
		},
		0,
		[_veh, _fromPos, _toPos, _timeFrom, _timeTo]
	] call CBA_fnc_addPerFrameHandler;
};

FUNC(assignToCallInHelicopter) = {
	// params ["_unit","_veh"];
	
	[{ (_this # 1) getVariable [QGVAR(CallInReady),false] },{
		params ["","_veh"];
		private _driver = driver _veh;
		
		if (!isNull _driver && { isPlayer _driver }) exitWith { /* some message */ };
		_veh call FUNC(removePilot);

		0 cutText ["", "WHITE OUT", 0.1];
		player allowDamage false;
		[{
			params ["_unit","_veh"];
			_veh setVariable [QGVAR(CallInReady), false, true];

			moveOut player;
			_unit setVelocity [0,0,0];
			_unit moveInDriver _veh;
			_veh engineOn true;

			0 cutText ["", "WHITE IN", 1];
			[{ _this allowDamage true; }, _unit, 3] call CBA_fnc_waitAndExecute;
		},_this,1] call CBA_fnc_waitAndExecute;
	},_this] call CBA_fnc_waitUntilAndExecute;
};

KK_fnc_setVelocityModelSpaceVisual = {
	private _o = _this select 0;
	_o setVelocity (
		_o modelToWorldVisual (_this select 1) vectorDiff (_o modelToWorldVisual [0,0,0])
	);
};
