#include "script_component.hpp"

/*
    Handles phonetic alphabet sequence.

    ABF A% -> ABF Alpha
    BOF C% -> BOF Charlie

    or auto-generate name:

    BOF % -> BOF Delta
*/

if !(_self get Q(Settings) get Q(PhoneticAlphabet) getOrDefault [Q(enable), false]) exitWith {};

["created", {
    params ["_marker"];
    GVAR(ComponentObject) call [F(phoneticAbc_handle), [_marker]];
}] call CBA_fnc_addMarkerEventHandler;
