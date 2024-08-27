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

if (player == tSF_Admin) exitWith { true };

private _cfg = SETTING_OR_DEFAULT_3(_self,Configs,_vehicle getVariable GAMELOGIC_FLAG,Q(allowedForRoles));
private _playerRole = roleDescription player;

// At least 1 match for player role
(_cfg findIf { [_x, _playerRole, false] call BIS_fnc_inString }) > -1
