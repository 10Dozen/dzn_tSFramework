#define	DEBUG	false

tSF_fnc_ArtillerySupport_isAuthorizedUser = {
	// Player call tSF_fnc_ArtillerySupport_isAuthorizedUser
	[_this, "ARTILLERY"] call tSF_Authorization_fnc_checkPlayerAuthorized
};

/*
 *	Server side
 */

tSF_fnc_ArtillerySupport_processLogics = {
	{
		private _logic = _x;

		if !(isNil {_logic getVariable "tSF_ArtillerySupport"}) then {
			// [ @Logic, @Callsign, @VehicleDisplayName, @Vehicles ]
			private _guns = synchronizedObjects _logic;
			private _isVirtual = _guns isEqualTo [];
			private _name = _logic getVariable ["tSF_ArtillerySupport_Label", ""];
			if (!_isVirtual) then {
				_name = (typeOf ((synchronizedObjects _logic) select 0)) call dzn_fnc_getVehicleDisplayName;
			};
			private _condition = _logic getVariable ["tSF_ArtillerySupport_Condition", ""];

			private _battery = [
				_logic
				, _logic getVariable "tSF_ArtillerySupport"
				, _name
				, _guns
				, _isVirtual
				, _condition
			];

			private _firemissionsList = [];
			if (_isVirtual) then {
				private _idx = tSF_ArtillerySupport_VirtualFiremissionsProperties findIf { _x # 0 == _name };
				if (_idx > -1) then {
					(tSF_ArtillerySupport_VirtualFiremissionsProperties # _idx) params [
						""
						,"_firemissionsLoadout"
						,"_ranges"
						,"_ETAs"
						,"_numOfGuns"
						,"_shotReloadTime"
					];

					_firemissionsList = _firemissionsLoadout;

					[_logic, [
						 ["tSF_ArtillerySupport_MinRange", _ranges # 0, true]
						,["tSF_ArtillerySupport_MaxRange", _ranges # 1, true]
						,["tSF_ArtillerySupport_MinETA", _ETAs # 0, true]
						,["tSF_ArtillerySupport_MaxETA", _ETAs # 1, true]
						,["tSF_ArtillerySupport_NumberOfGuns", _numOfGuns, true]
						,["tSF_ArtillerySupport_ROF", _shotReloadTime, true]
					]] call dzn_fnc_setVars;
				} else {
					["No config for Virtual Battery [" + _name + "]"] call BIS_fnc_error;
				};
			} else {
				private _ammo = getArtilleryAmmo [synchronizedObjects _logic select 0];
				{
					private _roundType = _x;
					// [ [ @DisplayName, @NumberAvailable, @ListfRounds ] ]
					private _type = tSF_ArtillerySupport_FiremissionsProperties select { _roundType in (_x select 2) };
					if !(_type isEqualTo []) then {
						_firemissionsList pushBack [
							(_type select 0) select 0
							, (_type select 0) select 1
							, _roundType
						];
					};
				} forEach _ammo;
			};

			_logic setVariable ["tSF_ArtillerySupport_State", "Waiting", true];
			_logic setVariable ["tSF_ArtillerySupport_AvailableFiremissions", _firemissionsList, true];
			_logic setVariable ["tSF_ArtillerySupport_MaxFiremissions", +_firemissionsList, true];
			tSF_ArtillerySupport_Batteries pushBack _battery;

			// [_battery] spawn tSF_fnc_ArtillerySupport_HandleBatteryReload;
		};
	} forEach (entities "Logic");

	[
		{ [] call tSF_fnc_ArtillerySupport_HandleBatteriesReload }
		, 10
	] call CBA_fnc_addPerFrameHandler;
};

tSF_fnc_ArtillerySupport_HandleBatteriesReload = {
	{
		private _battery = _x;
		_battery params ["","_callsign"];
		private _hasEmptyAmmo = { _x == 0 } count ((_battery call tSF_fnc_ArtillerySupport_GetBatteryMissionsAvailable) # 3) > 0;

		if (
			_hasEmptyAmmo
			&& tSF_ArtillerySupport_BatteriesRequestedReload find _callsign < 0
		) then {
			tSF_ArtillerySupport_BatteriesRequestedReload pushBack _callsign;
			[
				{ _this call tSF_fnc_ArtillerySupport_ReloadBattery; }
				, [_battery]
				, tSF_ArtillerySupport_BatteryReloadTime
			] call CBA_fnc_waitAndExecute;
		};
	} forEach tSF_ArtillerySupport_Batteries;
};

tSF_fnc_ArtillerySupport_ReloadBattery = {
	params ["_battery"];
	_battery params ["_logic","_callsign","_name","_guns","_isVirtual"];

	{
		private _fmRound = _x; // ["HE",0,"8Rnd_82mm_Mo_shells"]
		private _fmCurrentAmmo = _fmRound # 1;
		private _max = ((_logic getVariable "tSF_ArtillerySupport_MaxFiremissions") # _forEachIndex) # 1;

		[_battery, _fmRound # 0, _max - _fmCurrentAmmo] call tSF_fnc_ArtillerySupport_UpdateBatteryMissionsAvailable;
	} forEach (_logic getVariable "tSF_ArtillerySupport_AvailableFiremissions");

	tSF_ArtillerySupport_BatteriesRequestedReload deleteAt (tSF_ArtillerySupport_BatteriesRequestedReload find _callsign);
};

/*
 *	Common functions
 */

tSF_fnc_ArtillerySupport_GetBattery = {
	//@Callsign call tSF_fnc_ArtillerySupport_GetBattery

	(tSF_ArtillerySupport_Batteries select { _x select 1 == _this }) select 0
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
	}
};

tSF_fnc_ArtillerySupport_GetStatus = {
	// [@Battery/@Callsign, @State] call tSF_fnc_ArtillerySupport_GetStatus
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
		case "VIRTUAL_GUNS_COUNT": {
			(_battery # 0) getVariable ["tSF_ArtillerySupport_NumberOfGuns", 0];
		};
		case "VIRTUAL_ROF": {
			(_battery # 0) getVariable ["tSF_ArtillerySupport_ROF", 0];
		};
	}
};

tSF_fnc_ArtillerySupport_IsAvailable = {
	// @Battery call tSF_fnc_ArtillerySupport_IsAvailable

	[_this, "State", "Waiting Correction"] call tSF_fnc_ArtillerySupport_AssertStatus
	&& [_this, "Requester", player] call tSF_fnc_ArtillerySupport_AssertStatus
	&& (_this call tSF_fnc_ArtillerySupport_GetBatteryMissionsAvailable) select 4
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
		private _roundsLabel = switch (true) do {
			case (_x # 1 < 0): { "N/A" };
			case (_x # 1 == 0): { "(reloading)" };
			default { str (_x # 1) };
		};

		_line = _line + format ["%1: %2", (_x # 0), _roundsLabel];
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

tSF_fnc_ArtillerySupport_AddCrew = {
	// [@Battery, @Add] spawn tSF_fnc_ArtillerySupport_AddCrew
	params["_battery", "_add"];

	private _crewGrp = [_battery, "CREW"] call tSF_fnc_ArtillerySupport_GetStatus;

	if (_add) then {
		// ADD NEW CREW
		_crewGrp = createGroup (side player);
		{
			private _unit = _crewGrp createUnit [tSF_ArtillerySupport_CrewClassname, [0,0,0], [], 0, "NONE"];

			if (tSF_ArtillerySupport_CrewKitname != "" && { !isNil "dzn_gear_serverInitDone" }) then {
				[_unit, tSF_ArtillerySupport_CrewKitname, false] call dzn_fnc_gear_assignKit;
			} else {
				if (isNil "dzn_gear_serverInitDone") then { diag_log "dzn_fnc_createVehicle: No dzn_gear initialized at the moment"; };
			};

			_unit moveInGunner _x;
		} forEach (_battery select 3);

		[_battery, "CREW", _crewGrp] call tSF_fnc_ArtillerySupport_SetStatus;
	} else {
		if !(isNull _crewGrp) then {
			{
				moveOut _x;
				sleep 0.5;

				deleteVehicle _x;
			} forEach (units _crewGrp);

			[_battery, "CREW", grpNull] call tSF_fnc_ArtillerySupport_SetStatus;
		};
	};

	_crewGrp
};

tSF_fnc_ArtillerySupport_GetVirtualFiremissionETA = {
	params ["_logic","_distance"];

	ceil linearConversion [
		_logic getVariable "tSF_ArtillerySupport_MinRange"
		, _logic getVariable "tSF_ArtillerySupport_MaxRange"
		, _distance
		, _logic getVariable "tSF_ArtillerySupport_MinETA"
		, _logic getVariable "tSF_ArtillerySupport_MaxETA"
		, false
	]
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

/*
 *	Firemission Contol
 */

tSF_fnc_ArtillerySupport_RequestFiremission = {
	// _requestOptions [0"_gridCtrl", 1"_trpCtrl", 2"_shapeCtrl", 3"_dirCtrl", 4"_sizeCtrl", 5"_typeCtrl", 6"_timesCtrl", 7"_delayCtrl"];
	params["_battery","_requestOptions", "_state"];

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

	// ["03909865"," ",[3900,3770,0],"LINE",90,25,"HE","8Rnd_82mm_Mo_shells",3,2]
	// ["","TRP002",[0,0,0],"CIRCLE",0,50,"HE","8Rnd_82mm_Mo_shells",5,0]
	[_battery, "STATE", _state] call tSF_fnc_ArtillerySupport_SetStatus;
	[_battery, "Firemission", [_pos, _type, _typeName, _number, _shape, _dir, _size, _delay, _trpName]] call tSF_fnc_ArtillerySupport_SetStatus;
	[_battery,_pos, _type, _typeName, _number, _shape, _dir, _size, _delay, false] execFSM "dzn_tSFramework\Modules\ArtillerySupport\Firemission.fsm";
};

tSF_fnc_ArtillerySupport_CancelFiremission = {
	params["_battery"];
	_battery params ["_logic","_callsign","_name","_guns","_isVirtual"];

	if (!_isVirtual) then {
		[_battery, false] spawn tSF_fnc_ArtillerySupport_AddCrew;
	};

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


/*
 *	Firemission Fire For Effect Calculations
 */

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

tSF_fnc_ArtillerySupport_Fire = {
	params ["_u", "_type", "_rounds", "_tgts", "_delay", "_timeout", "_battery"];

	if (DEBUG) then { systemChat format ["[FIRE %2] Timeout %1 sec", _timeout, _u]; };
	for "_i" from 0 to _timeout do {
		sleep 1;
		if ([_battery, "State", "Waiting"] call tSF_fnc_ArtillerySupport_AssertStatus) exitWith { _i = 999; };
	};

	if (DEBUG) then { systemChat format ["[FIRE %2] Timeout ended after %1 sec", _timeout, _u]; };
	for "_i" from 1 to _rounds do {
		if ([_battery, "State", "Waiting"] call tSF_fnc_ArtillerySupport_AssertStatus) exitWith { _i = 999; };

		if (DEBUG) then { systemChat format ["[FIRE %1] Shot %2 to position %3", _u, _i, _tgts select (_i - 1)]; };

		_u commandArtilleryFire [_tgts select (_i - 1), _type, 1];
		_u setVehicleAmmo 1;

		if (_delay > 40) then { [_battery, "Shot fired", "Fire for Effect"] call tSF_fnc_ArtillerySupport_showHint; };

		sleep (_delay max 6);
	};
};

tSF_fnc_ArtillerySupport_FireAdjustFiremissionVirtual = {
	params ["_type","_tgt","_delay"];

	private _ammo = getText (configFile >> "CfgMagazines" >> _type >> "ammo");

	[
		{ _this spawn dzn_fnc_StartVirtualFiremission }
		, [[_tgt,"CIRCLE",0,1], _ammo, 1, 1]
		, _delay
	] call CBA_fnc_waitAndExecute;
};

tSF_fnc_ArtillerySupport_FireForEffectVirtual = {
	params ["_type", "_rounds", "_tgtInfo", "_delay", "_ETA", "_battery"];

	private _rofDelay = [_battery, "VIRTUAL_ROF"] call tSF_fnc_ArtillerySupport_GetStatus;
	private _guns = [_battery, "VIRTUAL_GUNS_COUNT"] call tSF_fnc_ArtillerySupport_GetStatus;
	private _ammo = getText (configFile >> "CfgMagazines" >> _type >> "ammo");

	private _salvos = [];
	if (_delay == 0) then {
		_salvos = [_rounds, _guns] call tSF_fnc_ArtillerySupport_getRoundsPerGun;
	} else {
		for "_i" from 1 to _rounds do { _salvos pushBack 1 };
	};

	for "_i" from 0 to _ETA do {
		sleep 1;
		if ([_battery, "State", "Waiting"] call tSF_fnc_ArtillerySupport_AssertStatus) exitWith { _i = 999; };
	};

	_delay = _delay max _rofDelay;
	for "_i" from 0 to (count _salvos - 1) do {
		if ([_battery, "State", "Waiting"] call tSF_fnc_ArtillerySupport_AssertStatus) exitWith { _i = 999; };

		[
			_tgtInfo
			, _ammo
			, 1
			, _salvos # _i
			, 0
			, _delay
		] spawn dzn_fnc_StartVirtualFiremission;

		if (_delay > 40) then { [_battery, "Shot fired", "Fire for Effect"] call tSF_fnc_ArtillerySupport_showHint; };
		sleep _delay;
	};
};
