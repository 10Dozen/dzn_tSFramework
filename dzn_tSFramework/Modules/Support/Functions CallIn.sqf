
/*
 *	Call In
 */
 
tSF_fnc_Support_CallIn_Available = {
	private _veh = _this;
	
	!(_veh getVariable ["tSF_Support_doRTB", false])
	&& !(_veh getVariable ["tSF_Support_InProgress", false]) 
	&& !(_veh getVariable ["tSF_Support_doCallIn", false])
};

// CLIENT SIDE
tSF_fnc_Support_CallIn_Action = {
	_veh = _this call tSF_fnc_Support_getByCallsign;
	
	call tSF_fnc_Support_CallIn_showCloseAreaMarker;
	openMap [true, false];
	
	player setVariable ["tS_Support_CalledIn", true, true];
	
	[
		_veh
		, "Approaching AO"
		, "Select INGRESS waypoint!"
	] call tSF_fnc_Support_showHint;
	
	["tSF_Support_clickForCallIn", "onMapSingleClick", {			
		[_this, _pos, true] call tSF_fnc_Support_CallIn_Call;
		
		[
			_this
			, "Approaching AO"
			, "Assuming direct control in 15 seconds..."
		] call tSF_fnc_Support_showHint;
		systemChat format ["This is %1, approaching AO!", _this getVariable "tSF_Support_Callsign"];
		
		_this spawn {
			openMap [false, false];
			call tSF_fnc_Support_CallIn_hideCloseAreaMarker;
			
			waitUntil { _this getVariable ["tSF_Support_CallInReady",false] };
			
			0 cutText ["", "WHITE OUT", 0.1];
			player allowDamage false;
			sleep 1;
			
			moveOut player;	
			player setVelocity [0,0,0];
			player moveInDriver _this;	
			
			0 cutText ["", "WHITE IN", 1];
			sleep 3;
			
			player allowDamage true;
			
			_this setVariable ["tSF_Support_CallInReady", false, true];
			player setVariable ["tS_Support_CalledIn", false, true];
		};		
		
		["tSF_Support_clickForCallIn", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
	}, _veh] call BIS_fnc_addStackedEventHandler;
};

tSF_fnc_Support_CallIn_Call = {
	params ["_veh", "_pos","_deploy"];
	
	_veh setVariable ["tSF_Support_doRTB", false, true];	
	_veh setVariable ["tSF_Support_doCallIn", true, true];
	_veh setVariable ["tSF_Support_InProgress", false, true];	
	_veh setVariable ["tSF_Support_IngressPoint", _pos, true];
};

tSF_fnc_Support_CallIn_showCloseAreaMarker = {
	// Create marker to represent area too close to spawn air taxi unit
	private _closeAreaMarker = createMarkerLocal ["tSF_Support_CloseAreaMarker", [getPosASL player select 0, getPosASL player select 1]];
	"tSF_Support_CloseAreaMarker" setMarkerShapeLocal "ELLIPSE";
	"tSF_Support_CloseAreaMarker" setMarkerSizeLocal [tSF_Support_CallIn_MinDistance, tSF_Support_CallIn_MinDistance];
	"tSF_Support_CloseAreaMarker" setMarkerColorLocal "ColorRed";
	"tSF_Support_CloseAreaMarker" setMarkerAlphaLocal 0.5;	
};

tSF_fnc_Support_CallIn_hideCloseAreaMarker = {
	deleteMarkerLocal "tSF_Support_CloseAreaMarker";
};


// SERVER SIDE

tSF_fnc_Support_CallIn_Handle = {
	tSF_fnc_Support_CallIn_CanCheck = true;
	tSF_fnc_Support_CallIn_waitAndCheck = { 
		tSF_fnc_Support_RTB_CanCheck=false; 
		sleep tSF_Support_CallIn_CheckTimeout; 
		tSF_fnc_Support_RTB_CanCheck=true;
	};

	["tSF_Support_CallIn", "onEachFrame", {
		if !(tSF_fnc_Support_CallIn_CanCheck) exitWith {};
		[] spawn tSF_fnc_Support_CallIn_waitAndCheck;
		
		{
			private _veh = _x select 0;
			
			if (_veh getVariable ["tSF_Support_doCallIn", false]) then {
				_veh setVariable ["tSF_Support_doCallIn", false, true];
				_veh setVariable ["tSF_Support_InProgress", true, true];
				
				_veh spawn tSF_fnc_Support_CallIn_Do;			
			};			
		} forEach tSF_Support_Vehicles;
	}] call BIS_fnc_addStackedEventHandler;
};


/* Should be CLIENT SIDE lol */
tSF_fnc_Support_CallIn_Do = {
	private _veh = _this;
	
	_veh engineOn true;
	sleep 15;
	
	private _pos = _veh getVariable "tSF_Support_IngressPoint";
	_pos set [2, 100];
	_veh setPosATL _pos;	
	
	_veh setDir ([_veh, player] call BIS_fnc_dirTo);			
	[_veh, [0,20,25]] call KK_fnc_setVelocityModelSpaceVisual;
	
	_veh setVariable ["tSF_Support_CallInReady", true, true];
	
	waitUntil { sleep 5; !isNull (driver _veh) };
	waitUntil { isNull (driver _veh) };
	_veh setVariable ["tSF_Support_InProgress", false, true];
	_veh setVariable ["tSF_Support_CallInReady", false, true];
};


KK_fnc_setVelocityModelSpaceVisual = {
    private "_o";
    _o = _this select 0;
    _o setVelocity (
        _o modelToWorldVisual (_this select 1) vectorDiff (
            _o modelToWorldVisual [0,0,0]
        )
    );
};

