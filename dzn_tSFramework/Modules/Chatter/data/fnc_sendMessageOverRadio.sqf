#include "script_component.hpp"

/*
    Sends message from unit by LR or SW. Has global effect.

    Params:
    _unitIdentity - (object) or (string) unit that sends the radio message OR callsign (requires unit to be registred).
    _message - (string) message to display.
    _radioType - (string) 'LR' for long-range or 'SW' for short range radio.
    _distance - (number) max distance to broadcast in meters. Optional, default - unlimited.

    Return: nothing

    Example:
    [player, "Get into da choppa!", "SW", 1500] call tSF_Chatter_fnc_sendMessageOverRadio;
    // Sends message over SW radio to all players in 1500 meters.
*/

params ["_unitIdentity", "_message", "_radioType", ["_distance", -1]];

DEBUG_1("(sendMessageOverRadio) Params: %1", _this);

private _unit = objNull;
private _callsign = "";
private _lrRange = -1;
private _swRange = -1;
private _sayLocal = true;

if (typename _unitIdentity == "STRING") then {
    // User identity is a Callsign
    private _talkerEntity = [_unitIdentity] call FUNC(getRadioTalkerByCallsign);

    if (_talkerEntity isEqualTo []) exitWith {};
    _callsign = _talkerEntity # 0;
    _unit = _talkerEntity # 1;
    _lrRange = _talkerEntity # 2;
    _swRange = _talkerEntity # 3;
    _sayLocal = _talkerEntity # 4;
} else {
    // User identity is actual unit
    _unit = _unitIdentity;
    _callsign = groupId group _unit;
    _lrRange = _distance;
    _swRange = _distance;
};

// Failed to find unit
if (isNull _unit && _callsign isEqualTo "") exitWith {};

// Person is dead - no radio coms from it
if (!isNull _unit && { !alive _unit }) exitWith {};

private _position = getPos _unit;
private _comsRange = switch (toUpper _radioType) do {
    case "LR": { _lrRange };
    case "SW": { _swRange };
};

[_unit, _callsign, _message, _radioType, _comsRange] remoteExec [QFUNC(showMessageOverRadio)];

if (!_sayLocal) exitWith {};
private _name = format ["[%1] %2", groupId group _unit, name _unit];
[_unit, _message, _name, 10] call FUNC(Say);
