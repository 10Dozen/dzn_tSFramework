#include "script_component.hpp"

/*
    Reads Radio Talkers table and creates talkers
    Params: none
    Return: none
*/

{
    _x params ["_side", "_callsign", ["_unit", objNull], ["_range", [-1,-1]]];

    if (isNull _unit) then {
        [_side, _callsign] call FUNC(createVirtualRadioTalker);
    } else {
        if (_unit isKindOf "Logic") then {
            // GameLogic as Virtual talker
            [_side, _callsign, getPos _unit, _range] call FUNC(createVirtualRadioTalker);
        } else {
            // Unit-talker
            [_unit, _callsign, _range] call FUNC(registerUnitAsRadioTalker);
        };
    };
} forEach GVAR(TalkersTable);

publicVariable QGVAR(RadioTalkers);
