// #define	DEBUGIF(X)	if (true) then { X }
#define	DEBUGIF(X)	if (false) then { X }

/*
 *	Return To Base
 */
 
// ***** CLIENT SIDE *****
 
tSF_fnc_Support_RTB_Action = {	
	private _veh = _this call tSF_fnc_Support_getByCallsign;
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
		[_this, "Leaving AO and returning to base!"] call tSF_fnc_Support_showMsg;		
		
		["tSF_Support_clickForRTB", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
	}, _veh] call BIS_fnc_addStackedEventHandler;
};

tSF_fnc_Support_RTB_Call = {
	params ["_veh", "_pos","_deploy"];
	
	_veh engineOn true;	
	_veh setVariable ["tSF_Support_EgressPoint", _pos, true];
	_veh setVariable ["tSF_Support_Side", side player, true];	
	_veh setVariable ["tSF_Support_Status", "RTB", true];
};

// ***** SERVER SIDE *****

tSF_fnc_Support_RTB_Do = {
	private _veh = _this;
	private _egressPoint = _veh getVariable "tSF_Support_EgressPoint";
	
	private _pilot = _veh call tSF_fnc_Support_AddPilot;	
	_veh engineOn true;
	
	DEBUGIF(systemChat "RTB: Pilot assigned";);
	
	[_pilot, _egressPoint, 400] call tSF_fnc_Support_MoveToPosition;
	
	DEBUGIF(systemChat "RTB: Moving to Egress point";);
	
	waitUntil {
		sleep 5;
		DEBUGIF(systemChat format ["RTB: Check Egress point reached -- %1", _veh distance _egressPoint < 400];);
		_veh distance _egressPoint < 400
	};	
	[_pilot, _veh getVariable "tSF_Support_RTBPoint"] call tSF_fnc_Support_MoveToPosition;
	
	waitUntil {
		sleep 5;
		DEBUGIF(systemChat format ["RTB: Check Return point reached -- %1", _veh distance (_veh getVariable "tSF_Support_RTBPoint") < 200 && currentWaypoint (group _pilot) > 0]; );
		_veh distance (_veh getVariable "tSF_Support_RTBPoint") < 200 && currentWaypoint (group _pilot) > 0
	};
	
	DEBUGIF(systemChat "RTB: Landing";);
	[_veh, "LAND"] spawn tSF_fnc_Support_Land;
};