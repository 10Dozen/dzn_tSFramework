tSF_ArtillerySupport_processLogics = {
	{
		private _logic = _x;
		
		if (!isNil { _logic getVariable "tSF_ArtillerySupport" }) then {
			private _guns = synchronizedObjects _logic select { !(_x isKindOf "Logic") };
			
			tSF_ArtillerySupport_Batteries pushBack [
				_guns
				, _logic getVariable "tSF_ArtillerySupport"
			];
		};
	} forEach (entities "Logic");
};

/*
 *	General
 */
tSF_fnc_ArtillerySupport_isAuthorizedUser = {
	private _unit = _this;	
	private _result = false;
	
	private _listOfAuthorizedUsers = tSF_ArtillerySupport_AuthorizedUsers apply { toLower(_x) };
	
	if (
		"any" in _listOfAuthorizedUsers
		|| toLower(roleDescription _unit) in  _listOfAuthorizedUsers
	) exitWith { true };
	
	if ("admin" in _listOfAuthorizedUsers) exitWith {
		(serverCommandAvailable "#logout") || !(isMultiplayer) || isServer	
	};
	
	_result
};
