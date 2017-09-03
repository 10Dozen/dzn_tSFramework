
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
	
	private _battery = if (typename _callsign == "ARRAY") then {
		_callsign
	} else {
		_callsign call tSF_fnc_ArtillerySupport_GetBattery
	};
	
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
	}
};

tSF_fnc_ArtillerySupport_GetStatus = {
	// [@Battery/@Callsign, @State, @AssertValue] call tSF_fnc_ArtillerySupport_GetkStatus
	params["_callsign","_state"];

	private _battery = if (typename _callsign == "ARRAY") then { _callsign } else { _callsign call tSF_fnc_ArtillerySupport_GetBattery };
	
	switch (toUpper(_state)) do {
		case "STATE": {
			(_battery select 0) getVariable "tSF_ArtillerySupport_State";
		};
		case "REQUESTER": {
			(_battery select 0) getVariable "tSF_ArtillerySupport_Requester";	
		};
		case "CREW": {
			(_battery select 0) getVariable "tSF_ArtillerySupport_Crew";	
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

tSF_fnc_ArtillerySupport_ShowMenu = {
	// @BatteryCallsign call tSF_fnc_ArtillerySupport_ShowMenu
	private _battery = _this call tSF_fnc_ArtillerySupport_GetBattery;	
	
	if ([_this, "State", "Waiting"] call tSF_fnc_ArtillerySupport_AssertStatus) then {
		_battery call tSF_fnc_ArtillerySupport_ShowRequestMenu;
	} else {
		if (
			[_this, "State", "Searching Fire"] call tSF_fnc_ArtillerySupport_AssertStatus
			&& [_this, "Requester", player] call tSF_fnc_ArtillerySupport_AssertStatus
		) then {
			_battery call tSF_fnc_ArtillerySupport_ShowCorrectionMenu;
		} else {
			hint "Artillery is not available";		
		};	
	};
};

tSF_fnc_ArtillerySupport_ShowRequestMenu = {
	// [ @Logic, @Callsign, @VehicleDisplayName, @Vehicles ]
	tSF_ArtillerySupport_LastRequested = _this;
	private _AvailableFMs = _this call tSF_fnc_ArtillerySupport_GetBatteryMissionsAvailable;
	
	[
		[0,"HEADER","Firemission Request"]
		,[1,"LABEL","<t align='right'>Battery:</t>"]
		,[1,"LABEL", (_this select 1)]
		,[2,"LABEL", format ["<t align='center'>%1<t>", _AvailableFMs select 2]]
		,[3,"HEADER",""]
		,[4,"INPUT"]
		,[4,"LABEL", "<t align='left'>8-Grid</t><t align='right'>TRP</t>"]
		,[4,"DROPDOWN",[" ","TRP001","TRP002","TRP003"],[]]
		,[5,"LABEL",""]
		,[6,"LISTBOX", _AvailableFMs select 0, _AvailableFMs select 1]
		,[6,"LABEL","<t align='left'>Type</t> <t align='center' color='#999999'>ROUND</t> <t align='right'>Number</t>"]
		,[6,"LISTBOX",["5","6","7","8","9","10","1","2","3","4"],[]]
		,[7,"LABEL",""]
		
		,[8,"LABEL","<t align='right'>Spread (m)</t>"]
		,[8,"SLIDER",[0,500,30]]
		,[9,"LABEL",""]
		,[10,"BUTTON","CANCEL",{closeDialog 2;}]
		,[10,"LABEL",""]
		,[10,"BUTTON","REQUEST", {
			closeDialog 2;
			[tSF_ArtillerySupport_LastRequested, _this] spawn tSF_fnc_ArtillerySupport_RequestFiremissionLocal;
		}]
	] call dzn_fnc_ShowAdvDialog;
};

/*

_this in Button Code is an array of values formatted as:
		INPUT			- [@InputText (STRING)]
		DROPDOWN or LISTBOX	- [@SelectedItemID (SCALAR), @SelectedItemText (STRING), @ExpressionPerItem (ARRAY of CODE)]
		CHECKBOX		- [@IsChecked (BOOL)]
		SLIDER			- [@SelectedValue (SCALAR), [@MinimumValue (SCALAR), @MaximumValues (SCALAR)]]
	Values are listed in order they where added (e.g. from line 0 to 5) and can be reffered as _this select 0 for 1st input item, _this select 6 for 7th inpu
	*/

tSF_fnc_ArtillerySupport_RequestFiremissionLocal = {
	// LOCAL: [@Battery, @DialogOptions] call tSF_fnc_ArtillerySupport_RequestFiremission
	params["_battery","_requestOptions"];
	
	private _pos = [0,0,0];
	private _type = ((_requestOptions select 2) select 2) select ((_requestOptions select 2) select 0);
	private _number = parseNumber ((_requestOptions select 3) select 1);
	private _spread = (_requestOptions select 4) select 0;
	
	
	private _grid = (_requestOptions select 0) select 0;
	private _trpName = (_requestOptions select 1) select 1;
	
	if ( (_grid == "" && _trpName == " ") || (count _grid < 8) ) exitWith {
		hint "Wrong Firemission request! TGT POS is not defined!";
	};
	
	if (_grid != "") then {
		_pos = (_grid splitString " " joinString "") call CBA_fnc_mapGridToPos;
	} else {
		_pos = ((_requestOptions select 1) select 2) select ((_requestOptions select 1) select 0);
	};
	
	C2 = [_pos, _trp, _type, _number, _spread];	
	private _grp = createGroup (side player);
	
	[_battery, "State", "Requested"] call tSF_fnc_ArtillerySupport_SetStatus;
	[_battery, "Requester", player] call tSF_fnc_ArtillerySupport_SetStatus;
	[_battery, "Crew", _grp] call tSF_fnc_ArtillerySupport_SetStatus;
	
	{
		private _unit = _grp createUnit [typeOf player, [0,0,0], [], 0, "NONE"];
		_unit moveInGunner _x;	
	} forEach (_battery select 3);
		
	
	if !(_pos inRangeOfArtillery [ _battery select 3, _type]) exitWIth {
		hint "Wrong Firemission request! TGT POS is out of range!";
		[_battery, "State", "Waiting"] call tSF_fnc_ArtillerySupport_SetStatus;
		[_battery, "Requester", nil] call tSF_fnc_ArtillerySupport_SetStatus;
		
		{
			moveOut _x;
			deleteVehicle _x;			
		} forEach (units _grp);
		deleteGroup _grp;
		
		[_battery, "Crew", nil] call tSF_fnc_ArtillerySupport_SetStatus;
	};
	
	[_battery, "State", "Searching Fire"] call tSF_fnc_ArtillerySupport_SetStatus;
	
	private _lead = leader _grp;
	private _ETA = (vehicle _lead) getArtilleryETA [_pos, _type];
	hint str(_ETA);
	
	_lead commandArtilleryFire [_pos, _type, 1];
	sleep (_ETA - 3);
	hint "SPLASH!";
	
	
};


tSF_fnc_ArtillerySupport_ShowCorrectionMenu = {
	
	

[
  [0,"HEADER","Adjust Firemission"]
  ,[1,"LABEL","<t align='right'>Battery:</t>"]
  ,[1,"LABEL","Pinkie-3"]
  ,[2,"LABEL","<t align='right'>Firemission:</t>"]
  ,[2,"LABEL","0033 4124, 6 HE"]
  
  ,[3,"HEADER",""]
  
  ,[4,"LABEL","<t align='center'>North</t>"]
  ,[5,"LABEL","<t align='center'>West</t>"]
  ,[5,"INPUT"]
  ,[5,"LABEL","<t align='center'>East</t>"]
  ,[6,"INPUT"]
  ,[6,"BUTTON","<t align='center'>ADJUST</t>",{}]
  ,[6,"INPUT"]
  ,[7,"LABEL",""]
  ,[7,"INPUT"]
  ,[7,"LABEL",""]
  ,[8,"LABEL","<t align='center'>South</t>"]
  ,[9,"LABEL",""]
  
    ,[10,"BUTTON","ABORT",{}]
  ,[10,"LABEL",""]
  
  ,[10,"BUTTON","FIRE FOR EFFECT",{}]
 ] call dzn_fnc_ShowAdvDialog


};







/*
b1 = getArtilleryAmmo [vehicle A1];
b2 = (getPos TGT1) inRangeOfArtillery [[vehicle A1], "8Rnd_82mm_Mo_shells"];

(A1) commandArtilleryFire [(getPos TGT1), "8Rnd_82mm_Mo_Smoke_white", 6]
*/



