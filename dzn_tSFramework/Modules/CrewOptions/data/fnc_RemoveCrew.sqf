#include "script_component.hpp"

/* TBD
    Checks that player is admin or have whitelisted role name to access 
	crew menu for particular vehicle (and it's config).

    (_self)

    Params:
        _vehicle (OBJECT) - vehicle to check against
    Returns:
        none

    _self call ["fnc_actionCondition", [_vehicle]];
*/

params ["_vehicle", "_seatCfg"];

private _seatName = _seatCfg get Q(seat);
private _unit = _self call [F(getUnitOfSeat), [_vehicle, _seatName]];

if (isNull _unit || { isPlayer _unit }) exitWith {};

moveOut _unit;
deleteVehicle _unit;
