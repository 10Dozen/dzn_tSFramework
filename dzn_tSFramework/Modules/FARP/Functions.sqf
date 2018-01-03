
tSF_fnc_FARP_drawAllowedAreaMarkers = {
	// @Markers = call tSF_fnc_FARP_drawAllowedAreaMarkers
	private _mrk = ["mrk_FARP_default", getPosATL tsf_FARP, "mil_box", "ColorOrange", format ["(%1)", tSF_FARP_STR_ShortName], true] call dzn_fnc_createMarkerIcon;
	_mrk setMarkerAlpha 0.5;
	
	private _markers = [];
	{
		private _trgArea = triggerArea _x;
		private _mrk = createMarker [format ["mrk_FARP_allowed_%1", _forEachIndex], getPosATL _x];

		_mrk setMarkerShape (if (_trgArea select 3) then {"RECTANGLE"} else {"ELLIPSE"});
		_mrk setMarkerSize [_trgArea select 0, _trgArea select 1];
		_mrk setMarkerDir (_trgArea select 2);

		_mrk setMarkerBrush "SolidBorder";
		_mrk setMarkerColor "ColorOrange";
		_mrk setMarkerAlpha 0.25;

		_markers pushBack _mrk;
	} forEach (synchronizedObjects tSF_FARP);

	_markers
};

tSF_fnc_FARP_removeAllowedAreaMarkers = {
	// @Markers call tSF_fnc_FARP_removeAllowedAreaMarkers
	{deleteMarker _x;} forEach _this;
};

tSF_fnc_FARP_findAndUpdateMarker = {
	// call tSF_fnc_FARP_findAndUpdateMarker
	private _markerPos = getPosASL tsf_FARP;
	private _useDefault = true;
	
	{
		if (toLower(markerText _x) == "farp") then {		 	
			_x setMarkerText tSF_FARP_STR_ShortName;
		 	_x setMarkerType "mil_flag";
		 	_x setMarkerColor "ColorOrange";
			deleteMarker "mrk_FARP_default";
			_markerPos = markerPos _x;
			
			_useDefault = false;
		};
	} forEach allMapMarkers;
	
	if (_useDefault) then {
		[] spawn {
			"mrk_FARP_default" setMarkerText tSF_FARP_STR_ShortName;
			"mrk_FARP_default" setMarkerType "mil_flag";
			"mrk_FARP_default" setMarkerColor "ColorOrange";
			"mrk_FARP_default" setMarkerAlpha 1;
		};
	};
	
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
	
	private _pad = "Land_HelipadCircle_F" createVehicle [0,0,0];
	_pad setPos (tSF_FARP_Position getPos [20, 225]);

	publicVariable "tSF_FARP_Objects";
};


tSF_fnc_FARP_createFARP_Client = {
	waitUntil { !isNil "tSF_FARP_Position" };
	waitUntil {!isNil "tSF_FARP_Objects"};
	{
		[
			_x
			, "<t color='#9bbc2f' size='1.2'>FARP Menu</t>"
			, { [] spawn tSF_fnc_FARP_showMenu; }
			, 8
			, "true"
			, 6
		] call dzn_fnc_addAction;
	} forEach tSF_FARP_Objects;
};

/*
 *	FARP Servicing Functions
 *
 */

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
 

tSF_fnc_FARP_spawnAssets = {
	params["_assetId","_assetName","_assetsList"];
	
	if (_assetName == "RENEW KIT") exitWith {
		call compile preprocessFile "dzn_gear\Kits.sqf";
		player setVariable ["tSF_FARP_RenewGearInProgress", true, true];
		
		[
			player
			, selectRandom["HubStandingUC_idle1","HubStandingUB_idle1"]
			, "_this getVariable 'tSF_FARP_RenewGearInProgress'"
			, true
		] spawn dzn_fnc_playAnimLoop;
		
		[
			"<t align='center' shadow='2' font='PuristaMedium'>RENEWING GEAR</t>"
			, [1,18.5,74,0.04], [0,0,0,0]
			, "!(player getVariable 'tSF_FARP_RenewGearInProgress')"
		] call dzn_fnc_ShowMessage;
		
		[
			1,tSF_FARP_Assets_RenewKitTime,1
			,"BOTTOM"
			, {				
				0 cutText ["", "WHITE OUT", 0.1];
				sleep 0.5;
				player setVariable ["tSF_FARP_RenewGearInProgress", false, true];
				[player, player getVariable "dzn_gear"] call dzn_fnc_gear_assignKit;	
				sleep 0.5;
				0 cutText ["", "WHITE IN", 1];
			}
		] spawn dzn_fnc_ShowProgressBar;
	};
	
	if ((_assetsList select _assetId) in ["ACE_Wheel","ACE_Track"]) then {
		hint format ["%1 asset deployed", _assetName];
		private _pos = ((tSF_FARP_Objects select { typeOf _x == "Land_CampingTable_F" }) select 0) modelToWorld [0,0.3,1];	
		private _asset = (_assetsList select _assetId) createVehicle _pos;
		_asset setPosATL _pos;
	} else {
		hint format ["%1 asset added to equipment box", _assetName];
		tSF_FARP_EquipmentBox addItemCargoGlobal [(_assetsList select _assetId),1];
	};
};
 
tSF_fnc_FARP_showMenu = {
	private _repairLabel 	= "<t color='#dd3333'>Not available</t>";
	private _refuelLabel 	= "<t color='#dd3333'>Not available</t>";
	private _rearmLabel 		= "<t color='#dd3333'>Not available</t>";	
	
	if (tSF_FARP_Repair_Allowed) then {
		_repairLabel = if (tSF_FARP_Repair_ResoucesLevel > 0) then { str(tSF_FARP_Repair_ResoucesLevel) } else { "Available" };
	};
	
	if (tSF_FARP_Refuel_Allowed) then {
		_refuelLabel = if (tSF_FARP_Refuel_ResoucesLevel > 0) then { str(tSF_FARP_Refuel_ResoucesLevel) } else { "Available" };
	};
	
	if (tSF_FARP_Rearm_Allowed) then {
		_rearmLabel = if (tSF_FARP_Rearm_ResoucesLevel > 0) then { str(tSF_FARP_Rearm_ResoucesLevel) } else { "Available" };
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
	
	tSF_FARP_Vehicles = vehicles select { 
		(_x isKindOf "Car" || _x isKindOf "Tank" || _x isKindOf "Air") 
		&& !(_x in tSF_FARP_Objects)
		&& alive _x
		&& { 
			(getPosATL _x select 2) < 0.4
			&& speed _x < 5
			&& [ _x, tSF_FARP_Position, 25] call dzn_fnc_isInArea2d 
		}		
	};
	
	if (tSF_FARP_Vehicles isEqualTo []) then {
		_farpMenu pushBack [_farpMenuLine, "LABEL", "<t align='center'>NO VEHICLES</t>"];
		_farpMenuLine = _farpMenuLine + 1;
	} else {
		{
			private _classname = typeOf _x;
			private _fullLoadout = [];
			
			if ( {(_x select 0) == _classname} count tSF_FARP_VehicleDefaultLoadouts > 0 ) then {
				_fullLoadout = ((tSF_FARP_VehicleDefaultLoadouts select  { (_x select 0) == _classname }) select 0) select 1;
			} else {
				private _v = (typeOF _x) createVehicleLocal [0,0,50];
				_fullLoadout = magazinesAllTurrets _v;
				deleteVehicle _v;
				
				tSF_FARP_VehicleDefaultLoadouts pushBack [typeOf _x, _fullLoadout];
				publicVariable "tSF_FARP_VehicleDefaultLoadouts";
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
				_farpMenu pushBack [_farpMenuLine,"LABEL", format ["Servicing... (%1 s)", _x getVariable ["tSF_FARP_ServicingTimeLeft", 0]]];
			
			} else {			
				_farpMenu pushBack [
					_farpMenuLine
					,"BUTTON"
					, "<t align='center'>SERVICE</t>"
					, compile format [
						"closeDialog 2;
						[] spawn { 
							sleep 0.05;
							(tSF_FARP_Vehicles select %1) call tSF_fnc_FARP_showServiceMenu;
						}"
						, _forEachIndex
					]
				];
			};
			_farpMenuLine = _farpMenuLine + 1;
		} forEach tSF_FARP_Vehicles;
	};
	
	// Assets
	private _assets = tSF_FARP_Assets_BasicList apply { _x };	
	private _assetsNames = tSF_FARP_Assets_BasicList apply { toUpper(_x call dzn_fnc_getItemDisplayName) };
	
	if (tSF_FARP_Assets_AllowNVG) then {
		_assets pushBack "NVGoggles_OPFOR";
		_assetsNames pushBack "NVG";
	};
	
	if (tSF_FARP_Assets_AllowPrimayMagazine) then {
		_assets pushBack (getArray(configFile >> "CfgWeapons" >> primaryWeapon player >> "magazines") select 0);
		_assetsNames pushBack ((getArray(configFile >> "CfgWeapons" >> primaryWeapon player >> "magazines") select 0) call dzn_fnc_getItemDisplayName);
	};
	
	if (tSF_FARP_Assets_AllowRenewKit) then {
		// player getVariable "dzn_gear"
		if (!isNil {player getVariable "dzn_gear"}) then {
			_assets pushBack "dzn_gear_kit";
			_assetsNames pushBack "RENEW KIT";
		};
	};
	
	_farpMenu pushBack [_farpMenuLine, "LABEL",""];
	_farpMenu pushBack [_farpMenuLine + 1, "HEADER","<t align='center'>ASSETS DISPENSER</t>"];
	
	_farpMenu pushBack [_farpMenuLine + 2, "LABEL","Select asset"];
	_farpMenu pushBack [_farpMenuLine + 2, "LISTBOX", _assetsNames, _assets];
	_farpMenu pushBack [_farpMenuLine + 2, "BUTTON","<t align='center'>REQUEST</t>", { (_this select 0) spawn tSF_fnc_FARP_spawnAssets; closeDialog 2;}];	
	
	_farpMenu call dzn_fnc_ShowAdvDialog;
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
	_farpServiceMenu pushBack [
		_farpMenuLine + 1
		, "BUTTON", "<t align='center' font='PuristaBold'>SERVICE</t>"
		, { 
			hint "Vehicle servicing started";
			closeDialog 2; 
			[tSF_FARP_Servicing_Vehicle,  _this] spawn tSF_fnc_FARP_RunService;			
		}
	];
	_farpServiceMenu pushBack [_farpMenuLine + 1, "LABEL", ""];
	_farpServiceMenu pushBack [_farpMenuLine + 1, "LABEL", ""];
	_farpServiceMenu pushBack [_farpMenuLine + 1, "BUTTON", "CANCEL", { closeDialog 2; }];

	_farpServiceMenu call dzn_fnc_ShowAdvDialog;
};


tSF_fnc_FARP_RunService = {
	params ["_veh","_data"];
	
	_veh setVariable ["tSF_FARP_ServiceData", _data];
	{ moveOut _x; } forEach (crew _veh);
	_veh lock true;
	
	tSF_FARP_MakeOwner = [clientOwner, _veh];
	publicVariableServer "tSF_FARP_MakeOwner";
	
	waitUntil {sleep 1; local _veh};
	{ moveOut _x; } forEach (crew _veh);
	_veh lock true;
	
	_veh spawn tSF_fnc_FARP_ProcessService;
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
	private _veh = _this;
	private _dialogResult = _this getVariable "tSF_FARP_ServiceData";
	
	_veh setVariable ["tSF_FARP_OnSerivce", true, true];	
	private _sleepTime = 0;
	
	/*
	 *	Parse params
	 */
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
	
	/*
	 *	Service Starting 
	 */
	_veh setVariable ["tSF_FARP_FuelToLoad", fuel _veh, true];
	_veh setVelocity [0,0,0];
	_veh setFuel 0;
	
	
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
				if (tSF_FARP_Repair_ProportionalMode) then { _sleepTime = _sleepTime + tSF_FARP_Repair_TimeMultiplier*(100*_repairDiff*_hitpointsWeight); };
			};
		} forEach _hitpoints;
		
		if (tSF_FARP_Repair_ResoucesLevel >= 0) then {
			tSF_FARP_Repair_ResoucesLevel = round(tSF_FARP_Repair_ResoucesLevel);
			publicVariable "tSF_FARP_Repair_ResoucesLevel";
		};
		
		if !(tSF_FARP_Repair_ProportionalMode) then { _sleepTime = _sleepTime + tSF_FARP_Repair_TimeMultiplier; }
	};	
	
	if (_needRefuiling) then {		
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
		
		_veh setVariable ["tSF_FARP_FuelToLoad", _currentFuelLevel + _fuelDiff, true];
		
		_sleepTime = _sleepTime +  (if (tSF_FARP_Refuel_ProportionalMode) then { tSF_FARP_Refuel_TimeMultiplier * _fuelDiff*100 } else { tSF_FARP_Refuel_TimeMultiplier });
	};	
	
	if (_needRearmTotal) then {
		
		{
			private _diff = 0;
			
			private _mag = _x select 0;
			private _turret = _x select 1;
			private _needRearm = _x select 2;
			private _currentMags = _x select 3;
			private _requestedMags = _x select 4;
			
			if (_needRearm) then {
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
					
					// Adding magazines (return full mags and difference between requested and actual)
					for "_i" from 1 to (_currentMags + _diff) do {
						_veh addMagazineTurret [_mag, _turret];
					};
				} else {			
					_diff = _currentMags - _requestedMags;
					
					if (tSF_FARP_Rearm_ResoucesLevel >= 0) then {
						tSF_FARP_Rearm_ResoucesLevel = tSF_FARP_Rearm_ResoucesLevel + _diff;
					};
					
					for "_i" from 1 to _diff do {
						_veh removeMagazineTurret [_mag, _turret];
					};
				};
				
				if (tSF_FARP_Rearm_ProportionalMode) then { _sleepTime = _sleepTime + tSF_FARP_Rearm_TimeMultiplier * _diff };
			};	
		} forEach _rearmList;
		
		if (tSF_FARP_Rearm_ResoucesLevel >= 0) then { publicVariable "tSF_FARP_Rearm_ResoucesLevel" };		
		if !(tSF_FARP_Rearm_ProportionalMode) then { _sleepTime = _sleepTime + tSF_FARP_Rearm_TimeMultiplier; }
	};
	
	_veh setVariable ["tSF_FARP_ServicingTimeLeft", round(_sleepTime), true];	
	_veh spawn {
		while { (_this getVariable "tSF_FARP_ServicingTimeLeft") > 0 } do {
			sleep 5;
			
			_this setVariable [
				"tSF_FARP_ServicingTimeLeft"
				, if ((_this getVariable "tSF_FARP_ServicingTimeLeft") - 5 < 0) then { 0 } else { (_this getVariable "tSF_FARP_ServicingTimeLeft") - 5 }
				, true
			];
		};
		
		if (local _this) then {
			_this setFuel (_this getVariable "tSF_FARP_FuelToLoad");
		} else {
			[_this, _this getVariable "tSF_FARP_FuelToLoad"] remoteExec ["setFuel", _this];
		};
		
		_this setVariable ["tSF_FARP_ServicingTimeLeft", nil, true];
		_this setVariable ["tSF_FARP_FuelToLoad", nil, true];
		
		_this setVariable ["tSF_FARP_OnSerivce", false, true];
		
		[_this, false] remoteExec ["lock"];
	};
};
