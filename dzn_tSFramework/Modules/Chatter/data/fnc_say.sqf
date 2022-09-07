#include "script_component.hpp"

/*
    Makes unit to say given message, that will be displayed as subtitle for nearby players.
    Has global effect.

    Params:
    _unit - (object) a speaker.
    _message - (string) message to display.
    _name - (string) displayed name in the subtitle. Optional, by default - name returned by 'name' command.
    _distance - (number) max distance for speech to be 'heard' by players, in meters. Optional, default - 30 meters.

    Return: nothing

    Example:
    [player, "Get into da choppa!", "Dutch"] call tSF_Chatter_fnc_Say;
    // Will show 'Get into da choppa' message from 'Dutch' for all players within 30 meters from player.
*/

params [
    "_unit",
    "_message",
    ["_name", name (_this # 0)],
    ["_distance", GET_ "Direct", "Range", "Say" _SETTING]
];

if (!alive _unit) exitWith {};

[_unit, _message, _name, _distance] remoteExec [QFUNC(showMessageLocally)];
