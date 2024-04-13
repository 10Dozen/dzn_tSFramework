#include "script_component.hpp"

/*
    Same as tSF_Chatter_fnc_Shout, but for larger distance (~75 meters, see defaults in Settings)

    [player, "Get into da choppa!", "Dutch"] call tSF_Chatter_fnc_Shout;
*/

params [
    "_unit",
    "_message",
    ["_name", name (_this # 0)],
    ["_distance", SETTING_2(COB,Direct,Shout Range)]
];

COB call [F(say), [_unit, _message, _name, _distance, SAY_MODE__SHOUT]];
