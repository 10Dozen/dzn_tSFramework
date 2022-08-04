#include "script_component.hpp"

/*
    Makes unit to send radio message 'using LR radio'.
    Message will be printed in 'commandChat' only to players with LR radio and within range.
    Has global effect.

    Params:
    _unitIdentity - (object) or (string) unit that sends the radio message OR callsign (requires unit to be registred)
    _message - (string) message to display
    _distance - (number) max distance to broadcast in meters. Optional, default - unlimited.

    Return: nothing

    Example:
    [player, "Get into da choppa!"] call tSF_Chatter_fnc_SendMessageOverLRRadio;
*/

params ["_unitIdentity", "_message", ["_distance", -1]];

[_unitIdentity, _message, "LR", _distance] call FUNC(sendMessageOverRadio);
