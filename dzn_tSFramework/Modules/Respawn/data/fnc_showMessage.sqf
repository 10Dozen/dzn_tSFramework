#include "script_component.hpp"


/*
    Draws Hint or on screen message.
    (_self)

    Params:
        _mode (ENUM) - one of the following:
                       MODE_ON_RESPAWN_HINT - to display hint 
                       MODE_BEFORE_RESPAWN_MSG - to display on screen message with respawn text from settings 
                       MODE_RESPAWN_CANCELED_MSG - to display on screen message with unscheduled respawn text from settings.
                       else - hides hint and on screen message
        _args (ANY) - optional, argumens for formatting on screen messages (timeout)
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
            Q(RESPAWN_MSG_SCHEDULED)
            format [Q(RESPAWN_HINT_MSG_TEXT), _message]
        ]
        , "TOP"
        , [0,0,0,.75]
        , _args # 0
    ] call dzn_fnc_ShowMessage;
};

if (_mode == MODE_RESPAWN_CANCELED_MSG) exitWith {
    private _message = format ([SETTING(_self,CancelRespawnMessage)] +_args);
    [
        [
            Q(RESPAWN_MSG_UNSCHEDULED),
            format [Q(RESPAWN_HINT_MSG_TEXT), _message]
        ]
        , "TOP"
        , [0,0,0,.75]
        , 15
    ] call dzn_fnc_ShowMessage;
};

// Otherwise - clear both messages
hintSilent "";
(uiNamespace getVariable ["dzn_DynamicMessageDialog",displayNull]) call dzn_fnc_dynamicMessage_clearControls;

