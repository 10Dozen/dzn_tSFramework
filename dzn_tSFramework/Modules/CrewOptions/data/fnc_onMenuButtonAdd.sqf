#include "script_component.hpp"

/*
    Handles menu '+' (add) and '++' (add to player's group) actions.
    (_self)

    Params:
        _cob (HASHMAP) - ShowAdvDialog2 object.
        _args (ARRAY) - list of argumentss:
            _crewOptions (HASHMAPOBJECT) - CrewOptions COB.
            _vehicle (OBJECT) - target vehicle.
            _seat (HASHMAP) - slot configuration.
            _joinPlayerGroup (BOOL) - flag to AI unit to join player's group.
    Returns:
        none

    _self call ["fnc_actionCondition", [_vehicle]];
*/

params ["_advDialog","_args"];
_args params ["_crewOptions", "_vehicle", "_seat", "_joinPlayerGroup"];

_crewOptions call [F(addCrew), [_vehicle, _seat, _joinPlayerGroup]];

_advDialog call ["Close"];
[
    {
        params ["_crewOptions", "_vehicle", "_seatCfg"];
        !isNull (_crewOptions call [F(getUnitOnSeat), [_vehicle, _seatCfg get Q(seat)]])
    },
    {
        params ["_crewOptions", "_vehicle", "_seatCfg"];
        _crewOptions call [F(openCrewMenu), [_vehicle]];
    },
    [_crewOptions, _vehicle, _seat],
    1
] call CBA_fnc_waitUntilAndExecute;
