// #define	DEBUGIF(X)	if (true) then { X }
#define	DEBUGIF(X)	if (false) then { X }

/*
 *	PickUp Request
 */
 
// ***** CLIENT SIDE *****

tSF_fnc_AirborneSupport_Pickup_Action = {	
	private _veh = _this call tSF_fnc_AirborneSupport_getByCallsign;
	openMap [true, false];
	
	[
		_veh
		, "Pickup Requested"
		, "Select INGRESS waypoint!"
	] call tSF_fnc_AirborneSupport_showHint;	
	
	["tSF_AirborneSupport_clickForPickup", "onMapSingleClick", {		
		[_this, _pos] spawn {
			params ["_veh","_ingress"];
			hintSilent "";
			sleep 1;
			
			openMap [true,false];
			
			[
				_veh
				, "Pickup Requested"
				, "Select LZ!"
			] call tSF_fnc_AirborneSupport_showHint;
		
			["tSF_AirborneSupport_clickForPickupLZ", "onMapSingleClick", {
				if (_pos call dzn_fnc_isInWater) exitWith { systemChat "Landing Zone should not be in water!"; };

				openMap [false,false];
				private _veh = _this select 0;
				private _ingress = _this select 1;
				private _lz = _pos;
			
				[_veh, _ingress, _lz] call tSF_fnc_AirborneSupport_Pickup_Call;
				
				[
					_veh
					, "Pickup Requested"
					, "Approaching to AO!"
				] call tSF_fnc_AirborneSupport_showHint;
				[_veh, "Leaving base and approaching to AO!"] call tSF_fnc_AirborneSupport_showMsg;
			
				["tSF_AirborneSupport_clickForPickupLZ", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
			}, [_veh,_ingress]] call BIS_fnc_addStackedEventHandler;		
		};		

		["tSF_AirborneSupport_clickForPickup", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
	}, _veh] call BIS_fnc_addStackedEventHandler;
};

tSF_fnc_AirborneSupport_Pickup_Call = {
	params ["_veh", "_ingress","_lz"];
	
	_veh engineOn true;	
	_veh setVariable ["tSF_AirborneSupport_IngressPoint", _ingress, true];
	_veh setVariable ["tSF_AirborneSupport_LandingPoint", _lz, true];
	_veh setVariable ["tSF_AirborneSupport_Side", side player, true];	
	_veh setVariable ["tSF_AirborneSupport_Status", "Pickup", true];
};
 
 
// ***** SERVER SIDE *****

tSF_fnc_AirborneSupport_Pickup_Do = {
	private _veh = _this;
	private _ingressPoint = _veh getVariable "tSF_AirborneSupport_IngressPoint";
	private _landingPoint = _veh getVariable "tSF_AirborneSupport_LandingPoint";
	private _helipad = [
		[_landingPoint, _ingressPoint getDir _landingPoint]
		, "Land_HelipadEmpty_F"
	] call dzn_fnc_createVehicle;	
	
	DEBUGIF(systemChat "Pickup: LZ created";);
	
	private _pilot = _veh call tSF_fnc_AirborneSupport_AddPilot;	
	_veh engineOn true;
	
	DEBUGIF(systemChat "Pickup: Pilot assigned";);
	
	[_pilot, _ingressPoint, 400] call tSF_fnc_AirborneSupport_MoveToPosition;
	
	DEBUGIF(systemChat "Pickup: Moving to Egress point";);
	
	waitUntil {
		sleep 5;
		DEBUGIF(systemChat format ["Pickup: Check Ingress point reached -- %1", _veh distance _ingressPoint < 400];);
		_veh distance _ingressPoint < 400
	};	
	[_pilot, _landingPoint] call tSF_fnc_AirborneSupport_MoveToPosition;
	
	waitUntil {
		sleep 5;
		DEBUGIF(systemChat format ["Pickup: Check Return point reached -- %1", _veh distance _landingPoint < 200 && currentWaypoint (group _pilot) > 0]; );
		_veh distance _landingPoint < 200 && currentWaypoint (group _pilot) > 0
	};
	
	DEBUGIF(systemChat "Pickup: Landing";);
	[_veh, "GET IN"] spawn tSF_fnc_AirborneSupport_Land;
};
