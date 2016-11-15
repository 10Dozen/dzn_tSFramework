tSF_fnc_Support_processLogics = {
		{
			private _logic = _x;
			
			if !(isNil {_logic getVariable "tSF_Support"}) then {
				tSF_Support_Vehicles pushBack [
					(synchronizedObjects _logic) select 0
					, _logic getVariable "tSF_Support"
				];
			};
			
			if !(isNil {_logic getVariable "tSF_Support_ReturnPoint"}) then {
				tSF_Support_ReturnPoint = getPosATL _logic;
			};			
		} forEach (entities "Logic");		
	};
	
	
tSF_fnc_Support_processVehicleClient = {
	// [@Vehicle, @Name]
	params ["_veh","_name"];
	
	_name = if (_name == "") then {typeOf _veh} else {format ["%1 (%2)", _name, typeOf _veh]};
	_veh setVariable ["tSF_Support_Name", _name];
	
	if (tSF_Support_ReturnToBase && tSF_fnc_Support_isAuthorizedUser) then {
		_v call tSF_fnc_Support_RTB_AddAction;	
	};
};

tSF_fnc_Support_isAuthorizedUser = {
	// Player call tSF_fnc_Support_isAuthorizedUser
	true
};


tSF_fnc_Support_RTB_AddAction = {
	[
		_this 
		, "<t color='#edb125'># Return to base</t>"
		, {
			hint "RTB INITIATED";
			
			_v = _this select 0;
			openMap [true, false];
			systemChat "Select egress waypoint!";
			
			["tSF_Support_clickForRTB", "onMapSingleClick", {			
				[_this, _pos] call tSF_fnc_Support_CallRerturnToBase;
				systemChat format ["This is %1, Returning to base!", _v getVariable "tSF_Support_Name"];
				
				["tSF_Support_clickForRTB", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
			}, _v] call BIS_fnc_addStackedEventHandler;
		}
		, 10
		, "_target call tSF_fnc_Support_RTB_Available"
		, 1
	] call dzn_fnc_addAction;
	
	/*
	[
		_this 
		, "<t color='#edb125'># Deploy All & Return to base</t>"
		, {
			hint "Deploy & RTB INITIATED";
			
			_v = _this select 0;
			openMap [true, false];
			systemChat "Select egress waypoint!";
			
			["tSF_Support_clickForRTB", "onMapSingleClick", {			
				[_this, _pos] call tSF_fnc_Support_CallRerturnToBase;
				systemChat format ["This is %1, Returning to base!", _v getVariable "tSF_Support_Name"];
				
				["tSF_Support_clickForRTB", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
			}, _v] call BIS_fnc_addStackedEventHandler;
		}
		, 10
		, "_target call tSF_fnc_Support_RTB_Available"
		, 1
	] call dzn_fnc_addAction;
	*/
};

tSF_fnc_Support_RTB_Available= {
	true
};

tSF_fnc_Support_RTB_Call = {
	// _vehicle, _pos
	params ["_veh", "_pos","_deploy"];
	
	_veh setVariable ["tSF_Support_doRTB", true, true];
	_veh setVariable ["tSF_Support_EgressPoint", _pos, true];
	_veh setVariable ["tSF_Support_ClearOut", _deploy, true];
	_veh setVariable ["tSF_Support_Side", side player, true];
};

tSF_fnc_Support_RTB_Do = {
	private _veh = _this;	
	
	_veh lock true;
	private _pilot = (units ([
		_veh
		, _veh getVariable "tSF_Support_Side"
		, ["driver"]
		, "tSF_Support_PilotKit"
		, 0
	] call dzn_fnc_createVehicleCrew)) select 0;
	
	_pilot doMove (_veh getVariable "tSF_Support_EgressPoint");
	
	_pilot disableAI "TARGET";
	_pilot disableAI "AUTOTARGET";
	_pilot disableAI "SUPPRESSION";
	_pilot disableAI "AIMINGERROR";
	_pilot disableAI "COVER";
	_pilot disableAI "AUTOCOMBAT";	
	
	[
		_pilot
		, _veh getVariable "tSF_Support_EgressPoint"
	] spawn {
		params ["_pilot","_egress"];
	
		for "_i" from 0 to 10 do {
			sleep 5;
			if (_pilot distance2d _egress < 400) then {
				_pilot doMove _egress;
			} else {
				_pilot doMove tSF_Support_ReturnPoint;
			};
		};
	};
};


