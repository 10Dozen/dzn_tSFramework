tSF_fnc_Authorization_checkPlayerAuthorized = {
	/*
		Returns authorization status of player according to it's role.

		Params:
		_unit -- unit to check <OBJECT>
		_authorizationType -- type of authorization to check: "ARTILLERY", "AIRBORNE", "POM" <STRING>

		Returns:
		_isAuthorized -- authorization status <BOOLEAN>
	*/

	params ["_unit","_authorizationType"];
	private _authTypeIdx = ["ARTILLERY", "AIRBORNE", "POM"] find toUpper(_authorizationType);

	// Return true if sauthorized for everyone
	if (tSF_Authorization_CommonPermissions # _authTypeIdx) exitWith { true };

	// Return Admin permissions if player is admin and there are admin permissions defined
	private _perms = ["Admin"] call tSF_fnc_Authorization_getRolePermissions;
	if (
		(serverCommandAvailable "#logout" || !isMultiplayer || isServer)
		&& { !(_perms isEqualTo []) }
	) exitWith {
		_perms # _authTypeIdx
	};

	// Return player's role permissions or false, if no any permissions defined for role
	_perms = [roleDescription _unit] call tSF_fnc_Authorization_getRolePermissions;
	if (_perms isEqualTo []) exitWith { false };

	_perms # _authTypeIdx
};

tSF_fnc_Authorization_getRolePermissions = {
	params ["_rolename"];
	_rolename = toLower (_rolename);

	private _foundByName = tSF_Authorization_List findIf { [_x # 0, _rolename, false] call  BIS_fnc_inString };
	if (_foundByName < 0) exitWith { [] };

	(tSF_Authorization_List # _foundByName) # 1
};
