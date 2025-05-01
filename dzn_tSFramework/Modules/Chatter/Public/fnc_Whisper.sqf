#include "script_component.hpp"

/*
    Same as tSF_Chatter_fnc_Say, but for shorter distance (~7 meters, see Settings).

    [player, "Get into da choppa!", "Dutch"] call tSF_Chatter_fnc_Whisper;
*/
params [
    "_unit",
    "_message",
    ["_name", name (_this # 0)],
    ["_distance", SETTING_2(COB,Direct,Whisper Range)]
];

COB call [F(say), [_unit, _message, _name, _distance, SAY_MODE__WHISPER]];
