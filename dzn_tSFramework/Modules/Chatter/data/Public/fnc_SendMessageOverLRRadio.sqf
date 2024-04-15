#include "script_component.hpp"

/*
    Makes unit to send radio message 'using LR radio'.
    Message will be printed in 'commandChat' only to players with LR radio and within range.
    If _unitIdentity of registerd RadioTalker was given - uses it's settings.
    Has global effect.

    Params:
    _unitIdentity - (object) or (string) unit that sends the radio message OR callsign (requires unit to be registred).
    _message - (string) message to display
    _distance - (number) max distance to broadcast in meters. -1 - for unlimited range.
                Optional, default - Radio > LR Range  defined in Settings.yaml.

    Return: nothing

    Example:
    [player, "Get into da choppa!"] call tSF_Chatter_fnc_SendMessageOverLRRadio;
*/

params ["_unitIdentity", "_message", ["_distance", SETTING_2(COB,Radio,LR Range)]];

COB call [F(sendMessageOverRadio), [_unitIdentity, _message, "LR", _distance]];
