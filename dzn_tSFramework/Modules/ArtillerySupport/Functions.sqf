
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
			_logic setVariable ["tSF_ArtillerySupport_AvailableFiremissions", _firemissionsList];
		};	
	} forEach (entities "Logic");
};

tSF_fnc_ArtillerySupport_StartRequestHandler = {
	while { true } do {
		sleep tSF_ArtillerySupport_requestHandlerTimeout;
		
		{
			if ([_x, "State", "Requested"] call tSF_fnc_ArtillerySupport_CheckStatus) then {
				_x spawn tSF_fnc_ArtillerySupport_SearchFire;
			};
		
		} forEach tSF_ArtillerySupport_Batteries;
	
	};


};


tSF_fnc_ArtillerySupport_GetBattery = {
	//@Callsign call tSF_fnc_ArtillerySupport_GetBattery
	
	(tSF_ArtillerySupport_Batteries select { _x select 1 == _this }) select 0
};

tSF_fnc_ArtillerySupport_isAuthorizedUser = {
	true
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
			(_battery select 0) setVariable ["tSF_ArtillerySupport_State", _value];
		};
		case "REQUESTER": {
			(_battery select 0) setVariable ["tSF_ArtillerySupport_Requester", _value];	
		};
		case "CREW": {
			(_battery select 0) setVariable ["tSF_ArtillerySupport_Crew", _value];	
		};
		case "FIREMISSION": {
			(_battery select 0) setVariable ["tSF_ArtillerySupport_Firemission", _value];	
		};
		case "CORRECTIONS": {
			(_battery select 0) setVariable ["tSF_ArtillerySupport_Corrections", _value];	
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
	}
};

tSF_fnc_ArtillerySupport_GetBatteryMissionsAvailable = {
	// [ @Logic, @Callsign, @VehicleDisplayName, @Vehicles ] call tSF_fnc_ArtillerySupport_GetBatteryMissionsAvailable
	private _fm = (_this select 0) getVariable "tSF_ArtillerySupport_AvailableFiremissions";
	private _listOfTypes = [];
	private _listOfRounds = [];
	private _line = "";
	
	{
		_listOfTypes pushBack (_x select 0);
		_listOfRounds pushBack (_x select 2);
		
		if (_forEachIndex > 0) then { _line = _line + " | "; };
		_line = _line + format ["%1: %2", (_x select 0),  (_x select 1)];		
	} forEach _fm;
	
	[
		_listOfTypes
		, _listOfRounds
		, _line
	]
};


/*
 *	Firemission
 */

tSF_fnc_ArtillerySupport_RequestFiremission = {
	params["_battery","_requestOptions"];

	private _typeName = (_requestOptions select 2) select 1;
	private _type = ((_requestOptions select 2) select 2) select ((_requestOptions select 2) select 0);
	private _number = parseNumber ((_requestOptions select 3) select 1);
	private _spread = (_requestOptions select 4) select 0;	
	
	private _grid = (_requestOptions select 0) select 0;
	private _trpName = (_requestOptions select 1) select 1;
	
	if ( (_grid == "" && _trpName == " ") || (count _grid < 8) ) then {
		_pos = [0,0,0];
	} else {
		if (_grid != "") then {
			_pos = (_grid splitString " " joinString "") call dzn_fnc_getPosOnMapGrid;
		} else {
			_pos = ((_requestOptions select 1) select 2) select ((_requestOptions select 1) select 0);
		};
	};
	
	[_battery, "Firemission", [_pos, _type, _typeName, _number, _spread]] call tSF_fnc_ArtillerySupport_SetStatus;	
	[
		_battery
		, _pos
		, _type
		, _number
		, _spread
	] execFSM "dzn_tSFramework\Modules\ArtillerySupport\Firemission.fsm";
};

tSF_fnc_ArtillerySupport_CancelFiremission = {
	params["_battery"];	
	
	private _grp = [_battery, "Crew"] call tSF_fnc_ArtillerySupport_GetStatus;
	for "_i" from 0 to (count (units _grp)) do {
		private _u = units _grp select 0;
		moveOut _u
		deleteVehicle _u;
	};
	deleteGroup _grp;
	
	[_battery, "Crew", nil] call tSF_fnc_ArtillerySupport_SetStatus;
	[_battery, "Requester", nil] call tSF_fnc_ArtillerySupport_SetStatus;
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
	params["_battery"];
	[_battery, "State", "Waiting"] call tSF_fnc_ArtillerySupport_SetStatus;
};
