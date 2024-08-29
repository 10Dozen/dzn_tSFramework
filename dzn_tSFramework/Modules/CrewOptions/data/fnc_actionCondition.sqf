#include "script_component.hpp"

#define ACTION_TITLE Q(<t color=COLOR_HEX_LIGHT_BLUE>Экипаж</t>)

/*
    Checks that player is admin or have whitelisted role name to access 
	crew menu for particular vehicle (and it's config).

    (_self)

    Params:
        _vehicle (OBJECT) - vehicle to check against
    Returns:
        none

    _self call ["fnc_actionCondition", [_vehicle]];
*/

params["_vehicle"];

private _isInVehicle = player in _vehicle;

if (_isInVehicle && player == tSF_Admin) exitWith { true };

private _cfgName = _vehicle getVariable GAMELOGIC_FLAG;
private _cfg = SETTING(_self,Configs) get _cfgName get Q(allowedForRoles);
private _playerRole = roleDescription player;

// At least 1 match for player role
_isInVehicle && (_cfg findIf { [_x, _playerRole, false] call BIS_fnc_inString }) > -1