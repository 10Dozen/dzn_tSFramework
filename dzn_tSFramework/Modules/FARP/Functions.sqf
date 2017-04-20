
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
			, { [] spawn tSF_fnc_FARP_showFARPMenu; }
			, 5
			, "!(player getVariable ['tSF_FARP_OnServing',false])"
			, 6
		] call dzn_fnc_addAction;
	} forEach tSF_FARP_Objects;

	player setVariable ["tSF_CCP_forceHealing", false];

	/*
	tSF_FARP_CanCheck = true;
	tSF_fnc_FARP_wait = {tSF_FARP_CanCheck = false; sleep 10; tSF_FARP_CanCheck = true;};
	addMissionEventHandler ["EachFrame", {
		if !(tSF_FARP_CanCheck) exitWith {};
		[] spawn tSF_fnc_FARP_wait;

		if (vehicle player == player) exitWith {};
		
		(vehicle player) spawn tSF_fnc_FARP_doService;
	}];
	*/
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






tSF_fnc_FARP_VehiclesDefaultLoadout = [];

tSF_fnc_FARP_showMenu = {
	private _farpVehicles = vehicles select { 
		(_x isKindOf "Car" || _x isKindOf "Tank" || _x isKindOf "Air") 
		&& !(_x getVariable ["tSF_FARP_OnServing", false])
		&& { [ _x, tSF_FARP_Position, 20] call dzn_fnc_isInArea2d }
	};
	
	AX = _farpVehicles;
	
	{
		private _classname = typeOf _x;
		private _fullLoadout = [];
		
		if ( {(_x select 0) == _classname} count tSF_fnc_FARP_VehiclesDefaultLoadout > 0 ) then {
			_fullLoadout = (tSF_fnc_FARP_VehiclesDefaultLoadout select  { (_x select 0) == _classname }) select 1;
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
				, round (count(magazinesAllTurrets _x) / count _fullLoadout)
				, magazinesAllTurrets _x
				, _fullLoadout
			]
		];
	} forEach _farpVehicles;
	
	


};


tSF_fnc_FARP_countNotEmptyMagazines = {
	params["_curMags", "_fullMags"];
	
	private _magazineCount = 0;
	
	private _fullMagazineTypes = [];
	{
		if !((_x select 0) in _fullMagazineTypes) then {
			_fullMagazineTypes pushBack [_x select 0, _x select 2];		
		};
	} forEach _fullMags;
	
	{
		private _mag = _x select 0;
		private _ammoFull = _x select 2;		
		private _numberOfMagazinesTotal = { (_x select 0) == _mag } count _fullMags;
		
		{
			if (_x select 0 == _mag) then {
				private _numParts = toString((_x select 2)/_ammoFull) splitString ".";
				private _num = round( ((_x select 2)/_ammoFull) * 10 ) / 10;
			
				_magazineCount = _magazineCount + _num;
			};
		} forEach _curMags;
	} forEach _fullMagazineTypes;
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
*/

tSF_fnc_FARP_ProcessService = {
	
	private _veh = _this;
	
	private _needRepair = true;
	private _repairLevelRequested = 100/100;
	
	private _needRefuiling = true;
	private _fuelLevelRequested = 100/100;
		
	private _needRearm = true;
	private _magazines = [5,2,1];
	
	
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
		
		AX = _hitpoints;
		
		systemChat "Repairing";
		{
			private _currHealth = 1 - (_x select 1);
			
			if ( _currHealth < _repairLevelRequested ) then {
				private _repairDiff = _repairLevelRequested - _currHealth;
				
				if (tSF_FARP_Repair_ResoucesLevel - (_repairDiff * 100 * _hitpointsWeight) < 0) then {
					_repairDiff = tSF_FARP_Repair_ResoucesLevel/100;
					tSF_FARP_Repair_ResoucesLevel = 0;
				} else {
					tSF_FARP_Repair_ResoucesLevel = tSF_FARP_Repair_ResoucesLevel - (_repairDiff * 100 * _hitpointsWeight);
				};
				
				_veh setHitPointDamage [_x select 0, 1 - (_currHealth + _repairDiff), true];
			};
		} forEach _hitpoints;
		tSF_FARP_Repair_ResoucesLevel = round(tSF_FARP_Repair_ResoucesLevel);
		publicVariable "tSF_FARP_Repair_ResoucesLevel";
	};
	
	
	if (_needRefuiling) then {
		systemChat "Refuiling";
		
		private _currentFuelLevel = fuel _veh;
		private _fuelDiff = _fuelLevelRequested - _currentFuelLevel;
		
		if (tSF_FARP_Refuel_ResoucesLevel - 100*_fuelDiff < 0) then {
			_fuelDiff = tSF_FARP_Refuel_ResoucesLevel/100;
			tSF_FARP_Refuel_ResoucesLevel = 0;
		} else {
			tSF_FARP_Refuel_ResoucesLevel = round( tSF_FARP_Refuel_ResoucesLevel - 100*_fuelDiff );
		};
		publicVariable "tSF_FARP_Refuel_ResoucesLevel";
		
		_veh setFuel (_currentFuelLevel + _fuelDiff);
	};
	
	

	if (_needRearm) then {
		private _setMagazines = [];
		systemChat "Rearm";
		{
			if !((_x select 0) in _setMagazines) then {
				private _magCount = _magazines select (count _setMagazines);
				
				systemChat format ["Rearm : Mags = %1", _magCount];
				if (_magCount != 0) then {
					if (_magCount > 0) then {
						if (tSF_FARP_Rearm_ResoucesLevel < _magCount) then {
							_magCount = tSF_FARP_Rearm_ResoucesLevel;
							tSF_FARP_Rearm_ResoucesLevel = 0;
						};
					
						for "_i" from 0 to _magCount do {	
							systemChat format ["Rearm : Add mag %1", _x select 0];
							_veh addMagazineTurret [_x select 0, _x select 1];
							tSF_FARP_Rearm_ResoucesLevel = tSF_FARP_Rearm_ResoucesLevel - 1;
						};
					} else {
						for "_i" from 0 to abs(_magCount) do {
							systemChat format ["Rearm : Remove mag %1", _x select 0];
							_veh removeMagazineTurret [_x select 0, _x select 1];
							tSF_FARP_Rearm_ResoucesLevel = tSF_FARP_Rearm_ResoucesLevel + 1;
						};
					};
				};
				_setMagazines pushBack (_x select 0);
				
			};			
		} forEach (magazinesAllTurrets _veh);
		publicVariable "tSF_FARP_Rearm_ResoucesLevel";
	};
	
};
