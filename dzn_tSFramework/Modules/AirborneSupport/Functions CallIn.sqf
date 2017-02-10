//#define	DEBUGIF(X)	if (true) then { X }
#define	DEBUGIF(X)	if (false) then { X }

/*
 *	CallIn Request
 */
 
// ***** CLIENT SIDE *****

tSF_fnc_AirborneSupport_Callin_Action = {
	private _veh = _this call tSF_fnc_AirborneSupport_getByCallsign;

	"SHOW" call tSF_fnc_AirborneSupport_displayCloseAreaMarker;
	openMap [true, false];

	[
		_veh
		, "Approaching AO"
		, "Select INGRESS waypoint!"
	] call tSF_fnc_AirborneSupport_showHint;

	["tSF_AirborneSupport_clickForCallIn", "onMapSingleClick", {
    		openMap [false, false];
		"HIDE" call tSF_fnc_AirborneSupport_displayCloseAreaMarker;

    		[
			_this
			, "Approaching AO"
			, "Assuming direct control in 15 seconds..."
		] call tSF_fnc_AirborneSupport_showHint;
		[_this, "Approaching AO!"] call tSF_fnc_AirborneSupport_showMsg;

		[_this, _pos] spawn tSF_fnc_AirborneSupport_Callin_Call;

    		["tSF_AirborneSupport_clickForCallIn", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
    	}, _veh] call BIS_fnc_addStackedEventHandler;
};

tSF_fnc_AirborneSupport_Callin_Call = {
	params["_veh","_ingress"];

	_veh engineOn true;
    _veh setVariable ["tSF_SupportIngressPoint", _ingress, true];
    _veh setVariable ["tSF_AirborneSupport_Side", side player, true];
    _veh setVariable ["tSF_AirborneSupport_Status", "CallIn", true];

	waitUntil { _veh getVariable ["tSF_AirborneSupport_CallInReady",false] };

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

 
// ***** SERVER SIDE *****

tSF_fnc_AirborneSupport_Callin_Do = {
	private _veh = _this;
	private _ingressPoint = _veh getVariable "tSF_SupportIngressPoint";
	_ingressPoint set [2,100];

	DEBUGIF(systemChat "Callin: Waiting for engine start";);

	_veh engineOn true;
	sleep 15;

	DEBUGIF(systemChat "Callin: Moving vehicle to ingress position";);

	_veh setPosATL _ingressPoint;
	_veh setDir (_veh getDir _ingressPoint);
	[_veh, [0,20,25]] call KK_fnc_setVelocityModelSpaceVisual;

	DEBUGIF(systemChat "Callin: Vehicle ready";);

	private _pilot = driver _veh;
	if (!isPlayer _pilot) then {
		moveOut _pilot;
		private _grp = group _pilot;
		deleteVehicle _pilot;
		deleteGroup _grp;
	};
	
	_veh setVariable ["tSF_AirborneSupport_CallInReady", true, true];
	
	waitUntil {
		sleep 5;
		DEBUGIF(systemChat "Callin: Waiting for player-driver.";);
		!isNull (driver _veh)
	};
	waitUntil {
		DEBUGIF(systemChat "Callin: Waiting for driver leaving";);
		isNull (driver _veh)
	};

	DEBUGIF(systemChat "Callin: Ends";);
	_veh call tSF_fnc_AirborneSupport_ResetVehicleVars;
};
