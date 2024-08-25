#include "script_component.hpp"


/*
    (_self)

    Params:
        nothing
    Returns:
        nothing
*/

params ["_mode", ["_args",[]]];

if (_mode == MODE_ON_RESPAWN_HINT) exitWith {
    private _message = format [
        SETTING(_self,OnRespawnMessage),
        groupId group player
    ];
    hintSilent parseText _message;
};

if (_mode == MODE_BEFORE_RESPAWN_MSG) exitWith {
    private _message = format ([SETTING(_self,BeforeRespawnMessage)] +_args);

    [
        [
            "<t color='#FFD000'>Возрождение</t>",
            format ["<t align='center'>%1</t>", _message]
        ]
        , "TOP"
        , [0,0,0,.75]
        , _args # 0
    ] call dzn_fnc_ShowMessage;
};

// Otherwise - clear both messages
hintSilent "";
(uiNamespace getVariable ["dzn_DynamicMessageDialog",displayNull]) call dzn_fnc_dynamicMessage_clearControls;

