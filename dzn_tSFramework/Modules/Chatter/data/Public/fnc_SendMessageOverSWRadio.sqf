#include "script_component.hpp"

/*
    Makes unit to send radio message 'using SW radio'.
    Message will be printed in 'sideChat' only to players with LR radio and within range.
    Has global effect.

    Params:
    _unitIdentity - (object) or (string) unit that sends the radio message OR callsign (requires unit to be registred).
    _message - (string) message to display.
    _distance - (number) max distance to broadcast in meters. -1 - for unlimited range. 
                Optional, default - Radio > SW Range  defined in Settings.yaml.

    Return: nothing

    Example:
    [player, "Get into da choppa!"] call tSF_Chatter_fnc_SendMessageOverSWRadio;
*/

params ["_unitIdentity", "_message", ["_distance", SETTING_2(COB,Radio,SW Range)]];

COB call [F(sendMessageOverRadio), [_unitIdentity, _message, "SW", _distance]];
