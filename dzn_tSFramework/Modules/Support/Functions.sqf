
/*
 *	General
 */	
tSF_fnc_Support_isAuthorizedUser = {
	// Player call tSF_fnc_Support_isAuthorizedUser
	private _unit = _this;	
	private _result = false;
	
	private _listOfAuthorizedUsers = [];
	{_listOfAuthorizedUsers pushBack toLower(_x);} forEach tSF_Support_AuthorizedUsers;
	
	if (
		"any" in _listOfAuthorizedUsers
		|| toLower(roleDescription _unit) in  _listOfAuthorizedUsers
	) exitWith { true };
	
	if ("admin" in _listOfAuthorizedUsers) exitWith {
		(serverCommandAvailable "#logout") || !(isMultiplayer) || isServer	
	};
	
	_result
};
 
tSF_fnc_Support_getVehicleDisplayName = {
	// Return display name of given classname of vehicle
	// "B_Heli_Transport_01_camo_F" call dzn_atc_fnc_getVehicleDisplayName
	// 0: STRING 	- classname
	// RETURN:		displayed name
	
	private["_class","_item","_CName", "_DName"];
	
	_class = _this;
	
	_item = (( "configName(_x) == _class") configClasses  (configFile >> "CfgVehicles")) select 0;
	_CName = configName(_item);
	_DName = getText(configFile >> "CfgVehicles" >> _CName >> "displayName");
	
	_DName
};

tSF_fnc_Support_getByCallsign = {
	_result = objNull;
	{
		if (_x select 1 == _this) exitWith { _result = _x select 0; };
	} forEach tSF_Support_Vehicles;
	
	_result
};

/*
 * Process vehicles
 */
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
			{
				tSF_Support_ReturnPoints pushBack (getPosATL _x);			
			} forEach (synchronizedObjects _logic);			
		};	
	} forEach (entities "Logic");
	
	if (count tSF_Support_Vehicles > count tSF_Support_ReturnPoints) then {
		diag_log "tSF :: Support :: There are not enough Return points for vehicles";
		["tSF :: Support :: There are not enough Return points for vehicles"] call BIS_fnc_error;
	};
	
	tSF_Support_ReturnPointsList = [] + tSF_Support_ReturnPoints;
};
	
	
tSF_fnc_Support_processVehicleClient = {
	// [@Vehicle, @Name]
	params ["_veh","_name"];
	_veh setVariable ["tSF_Support_Callsign", _name];
	
	_name = if (_name == "") then {(typeOf _veh) call tSF_fnc_Support_getVehicleDisplayName} else {format ["%1 (%2)", _name, typeOf _veh]};
	_veh setVariable ["tSF_Support_Name", _name];
	
	if (tSF_Support_ReturnToBase && player call tSF_fnc_Support_isAuthorizedUser) then {
	
	};
};

tSF_fnc_Support_processVehicleServer = {
	params ["_veh","_name"];
	
	_veh setVariable ["tSF_Support_Callsign", _name];
	_name = if (_name == "") then {(typeOf _veh) call tSF_fnc_Support_getVehicleDisplayName} else {format ["%1 (%2)", _name, typeOf _veh]};
	_veh setVariable ["tSF_Support_Name", _name];
	_veh setVariable ["tSF_Support_RTBPoint", tSF_Support_ReturnPoints call dzn_fnc_selectAndRemove, true];
	
	
};


/*
 *	MENU
 */
 
tSF_fnc_Support_ShowMenu = {
	params["_callsign"];
	
	tSF_Support_SupporterMenu = [[_callsign,false]];
	private _veh = _callsign call tSF_fnc_Support_getByCallsign;
	
	if (
		!(isNil "tSF_fnc_Support_RTB_Available") 
		&& {_veh call tSF_fnc_Support_RTB_Available}
	) then {
		tSF_Support_SupporterMenu pushBack [
			"Return To Base"
			,[2]
			,""
			,-5
			,[["expression", format ["'%1' call tSF_fnc_Support_RTB_Action",_callsign]]]
			,"1"
			,"1"
		];	
	};
	
	showCommandingMenu "#USER:tSF_Support_SupporterMenu";
};


/*
 *	Teleport
 */
 
tSF_fnc_Support_showTeleportMenu = {
	tSF_Support_TeleportMenu = [
		["Re-deploy",false]		
		, ["Deploy to Squad",[2],"",-5,[["expression", "[player,'squad'] spawn tSF_fnc_Support_doTeleport"]],"1","1"]
		, ["Deploy to Base",[3],"",-5,[["expression", "[player,'base'] spawn tSF_fnc_Support_doTeleport"]],"1","1"]
	];
	showCommandingMenu "#USER:tSF_Support_TeleportMenu";
};

tSF_fnc_Support_doTeleport = {
	params["_unit","_dest"];
	
	private _pos = if ("base" == toLower(_dest)) then {
		selectRandom tSF_Support_ReturnPointsList		
	} else {
		getPosATL ( selectRandom (units (group _unit)) )
	};
	
	_pos = [(_pos select 0) + 10, (_pos select 1) - 10,0];
	
	
	0 cutText ["", "WHITE OUT", 0.1];
	_unit allowDamage false;
	sleep 1;					
	moveOut _unit;
	_unit setPosATL _pos;
	sleep 1;
	_unit allowDamage true;	
	
	0 cutText ["", "WHITE IN", 1];
};

