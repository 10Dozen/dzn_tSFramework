#include "script_component.hpp"

/*
    Creates a new group of given side with one dummy unit.
    Params:
    _side - (side) side of the group.
    _position - (PosAGL array) position of the unit. Optional, default [-1000, -1000, 0]

    Return:
    _grp - (group) created group.
*/
params ["_side", ["_position", [-1000, -1000, 0]]];

private _grp = createGroup _side;
private _class = switch (_side) do {
    case west: { "B_soldier_F" };
    case east: { "O_soldier_F" };
    case resistance: { "I_soldier_F" };
    case civilian: { "C_man_1" };
};
private _unit = _grp createUnit [_class , _position, [], 0, "NONE"];
_unit disableAI "ALL";
hideObjectGlobal _unit;
_unit enableSimulation false;

_unit setVariable [QGVAR(IsDummySpeaker), true, true];

// Disable Dynai caching for unit
_unit setVariable ["dzn_dynai_cacheable", true, true];
// Disable IWB loop for unit
_unit setVariable ["IWB_Disable", true, true];

_grp
