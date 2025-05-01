#include "script_component.hpp"

/*
    Starts roster update loop.
    (_self)

    Params:
        none
    Returns:
        nothing
*/

private _updateTimeout = SETTING_2(_self,Roster,updatePeriod);
private _updateEndsAt = time + SETTING_2(_self,Roster,updateUntil);

[
    {
        params ["_args", "_pfhId"];

        _args params ["_cob", "_endTime"];
        private _updateUpcoming = true;
        if (time > _endTime) then {
            [_pfhId] call CBA_fnc_removePerFrameHandler;
            _updateUpcoming = false;
        };

        _cob call [F(updateRoster), [_updateUpcoming]];
    },
    _updateTimeout,
    [_self, _updateEndsAt]
] call CBA_fnc_addPerFrameHandler;
