#include "script_component.hpp"

/*
    Handles menu '-' (remove) action.
    (_self)

    Params:
        _cob (HASHMAP) - ShowAdvDialog2 object.
        _args (ARRAY) - list of argumentss:
            _crewOptions (HASHMAPOBJECT) - CrewOptions COB.
            _vehicle (OBJECT) - target vehicle.
            _seat (HASHMAP) - slot configuration.
            _reAdd (BOOL) - flag to re-add AI unit.
            _joinGroup (BOOL) - flag for AI to join player's group.
    Returns:
        none

    _self call ["fnc_actionCondition", [_vehicle]];
*/

 params ["_advDialog","_args"];
_args params ["_crewOptions", "_vehicle", "_seat", "_reAdd", "_joinGroup"];

// -- Get existing unit props
private _unit = _crewOptions call [F(getUnitOnSeat), [_vehicle, _seat get Q(seat)]];
if (isNull _unit) exitWith {
    hint format ["Место %1 пустое!", _seat get Q(seat)];
};
if (isPlayer _unit) exitWith {
    hint format ["Место %1 занято игроком!", _seat get Q(seat)];
};

private _reopenCondition = {
    params ["_crewOptions", "_vehicle", "_seatCfg"];
    isNull (_crewOptions call [F(getUnitOnSeat), [_vehicle, _seatCfg get Q(seat)]])
};

// -- Remove unit 
_crewOptions call [F(removeCrew), [_vehicle, _seat]];
_advDialog call ["Close"];

// -- If reAdd - add crew member and change menu re-open condition 
if (_reAdd) exitWith {
    DEBUG_3("(onMenuButtonRemove) Schedule re-add crew: _vehicle=%1, _seat=%2, _joinGroup=%3", _vehicle, _seat, _joinGroup);
    [
        _reopenCondition,
         {
            params ["_crewOptions", "_vehicle", "_seatCfg", "_joinGroup"];
            _crewOptions call [F(addCrew), [_vehicle, _seatCfg, _joinGroup]];
            // -- Re-open menu once new unit added
            [
                {
                    params ["_crewOptions", "_vehicle", "_seatCfg"];
                    !isNull (_crewOptions call [F(getUnitOnSeat), [_vehicle, _seatCfg get Q(seat)]])
                },
                {
                    params ["_crewOptions", "_vehicle"]; 
                    _crewOptions call [F(openCrewMenu), [_vehicle]];
                },
                [_crewOptions, _vehicle, _seatCfg],
                1
            ] call CBA_fnc_waitUntilAndExecute;
        },
        [_crewOptions, _vehicle, _seat, _joinGroup],
        1
    ] call CBA_fnc_waitUntilAndExecute;
};

// -- Re-open menu once unit removed
[
    _reopenCondition,
    {
        params ["_crewOptions", "_vehicle", "_seatCfg"];
        _crewOptions call [F(openCrewMenu), [_vehicle]];
    },
    [_crewOptions, _vehicle, _seat],
    1
] call CBA_fnc_waitUntilAndExecute;
