/*
 *	Return To Base
 */
 
tSF_fnc_Support_RTB_Available = {
	private _veh = _this;
	
	!(_veh getVariable ["tSF_Support_doRTB", false])
	&& !(_veh getVariable ["tSF_Support_InProgress", false]) 
	&& {_veh distance2d (_veh getVariable "tSF_Support_RTBPoint") > 200}
};


// CLIENT SIDE

tSF_fnc_Support_RTB_Action = {	
	_veh = _this call tSF_fnc_Support_getByCallsign;
	openMap [true, false];
	
	[
		_veh
		, "Returning to base"
		, "Select EGRESS waypoint!"
	] call tSF_fnc_Support_showHint;
	
	["tSF_Support_clickForRTB", "onMapSingleClick", {
		openMap [false, false];
		[_this, _pos, true] call tSF_fnc_Support_RTB_Call;
		
		[
			_this
			, "Returning to base"
			, "Leaving AO!"
		] call tSF_fnc_Support_showHint;
		systemChat format ["This is %1, Returning to base!", _this getVariable "tSF_Support_Callsign"];
		
		["tSF_Support_clickForRTB", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
	}, _veh] call BIS_fnc_addStackedEventHandler;
};

tSF_fnc_Support_RTB_Call = {
	// _vehicle, _pos
	params ["_veh", "_pos","_deploy"];
	
	_veh engineOn true;
	_veh setVariable ["tSF_Support_doRTB", true, true];
	_veh setVariable ["tSF_Support_InProgress", false, true];
	_veh setVariable ["tSF_Support_EgressPoint", _pos, true];
	_veh setVariable ["tSF_Support_ClearOut", _deploy, true];
	_veh setVariable ["tSF_Support_Side", side player, true];
};
 

// SERVER SIDE

tSF_fnc_Support_RTB_Handle = {
	tSF_fnc_Support_RTB_CanCheck = true;
	tSF_fnc_Support_RTB_waitAndCheck = { 
		tSF_fnc_Support_RTB_CanCheck=false; 
		sleep tSF_Support_RTB_CheckTimeout; 
		tSF_fnc_Support_RTB_CanCheck=true;
	};

	["tSF_Support_RTB", "onEachFrame", {
		if !(tSF_fnc_Support_RTB_CanCheck) exitWith {};
		[] spawn tSF_fnc_Support_RTB_waitAndCheck;
		
		{
			private _veh = _x select 0;			
			
			if (_veh getVariable ["tSF_Support_doRTB", false]) then {
				_veh setVariable ["tSF_Support_doRTB", false, true];
				_veh setVariable ["tSF_Support_InProgress", true, true];
				
				_veh spawn tSF_fnc_Support_RTB_Do;			
			};			
		} forEach tSF_Support_Vehicles;
	}] call BIS_fnc_addStackedEventHandler;
};

tSF_fnc_Support_RTB_Do = {
	private _veh = _this;	
	_veh engineOn true;
	
	private _pilot = (units ([
		_veh
		, _veh getVariable "tSF_Support_Side"
		, ["driver"]
		, tSF_Support_PilotKit
		, 0
	] call dzn_fnc_createVehicleCrew)) select 0;
	
	_veh lock true;
	
	_pilot doMove (_veh getVariable "tSF_Support_EgressPoint");
	
	_pilot disableAI "TARGET";
	_pilot disableAI "AUTOTARGET";
	_pilot disableAI "SUPPRESSION";
	_pilot disableAI "AIMINGERROR";
	_pilot disableAI "COVER";
	_pilot disableAI "AUTOCOMBAT";
	
	[
		_pilot
		, _veh
		, _veh getVariable "tSF_Support_EgressPoint"		
	] spawn {
		params ["_pilot","_veh","_egress"];
	
		waitUntil {
			sleep 5;
			_pilot doMove _egress;
			_pilot distance2d _egress < 400
		};
	
		waitUntil {
			sleep 5;
			_pilot doMove (_veh getVariable "tSF_Support_RTBPoint");
			_pilot distance2d (_veh getVariable "tSF_Support_RTBPoint") < 400
		};		
		
		_veh land "LAND";			
		moveOut _pilot;
		private _grp = group _pilot;
		
		deleteVehicle _pilot;
		deleteGroup _grp;
		
		_veh spawn tSF_fnc_Support_RTB_ReturnVehicle;	
	};
};

tSF_fnc_Support_RTB_ReturnVehicle = {
	private _veh = _this;
	_veh lock false;
	
	_veh allowDamage false;
	for "_i" from 0 to 5 do {
		_veh setVelocity [0,0,0];
		_veh setPos (_veh getVariable "tSF_Support_RTBPoint");
		_veh engineOn false;
	
		sleep 2;
	};
	
	_veh setVariable ["tSF_Support_doRTB", false, true];
	_veh setVariable ["tSF_Support_InProgress", false, true];
	_veh setVariable ["tSF_Support_EgressPoint", [], true];
	_veh setVariable ["tSF_Support_ClearOut", false, true];
	
	_veh allowDamage true;
};