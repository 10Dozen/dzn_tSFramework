#include "script_component.hpp"

FUNC(checkPlayerAuthorized) = {
	/*
		Returns authorization status of player according to it's role.

		Params:
		_unit -- unit to check <OBJECT>
		_authorizationType -- type of authorization to check: "ARTILLERY", "AIRBORNE", "POM" <STRING>

		Returns:
		_isAuthorized -- authorization status <BOOLEAN>
	*/

	params ["_unit","_authorizationType"];
	private _authTypeIdx = AUTHORIZATION_TYPES find toUpper(_authorizationType);

	// Return true if authorized for everyone
	if (tSF_Authorization_CommonPermissions # _authTypeIdx) exitWith { true };

	// Return Admin permissions if player is admin and there are admin permissions defined
	private _perms = ["Admin"] call FUNC(getRolePermissions);
	if (
		(serverCommandAvailable "#logout" || !isMultiplayer || isServer)
		&& { !(_perms isEqualTo []) }
	) exitWith {
		_perms # _authTypeIdx
	};

	// Return player's role permissions if found and true 
	_perms = [roleDescription _unit] call FUNC(getRolePermissions);
	if (!(_perms isEqualTo []) && {_perms # _authTypeIdx}) exitWith { true };

	// Returns "Any" role permissions if found and true, or return false
	_perms = ["Any"] call FUNC(getRolePermissions);
	if (_perms isEqualTo []) exitWith { false };

	_perms # _authTypeIdx
};

FUNC(getRolePermissions) = {
	params ["_rolename"];
	_rolename = toLower (_rolename);

	private _foundByName = GVAR(RuleList) findIf { [_x # 0, _rolename, false] call  BIS_fnc_inString };
	if (_foundByName < 0) exitWith { [] };

	(GVAR(RuleList) # _foundByName) # 1
};
