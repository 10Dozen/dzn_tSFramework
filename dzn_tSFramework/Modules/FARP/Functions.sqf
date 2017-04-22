
tSF_fnc_FARP_drawAllowedAreaMarkers = {
	// @Markers = call tSF_fnc_FARP_drawAllowedAreaMarkers
	private _markers = [];
	{
		private _trgArea = triggerArea _x;
		private _mrk = createMarker [format ["mrk_FARP_allowed_%1", _forEachIndex], getPosATL _x];

		_mrk setMarkerShape (if (_trgArea select 3) then {"RECTANGLE"} else {"ELLIPSE"});
		_mrk setMarkerSize [_trgArea select 0, _trgArea select 1];
		_mrk setMarkerDir (_trgArea select 2);

		_mrk setMarkerBrush "SolidBorder";
		_mrk setMarkerColor "ColorOrange";
		_mrk setMarkerAlpha 0.8;

		_markers pushBack _mrk;
	} forEach (synchronizedObjects tsf_FARP);

	_markers
};

tSF_fnc_FARP_removeAllowedAreaMarkers = {
	// @Markers call tSF_fnc_FARP_removeAllowedAreaMarkers
	{deleteMarker _x;} forEach _this;
};

tSF_fnc_FARP_findMarker = {
	// call tSF_fnc_tsf_FARP_findMarker
	private _markerPos = getPosASL tsf_FARP;
	{
		if (toLower(markerText _x) == "farp") then { _markerPos = markerPos _x; };
	} forEach allMapMarkers;

	_markerPos
};


tSF_fnc_FARP_createFARP_Server = {
	params["_pos","_composition"];

	private _dir = 0;
	if !(typename _pos == "ARRAY") then {
		_dir = getDir _pos;
		_pos = getPosATL _pos;
	};

	tSF_FARP_Objects = [[_pos, _dir], _composition] call dzn_fnc_setComposition;
	tSF_FARP_Objects apply { _x lock true };

	publicVariable "tSF_CCP_Objects";
};


tSF_fnc_FARP_createFARP_Client = {
	waitUntil { !isNil "tSF_FARP_Position" };
	["mrk_auto_farp", tSF_FARP_Position, "mil_flag", "ColorOrange", "FARP", true] call dzn_fnc_createMarkerIcon;

	waitUntil {!isNil "tSF_FARP_Objects"};
	{
		[
			_x
			, "<t color='#9bbc2f' size='1.2'>Serve vehicles</t>"
			, { [] spawn tSF_fnc_FARP_showMenu; }
			, 5
			, "true"
			, 6
		] call dzn_fnc_addAction;
	} forEach tSF_FARP_Objects;

	player setVariable ["tSF_CCP_forceHealing", false];
};


tSF_fnc_FARP_doService = {
	if (player getVariable ["onServing", false]) exitWith {};

	params ["_v"];

	1000 cutText ["Vehicle Servicing", "PLAIN"];
	player setVariable ["onServing", true];

	sleep 2;

	sleep 5;
	_v setDamage 0;
	{
		_v setHit [_x, 0];
	} forEach [
		"wheel_1"
		,"wheel_2"
		,"wheel_3"
		,"wheel_4"
		,"pas_L"
		,"pas_P"
	];

	sleep 5;
	_v setFuel 1;

	sleep 5;
	_v setVehicleAmmo 1;

	sleep 1;
	1000 cutText ["Vehicle Servicing - Done", "PLAIN"];
	[] spawn {
		sleep 20;
		player setVariable ["onServing", false];
	};


};







/*
 *	FARP Servicing Functions
 *
 */

tSF_fnc_FARP_showMenu = {
	#define	NOT_AVAILABLE		"<t color='#dd3333'>Not available</t>"
	// disableSerialization;
	
	private _repairLabel = "<t color='#dd3333'>Not available</t>";
	private _refuelLabel = "<t color='#dd3333'>Not available</t>";
	private _rearmLabel = "<t color='#dd3333'>Not available</t>";
	
	
	if (tSF_FARP_Repair_Allowed) then {
		if (tSF_FARP_Repair_ResoucesLevel > 0) then {
			_repairLabel = str(tSF_FARP_Repair_ResoucesLevel);
		} else {
			_repairLabel = "Available"
		};
	};
	
	if (tSF_FARP_Refuel_Allowed) then {
		if (tSF_FARP_Refuel_ResoucesLevel > 0) then {
			_refuelLabel = str(tSF_FARP_Refuel_ResoucesLevel);
		} else {
			_refuelLabel = "Available"
		};
	};
	
	if (tSF_FARP_Rearm_Allowed) then {
		if (tSF_FARP_Rearm_ResoucesLevel > 0) then {
			_rearmLabel = str(tSF_FARP_Rearm_ResoucesLevel);
		} else {
			_rearmLabel = "Available"
		};
	};	

	private _farpMenu = [
		[0, "HEADER", "FARP Menu"]
		
		,[1, "HEADER", "<t align='center' font='PuristaBold'>AVAILABLE RESOURCES</t>"]
		,[2, "LABEL", "<t align='right'>Repair</t>"]
		,[2, "LABEL", _repairLabel]	
		,[3, "LABEL", "<t align='right'>Fuel</t>"]
		,[3, "LABEL", _refuelLabel]
		,[4, "LABEL", "<t align='right'>Ammo</t>"]
		,[4, "LABEL", _rearmLabel]

		,[5, "HEADER", "<t align='center' font='PuristaBold'>VEHICLES ON FARP</t>"]		
	];
	private _farpMenuLine = 6;
	
	FARP_Vehicles = vehicles select { 
		(_x isKindOf "Car" || _x isKindOf "Tank" || _x isKindOf "Air") 
		&& !(_x in tSF_FARP_Objects)
		&& alive _x
		&& { [ _x, tSF_FARP_Position, 20] call dzn_fnc_isInArea2d }
		
	};
	
	if (FARP_Vehicles isEqualTo []) then {
		_farpMenu pushBack [_farpMenuLine,"LABEL","<t align='center'>NO VEHICLES</t>"];
	} else {
		{
			private _classname = typeOf _x;
			private _fullLoadout = [];
			
			if ( {(_x select 0) == _classname} count tSF_fnc_FARP_VehiclesDefaultLoadout > 0 ) then {
				_fullLoadout = ((tSF_fnc_FARP_VehiclesDefaultLoadout select  { (_x select 0) == _classname }) select 0) select 1;
			} else {
				private _v = (typeOF _x) createVehicleLocal [0,0,50];
				_fullLoadout = magazinesAllTurrets _v;
				deleteVehicle _v;
				
				tSF_fnc_FARP_VehiclesDefaultLoadout pushBack [typeOf _x, _fullLoadout];
				publicVariable "tSF_fnc_FARP_VehiclesDefaultLoadout";
			};
			
			// [ 0@Health, 1@Fuel, 2@AmmoLevel, 3@CurrentMagazines, 4@FullMagazines ]
			_x setVariable [
				"tSF_FARP_VehicleState"
				, [
					1 - damage _x
					, fuel _x
					, [magazinesAllTurrets _x, _fullLoadout] call tSF_fnc_FARP_countMagazines
				]
			];
			
			_farpMenu pushBack [_farpMenuLine,"LABEL", format["   <t font='PuristaBold' size='1.25'>%1</t>", _classname call dzn_fnc_getVehicleDisplayName] ];
			_farpMenuLine = _farpMenuLine + 1;
			_farpMenu pushBack [_farpMenuLine,"LABEL", format["<t align='left'>State</t><t align='right'>%1%2</t>", round(100*(1 - damage _x)), "%"] ];
			_farpMenu pushBack [_farpMenuLine,"LABEL", format["<t align='left'>Fuel</t><t align='right'>%1%2</t>", round(100* fuel _x), "%"] ];
			_farpMenu pushBack [_farpMenuLine,"LABEL", format["<t align='left'>Ammunition</t><t align='right'>%1%2</t>", [magazinesAllTurrets _x, _fullLoadout] call tSF_fnc_FARP_countFullMagazinesRatio, "%"] ];
			
			if (_x getVariable ["tSF_FARP_OnSerivce", false]) then {
				_farpMenu pushBack [_farpMenuLine,"LABEL", "Servicing..."];
			
			} else {			
				_farpMenu pushBack [_farpMenuLine,"BUTTON", "<t align='center'>SERVICE</t>", compile format ["closeDialog 2; [] spawn { sleep 0.05; (FARP_Vehicles select %1) call tSF_fnc_FARP_showServiceMenu; }", _forEachIndex] ];
			};
			_farpMenuLine = _farpMenuLine + 1;
		} forEach FARP_Vehicles;
	};
	_farpMenu call dzn_fnc_ShowAdvDialog;
};

tSF_fnc_FARP_countFullMagazinesRatio = {
	params["_curMags", "_fullMags"];
	
	private _magsAll = [_curMags, _fullMags] call tSF_fnc_FARP_countMagazines;	
	private _magsNonFull = 0;
	private _magsFull = 0;
	
	{
		_magsFull = _magsFull + (_x select 3);	
		_magsNonFull = _magsNonFull + (_x select 2);
	} forEach _magsAll;
	
	if (_magsFull > 0) then {
		round( 100*(_magsNonFull/_magsFull) )
	} else {
		0
	}
};

tSF_fnc_FARP_countMagazines = {
	params["_curMags", "_fullMags"];
	
	private _magazines = [];
	private _counted = [];
	
	{
		private _magClass = _x select 0;
		private _turretPath = _x select 1;
		private _ammoCount = _x select 2;
		
		if !([_magClass, _turretPath] in _counted) then {
			_counted pushBack [_magClass, _turretPath];
		
			private _currentMagazines = { (_magClass == _x select 0) && (_turretPath isEqualTo (_x select 1)) && (_ammoCount == _x select 2) } count _curMags;
			private _fullMagazines = { (_magClass == _x select 0) && (_turretPath isEqualTo (_x select 1)) && (_ammoCount == _x select 2) } count _fullMags;
		
			_magazines pushBack [_magClass, _turretPath, _currentMagazines, _fullMagazines];
		};	
	} forEach _fullMags;
	
	// [ [@MagazineName, @TurretPath, @CurrFullMags, @FullMags] ]
	_magazines
};

tSF_fnc_FARP_showServiceMenu = {
	tSF_FARP_Servicing_Vehicle = _this;
	tSF_FARP_DialogLines = [];
	
	private _vehState = _this getVariable "tSF_FARP_VehicleState";
	private _damageState = round(100*(_vehState select 0));
	private _fuel = round(100*(_vehState select 1));
	private _magazines  = _vehState select 2;	// [ [@MagazineName, @TurretPath, @CurrFullMags, @FullMags] ... ]

	private _farpServiceMenu = [
		[0, "HEADER", "FARP Service Menu"]
		,[1, "HEADER", format ["<t align='center' font='PuristaBold'>%1</t>", typeOf(_this) call dzn_fnc_getVehicleDisplayName]]
	];
	private _farpMenuLine = 2;
	
	if (tSF_FARP_Repair_Allowed) then {
		_farpServiceMenu pushBack [_farpMenuLine, "LABEL", "Repair"];
		_farpServiceMenu pushBack [_farpMenuLine,"CHECKBOX"];
		_farpServiceMenu pushBack [_farpMenuLine,"SLIDER",[0,100, _damageState]];
		tSF_FARP_DialogLines pushBack "REPAIR";
		_farpMenuLine = _farpMenuLine + 1;
	};
	
	if (tSF_FARP_Refuel_Allowed) then {
		_farpServiceMenu pushBack [_farpMenuLine, "LABEL", "Refuel"];
		_farpServiceMenu pushBack [_farpMenuLine,"CHECKBOX"];
		_farpServiceMenu pushBack [_farpMenuLine,"SLIDER",[0,100, _fuel]];
		tSF_FARP_DialogLines pushBack "REFUEL";
		_farpMenuLine = _farpMenuLine + 1;
	};
	
	
	if (tSF_FARP_Rearm_Allowed) then {
		_farpServiceMenu pushBack [_farpMenuLine, "LABEL", "<t align='center' font='PuristaBold'>Ammunition</t>"];
		_farpMenuLine = _farpMenuLine + 1;
		
		tSF_FARP_DialogLines pushBack "AMMO";
		{
			private _mag = _x select 0;
			private _turret = _x select 1;
			private _curMagCount = _x select 2;
			private _fullMagCount = _x select 3;		
			
			_farpServiceMenu pushBack [
				_farpMenuLine, "LABEL"
				, format[
					"<t align='left' size='0.6' color='#999999'>%1 </t>%2"
					, [_turret, ["ARRAY"]] call dzn_fnc_stringify
					, _mag call dzn_fnc_getItemDisplayName
				]
			];		
			_farpServiceMenu pushBack [_farpMenuLine, "CHECKBOX"];
			_farpServiceMenu pushBack [_farpMenuLine, "SLIDER", [0, _fullMagCount, _curMagCount]];
			_farpMenuLine = _farpMenuLine + 1;
		} forEach _magazines;
	};
	
	_farpServiceMenu pushBack [_farpMenuLine, "LABEL", ""];
	_farpServiceMenu pushBack [_farpMenuLine + 1, "BUTTON", "<t align='center' font='PuristaBold'>SERVICE</t>", { [tSF_FARP_Servicing_Vehicle, _this] spawn tSF_fnc_FARP_ProcessService; closeDialog 2; }];
	_farpServiceMenu pushBack [_farpMenuLine + 1, "LABEL", ""];
	_farpServiceMenu pushBack [_farpMenuLine + 1, "LABEL", ""];
	_farpServiceMenu pushBack [_farpMenuLine + 1, "BUTTON", "CANCEL", { closeDialog 2; }];

	_farpServiceMenu call dzn_fnc_ShowAdvDialog;
};


tSF_fnc_FARP_ProcessService = {
	
	/*
		[
			@VEHICLE
			,[
				0[@Checkbox_REPAIR]
				1[@SliderValue_REPAIR, [@Min, @Max]]
				
				2[@Checkbox_REFUEL]
				3[@SliderValue_REFUEL, [@Min, @Max]]
				
				4[@Checkbox_MAG_1]
				5[@SliderValue_MAG_1, [Min_MAG_1, Max_MAG_1]
				
				6...7 (MAG2)
				8...9 (MAG3)
			]
		]
	*/
	params["_veh", "_dialogResult"];
	
	_veh setVariable ["tSF_FARP_OnSerivce", true, true];
	
	private _needRepair = false;
	private _repairLevelRequested = 0;
	
	private _needRefuiling = false;
	private _fuelLevelRequested = 0;
	
	private _needRearmTotal = false;
	private _ammoSectionStartId = 0;
	
	{
		switch (true) do {
			case (_x == "REPAIR"): {
				_needRepair = ((_dialogResult select 0) select 0);
				_repairLevelRequested = ((_dialogResult select 1) select 0)/100;
			};		
			case (_x == "REFUEL"): {				
				_needRefuiling = ((_dialogResult select (0 + 2*_forEachIndex)) select 0);
				_fuelLevelRequested = ((_dialogResult select (1 + 2*_forEachIndex)) select 0)/100;
			};			
			case (_x == "AMMO"): {
				_needRearmTotal = true;
				_ammoSectionStartId = 2*_forEachIndex;
			};
		};
	} forEach tSF_FARP_DialogLines;
	
	private _magazinesList = (_veh getVariable "tSF_FARP_VehicleState") select 2; // [ [@MagazineName, @TurretPath, @CurrFullMags, @FullMags] ... ]
	private _rearmList = [];	// [ [@MagazineClass, @TurretPath, @NeedRearm, @CurrFullMags, @MagsToRearm] ]
	
	{
		_rearmList pushBack [
			_x select 0
			, _x select 1
			, _dialogResult select (_ammoSectionStartId + 2*_forEachIndex) select 0
			, _x select 2
			, _dialogResult select (_ammoSectionStartId + 1 + 2*_forEachIndex) select 0
		];	
	} forEach _magazinesList;
	
	FARPDATA = _this;
	MAGDATA = _rearmList;
	
	
	if (_needRepair) then {	
		private _hitPointsDamages = getAllHitPointsDamage _veh;
		
		private _hitpoints = [];
		for "_i" from 0 to count (_hitPointsDamages select 0) - 1 do {	
			if !((_hitPointsDamages select 0 select _i) in tSF_FARP_Repair_NonRepairable) then {
				_hitpoints pushBack [
					_hitPointsDamages select 0 select _i
					, _hitPointsDamages select 2 select _i
				];
			};
		};
		private _hitpointsWeight = 1/(count _hitpoints);
		
		systemChat "Repairing";
		private _repairDiff = 0;
		{
			private _currHealth = 1 - (_x select 1);
			
			if ( _currHealth < _repairLevelRequested ) then {
				_repairDiff = _repairLevelRequested - _currHealth;
				
				if (tSF_FARP_Repair_ResoucesLevel >= 0) then {
					if (tSF_FARP_Repair_ResoucesLevel - (_repairDiff * 100 * _hitpointsWeight) < 0) then {
						_repairDiff = tSF_FARP_Repair_ResoucesLevel/100;
						tSF_FARP_Repair_ResoucesLevel = 0;
					} else {
						tSF_FARP_Repair_ResoucesLevel = tSF_FARP_Repair_ResoucesLevel - (_repairDiff * 100 * _hitpointsWeight);
					};
				};
				
				_veh setHitPointDamage [_x select 0, 1 - (_currHealth + _repairDiff), true];
			};
		} forEach _hitpoints;
		
		if (tSF_FARP_Repair_ResoucesLevel >= 0) then {
			tSF_FARP_Repair_ResoucesLevel = round(tSF_FARP_Repair_ResoucesLevel);
			publicVariable "tSF_FARP_Repair_ResoucesLevel";
		};
		
		sleep (if (tSF_FARP_Repair_ProportionalMode) then { tSF_FARP_Repair_TimeMultiplier * _repairDiff } else { tSF_FARP_Repair_TimeMultiplier });
	};	
	
	if (_needRefuiling) then {
		systemChat "Refuiling";
		
		private _currentFuelLevel = fuel _veh;
		private _fuelDiff = _fuelLevelRequested - _currentFuelLevel;
		
		if (tSF_FARP_Refuel_ResoucesLevel >= 0) then {
			if (tSF_FARP_Refuel_ResoucesLevel - 100*_fuelDiff < 0) then {
				_fuelDiff = tSF_FARP_Refuel_ResoucesLevel/100;
				tSF_FARP_Refuel_ResoucesLevel = 0;
			} else {
				tSF_FARP_Refuel_ResoucesLevel = round( tSF_FARP_Refuel_ResoucesLevel - 100*_fuelDiff );
			};
			publicVariable "tSF_FARP_Refuel_ResoucesLevel";
		};
		
		_veh setFuel (_currentFuelLevel + _fuelDiff);
		
		sleep (if (tSF_FARP_Refuel_ProportionalMode) then { tSF_FARP_Refuel_TimeMultiplier * _fuelDiff } else { tSF_FARP_Refuel_TimeMultiplier });
	};
	
	if (_needRearmTotal) then {
		private _diff = 0;
		{
			private _mag = _x select 0;
			private _turret = _x select 1;
			private _needRearm = _x select 2;
			private _currentMags = _x select 3;
			private _requestedMags = _x select 4;
			
			if (_needRearm) then {
				systemChat format ["Rearming : %1", _mag call dzn_fnc_getItemDisplayName];
				if (_requestedMags > _currentMags) then {					
					_diff = _requestedMags - _currentMags;
					if (tSF_FARP_Rearm_ResoucesLevel >= 0) then {
						if (tSF_FARP_Rearm_ResoucesLevel < _diff) then {
							_diff = tSF_FARP_Rearm_ResoucesLevel;
							tSF_FARP_Rearm_ResoucesLevel = 0;
						} else {
							tSF_FARP_Rearm_ResoucesLevel = tSF_FARP_Rearm_ResoucesLevel - _diff;
						};
					};
					
					// Removing all magazines of type (to remove non full magazines too)
					for "_i" from 0 to (_currentMags+1) do {
						_veh removeMagazineTurret [_mag, _turret];
					};
					
					ADDMAG = [_currentMags, _diff];
					// Adding magazines (return full mags and difference between requested and actual)
					for "_i" from 1 to (_currentMags + _diff) do {
						_veh addMagazineTurret [_mag, _turret];
					};
					
					systemChat format ["Rearming : %1 : Added x%2", _mag call dzn_fnc_getItemDisplayName, _diff];
				} else {			
					_diff = _currentMags - _requestedMags;
					
					if (tSF_FARP_Rearm_ResoucesLevel >= 0) then {
						tSF_FARP_Rearm_ResoucesLevel = tSF_FARP_Rearm_ResoucesLevel + _diff;
					};
					
					for "_i" from 1 to _diff do {
						_veh removeMagazineTurret [_mag, _turret];
					};

					systemChat format ["Rearming : %1 : Removed x%2", _mag call dzn_fnc_getItemDisplayName, _diff];
				};
			};	
		} forEach _rearmList;
		
		if (tSF_FARP_Rearm_ResoucesLevel >= 0) then { publicVariable "tSF_FARP_Rearm_ResoucesLevel" };
		
		sleep (if (tSF_FARP_Rearm_ProportionalMode) then { tSF_FARP_Rearm_TimeMultiplier * _diff } else { tSF_FARP_Rearm_TimeMultiplier });
	};
	
	_veh setVariable ["tSF_FARP_OnSerivce", false, true];
};




/*

[
configfile >> "CfgWeapons" >> "CUP_Vgmg_MK19_veh" >> "magazines"

configfile >> "CfgMagazines" >> "CUP_96Rnd_40mm_MK19_M" >> "displayName"
configfile >> "CfgMagazines" >> "CUP_96Rnd_40mm_MK19_M" >> "count"


"CUP_Vgmg_MK19_veh" call dzn_fnc_getItemDisplayName

"CUP_96Rnd_40mm_MK19_M" call dzn_fnc_getItemDisplayName
"CUP_32Rnd_40mm_MK19_M" call dzn_fnc_getItemDisplayName

https://community.bistudio.com/wiki/allTurrets		vehicle weaponsTurret turretPath


getArray (configfile >> "CfgWeapons" >> "CUP_Vgmg_MK19_veh" >> "magazines")
getNumber (configfile >> "CfgMagazines" >> "CUP_96Rnd_40mm_MK19_M" >> "count")

	["CUP_Vgmg_MK19_veh","CUP_Vhmg_M2_AAV_Noeject"]
	
	["CUP_96Rnd_40mm_MK19_M",[0],0,1.00002e+007,0]
	,["CUP_96Rnd_40mm_MK19_M",[0],0,1.00002e+007,0]
	,["CUP_96Rnd_40mm_MK19_M",[0],96,1.00002e+007,0]
	,["CUP_96Rnd_40mm_MK19_M",[0],96,1.00002e+007,0]
	,["CUP_96Rnd_40mm_MK19_M",[0],96,1.00002e+007,0]
	,["CUP_96Rnd_40mm_MK19_M",[0],96,1.00002e+007,0]
	,["CUP_96Rnd_40mm_MK19_M",[0],96,1.00002e+007,0]
	,["CUP_96Rnd_40mm_MK19_M",[0],96,1.00002e+007,0]
	,["CUP_200Rnd_TE1_Red_Tracer_127x99_M",[0],200,1.00002e+007,0]
	,["CUP_200Rnd_TE1_Red_Tracer_127x99_M",[0],200,1.00002e+007,0]
	,["CUP_200Rnd_TE1_Red_Tracer_127x99_M",[0],200,1.00003e+007,0]
	,["CUP_200Rnd_TE1_Red_Tracer_127x99_M",[0],200,1.00003e+007,0]
	,["CUP_200Rnd_TE1_Red_Tracer_127x99_M",[0],200,1.00003e+007,0]
	,["CUP_200Rnd_TE1_Red_Tracer_127x99_M",[0],200,1.00003e+007,0]
	,["SmokeLauncherMag",[1],2,1.00003e+007,0]
	,["SmokeLauncherMag",[1],2,1.00003e+007,0]
]


magazinesAllTurrets vehicle player;

[
["CUP_96Rnd_40mm_MK19_M",[0],96,1.00002e+007,0]
,["CUP_96Rnd_40mm_MK19_M",[0],96,1.00002e+007,0]
,["CUP_96Rnd_40mm_MK19_M",[0],96,1.00002e+007,0]
,["CUP_96Rnd_40mm_MK19_M",[0],96,1.00002e+007,0]
,["CUP_96Rnd_40mm_MK19_M",[0],96,1.00002e+007,0]
,["CUP_96Rnd_40mm_MK19_M",[0],96,1.00002e+007,0]
,["CUP_96Rnd_40mm_MK19_M",[0],96,1.00002e+007,0]
,["CUP_96Rnd_40mm_MK19_M",[0],96,1.00002e+007,0]
,["CUP_200Rnd_TE1_Red_Tracer_127x99_M",[0],200,1.00002e+007,0]
,["CUP_200Rnd_TE1_Red_Tracer_127x99_M",[0],200,1.00002e+007,0]
,["CUP_200Rnd_TE1_Red_Tracer_127x99_M",[0],200,1.00003e+007,0]
,["CUP_200Rnd_TE1_Red_Tracer_127x99_M",[0],200,1.00003e+007,0]
,["CUP_200Rnd_TE1_Red_Tracer_127x99_M",[0],200,1.00003e+007,0]
,["CUP_200Rnd_TE1_Red_Tracer_127x99_M",[0],200,1.00003e+007,0]
,["SmokeLauncherMag",[1],2,1.00003e+007,0]
,["SmokeLauncherMag",[1],2,1.00003e+007,0]]

[
	["HitHull","HitEngine","HitLTrack","HitRTrack","HitFuel","","","","","HitTurret","HitGun","HitTurret","HitGun","HitTurret","HitGun","HitTurret","HitGun","HitTurret","HitGun","HitTurret","HitGun","HitTurret","HitGun","HitTurret","HitGun"]
	,["","","pas_l","pas_p","engine_hit","light_l","light_l","light_r","light_r","main_turret","main_gun","","","","","","","","","","","","","",""]
	,[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
]

[
["hitwindshield_1","hitwindshield_2","HitGlass1","HitGlass2","HitGlass3","HitGlass4","HitGlass5","HitGlass6","HitBody","hitfuel","HitLFWheel","HitRFWheel","HitLF2Wheel","HitRF2Wheel","HitEngine","HitHull","HitRGlass","HitLGlass","HitLBWheel","HitLMWheel","HitRBWheel","HitRMWheel","","","","","","","","","HitTurret","HitGun","HitTurret","HitGun","HitTurret","HitGun","HitTurret","HitGun"]
,["windshield_1","windshield_2","glass1","glass2","glass3","glass4","","","vehicle","fuel","wheel_1","wheel_2","wheel_3","wheel_4","engine","","","","","","","","light_hd_1","light_hd_2","light_hd_1","light_hd_2","light_hd_1","light_hd_2","light_hd_2","light_hd_1","","","","","","","",""]
,[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
]

call compile preProcessFileLineNumbers "dzn_tSFramework\Modules\FARP\Functions.sqf";
(vehicle player) call tSF_fnc_FARP_ProcessService




tSF_fnc_FARP_showFARPMenu = {
	[
		[0, "HEADER", "FARP Menu"]
		
		,[1, "HEADER", "<t align='center' font='PuristaBold'>AVAILABLE RESOURCES</t>"]
		,[2, "LABEL", "<t align='right'>Fuel</t>"]
		,[2, "LABEL", "200"]
		,[3, "LABEL", "<t align='right'>Ammo</t>"]
		,[3, "LABEL", "120"]
		,[4, "LABEL", "<t align='right'>Repair</t>"]
		,[4, "LABEL", "69"]	
		
		,[5, "HEADER", "<t align='center' font='PuristaBold'>VEHICLES ON FARP</t>"]		
		
		,[6,"LABEL", "M1035 HMWWV (M2)"]		
		,[7,"LABEL", "Damage"]
		,[7,"LABEL", "25"]
		,[7,"LABEL", "Fuel"]
		,[7,"LABEL", "72"]
		,[7,"LABEL", "Ammo"]
		,[7,"LABEL", "62"]
		,[7,"BUTTON", "<t align='center'>SERVICE</t>", { hint 'Serviced'; }]
	
	] call dzn_fnc_ShowAdvDialog;
	
	
	[
		[0, "HEADER", "FARP - M1035 HMWWV (M2) Vehicle Menu"]
		
		,[1, "LABEL", "Repair"]
		,[1,"CHECKBOX"]
		,[1,"SLIDER",[0,100,75]]
		
		,[2, "LABEL", "Fuel"]
		,[2,"CHECKBOX"]
		,[2,"SLIDER",[0,100,72]]
		
		,[3, "LABEL", "Ammo"]
		,[3,"CHECKBOX"]
		,[3,"SLIDER",[0,100,72]]
		
		,[4,"BUTTON","SERVE", { hint 'SERVE' }]
		,[4,"LABEL",""]
		,[4,"LABEL",""]
		,[4,"BUTTON","CANCEL", { closeDialog 2; }]
	] call dzn_fnc_ShowAdvDialog

	
	
};

*/
