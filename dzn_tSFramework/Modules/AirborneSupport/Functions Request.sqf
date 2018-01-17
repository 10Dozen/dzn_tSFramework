
/*
 *	Vehicle Availability
 */

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
	
	if !([_veh, "STATE", "Waiting"] call tSF_fnc_AirborneSupport_AssertStatus) exitWith { false };
	
	private _result = true;
	
	switch toLower(_type) do {
		case "rtb": {
			_result = (_veh distance2d ([_veh, "RTB POINT"] call tSF_fnc_AirborneSupport_GetStatus) > 30);
		};
		case "callin": {
			_result = !isPlayer (driver _veh);
		};
		case "pickup": {
			_result = true;
		};
	};
	
	_result
};


/*
 *	MENU
 */
tSF_fnc_AirborneSupport_ShowMenu = {
	params["_callsign"];
	
	if !(player call tSF_fnc_AirborneSupport_isAuthorizedUser) exitWith {};
	private _veh = (_callsign call tSF_fnc_AirborneSupport_GetProvider) select 0;
	if !(_veh call tSF_fnc_AirborneSupport_checkVehicleAvailable) exitWith {	
		[_veh, "IS NOT AVAILABLE", ""] call tSF_fnc_AirborneSupport_showHint;
	};
	
	private _inProgress = (
		!([_veh, "STATE", "Waiting"] call tSF_fnc_AirborneSupport_AssertStatus) 
		&& [_veh, "IN PROGRESS"] call tSF_fnc_AirborneSupport_GetStatus
	);

	private _canRTB = [_veh, "rtb"] call tSF_fnc_AirborneSupport_checkVehicleFree;
	private _canCallin = [_veh, "callin"] call tSF_fnc_AirborneSupport_checkVehicleFree;
	private _canPickup = [_veh, "pickup"] call tSF_fnc_AirborneSupport_checkVehicleFree;

	private _menu = [
		[0, "HEADER", "AIRBORNE SUPPORT"]
		, [1, "LABEL", "<t align='center' color='#c1c1c1'>CALLSIGN | TYPE</t>"]
		, [2, "LABEL", format ["<t align='center' font='PuristaBold'>%1</t>", _callsign] ]
		, [3, "LABEL", format ["<t align='center' color='#c1c1c1'>%1</t>", (typeof _veh) call dzn_fnc_getVehicleDisplayName] ]
		, [4, "LABEL", ""]
	];
	
	private _i = 5;
	if (_inProgress) then {
		_menu pushBack [_i, "HEADER", format [
			"<t font='PuristaBold' align='center'>MISSION IN PROGRESS</t><t align='center'> [ %1 ]</t>"
			, [_veh, "STATE"] call tSF_fnc_AirborneSupport_GetStatus
		]];
		_menu pushBack [_i + 1, "BUTTON", "<t align='center'>ABORT CURRENT MISSION</t>", {
			closeDialog 2;
			_args call tSF_fnc_AirborneSupport_AbortMission;
		}, _callsign];
		_i = _i + 2;
	} else {
		_menu pushBack [_i, "HEADER", "<t font='PuristaBold' align='center'>READY FOR MISSION</t>"];
		_i = _i + 1;
		
		if (tSF_AirborneSupport_ReturnToBase && _canRTB) then {
			_menu pushBack [_i, "BUTTON", "<t align='center'>RETURN TO BASE</t>", {
				closeDialog 2;
				_args call tSF_fnc_AirborneSupport_RTB_Action;
			}, _callsign];
			_i = _i + 1;
		};
		
		if (tSF_AirborneSupport_RequestPickup && _canPickup) then {
			_menu pushBack [_i, "BUTTON", "<t align='center'>REQUEST PICKUP</t>", { 
				closeDialog 2;
				_args call tSF_fnc_AirborneSupport_Pickup_Action;
			}, _callsign];
			_i = _i + 1;
		};

		if (tSF_AirborneSupport_CallIn && _canCallin) then {
			_menu pushBack [_i, "BUTTON", "<t align='center'>CALL IN</t>", {
				closeDialog 2;
				_args call tSF_fnc_AirborneSupport_Callin_Action;
			}, _callsign];
			_i = _i + 1;
		};
	};
	
	_menu pushBack [_i, "BUTTON", "<t align='center'>CANCEL</t>", { closeDialog 2 }];
	_menu call dzn_fnc_ShowAdvDialog;
};

/*
 *	Requseting
 */

tSF_fnc_AirborneSupport_showHint = {
	params["_veh","_title","_subtitle"];
	
	private _callsign = [_veh, "CALLSIGN"] call tSF_fnc_AirborneSupport_GetStatus;
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


/*
 *	Pick Up
 */
 
tSF_fnc_AirborneSupport_Pickup_Action = {	
	private _veh = (_this call tSF_fnc_AirborneSupport_GetProvider) select 0;
	openMap [true, false];
	
	[
		_veh
		, "Pickup Requested"
		, "<t size='0.8'>(Step 1 of 2)</t><br />Select INGRESS waypoint!"
	] call tSF_fnc_AirborneSupport_showHint;	
	
	["tSF_AirborneSupport_clickForPickup", "onMapSingleClick", {
		tSF_Ingress_Mrk = ["tSF_Ingress", _pos, "mil_marker", "ColorCIV", "Ingress", true] call dzn_fnc_createMarkerIcon;
		
		[_this select 4, _pos] spawn {
			params ["_veh","_ingress"];
			hintSilent "";
			sleep 0.5;
			
			openMap [true,false];
			
			[
				_veh
				, "Pickup Requested"
				, "<t size='0.8'>(Step 2 of 2)</t><br />Select LZ!"
			] call tSF_fnc_AirborneSupport_showHint;
		
			["tSF_AirborneSupport_clickForPickupLZ", "onMapSingleClick", {
				if (_pos call dzn_fnc_isInWater) exitWith { systemChat "Landing Zone should not be in water!"; };
				
				openMap [false,false];
				private _veh = _this select 4 select 0;
				private _ingress = _this select 4 select 1;
				private _lz = _pos;
			
				_veh engineOn true;
				[_veh, [
					["STATE", "Pickup"]
					, ["SIDE", side player] 
					, ["LANDING POINT", _lz]
					, ["INGRESS POINT", _ingress]
					, ["IN PROGRESS", true]
				]] call tSF_fnc_AirborneSupport_SetStatus;
				
				[
					_veh
					, "Pickup Requested"
					, "Approaching to AO!"
				] call tSF_fnc_AirborneSupport_showHint;
				[_veh, "Leaving base and approaching to AO!"] call tSF_fnc_AirborneSupport_showMsg;
				
				deleteMarker tSF_Ingress_Mrk;
			
				["tSF_AirborneSupport_clickForPickupLZ", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
			}, [[_veh,_ingress]]] call BIS_fnc_addStackedEventHandler;
		};

		["tSF_AirborneSupport_clickForPickup", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
	}, [_veh]] call BIS_fnc_addStackedEventHandler;
};

tSF_fnc_AirborneSupport_RTB_Action = {	
	private _veh =(_this call tSF_fnc_AirborneSupport_GetProvider) select 0;
	openMap [true, false];
	
	[
		_veh
		, "Returning to base"
		, "Select EGRESS waypoint!"
	] call tSF_fnc_AirborneSupport_showHint;
	
	["tSF_AirborneSupport_clickForRTB", "onMapSingleClick", {
		private _veh =_this select 4;
		
		openMap [false, false];
		
		_veh engineOn true;	
		[_veh, [
			["EGRESS POINT", _pos]
			, ["SIDE", side player]
			, ["STATE", "RTB"]
			, ["IN PROGRESS", true]
		]] call tSF_fnc_AirborneSupport_SetStatus;
		
		[
			_veh
			, "Returning to base"
			, "Leaving AO!"
		] call tSF_fnc_AirborneSupport_showHint;
		
		[_veh, "Leaving AO and returning to base!"] call tSF_fnc_AirborneSupport_showMsg;		
		
		["tSF_AirborneSupport_clickForRTB", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
	}, [_veh]] call BIS_fnc_addStackedEventHandler;
};

tSF_fnc_AirborneSupport_Callin_Action = {
	private _veh = (_this call tSF_fnc_AirborneSupport_GetProvider) select 0;

	"SHOW" call tSF_fnc_AirborneSupport_displayCloseAreaMarker;
	openMap [true, false];

	[
		_veh
		, "Approaching AO"
		, "Select INGRESS waypoint!"
	] call tSF_fnc_AirborneSupport_showHint;

	["tSF_AirborneSupport_clickForCallIn", "onMapSingleClick", {
		private _veh = _this select 4;
		private _ingress = _pos;
		
    		openMap [false, false];
		"HIDE" call tSF_fnc_AirborneSupport_displayCloseAreaMarker;

    		[
			_veh 
			, "Approaching AO"
			, "Assuming direct control in 15 seconds..."
		] call tSF_fnc_AirborneSupport_showHint;
		[_veh, "Approaching AO!"] call tSF_fnc_AirborneSupport_showMsg;

		_veh engineOn true;
		[_veh, [
			["INGRESS POINT", _ingress]
			, ["SIDE", side player]
			, ["STATE", "Call In"]
			, ["IN PROGRESS", true]
		]] call tSF_fnc_AirborneSupport_SetStatus;
		
		[_veh] spawn {
			params["_veh"];
			waitUntil { _veh getVariable ["tSF_AirborneSupport_CallInReady",false] };
			
			private _driver = driver _veh;
			if (!isNull _driver) then {
				moveOut _driver;
				private _grp = group _driver;
				
				deleteVehicle _driver;
				deleteGroup _grp;
			};

			0 cutText ["", "WHITE OUT", 0.1];
			player allowDamage false;
			sleep 1;

			moveOut player;
			player setVelocity [0,0,0];
			player moveInDriver _veh;

			0 cutText ["", "WHITE IN", 1];
			sleep 3;

			player allowDamage true;
			_veh setVariable ["tSF_AirborneSupport_CallInReady", false, true];		
		};

    		["tSF_AirborneSupport_clickForCallIn", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
    	}, [_veh]] call BIS_fnc_addStackedEventHandler;
};


tSF_fnc_AirborneSupport_AbortMission = {
	private _veh = (_this call tSF_fnc_AirborneSupport_GetProvider) select 0;
	
	if ([_veh, "STATE", "Call In"] call tSF_fnc_AirborneSupport_AssertStatus) exitWith {
		systemChat format ["Not possible to abort Call In mission of %1", _this];
		[
			_veh 
			, "Not possible to abort Call In mission"
			, "Wait for mission end"
		] call tSF_fnc_AirborneSupport_showHint;
	};
	
	[_veh, "STATE", "Aborted"] call tSF_fnc_AirborneSupport_SetStatus;
	
	[
		_veh
		, "Mission Aborted"
		, "Waiting for orders!"
	] call tSF_fnc_AirborneSupport_showHint;
	
	_veh spawn {
		sleep 10;
		if ([_this, "STATE", "ABORTED"] call tSF_fnc_AirborneSupport_AssertStatus) then {
			_this call tSF_fnc_AirborneSupport_ResetVehicleVars;
		};
	};
};