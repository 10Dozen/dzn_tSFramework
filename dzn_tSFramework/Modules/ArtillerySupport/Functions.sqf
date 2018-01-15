
/*
 *	Utility
 */

tSF_fnc_ArtillerySupport_processLogics = {
	{
		private _logic = _x;
		
		if !(isNil {_logic getVariable "tSF_ArtillerySupport"}) then {
			// [ @Logic, @Callsign, @VehicleDisplayName, @Vehicles ]
			tSF_ArtillerySupport_Batteries pushBack [
				_logic
				, _logic getVariable "tSF_ArtillerySupport"
				, (typeOf ((synchronizedObjects _logic) select 0)) call dzn_fnc_getVehicleDisplayName
				, synchronizedObjects _logic
			];
			
			private _ammo = getArtilleryAmmo [synchronizedObjects _logic select 0];
			private _firemissionsList = [];
			{
				private _roundType = _x;
				private _type = tSF_ArtillerySupport_FiremissionsProperties select { _roundType in (_x select 2) }; // [ [ @DisplayName, @NumberAvailable, @ListfRounds ] ]
				if !(_type isEqualTo []) then {
					_firemissionsList pushBack [
						(_type select 0) select 0
						, (_type select 0) select 1
						, _roundType
					];
				};
			} forEach _ammo;
			
			_logic setVariable ["tSF_ArtillerySupport_State", "Waiting", true];
			_logic setVariable ["tSF_ArtillerySupport_AvailableFiremissions", _firemissionsList, true];
			
			(tSF_ArtillerySupport_Batteries select (count tSF_ArtillerySupport_Batteries - 1)) spawn tSF_fnc_ArtillerySupport_HandleBatteryReload;
		};	
	} forEach (entities "Logic");
};

tSF_fnc_ArtillerySupport_GetBattery = {
	//@Callsign call tSF_fnc_ArtillerySupport_GetBattery
	
	(tSF_ArtillerySupport_Batteries select { _x select 1 == _this }) select 0
};

tSF_fnc_ArtillerySupport_isAuthorizedUser = {
	true
};


tSF_fnc_ArtillerySupport_IsAvailable = {
	// @Battery call tSF_fnc_ArtillerySupport_IsAvailable
	
	[_this, "State", "Waiting Correction"] call tSF_fnc_ArtillerySupport_AssertStatus
	&& [_this, "Requester", player] call tSF_fnc_ArtillerySupport_AssertStatus
	&& (_this call tSF_fnc_ArtillerySupport_GetBatteryMissionsAvailable) select 4
};

tSF_fnc_ArtillerySupport_AssertStatus = {
	// [@Battery/@Callsign, @State, @AssertValue] call tSF_fnc_ArtillerySupport_CheckStatus
	params["_callsign","_state","_assertValue"];
	
	private _battery = if (typename _callsign == "ARRAY") then { _callsign } else { _callsign call tSF_fnc_ArtillerySupport_GetBattery };
	
	switch (toUpper(_state)) do {
		case "STATE": {
			toUpper((_battery select 0) getVariable ["tSF_ArtillerySupport_State", ""]) == toUpper(_assertValue)		
		};
		case "REQUESTER": {
			((_battery select 0) getVariable ["tSF_ArtillerySupport_Requester", objNull]) == _assertValue		
		};
	}	
};

tSF_fnc_ArtillerySupport_SetStatus = {
	// [@Battery/@Callsign, @State, @AssertValue] call tSF_fnc_ArtillerySupport_CheckStatus
	params["_callsign","_state","_value"];

	private _battery = if (typename _callsign == "ARRAY") then { _callsign } else { _callsign call tSF_fnc_ArtillerySupport_GetBattery };
	
	switch (toUpper(_state)) do {
		case "STATE": {
			(_battery select 0) setVariable ["tSF_ArtillerySupport_State", _value, true];
		};
		case "REQUESTER": {
			(_battery select 0) setVariable ["tSF_ArtillerySupport_Requester", _value, true];	
		};
		case "CREW": {
			(_battery select 0) setVariable ["tSF_ArtillerySupport_Crew", _value, true];	
		};
		case "FIREMISSION": {
			(_battery select 0) setVariable ["tSF_ArtillerySupport_Firemission", _value, true];	
		};
		case "CORRECTIONS": {
			(_battery select 0) setVariable ["tSF_ArtillerySupport_Corrections", _value, true];	
		};
		case "CREW": {
			(_battery select 0) getVariable ["tSF_ArtillerySupport_Crew", _value, true];	
		};
	}
};

tSF_fnc_ArtillerySupport_GetStatus = {
	// [@Battery/@Callsign, @State, @AssertValue] call tSF_fnc_ArtillerySupport_GetkStatus
	params["_callsign","_state"];

	private _battery = if (typename _callsign == "ARRAY") then { _callsign } else { _callsign call tSF_fnc_ArtillerySupport_GetBattery };
	
	switch (toUpper(_state)) do {
		case "STATE": {
			(_battery select 0) getVariable ["tSF_ArtillerySupport_State", "Undefined"];
		};
		case "REQUESTER": {
			(_battery select 0) getVariable ["tSF_ArtillerySupport_Requester", objNull];	
		};
		case "CREW": {
			(_battery select 0) getVariable ["tSF_ArtillerySupport_Crew", grpNull];	
		};
		case "FIREMISSION": {
			(_battery select 0) getVariable ["tSF_ArtillerySupport_Firemission", [[0,0,0],"NoType","NoName",0,0]];	
		};
		case "CORRECTIONS": {
			(_battery select 0) getVariable ["tSF_ArtillerySupport_Corrections", [0,0,0,0]];	
		};
		case "CREW": {
			(_battery select 0) getVariable ["tSF_ArtillerySupport_Crew", grpNull];	
		};
	}
};

tSF_fnc_ArtillerySupport_GetBatteryMissionsAvailable = {
	// [ @Logic, @Callsign, @VehicleDisplayName, @Vehicles ] call tSF_fnc_ArtillerySupport_GetBatteryMissionsAvailable
	private _fm = (_this select 0) getVariable "tSF_ArtillerySupport_AvailableFiremissions";
	private _listOfTypes = [];
	private _listOfRounds = [];
	private _line = "";
	private _totalRounds = [];
	private _available = false;
	
	{
		if ((_x select 1) > 0) then { 
			_listOfTypes pushBack (_x select 0);
			_listOfRounds pushBack (_x select 2);
		
			_available = true; 
		};
		
		if (_forEachIndex > 0) then { _line = _line + " | "; };
		_line = _line + format ["%1: %2", (_x select 0),  (_x select 1)];
		_totalRounds pushBack (_x select 1);
	} forEach _fm;
	
	[
		_listOfTypes
		, _listOfRounds
		, _line
		, _totalRounds
		, _available
	]
};


/*
 *	Firemission
 */

tSF_fnc_ArtillerySupport_RequestFiremission = {
	// _requestOptions [0"_gridCtrl", 1"_trpCtrl", 2"_shapeCtrl", 3"_dirCtrl", 4"_sizeCtrl", 5"_typeCtrl", 6"_timesCtrl", 7"_delayCtrl"];
	params["_battery","_requestOptions"];
	
	private _grid = (_requestOptions select 0) select 0;
	private _trpName = if (count (_requestOptions select 1) > 1) then { (_requestOptions select 1) select 1 } else { " " };
	private _pos = [];
	
	if ( (_grid == "" || count _grid < 8) && _trpName == " " ) then {
		_pos = [0,0,0];
	} else {
		if (_grid != "") then {
			_pos = (_grid splitString " " joinString "") call dzn_fnc_getPosOnMapGrid;
		} else {
			_pos = getMarkerPos ( ((_requestOptions select 1) select 2) select ((_requestOptions select 1) select 0) );
		};
	};
	
	private _shape = ((_requestOptions select 2) select 1);
	private _dir = ((_requestOptions select 3) select 2) select ((_requestOptions select 3) select 0);
	private _size = ((_requestOptions select 4) select 2) select ((_requestOptions select 4) select 0);
	
	private _typeName = (_requestOptions select 5) select 1;
	private _type = ((_requestOptions select 5) select 2) select ((_requestOptions select 5) select 0);
	private _number = parseNumber ((_requestOptions select 6) select 1);
	
	private _delay = ((_requestOptions select 7) select 2) select ((_requestOptions select 7) select 0);
	
	tS_A1 = [
		_grid
		, _trpName
		, _pos
		, _shape, _dir, _size
		, _typeName, _type, _number
		, _delay
	];
	tS_A2 = _battery;
	// ["03909865"," ",[3900,3770,0],"LINE",90,25,"HE","8Rnd_82mm_Mo_shells",3,2]
	// ["","TRP002",[0,0,0],"CIRCLE",0,50,"HE","8Rnd_82mm_Mo_shells",5,0]
	
	[_battery, "Firemission", [_pos, _type, _typeName, _number, _shape, _dir, _size, _delay, _trpName]] call tSF_fnc_ArtillerySupport_SetStatus;	
	[_battery,_pos, _type, _typeName, _number, _shape, _dir, _size, _delay, true] execFSM "dzn_tSFramework\Modules\ArtillerySupport\Firemission.fsm";
	
	
};

tSF_fnc_ArtillerySupport_CancelFiremission = {
	params["_battery"];	
	
	[_battery, false] call tSF_fnc_ArtillerySupport_AddCrew;
	
	[_battery, "Requester", objNull] call tSF_fnc_ArtillerySupport_SetStatus;
	[_battery, "State", "Waiting"] call tSF_fnc_ArtillerySupport_SetStatus;
};

tSF_fnc_ArtillerySupport_AdjustFiremission = {
	params["_battery","_requestOptions"];

	//  [0@N,1@W,2@E,3@S] in meters
	[
		_battery
		, "Corrections"
		, [
			(_requestOptions select 0) select 0
			,(_requestOptions select 1) select 0
			,(_requestOptions select 2) select 0
			,(_requestOptions select 3) select 0
		]
	] call tSF_fnc_ArtillerySupport_SetStatus; 
	[_battery, "State", "Correction Requested"] call tSF_fnc_ArtillerySupport_SetStatus;

};

tSF_fnc_ArtillerySupport_FireForEffect = {
	params["_battery"];
	[_battery, "State", "Fire For Effect Requested"] call tSF_fnc_ArtillerySupport_SetStatus;
};

tSF_fnc_ArtillerySupport_AbortFiremission = {
	[_this, "State", "Waiting"] call tSF_fnc_ArtillerySupport_SetStatus;
};

tSF_fnc_ArtillerySupport_getRoundsPerGun = {
	params["_r", "_guns"];
	
	private _result = [];
	private _left = _r - floor(_r/_guns) * _guns;
	for "_i" from 1 to _guns do { _result pushBack floor(_r/_guns); };
	
	while { _left > 0 } do {
		for "_i" from 0 to (_guns-1) do {
			if (_left == 0) exitWith {};
			
			_result set [_i, (_result select _i) + 1];
			_left = _left - 1;
		};
	};
	
	_result
};

tSF_fnc_ArtillerySupport_UpdateBatteryMissionsAvailable = {
	params["_battery", "_roundType", "_add"];
	
	// [["HE",6,"8Rnd_82mm_Mo_shells"],["SMK",9,"8Rnd_82mm_Mo_Smoke_white"]] --> ["HE",6,"8Rnd_82mm_Mo_shells"]
	private _fm = ((_battery select 0) getVariable "tSF_ArtillerySupport_AvailableFiremissions") select { _x select 0 == _roundType } select 0;
	private _qnty = if ((_fm select 1) + _add < 0) then { 0 } else { (_fm select 1) + _add };
	
	_fm set [1, _qnty];
	
	(_battery select 0) setVariable [
		"tSF_ArtillerySupport_AvailableFiremissions"
		, (_battery select 0) getVariable "tSF_ArtillerySupport_AvailableFiremissions"
		, true
	];
};

tSF_fnc_ArtillerySupport_GetTargerts = {
	params ["_basepoint", "_shape", "_dist", "_dir", "_times"];
	
	private _tgts = [];
	private _step = _dist / _times;
	
	if (toUpper(_shape) == toUpper("CIRCLE")) then {
		for "_i" from 0 to (_times - 1) do {
			_tgts pushBack (_basepoint getPos [_step * _i * random [0.8, 1, 1.2], random (360)]);		
		};		
	} else {
		for "_i" from 0 to (_times - 1) do {
			private _pos = _basepoint getPos [_step * _i, _dir];
			_tgts pushBack (_pos getPos [random (_step max 20), random 360]);		
		};
	};
	
	_tgts
};

tSF_fnc_ArtillerySupport_getTgtPerGun = {
	params["_tgts", "_guns"];
	
	private _tgtsNum = count _tgts;
	private _times = floor (_tgtsNum/_guns);
	private _left = _tgtsNum - floor(_tgtsNum/_guns)*_guns;
	private _result = [];
	
	for "_i" from 1 to _guns do {
		private _gunTgts = [];
		for "_j" from 1 to _times do { _gunTgts pushBack (_tgts select ((_i-1)*_times + _j - 1)); };
		_result pushBack _gunTgts;
	};
	
	while { _left > 0 } do {
		for "_i" from 0 to (_guns - 1) do {
			if (_left == 0) exitWith {};
			_result set [_i, (_result select _i) + [ _tgts select ( _tgtsNum - _left ) ] ];
			_left = _left - 1;
		};
	};
	
	_result
};

tSF_Log = [];

tSF_fnc_ArtillerySupport_Fire = {
	params ["_u", "_type", "_rounds", "_tgts", "_delay", "_timeout", "_battery"];
	
	systemChat format ["[FIRE %2] Timeout %1 sec", _timeout, _u];
	for "_i" from 0 to _timeout do {
		sleep 1;
		if ([_battery, "State", "Waiting"] call tSF_fnc_ArtillerySupport_AssertStatus) exitWith { _i = 999; };
	};
	
	systemChat format ["[FIRE %2] Timeout ended after %1 sec", _timeout, _u];
	for "_i" from 1 to _rounds do {
		if ([_battery, "State", "Waiting"] call tSF_fnc_ArtillerySupport_AssertStatus) exitWith { _i = 999; };
		systemChat format ["[FIRE %1] Shot %2 to position %3", _u, _i, _tgts select (_i - 1)];
		
		_u commandArtilleryFire [_tgts select (_i - 1), _type, 1];
		_u setVehicleAmmo 1;
		
		if (_delay > 40) then { [_battery, "Shot fired", "Fire for Effect"] call tSF_fnc_ArtillerySupport_showHint; };
		
		sleep (_delay max 6);
	};
};



tSF_fnc_showTgts ={
	if (!isNil "tgts") then {
		{ deleteVehicle _x } forEach tgts;
	};
	
	tgts = [];
	
	{
		tgts pushBack ("Sign_Sphere100cm_F" createVehicle _x);
	} forEach _this;
};


tSF_fnc_ArtillerySupport_showHint = {
	params["_battery","_title","_subtitle"];
	
	private _callsign = _battery select 1;
	private _type = _battery select 2;
	
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

tSF_fnc_ArtillerySupport_AddCrew = {
	// [@Battery, @Add] call tSF_fnc_ArtillerySupport_AddCrew
	params["_battery", "_add"];
	
	private _crewGrp = [_battery, "CREW"] call tSF_fnc_ArtillerySupport_GetStatus;
	
	if (_add) then {
		if (isNull _crewGrp) then {
			// ADD NEW CREW 
			_crewGrp = createGroup (side player);
			{
				private _unit = _crewGrp createUnit [typeOf player, [0,0,0], [], 0, "NONE"];
				_unit moveInGunner _x;	
			} forEach (_battery select 3);
			
			[_battery, "CREW", _crewGrp] call tSF_fnc_ArtillerySupport_SetStatus;
		} else {
			// GET CREW FROM CACHE
			[_crewGrp, true] remoteExec ["tSF_fnc_ArtillerySupport_ToggleCrewSimulation", 0];
			{ ((units _crewGrp) select _forEachIndex) moveInGunner _x; } forEach (_battery select 3);
		};
	} else {
		// DISMOUNT AND CACHE CREW
		[_crewGrp, false] remoteExec ["tSF_fnc_ArtillerySupport_ToggleCrewSimulation", 0];
	};
	
	_crewGrp
};

tSF_fnc_ArtillerySupport_ToggleCrewSimulation = {
	params ["_grp", "_enable"];
	{	
		if !(_enable) then {
			moveOut _x;
			unassignVehicle _x;
			sleep 0.5;
		};
		
		_x hideObjectGlobal !(_enable);
		_x enableSimulation (_enable);
	} forEach (units _grp);
};

tSF_fnc_ArtillerySupport_HandleBatteryReload = {
	private _battery = _this;
	while { true } do {
		waitUntil { 
			sleep 10; 
			{ _x < 1 } count ((_battery call tSF_fnc_ArtillerySupport_GetBatteryMissionsAvailable) select 3) > 0
		};
		
		sleep tSF_ArtillerySupport_BatteryReloadTime;
		{
			private _fmRound = _x; // ["HE",0,"8Rnd_82mm_Mo_shells"]
			private _fmAmmo = _fmRound select 1;
			private _max = (tSF_ArtillerySupport_FiremissionsProperties select { _x select 0 == _fmRound select 0 }) select 0 select 1;
			
			[_battery, _fmRound select 0, _max - _fmAmmo] call tSF_fnc_ArtillerySupport_UpdateBatteryMissionsAvailable;
		} forEach ((_battery select 0) getVariable "tSF_ArtillerySupport_AvailableFiremissions");
	};
};